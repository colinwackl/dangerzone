require "Base"
require "tools"
Vector = require "hump.vector"
Class = require "hump.class"
Signal = require "hump.signal"

Entity = Class({function(self, dataPath)
	Base.construct(self, dataPath)
	
	self.pos = vector(0, 0)
	self.vel = vector(0, 0)
	self.accel = vector(0, 0)
	self.maxvel = math.huge
	self.friction = 0
	self.signals = Signal:new()
	
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
	self:setPosition(self.pos)
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
	if self.physics and self.physics.body then
		local body = self:getBody()
		body:setLinearVelocity(self.vel.x, self.vel.y)
		--body:setPosition(self.pos.x, self.pos.y)
		self.pos.x, self.pos.y = body:getPosition()
		
	else
		self.pos = self.pos + self.vel * dt
	end
	
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

function Entity:getBody()
	if self.physics == nil then self.physics = {} end
	if self.physics.body == nil then
		print("self.pos.x, self.pos.y", self.pos.x, self.pos.y)
		self.physics.body = love.physics.newBody(_G.world.physworld, self.pos.x, self.pos.y, self.physicsBodyType or "dynamic")
	end
	
	return self.physics.body
end

function Entity:createFixture(shape, density)
	density = density or 1
	local body = self:getBody()
	if shape == nil then
		shape = love.physics.newRectangleShape(self.bounds:width(),  self.bounds:height())
	end
	
	if self.physics.fixtures == nil then self.physics.fixtures = {} end
	local fixture = love.physics.newFixture(body, shape, density)
	fixture:setUserData(self)
	table.insert(self.physics.fixtures, fixture)
	return fixture
end

function Entity:setPosition(position)
	if self.physics and self.physics.body then
		local body = self:getBody()
		body:setPosition(position.x, position.y)
	end
end

function Entity:shoot(bullet, at)
	bullet:setPosition(self.pos)
	bullet.vel = at.pos - self.pos
	bullet.vel:normalize_inplace()
	bullet.vel = bullet.vel * bullet.maxvel
	
end