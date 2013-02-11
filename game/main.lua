vector = require "hump.vector"
camera = require "hump.camera"
require "LayeredSprite"
require "Tools"


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
	

	Tools:loadFonts()

	love.graphics.setBackgroundColor(255, 255, 255)

	titlefont = Tools.fontMainLarge

	if love.filesystem.exists("some.mp3") then
		music = love.audio.newSource("some.mp3", "stream")
		music:setLooping(true)
		love.audio.play(music)

	end
end

function love.draw()
	cam:attach()

	cam:detach()
end

function love.update(dt)

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