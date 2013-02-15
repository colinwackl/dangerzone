require "Entity"
require "tools"
require "Boundary"
Vector = require "hump.vector"
Class = require "hump.class"
timer = require "hump.timer"

Enemy = Class({function(self, dataPath, player)
	Entity.construct(self, dataPath)
	
	self.kamikaze = self.data.kamikaze or false
	
	self:createFixture()
	self:createSprites()
	
	self.shootBurst = self.data.shootBurst or 0
	self.shootInterval = self.data.shootInterval or 5
	
	self:getBody():setFixedRotation(true)
	
	self.signals:register("beginContact", self.beginContact)

	self.spawnTimer = 0
	self.timeUntilShot = 0
	self.currentBurstCount = 0
	
end,
name = "Enemy", inherits = Entity})

function Enemy:beginContact(collidedWith)
	if self.kamikaze and collidedWith:is_a(Crate) then
		collidedWith:hit(self)
		self:destroy()
		
	elseif collidedWith:is_a(Boundary) then
		self:destroy()
	end
end

function Enemy:hit(hitter)
	self:destroy()
end

function Enemy:update(dt)
	Entity.update(self, dt)

	self.spawnTimer = self.spawnTimer + dt

	Entity.setAlpha(self, self.spawnTimer/10)
	
	self.timeUntilShot = self.timeUntilShot - dt
	if self.shootInterval > 0 and self.timeUntilShot < 0 then
		if self.currentBurstCount >= self.shootBurst - 1 then
			self.timeUntilShot = self.shootInterval
			self.currentBurstCount = 0
		else
			self.timeUntilShot = 0.3
			self.currentBurstCount = self.currentBurstCount + 1
		end
		
		self:shoot(Bullet("Bullet", false), player)
	end
	
	local diff = _G.player.pos - self.pos
	diff:normalize_inplace()
	self.physics.body:setAngle(math.atan2(diff.y, diff.x) + math.pi / 2)
end

function Enemy:draw()
	Entity.draw(self)
end