vector = require "hump.vector"
camera = require "hump.camera"
require "LayeredSprite"
require "World"
require "Tools"

testLayeredSprite = {}
zoom = 1

function love.load()
	 -- assert(love.graphics.isSupported('pixeleffect'), 'Pixel effects are not supported on your hardware. Sorry about that.')

	math.randomseed(os.time())
	cameraX = love.graphics.getWidth() / 2
	cameraY = love.graphics.getHeight() / 2
	cameraZoom = 1
	cam = camera(cameraX, cameraY, cameraZoom, 0)

	gameRight = love.graphics.getWidth() * 3 / 2
	gameLeft = love.graphics.getWidth() / 2
	gameTop = love.graphics.getHeight() / 2
	gameBottom = love.graphics.getHeight() / 2
	
	world = World:new()
	world:init()

	world:create()

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

	world:draw()

	cam:detach()
end

function love.update(dt)
	world:update(dt)

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

	if button == "l" then
	elseif  button == "r" then
	end


end

function love.keyreleased( key, unicode )

	-- elseif key == "f1" then
	-- 	if DEBUG then
	-- 		DEBUG = false
	-- 	else
	-- 		DEBUG = true
	-- 	end

end