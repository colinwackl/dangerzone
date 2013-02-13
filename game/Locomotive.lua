require "Entity"
require "tools"
require "FingerPath"
Vector = require "hump.vector"
Class = require "hump.class"
signal = require "hump.signal"

Locomotive = Class({function(self, dataPath)
	Entity.construct(self, dataPath)
	
	self:createSprites()
	self:createFixture()
	self.path = FingerPath("FingerPath")
	
	local body = self:getBody()
	body:setMass(self.data.mass or 100)
	
	self.friction = 5
	
	self.port = Port("Port", self)
	
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
end

function Locomotive:keyReleased(key)
	if key == "up" or key == "down" then
		self.accel.y = 0
	elseif key == "left" or key == "right"then
		self.accel.x = 0
	end
end

function Locomotive:startPath()
	self.path:start()
end

function Locomotive:stopPath()
	self.path:stop()
end

function Locomotive:getCrateCount()
	local count = self.port:getSternLinks()
	return count
end

function Locomotive:update(dt)
	Entity.update(self, dt)
	
	self.port:setPosition(Vector(self.physics.body:getWorldPoint(0, self.bounds.bottom)))
	
	local destination = self.path:getFront()
	if destination then
		local diff = destination - self.pos
		while diff:len2() < 300 do
			self.path:popFront()
			destination = self.path:getFront()
			
			if destination == nil then
				return
			end
			diff = destination - self.pos
		end
		
		diff:normalize_inplace()
		self.vel = diff * self.maxvel
		self:setAngle(math.atan2(diff.y, diff.x) + math.pi / 2)
	else
		self.accel.x, self.accel.y = 0, 0
	end
	
end

function Locomotive:draw()
	Entity.draw(self)
end