require "Entity"
require "tools"
require "LayeredSprite"
Vector = require "hump.vector"
Class = require "hump.class"
timer = require "hump.timer"

Port = Class({function(self, dataPath, parent, type)
	Entity.construct(self, dataPath)
	self.parent = parent
	self.world.availablePorts[self] = self
	
	self.attachedLink = nil
	self.type = type
	
	self.effectiveDistance = self.data.effectiveDistance or 500
	self.maxLinkDistance = self.data.maxLinkDistance or 100
end,
name = "Port", inherits = Entity})

function Port:startLink()
	if self.link then
		self.link:stop()
		self.link = nil
	end
	
	self.link = ChainLink("ChainLink")
	self.world.availablePorts[self] = nil
end

function Port:linkWith(port)
	assert(self ~= port, "Can't link with myself!")
	assert(self.link, "No link found!")
	local diff = self.pos - port.pos
	local distance = diff:len()
	
	local meter = love.physics:getMeter()
	local x1, y1 = self.pos.x, self.pos.y
	local x2, y2 = port.pos.x, port.pos.y

	self.link.joint = love.physics.newDistanceJoint(self.parent.physics.body, port.parent.physics.body, x1, y1, x2, y2)
	
	self.link.head = self
	self.link.tail = port
	port.attachedLink = self.link
	self.link = nil
	
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

function Port:endLink()
	local link = self.link
	self.link = nil
	self.world.availablePorts[self] = self
	return link
end

function Port:isCompatible(other)
	return self ~= other and self.parent ~= other.parent
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

function Port:update(dt)
	Entity.update(self, dt)
	
	if self.link then
		self.link.points[1] = self.pos
		self.link.points[2] = Vector(self.world.camera:mousepos())
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
				joint:setLength(length - (length * dt))
			end
		end
	end
	
end

function Port:draw()
	Entity.draw(self)
	self:drawBounds()
end