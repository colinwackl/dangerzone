require "Entity"
require "tools"
require "LayeredSprite"
Vector = require "hump.vector"
Class = require "hump.class"
timer = require "hump.timer"

Port = Class({function(self, dataPath, parent, type)
	Entity.construct(self, dataPath)
	self:createSprites()
	self:setLinkSpriteAlpha(0)
	
	self.parent = parent
	self.world.availablePorts[self] = self
	
	self.attachedLink = nil
	self.type = type
	
	self.portActive = false
	
	self.effectiveDistance = self.data.effectiveDistance or 300
	self.maxLinkDistance = self.data.maxLinkDistance or 100
	
	self.shootInterval = self.data.shootInterval or 0
	self.bulletData = self.data.bulletData or "Bullet"
	self.timeToNextShot = 0
end,
name = "Port", inherits = Entity})

function Port:destroy()
	if self.attachedLink ~= nil then
		self.attachedLink:destroy()
	end

	Entity.destroy(self)
end

function Port:getLinkSprite()
	return self.sprites[2]
end

function Port:setLinkSpriteAlpha(a)
	local linkSprite = self:getLinkSprite()
	if linkSprite then linkSprite:setAlpha(a) end
end

function Port:linkWith(port)
	assert(self ~= port, "Can't link with myself!")
	local diff = self.pos - port.pos
	local distance = diff:len()
	
	local meter = love.physics:getMeter()
	local x1, y1 = self.pos.x, self.pos.y
	local x2, y2 = port.pos.x, port.pos.y
	
	local link = ChainLink("ChainLink")

	link.joint = love.physics.newDistanceJoint(self.parent.physics.body, port.parent.physics.body, x1, y1, x2, y2)
	
	link.head = self
	link.tail = port
	self.attachedLink = link
	port.attachedLink = link
	
	self:setPortActive(false)
	link:getOther(self).parent.portStern:setPortActive(true)
	
	self.world.availablePorts[port] = nil
end

function Port:getSternLinks()
	local link = self.attachedLink
	if link then
		return link:getOther(self).parent:getSternLinks() + 1
	else
		return 0
	end
end

function Port:setPortActive(b)
	self:setLinkSpriteAlpha(0)
	self.portActive = b
end

function Port:clicked()
	if self.portActive and self.closePort then
		self:linkWith(self.closePort)
	end
end

function Port:isCompatible(other)
	return self ~= other and self.parent ~= other.parent and (self.type ~= other.type) and (self.type == "head" or other.type ~= "tail")
end

function Port:setupRopeJointWith(port)
	local meter = love.physics:getMeter()
	local x1, y1 = self.parent.physics.body:getWorldCenter()
	local x2, y2 = port.parent.physics.body:getWorldCenter()
	local x3, y3 = self.pos.x, self.pos.y
	local x4, y4 = port.pos.x, port.pos.y
	local diffx, diffy = x3 - x1, y3 - y1
	local diff2x, diff2y = x4 - x2, y4 - y2
	
	x1, y1, x2, y2, x3, y3 = x1 * meter, y1 * meter, x2 * meter, y2 * meter, x3 * meter, y3 * meter
	x3 = x1 + diffx
	y3 = y1 + diffy
	x4 = x2 + diff2x
	y4 = y2 + diff2y
	
	self.attachedLink.joint = love.physics.newRopeJoint(self.parent.physics.body, port.parent.physics.body, x3, y3, x4, y4, self.maxLinkDistance)
end

function Port:setRotation(r)	
	if self.sprites == nil then return end
	
	for _, sprite in ipairs(self.sprites) do
		sprite:setRotation(r)
	end
end

function Port:isAttachedToPlayer(checked)
	checked = checked or {}
	checked[self] = self
	return self.parent:isAttachedToPlayer(checked)
end

function Port:update(dt)
	Entity.update(self, dt)
	
	if self.portActive then
		local port, distance = self.world:getClosestAvailablePort(vector(self.pos.x, self.pos.y), self)
		if port and distance < port.effectiveDistance then
			self.closePort = port
			self:setLinkSpriteAlpha(1)
		else
			self.closePort = nil
			self:setLinkSpriteAlpha(0)
		end
	end
	
	if self.link then
		self.link.points[1] = self.pos
		self.link.points[2] = Vector(self.world.camera:mousepos())
	end
	
	
	if self.shootInterval > 0 and self:isAttachedToPlayer() then
		self.timeToNextShot = self.timeToNextShot - dt
		if self.timeToNextShot <= 0 then
			self.timeToNextShot = self.shootInterval
			local bulletAngle = self.angle + math.pi / 2
			local direction = Vector(math.cos(bulletAngle), math.sin(bulletAngle))
			local bullet = Bullet(self.bulletData, true)
			bullet:setPosition(self.pos + direction * 50)
			
			bullet.vel = direction * bullet.maxvel
			
		end
	end
	
	if self.attachedLink then
		local x1, y1, x2, y2 = self.attachedLink.joint:getAnchors()
		self.attachedLink.points[1] = Vector(x1, y1)
		self.attachedLink.points[2] = Vector(x2, y2)
		
		local joint = self.attachedLink.joint
		if joint and joint:getType() == "distance" then
			local length = joint:getLength()
			
			if length <= self.maxLinkDistance then
				joint:destroy()
				self:setupRopeJointWith(self.attachedLink:getOther(self))
			else
				joint:setLength(length - (length * dt / 3))
			end
		end

		-- local force = vector(self.attachedLink.joint:getReactionForce(dt))
		-- local torque = self.attachedLink.joint:getReactionForce(dt)
		-- force = force * 1000
		-- torque = torque * 1000
		-- if force ~= nil then
		-- 	self.attachedLink:getOther(self).parent.physics.body:applyForce(force.x, force.y)
		-- 	self.attachedLink:getOther(self).parent.physics.body:applyTorque(torque)
		-- end

		-- --local force2 = vector(self.attachedLink.joint:getReactionForce(dt))
		-- --local torque2 = self.attachedLink.joint:getReactionForce(dt)
		-- --force2 = force2 * 100
		-- --torque2 = torque2 * 100
		-- if force ~= nil then
		-- 	self.parent.physics.body:applyForce(force.x, force.y)
		-- 	self.parent.physics.body:applyTorque(torque)
		-- end

	end
	
end

function Port:draw()
	Entity.draw(self)
	
	if self.type == "head" then
		love.graphics.setColor(0, 0, 255, 255)
	else
		love.graphics.setColor(255, 0, 0, 255)
	end
	self:drawBounds()
end