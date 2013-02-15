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
	self.maxEnergy = self.data.maxEnergy or 0
	self.currentEnergy = self.maxEnergy
	self.prevEnergy = self.currentEnergy
	self.regenRate = 3
	self.timeToNextRegen = self.regenRate
	
	self.unlinkTime = 20
	self.fadeOutTime = 5
	self.timeToUnlinkDeath = self.unlinkTime

	self.spawnTimer = 0
end,
name = "Crate", inherits = Entity})

function Crate:destroy(explode)
	if explode == nil then
		explode = true
	end
	
	if explode then
		self.sprites[1]:setData("cell.sprite2", "explosion")
		timer.add(0.4, function() self:realDestroy() end)
	else
		self:realDestroy()
	end
end

function Crate:realDestroy()
	self.portBow:destroy()
	self.portStern:destroy()
	if self.portSidePort then self.portSidePort:destroy() end
	if self.starboardPort then self.starboardPort:destroy() end
	Entity.destroy(self)
end

function Crate:getGenerators(generators)
	if self.maxEnergy > 0 then
		table.insert(generators, self)
	end
	self.portStern:getGenerators(generators)
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

function Crate:setAlpha(a)
	Entity.setAlpha(self, a)
	if self.starboardPort then
		local gunsprite = self.starboardPort:getGunSprite()
		if gunsprite then
			gunsprite:setAlpha(a)
		end
	end
	
	if self.portSidePort then
		local gunsprite = self.portSidePort:getGunSprite()
		if gunsprite then
			gunsprite:setAlpha(a)
		end
	end
end

function Crate:update(dt)
	Entity.update(self, dt)

	self.spawnTimer = self.spawnTimer + dt
	
	local rotation = self.physics.body:getAngle()
	
	if self.prevEnergy ~= self.currentEnergy then
		self.prevEnergy = self.currentEnergy
		
		local animationName = "reactor" .. self.currentEnergy
		self.sprites[1]:setAnimation(animationName)
	end

	self:setAlpha(self.spawnTimer / 3)
	
	if self.maxEnergy > 0 and self.currentEnergy < self.maxEnergy and self.timeToNextRegen <= 0 then
		self.timeToNextRegen = self.regenRate
		self.currentEnergy = self.currentEnergy + 1
		
	end
	self.timeToNextRegen = self.timeToNextRegen - dt
	
	if self:isAttachedToPlayer() then
		self.timeToUnlinkDeath = self.unlinkTime
	else
		if self.timeToUnlinkDeath < 0 then
			self:destroy(false)
		end
	end
	
	if self.timeToUnlinkDeath < self.fadeOutTime then
		local a = 1 / (self.fadeOutTime / self.timeToUnlinkDeath)
		self:setAlpha(a)
	end
	self.timeToUnlinkDeath = self.timeToUnlinkDeath - dt

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
	
	--[[if self.currentEnergy > 0 then
		love.graphics.print(self.currentEnergy, self.pos.x, self.pos.y, self.angle, 2, 2)
	end]]
	
	--[[if self.timeToUnlinkDeath then
		local text = "unlink: " .. self.timeToUnlinkDeath
		love.graphics.print(text, self.pos.x, self.pos.y, self.angle, 2, 2)
	end]]
end