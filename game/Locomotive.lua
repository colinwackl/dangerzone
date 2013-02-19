require "Entity"
require "tools"
require "FingerPath"
Vector = require "hump.vector"
Class = require "hump.class"
signal = require "hump.signal"

Locomotive = Class({function(self, dataPath)
	Entity.construct(self, dataPath)
	
	self.physicsBodyType = "kinematic"
	
	self:createSprites()
	self:createFixture()
	self.path = FingerPath("FingerPath")
	
	local body = self:getBody()
	body:setMass(self.data.mass or 200)
	body:setFixedRotation(true)
	body:setLinearDamping(100)
	
	self.port = Port("Port", self, "tail")
	self.port.portActive = true
	
	self.mouseLeftBounds = true
	
	self.boostTime = 5
	self.timeLeftInBoost = 0
	
	self.defaultSpeed = self.data.maxVelocity
	
	signal.register('keyPressed', function(...) self:keyPressed(...) end)
	signal.register('keyReleased', function(...) self:keyReleased(...) end)
end,
name = "Locomotive", inherits = Entity})

function Locomotive:keyPressed(key)
	local accel = self.data.acceleration or 10
	if key == "up" then
		self.accel.y = -accel
	elseif key == "down" then
		self.accel.y = accel
	elseif key == "left" then
		self.accel.x = -accel
	elseif key == "right" then
		self.accel.x = accel
	end
	
	local attachedLink = self.port.attachedLink
	if attachedLink then
		if key == "z" then
			self.port:firePort(0, 0.3)
		elseif key == "x" then
			self.port:fireStarboard(0, 0.3)
		end
	end
end

function Locomotive:keyReleased(key)
	if key == "up" or key == "down" then
		self.accel.y = 0
	elseif key == "left" or key == "right"then
		self.accel.x = 0
		
	elseif key == " " then
		self:boost()
	end
end

function Locomotive:startPath()
	self.mouseLeftBounds = false
end

function Locomotive:stopPath()
	self.mouseLeftBounds = true
	self.path:stop()
end

function Locomotive:resetPath()
	self.path:reset()
end

function Locomotive:getCrateCount()
	local count = self.port:getSternLinks()
	return count
end

function Locomotive:getGenerators()
	local generators = {}
	self.port:getGenerators(generators)
	return generators
end

function Locomotive:boost()
	if self.timeLeftInBoost <= 0 then
		local foundGenerator = false
		local generators = self:getGenerators()
		for _, generator in ipairs(generators) do
			if generator.currentEnergy >= 4 then
				generator.currentEnergy = generator.currentEnergy - 4
				foundGenerator = true
				break
			end
		end
		
		if foundGenerator == false then return end
		
		self.timeLeftInBoost = self.boostTime
		self.maxvel = self.defaultSpeed * 3
	end
end

function Locomotive:isAttachedToPlayer()
	return true
end

function Locomotive:update(dt)
	Entity.update(self, dt)
	
	self.port:setPosition(Vector(self.physics.body:getWorldPoint(0, self.bounds.bottom)))
	
	local v = Vector(self.world.camera:mousepos())	
	local destination = self.path:getFront()
	
	if self.timeLeftInBoost <= 0 then
		self.maxvel = self.defaultSpeed
	end
	self.timeLeftInBoost = self.timeLeftInBoost - dt

	-- if self:inBounds(v) then
	-- 	self.accel.x, self.accel.y = 0, 0
	-- 	self.vel.x, self.vel.y = 0, 0
	-- 	if destination then
	-- 		self.path:popFront()
	-- 	end
	-- else
	
	if self.mouseLeftBounds == false and self:inBounds(Vector(self.world.camera:mousepos())) ~= true then
		self.mouseLeftBounds = true
		self.path:start()
	end
	
	if destination and self.mouseLeftBounds then
		local diff = destination - self.pos
		while diff:len2() < 300 do
			self.path:popFront()
			destination = self.path:getFront()
			
			if destination == nil then return end
			diff = destination - self.pos
		end
		
		diff:normalize_inplace()
		self.vel = diff * self.maxvel
		self:setAngle(math.atan2(diff.y, diff.x) + math.pi / 2)
	else
		self.vel.x, self.vel.y = 0, 0
		self.accel.x, self.accel.y = 0, 0
	end
	
end

function Locomotive:draw()
	Entity.draw(self)
end