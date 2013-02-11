require "Entity"
require "tools"
Vector = require "hump.vector"
Class = require "hump.class"

Locomotive = Class({function(self)
	-- nothing
end,
name = "Locomotive", inherits = Entity})

function Locomotive:draw()
	--print("self.pos", self.pos)
	love.graphics.setColor(self.data.colour[1], self.data.colour[2], self.data.colour[3], self.data.colour[4] or 255)
	love.graphics.rectangle("fill", self.pos.x, self.pos.y, 100, 100)
end