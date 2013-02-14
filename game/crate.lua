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
	body:setMass(0)
	body:setAngularDamping(0)
	body:setAngle(math.rad(45))
	body:setLinearDamping(0)

	self.portSidePort = Port("GunPort", self, "port")
	self.starboardPort = Port("GunPort", self, "starboard")
	self.portBow = Port("Port", self, "head")
	self.portStern = Port("Port", self, "tail")

	self.spawnTimer = 0
end,
name = "Crate", inherits = Entity})

function Crate:destroy()
	self.portBow:destroy()
	self.portStern:destroy()
	self.portSidePort:destroy()
	self.starboardPort:destroy()

	Entity.destroy(self)
end

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

function Crate:hit(hitter)
	self:destroy()
end

function Crate:firePort(delay, additionalDelay)
	self.portSidePort:shoot(delay)
	self.portStern:firePort(delay, delay + additionalDelay)
end

function Crate:fireStarboard(delay, additionalDelay)
	self.starboardPort:shoot(delay)
	self.portStern:fireStarboard(delay, delay + additionalDelay)
end

function Crate:isAttachedToPlayer(checked)
	checked = checked or {}
	local attachedPort, attachedStern = false, false
	if checked[self.portStern] == nil and self.portStern.attachedLink then
		attachedPort = self.portStern.attachedLink:getOther(self.portStern):isAttachedToPlayer(checked)
	end
	
	if attachedPort == false and checked[self.portBow] == nil and self.portBow.attachedLink then
		attachedStern = self.portBow.attachedLink:getOther(self.portStern):isAttachedToPlayer(checked)
	end
	
	return attachedPort or attachedStern
end

function Crate:update(dt)
	Entity.update(self, dt)

	self.spawnTimer = self.spawnTimer + dt
	
	local rotation = self.physics.body:getAngle()

	self.sprite:setAlpha(self.spawnTimer/3)
	self.portStern:setLinkSpriteAlpha(self.spawnTimer/3)
	self.portBow:setLinkSpriteAlpha(self.spawnTimer/3)
	self.portSidePort:setLinkSpriteAlpha(self.spawnTimer/3)
	self.starboardPort:setLinkSpriteAlpha(self.spawnTimer/3)
	local gunsprite = self.starboardPort:getGunSprite()
	if gunsprite then
		gunsprite:setAlpha(self.spawnTimer/3)
	end
	gunsprite = self.portSidePort:getGunSprite()
	if gunsprite then
		gunsprite:setAlpha(self.spawnTimer/3)
	end

	
	self.sprite:setPosition(self.pos)
	self.sprite:setRotation(rotation)
	self.sprite:update(dt)

	-- -- update bow and stern ports
	local bowPos, sternPos = Vector(0, self.bounds.top), Vector(0, self.bounds.bottom)
	local portPos, starboardPos = Vector(self.bounds.left, 0), Vector(self.bounds.right, 0)

	bowPos.x, bowPos.y = self.physics.body:getWorldPoint(bowPos.x, bowPos.y)
	sternPos.x, sternPos.y = self.physics.body:getWorldPoint(sternPos.x, sternPos.y)
	portPos.x, portPos.y = self.physics.body:getWorldPoint(portPos.x, portPos.y)
	starboardPos.x, starboardPos.y = self.physics.body:getWorldPoint(starboardPos.x, starboardPos.y)

	if self.portBow ~= nil then
		self.portBow:setPosition(bowPos)
		self.portBow:update(dt)
	end
	if self.portStern ~= nil then
		self.portStern:setPosition(sternPos)
		self.portStern:update(dt)
	end
	if self.portSidePort ~= nil then
		self.portSidePort.angle = rotation - math.pi / 2
		self.portSidePort:setPosition(portPos)
		self.portSidePort:update(dt)
	end
	if self.starboardPort ~= nil then
		self.starboardPort.angle = rotation + math.pi / 2
		self.starboardPort:setPosition(starboardPos)
		self.starboardPort:update(dt)
	end
	
end

function Crate:draw()
	Entity.draw(self)
	self.sprite:draw()
end