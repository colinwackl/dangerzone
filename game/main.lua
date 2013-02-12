vector = require "hump.vector"
camera = require "hump.camera"
require "LayeredSprite"
require "World"
require "Tools"

testLayeredSprite = {}
zoom = 1

DEBUG = true
DRAWPHYSICS = true
DRAWGROUND = false

function love.load()
	 -- assert(love.graphics.isSupported('pixeleffect'), 'Pixel effects are not supported on your hardware. Sorry about that.')

	math.randomseed(os.time())
	cameraX = love.graphics.getWidth() / 2
	cameraY = love.graphics.getHeight() / 2
	cameraZoom = 1
	cam = camera(cameraX, cameraY, cameraZoom, 0)

	gameRight = love.graphics.getWidth() / 2
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

function math.clamp(input, min_val, max_val)
	if input < min_val then
		input = min_val
	elseif input > max_val then
		input = max_val
	end
	return input
end

function math.sign(input)
	if input < 0 then
		input = -1
	elseif input > 0 then
		input = 1
	else
		input = 1
	end
	return input
end

clickedInBox = false

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

	-- if love.mouse.isDown("l") then
	-- 	local x,y = cam:worldCoords(love.mouse.getX(), love.mouse.getY())
	-- 	local hit = world:getClickedObject(x, y)
	-- 	if clickedInBox then				
	-- 		local tractor = world:getTractor()
	-- 		if tractor then
	-- 			local force_x, force_y = math.clamp((x - tractor.physics.body:getX())/100, -10000 , 10000), math.clamp((y - tractor.physics.body:getY())/100, -10000 , 10000)
	-- 			tractor.physics.body:setPosition(tractor.physics.body:getX() + force_x, tractor.physics.body:getY() + force_y)
	-- 		end
	-- 	end
	-- end
end

function love.mousereleased(x, y, button)
	x,y = cam:worldCoords(x, y)

	if button == "l" then
		clickedInBox = false
	elseif  button == "r" then
	end
end

xPressed = 0
yPressed = 0
mouseMoved = false
function love.mousepressed(x, y, button)
	x,y = cam:worldCoords(x, y)

	--if button == "1" then
		--local tractor = world:getTractor()
		--tractor.physics.body:applyForce(1000 * (x - tractor.physics.body:getX()), 1000 * (y - tractor.physics.body:getY()))
		--tractor.physics.body.pos = vector(math.random() * 1280*3, math.random() * 960*3)
	--end

	xPressed = x
	yPressed = y

	mouseMoved = false

	-- if button == "l" then
	-- 	local hit = world:getClickedObject(x, y)
	-- 	if hit then		
	-- 		clickedInBox = true
	-- 	end
	-- elseif  button == "r" then
	-- end


end

function love.keyreleased( key, unicode )

	if key == "f1" then
		if DEBUG then
			DEBUG = false
		else
			DEBUG = true
		end
	end

end