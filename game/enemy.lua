require "Entity"
require "tools"
require "Bullet"
Vector = require "hump.vector"
Class = require "hump.class"
timer = require "hump.timer"

Enemy = Class({function(self, dataPath, player)
	Entity.construct(self, dataPath)
	
	local function shoot()
		self:shoot(Bullet("Bullet"), player)
	end
	shoot()
	
	local interval = self.data.shootInterval or 2
	timer.addPeriodic(interval, shoot)
	
end,
name = "Enemy", inherits = Entity})

function Enemy:draw()
	love.graphics.setColor(self.data.colour[1], self.data.colour[2], self.data.colour[3], self.data.colour[4] or 255)
	love.graphics.rectangle("fill", self.pos.x, self.pos.y, 100, 100)
end