require "Entity"
require "tools"
require "LayeredSprite"
require "Port"
Vector = require "hump.vector"
Class = require "hump.class"
timer = require "hump.timer"

Crate = Class({function(self, dataPath)
	Entity.construct(self, dataPath)
	
	local fixture = self:createFixture(nil, 1)
	fixture:setRestitution(0.4)
	fixture:setFriction(0)
	fixture:setDensity(0.1)
	
	local body = self:getBody()
	body:setMass(1)
	body:setAngularDamping(0)
	body:setAngle(math.rad(45))
	body:setLinearDamping(0)
	
	timer.add(2, function()
		print(" Body:getMassData( )",  body:getMassData())
		print("body:getLinearDamping()", body:getLinearDamping())
		body:applyForce(100, 100)
	end)

	self.portBow = Port("Port", self, "head")
	self.portStern = Port("Port", self, "tail")
	self.bowPos = Vector(0, 0)
	self.sternPos = Vector(0, 0)

	self.spawnTimer = 0
end,
name = "Crate", inherits = Entity})

function Crate:initSprite(strData, strAnimation)
	self.sprite = LayeredSprite:new()
	self.sprite:init(strData, strAnimation)
end

function Crate:setAnimation(strAnimation)
	self.sprite:setAnimation(strAnimation)
end

function Crate:getSternLinks()
	return self.portStern:getSternLinks()
end

function Crate:update(dt)
	Entity.update(self, dt)

	self.spawnTimer = self.spawnTimer + dt

	self.sprite:setAlpha(self.spawnTimer/10)
	
	self.sprite:setPosition(self.pos)
	self.sprite:setRotation(self.physics.body:getAngle())
	self.sprite:update(dt)

	-- -- update bow and stern ports
	self.bowPos.x, self.bowPos.y = 0, self.bounds.top
	self.sternPos.x, self.sternPos.y = 0, self.bounds.bottom

	self.bowPos.x, self.bowPos.y = self.physics.body:getWorldPoint(self.bowPos.x, self.bowPos.y)
	self.sternPos.x, self.sternPos.y = self.physics.body:getWorldPoint(self.sternPos.x, self.sternPos.y)

	if self.portBow ~= nil then
		self.portBow:setPosition(self.bowPos)
		self.portBow:update(dt)
	end
	if self.portStern ~= nil then
		self.portStern:setPosition(self.sternPos)
		self.portStern:update(dt)
	end
	
end

function Crate:draw()
	Entity.draw(self)
	self.sprite:draw()
end