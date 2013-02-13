vector = require "hump.vector"
signal = require "hump.signal"
timer = require "hump.timer"
require "Camera"
require "LayeredSprite"
require "World"
require "Tools"
require "Locomotive"
require "Enemy"
require "Crate"
require "Beam"

testLayeredSprite = {}
zoom = 1

DEBUG = true
DRAWPHYSICS = true
DRAWGROUND = false

function love.load()
	 -- assert(love.graphics.isSupported('pixeleffect'), 'Pixel effects are not supported on your hardware. Sorry about that.')

	math.randomseed(os.time())
	local cameraX = love.graphics.getWidth() / 2
	local cameraY = love.graphics.getHeight() / 2
	local cameraZoom = 0.5
	cam = Camera(cameraX, cameraY, cameraZoom, 0)

	gameRight = love.graphics.getWidth() / 2
	gameLeft = love.graphics.getWidth() / 2
	gameTop = love.graphics.getHeight() / 2
	gameBottom = love.graphics.getHeight() / 2
	
	world = World:new()
	world.camera = cam
	world:init()

	world:create()
	
	player = Locomotive("Locomotive")
	enemy = Enemy("enemy", player)
	enemy:setPosition(vector(10, 10))
	enemy.vel.x, enemy.vel.y = 20, 20

	crate = Crate("Crate")
	crate:initSprite("cell.sprite", "body")
	crate2 = Crate("Crate")
	crate2:initSprite("cell.sprite", "heart")
	crate3 = Crate("Crate")
	crate3:initSprite("cell.sprite", "body_grey")
	crate4 = Crate("Crate")
	crate4:initSprite("cell.sprite", "body_grey")

	beam = Beam("Beam")
	beam:initPhysics(world.physworld, player.physics.body, crate.physics.body, 200)
	
	world:addObject(player)
	world:addObject(enemy)
	world:addObject(crate)
	world:addObject(crate2)
	world:addObject(crate3)
	world:addObject(crate4)
	world:addObject(beam)

	Tools:loadFonts()

	love.graphics.setBackgroundColor(255, 255, 255)

	titlefont = Tools.fontMainLarge

	if love.filesystem.exists("some.mp3") then
		music = love.audio.newSource("some.mp3", "stream")
		music:setLooping(true)
		love.audio.play(music)

	end

	--testLayeredSprite = LayeredSprite:new()
	--testLayeredSprite:load("dude", "dude")
	--testLayeredSprite.speed = 100
end

function love.draw()
	cam:attach()

	love.graphics.setBackgroundColor(151, 144, 130, 255)
	world:draw()

	--beam:draw(beam)

	cam:detach()
end

function love.update(dt)
	timer.update(dt)
	
	world:update(dt)

	--j:setTarget(love.mouse.getPosition())


	-- if love.keyboard.isDown("right") then
	-- 	testLayeredSprite.position.x = testLayeredSprite.position.x + (testLayeredSprite.speed * dt)
	-- 	--ninja.flipH = false
	-- 	--testLayeredSprite:setAnimation("runRight", true)
	-- elseif love.keyboard.isDown("left") then
	-- 	testLayeredSprite.position.x = testLayeredSprite.position.x - (testLayeredSprite.speed * dt)
	-- 	--ninja.flipH = true
	-- 	--testLayeredSprite:setAnimation("runLeft", true)
	-- end

	-- if love.keyboard.isDown("down") then
	-- 	testLayeredSprite.position.y = testLayeredSprite.position.y + (testLayeredSprite.speed * dt)
	-- elseif love.keyboard.isDown("up") then
	-- 	testLayeredSprite.position.y = testLayeredSprite.position.y - (testLayeredSprite.speed * dt)
	-- end	
	--testLayeredSprite:update(dt)
end

function love.mousereleased(x, y, button)
	x,y = cam:worldCoords(x, y)
end

xPressed = 0
yPressed = 0
mouseMoved = false
function love.mousepressed(x, y, button)
	x,y = cam:worldCoords(x, y)

	xPressed = x
	yPressed = y

	mouseMoved = false
	
	if player:inBounds(vector(x, y)) then
		player:startPath()
	elseif crate:inBounds(vector(x, y)) then
			beam = Beam("Beam")
			beam:initPhysics(world.physworld, crate.physics.body, crate2.physics.body, 200)
			world:addObject(beam)
	elseif crate2:inBounds(vector(x, y)) then
			beam = Beam("Beam")
			beam:initPhysics(world.physworld, crate2.physics.body, crate3.physics.body, 200)
			world:addObject(beam)
	elseif crate3:inBounds(vector(x, y)) then
			beam = Beam("Beam")
			beam:initPhysics(world.physworld, crate3.physics.body, crate4.physics.body, 200)
			world:addObject(beam)
	end
	
	if button == "l" then
	elseif  button == "r" then
	end
end

function love.mousereleased(x, y, button)
	player:stopPath()
end

function love.keypressed( key, unicode )
	local function done() world:updateBoundaries() end
	if key == '-' then
		cam:setScaleOverTime(cam.scale * 0.5, 2, done)
	elseif key == '=' then
		cam:setScaleOverTime(cam.scale * 2, 2, done)
	end
		
	signal.emit("keyPressed", key, unicode)
end

function love.keyreleased( key, unicode )

	if key == "f1" then
		if DEBUG then
			DEBUG = false
		else
			DEBUG = true
		end
	end

	signal.emit("keyReleased", key, unicode)
end