require "Entity"
require "tools"
require "Boundary"
require "Locomotive"
require "Crate"
Vector = require "hump.vector"
Class = require "hump.class"

Bullet = Class({function(self, dataPath, friendly)
	Entity.construct(self, dataPath)
	self.signals:register("beginContact", self.beginContact)
	
	self.followGunRotation = self.data.followGunRotation
	self.deflect = self.data.deflect or false
	self.lifeLeft = self.data.life or math.huge
	self.startLife = self.data.life
	
	self:createFixture()
	self:createSprites()
	
	self.world.bullets[self] = self
	
	if self.deflect then
		local body = self:getBody()
		body:setFixedRotation(true)
		body:setMass(10)
	end
	
	self.friendly = friendly
end,
name = "Bullet", inherits = Entity})

function Bullet:beginContact(collideWith)
	if self.friendly then
		if collideWith:is_a(Enemy) and self.deflect ~= true then
			collideWith:hit(self)
			self:destroy()
		end
		
		if collideWith:is_a(Bullet) and self.deflect == true and collideWith.deflect ~= true then
			collideWith.vel = -collideWith.vel
		end
	else
		if collideWith:is_a(Crate) then 
			collideWith:hit(self)
		end
		
		if collideWith:is_a(Locomotive) or collideWith:is_a(Crate) then
			self:destroy()
		end
	end

	if collideWith:is_a(Boundary) then
		self:destroy()
	end
end

function Bullet:onDestroyed()
	self.world.bullets[self] = nil
end

function Bullet:update(dt)
	Entity.update(self, dt)
	self.lifeLeft = self.lifeLeft - dt
	
	if self.startLife then
		self:setAlpha(self.lifeLeft / self.startLife)
	end
	
	if self.lifeLeft < 0 then
		self:destroy()
	end
end

function Bullet:draw()
	Entity.draw(self)
	--love.graphics.setColor(self.data.colour[1], self.data.colour[2], self.data.colour[3], self.data.colour[4] or 255)
	--love.graphics.rectangle("fill", self.pos.x, self.pos.y, self.bounds:width(), self.bounds:height())
end