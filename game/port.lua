require "Entity"
require "tools"
require "LayeredSprite"
Vector = require "hump.vector"
Class = require "hump.class"
timer = require "hump.timer"

Port = Class({function(self, dataPath)
	Entity.construct(self, dataPath)
	
end,
name = "Port", inherits = Entity})

function Port:initSprite(strData, strAnimation)
	self.sprite = LayeredSprite:new()
	self.sprite:init(strData, strAnimation)
end

function Port:setAnimation(strAnimation)
	self.sprite:setAnimation(strAnimation)
end

function Port:update(dt)
	Entity.update(self, dt)
	
	if self.sprite ~= nil then
		self.sprite:setPosition(self.pos)
		self.sprite:setRotation(self.physics.body:getAngle())
		self.sprite:update(dt)
	end
end

function Port:draw()
	if self.sprite ~= nil then
		self.sprite:draw()
	end
	
	if DEBUG then
		love.graphics.push()

		love.graphics.setColor(0,255,0)
		love.graphics.setLine(1)
		love.graphics.translate(self.pos.x, self.pos.y)
		--love.graphics.translate(-self.offset.x / 2, -self.offset.y)
		love.graphics.setColor(173, 69, 0)
		love.graphics.circle("fill", 0, 0, self.size.x / 2)

		love.graphics.pop()
	end
end