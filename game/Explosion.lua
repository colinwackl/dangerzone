require "Entity"
require "tools"
require "LayeredSprite"
Vector = require "hump.vector"
Class = require "hump.class"

Explosion = Class({function(self, dataPath)
	Entity.construct(self, dataPath)
	self.sprite = LayeredSprite:new()
	self.sprite:init("cell.sprite2", "explosion")
	
	timer.add(0.3, function() self:destroy() end)
end,
name = "Explosion", inherits = Entity})


function Explosion:update(dt)
	Entity.update(self, dt)
	self.sprite:setPosition(self.pos)
	self.sprite:update(dt)
	
end

function Explosion:draw()
	Entity.draw(self)
	self.sprite:draw()
	--love.graphics.setColor(self.data.colour[1], self.data.colour[2], self.data.colour[3], self.data.colour[4] or 255)
	--love.graphics.rectangle("fill", self.pos.x, self.pos.y, self.bounds:width(), self.bounds:height())
end