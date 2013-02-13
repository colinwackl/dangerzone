vector = require "hump.vector"
signal = require "hump.signal"
timer = require "hump.timer"
require "Camera"
require "LayeredSprite"
require "World"
require "Tools"
require "Locomotive"
require "SpawnManager"
require "Enemy"
require "Crate"
require "Beam"
require "ChainLink"

testLayeredSprite = {}
zoom = 1

DEBUG = true
DRAWPHYSICS = true
DRAWGROUND = false

function love.load()
	 -- assert(love.graphics.isSupported('pixeleffect'), 'Pixel effects are not supported on your hardware. Sorry about that.')

	math.randomseed(os.time())
	
	world = World:new()
	spawnManager = SpawnManager("SpawnManager")
	
	local cameraX = love.graphics.getWidth() / 2
	local cameraY = love.graphics.getHeight() / 2
	local cameraZoom = 0.5
	cam = Camera(cameraX, cameraY, cameraZoom, 0)

	gameRight = love.graphics.getWidth() / 2
	gameLeft = love.graphics.getWidth() / 2
	gameTop = love.graphics.getHeight() / 2
	gameBottom = love.graphics.getHeight() / 2
	
	world.camera = cam
	world:init()

	world:create()
	
	player = Locomotive("Locomotive")
	--[[enemy = Enemy("enemy", player)
	enemy:setPosition(vector(10, 10))
	enemy.vel.x, enemy.vel.y = -200, -200
	spawnManager:addEnemy(enemy)]]
	
	world.player = player

	-- crate = Crate("Crate")
	-- crate:initSprite("cell.sprite", "body")
	-- crate:setPosition(Vector(100, 100))
	-- crate2 = Crate("Crate")
	-- crate2:initSprite("cell.sprite", "heart")
	-- crate2:setPosition(Vector(200, 200))
	-- crate3 = Crate("Crate")
	-- crate3:initSprite("cell.sprite", "body_grey")
	-- crate3:setPosition(Vector(300, 300))
	-- crate4 = Crate("Crate")
	-- crate4:initSprite("cell.sprite", "body_grey")
	-- crate4:setPosition(Vector(400, 400))
	
	--world:addObject(player)
	--world:addObject(enemy)
	-- world:addObject(crate)
	-- world:addObject(crate2)
	-- world:addObject(crate3)
	-- world:addObject(crate4)

	Tools:loadFonts()

	love.graphics.setBackgroundColor(195, 211,211)

	titlefont = Tools.fontMainLarge

	if love.filesystem.exists("some.mp3") then
		music = love.audio.newSource("some.mp3", "stream")
		music:setLooping(true)
		love.audio.play(music)

	end
end

function love.draw()
	cam:attach()

	world:draw()

	--beam:draw(beam)

	cam:detach()
end

function love.update(dt)
	timer.update(dt)
	
	world:update(dt)
end

function love.mousereleased(x, y, button)
	x,y = cam:worldCoords(x, y)
end

xPressed = 0
yPressed = 0
mouseMoved = false
local activePort = nil
function love.mousepressed(x, y, button)
	x,y = cam:worldCoords(x, y)

	xPressed = x
	yPressed = y
	
	mouseMoved = false
	
	if player:inBounds(vector(x, y)) then
		player:startPath()
		
	else
		local port, distance = world:getClosestAvailablePort(vector(x, y))
		if distance < port.effectiveDistance then
			port:startLink()
			activePort = port
		end
	end
	
	if button == "l" then
	elseif  button == "r" then
	end
end

function love.mousereleased(x, y, button)
	player:stopPath()
	if activePort then
		local port, distance = world:getClosestAvailablePort(vector(x, y), activePort)
		if port and distance < port.effectiveDistance then
			activePort:linkWith(port)
		else
			activePort:endLink():destroy()
			
		end
		activePort = nil
	end
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