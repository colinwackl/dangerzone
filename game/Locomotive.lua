require "Entity"
require "tools"
Vector = require "hump.vector"
Class = require "hump.class"
signal = require "hump.signal"

Locomotive = Class({function(self, dataPath)
	Entity.construct(self, dataPath)
	
	self.friction = 5
	
	signal.register('keyPressed', function(...) self:keyPressed(...) end)
	signal.register('keyReleased', function(...) self:keyReleased(...) end)
end,
name = "Locomotive", inherits = Entity})

function Locomotive:keyPressed(key)
	local accel = self.data.acceleration or 10
	if key == "up" then
		self.accel.y = -accel
	elseif key == "down" then
		self.accel.y = accel
	elseif key == "left" then
		self.accel.x = -accel
	elseif key == "right" then
		self.accel.x = accel
	end
end

function Locomotive:keyReleased(key)
	if key == "up" or key == "down" then
		self.accel.y = 0
	elseif key == "left" or key == "right"then
		self.accel.x = 0
	end
end

function Locomotive:draw()
	love.graphics.setColor(self.data.colour[1], self.data.colour[2], self.data.colour[3], self.data.colour[4] or 255)
	love.graphics.rectangle("fill", self.pos.x, self.pos.y, self.bounds:width(), self.bounds:height())
end