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
	
	local body = self:getBody()
	body:setMass(0)
	body:setAngularDamping(0)
	body:setAngle(math.rad(45))
	body:setLinearDamping(100)

	if self.data.hasGuns == true then
		self.portSidePort = Port("GunPort", self, "port")
		self.starboardPort = Port("GunPort", self, "starboard")
	end
	
	self.portBow = Port("Port", self, "head")
	self.portStern = Port("Port", self, "tail")
	
	self:createSprites()
	
	self.hp = self.data.hp or 1

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

function Crate:setAnimation(strAnimation)
	self.sprite:setAnimation(strAnimation)
end

function Crate:getSternLinks()
	return self.portStern:getSternLinks()
end

function Crate:hit(hitter)
	self.hp = self.hp - 1
	if self.hp <= 0 then
		self:destroy()
	end
end

function Crate:firePort(delay, additionalDelay)
	if self.portSidePort then
		self.portSidePort:shoot(delay)
	end
	
	self.portStern:firePort(delay + additionalDelay, additionalDelay)
end

function Crate:fireStarboard(delay, additionalDelay)
	if self.starboardPort then
		self.starboardPort:shoot(delay)
	end
	
	self.portStern:fireStarboard(delay + additionalDelay, additionalDelay)
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

	self:setAlpha(self.spawnTimer/3)
	--[[self.portStern:setLinkSpriteAlpha(self.spawnTimer/3)
	self.portBow:setLinkSpriteAlpha(self.spawnTimer/3)
	self.portSidePort:setLinkSpriteAlpha(self.spawnTimer/3)
	self.starboardPort:setLinkSpriteAlpha(self.spawnTimer/3)]]
	if self.starboardPort then
		local gunsprite = self.starboardPort:getGunSprite()
		if gunsprite then
			gunsprite:setAlpha(self.spawnTimer/3)
		end
	end
	
	if self.portSidePort then
		local gunsprite = self.portSidePort:getGunSprite()
		if gunsprite then
			gunsprite:setAlpha(self.spawnTimer/3)
		end
	end

	-- update bow and stern ports
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
end