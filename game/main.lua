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

DEBUG = false
DRAWPHYSICS = false
DRAWGROUND = false

function love.load()
	 -- assert(love.graphics.isSupported('pixeleffect'), 'Pixel effects are not supported on your hardware. Sorry about that.')

	math.randomseed(os.time())
	
	world = World:new()
	spawnManager = SpawnManager("SpawnManager")
	
	local cameraX = love.graphics.getWidth() / 2
	local cameraY = love.graphics.getHeight() / 2
	local cameraZoom = 0.7
	cam = Camera(cameraX, cameraY, cameraZoom, 0)

	gameRight = love.graphics.getWidth() / 2
	gameLeft = love.graphics.getWidth() / 2
	gameTop = love.graphics.getHeight() / 2
	gameBottom = love.graphics.getHeight() / 2
	
	world.camera = cam
	world:init()
	
	world:create()
	
	player = Locomotive("Locomotive")
	
	world.player = player

	Tools:loadFonts()

	love.graphics.setBackgroundColor(35,28,10)

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
function love.mousepressed(x, y, button)
	x,y = cam:worldCoords(x, y)

	xPressed = x
	yPressed = y
	
	mouseMoved = false
	
	if player:inBounds(vector(x, y)) then
		player:startPath()
	end
	
	local port, portDistance = world:getClosestAvailablePort(vector(x, y))
	local gun, gunDistance = world:getClosestGunPort(vector(x, y))
	
	if port and portDistance < port.effectiveDistance and port.portActive and port.closePort then
		port:clicked()
	elseif gun and gunDistance < gun.effectiveDistance then
		gun:clicked()
	end
	
	if button == "l" then
	elseif  button == "r" then
		--port.parent:destroy(true)
	end
	
	signals.emit("mousePressed", x, y, button)
end

function love.mousereleased(x, y, button)
	x,y = cam:worldCoords(x, y)

	player:stopPath()
	
	signals.emit("mouseReleased", x, y, button)
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