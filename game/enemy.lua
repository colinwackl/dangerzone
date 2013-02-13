require "Entity"
require "tools"
require "Bullet"
Vector = require "hump.vector"
Class = require "hump.class"
timer = require "hump.timer"

Enemy = Class({function(self, dataPath, player)
	Entity.construct(self, dataPath)
	
	self:createFixture()
	self:createSprites()
	
	local function shoot()
		self:shoot(Bullet("Bullet"), player)
	end
	shoot()
	
	local interval = self.data.shootInterval or 2
	timer.addPeriodic(interval, shoot)
	
end,
name = "Enemy", inherits = Entity})

function Enemy:update(dt)
	Entity.update(self, dt)
	
	local diff = _G.player.pos - self.pos
	diff:normalize_inplace()
	self.physics.body:setAngle(math.atan2(diff.y, diff.x) + math.pi / 2)
end

function Enemy:draw()
	--love.graphics.setColor(self.data.colour[1], self.data.colour[2], self.data.colour[3], self.data.colour[4] or 255)
	--self:drawBounds()
	Entity.draw(self)
end