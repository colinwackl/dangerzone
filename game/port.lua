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
	
	self.headLink = nil
	self.tailLink = nil
	self.type = type
	
	self.effectiveDistance = self.data.effectiveDistance or 500
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
	--[[local x1, y1 = self.pos.x, self.pos.y
	local x2, y2 = port.pos.x, port.pos.y]]
	
	--[[local x1, y1 = self.parent.physics.body:getLocalVector(self.pos.x, self.pos.y)
	local x2, y2 = port.parent.physics.body:getLocalVector(port.pos.x, port.pos.y)]]
	
	local x1, y1 = self.parent.physics.body:getWorldCenter()
	local x2, y2 = port.parent.physics.body:getWorldCenter()
	local x3, y3 = self.pos.x, self.pos.y
	local diffx, diffy = x3 - x1, y3 - y1
	print("x1, y1", x1, y1, "x3, y3", x3, y3)
	
	--[[local x1, y1 = 0, 0
	local x2, y2 = 0, 0]]
		
	x1, y1, x2, y2, x3, y3 = x1 * meter, y1 * meter, x2 * meter, y2 * meter, x3 * meter, y3 * meter
	--x1, y1, x2, y2 = x1 * meter, y1 * meter, x2 * meter, y2 * meter
	x3 = x1 + diffx
	y3 = y1 + diffy
	print("x1, y1", x1, y1, "x3, y3", x3, y3)
	

	self.link.joint = love.physics.newRopeJoint(self.parent.physics.body, port.parent.physics.body,
		x3, y3, x2, y2, distance)
	
	self.headLink = self.link
	port.tailLink = self.link
	self.link = nil
	
	self.world.availablePorts[port] = nil
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

function Port:update(dt)
	Entity.update(self, dt)
	
	if self.link then
		self.link.points[1] = self.pos
		self.link.points[2] = Vector(self.world.camera:mousepos())
	end
	
	if self.headLink then
		local x1, y1, x2, y2 = self.headLink.joint:getAnchors()
		--print("x1, y1, x2, y2", x1, y1, x2, y2 )
		self.headLink.points[1] = Vector(x1, y1)
		self.headLink.points[2] = Vector(x2, y2)
	end
	
	--[[if self.headLink then
		self.headLink.points[1] = self.pos
	end
	
	if self.tailLink then
		self.tailLink.points[2] = self.pos
	end]]
end

function Port:draw()
	Entity.draw(self)
	self:drawBounds()
end