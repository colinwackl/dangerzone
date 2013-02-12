require "Entity"
require "tools"
Vector = require "hump.vector"
Class = require "hump.class"

Bullet = Class({function(self, dataPath)
	Entity.construct(self, dataPath)
	world:addObject(self)
end,
name = "Bullet", inherits = Entity})

function Bullet:draw()
	print("Bullet:draw()", self.pos.x, self.pos.y)
	love.graphics.setColor(self.data.colour[1], self.data.colour[2], self.data.colour[3], self.data.colour[4] or 255)
	love.graphics.rectangle("fill", self.pos.x, self.pos.y, 10, 10)
end