require "Entity"
require "tools"
require "Boundary"
Vector = require "hump.vector"
Class = require "hump.class"
timer = require "hump.timer"

Enemy = Class({function(self, dataPath, player)
	Entity.construct(self, dataPath)
	
	self:createFixture()
	self:createSprites()
	
	self:getBody():setFixedRotation(true)
	
	local function shoot()
		if self.dontShoot ~= true then
			self:shoot(Bullet("Bullet"), player)
		end
		return self.dontShoot ~= true
	end
	shoot()
	
	local interval = self.data.shootInterval or 2
	self.shootTimer = timer.addPeriodic(interval, shoot)
	
	self.signals:register("beginContact", self.beginContact)

	self.spawnTimer = 0
	
end,
name = "Enemy", inherits = Entity})

function Enemy:beginContact(collidedWith)
	if collidedWith:is_a(Boundary) then
		self:destroy()
	end
end

function Enemy:onDestroyed()
	self.dontShoot = true
	timer.cancel(self.shootTimer)
end

function Enemy:update(dt)
	Entity.update(self, dt)

	self.spawnTimer = self.spawnTimer + dt

	Entity.setAlpha(self, self.spawnTimer/10)
	--self.sprite:setAlpha(self.spawnTimer/10)
	
	local diff = _G.player.pos - self.pos
	diff:normalize_inplace()
	self.physics.body:setAngle(math.atan2(diff.y, diff.x) + math.pi / 2)
end

function Enemy:draw()
	Entity.draw(self)
end