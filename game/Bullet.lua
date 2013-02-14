require "Entity"
require "tools"
require "Boundary"
require "Locomotive"
require "Crate"
Vector = require "hump.vector"
Class = require "hump.class"

Bullet = Class({function(self, dataPath)
	Entity.construct(self, dataPath)
	self.signals:register("beginContact", self.beginContact)
	self:createFixture()
	self:createSprites()
end,
name = "Bullet", inherits = Entity})

function Bullet:beginContact(collideWidth)
	if collideWidth:is_a(Crate) then 
		collideWidth:destroy()
	end		

	if collideWidth:is_a(Boundary) or collideWidth:is_a(Locomotive) or collideWidth:is_a(Crate) then
		self:destroy()
	end
end

function Bullet:draw()
	Entity.draw(self)
	--love.graphics.setColor(self.data.colour[1], self.data.colour[2], self.data.colour[3], self.data.colour[4] or 255)
	--love.graphics.rectangle("fill", self.pos.x, self.pos.y, self.bounds:width(), self.bounds:height())
end