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
	
	local body = self:getBody()
	body:setMass(0)
	body:setAngularDamping(0)
	body:setAngle(math.rad(45))

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
	end
	if self.portStern ~= nil then
		self.portStern:setPosition(self.sternPos)
	end

	self.portBow:update(dt)
	self.portStern:update(dt)
end

function Crate:draw()
	Entity.draw(self)
	self.sprite:draw()
end