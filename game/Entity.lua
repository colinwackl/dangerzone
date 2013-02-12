require "Base"
require "tools"
Vector = require "hump.vector"
Class = require "hump.class"

Entity = Class({function(self, dataPath)
	Base.construct(self, dataPath)
	
	self.pos = vector(0, 0)
	self.vel = vector(0, 0)
	self.accel = vector(0, 0)
	self.maxvel = math.huge
	self.friction = 0
	
	if dataPath then
		self:load(dataPath)
	end
	
end, inherits = Base})

function Entity:load(path)
	path =  'data/' .. path
	if string.find(path, ".lua") == nil then path = path .. ".lua" end
	assert(love.filesystem.exists(path))
	
	self.data = love.filesystem.load(path)()
	
	self.pos = self:asVector(self.data.pos)
	self.maxvel = self.data.maxVelocity or self.maxvel
	self.friction = self.data.friction or self.friction
	
	local bounds = {x = 20, y = 20 }
	if self.data.size then
		bounds.x = self.data.size[1] or bounds.x
		bounds.y = self.data.size[2] or bounds.y
	end
	self:setBounds(bounds)
	-- stuff
end

function Entity:asVector(a, default)
	default = default or {x = 0, y = 0}
	if a then
		return Vector(a[1] or default.x or 0, a[2] or default.y or 0)
	else
		return Vector(default.x or 0, default.y or 0)
	end
end

function Entity:update(dt)
	self.vel.x = math.min(self.vel.x + self.accel.x, self.maxvel)
	self.vel.y = math.min(self.vel.y + self.accel.y, self.maxvel)
	self.pos = self.pos + self.vel * dt
	
	if self.vel.x ~= 0 or self.vel.y ~= 0 then
		if self.lastVel == nil and (self.accel.x == 0 and self.accel.y == 0) then
			self.lastVel = self.vel
		elseif self.lastVel ~= nil then
			self.lastVel = nil
		end
	end
	
	if self.lastVel then
		self.vel = self.vel - (self.lastVel * self.friction * dt)
	end
	Base.update(self, dt)
end

function Entity:draw()
	Base.draw(self)
end

function Entity:shoot(bullet, at)
	bullet.pos.x, bullet.pos.y = self.pos.x, self.pos.y
	bullet.vel = at.pos - self.pos
	bullet.vel:normalize_inplace()
	bullet.vel = bullet.vel * bullet.maxvel
	
end