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

	self.portBow = Port("Port")
	self.portStern = Port("Port")
	self.bowPos = Vector(0, 0)
	self.sternPos = Vector(0, 0)
end,
name = "Crate", inherits = Entity})

function Crate:initSprite(strData, strAnimation)
	self.sprite = LayeredSprite:new()
	self.sprite:init(strData, strAnimation)
end

function Crate:setAnimation(strAnimation)
	self.sprite:setAnimation(strAnimation)
end

function Crate:update(dt)
	Entity.update(self, dt)
	
	self.sprite:setPosition(self.pos)
	self.sprite:setRotation(self.physics.body:getAngle())
	self.sprite:update(dt)

	-- -- update bow and stern ports
	self.bowPos.x, self.bowPos.y = 0, self.bounds.top
	self.sternPos.x, self.sternPos.y = 0, self.bounds.bottom

	self.bowPos.x, self.bowPos.y = self.physics.body:getWorldPoint(self.bowPos.x, self.bowPos.y)
	self.sternPos.x, self.sternPos.y = self.physics.body:getWorldPoint(self.sternPos.x, self.sternPos.y)

	if portBow ~= nil then
		self.portBow:setPosition(self.bowPos)
	end
	if portStern ~= nil then
		self.portStern:setPosition(self.sternPos)
	end

	self.portBow:update(dt)
	self.portStern:update(dt)
end

function Crate:draw()
	self.sprite:draw()
	
	if DEBUG and self.bounds ~= nil then
		love.graphics.push()
		--love.graphics.translate(self.pos.x, self.pos.y)
		love.graphics.setColor(255,0,0)
		love.graphics.setLine(1)
		love.graphics.translate(self.pos.x, self.pos.y)
		love.graphics.rotate(self.physics.body:getAngle())
		love.graphics.rectangle("line", self.bounds.left, self.bounds.top, self.bounds.right - self.bounds.left, self.bounds.bottom - self.bounds.top)
		love.graphics.pop()

		love.graphics.push()
		love.graphics.setColor(0,0,255)
		love.graphics.setLine(1)
		love.graphics.translate(self.bowPos.x, self.bowPos.y)
		love.graphics.circle("line", 0, 0, 100)
		love.graphics.pop()

		love.graphics.push()
		love.graphics.setColor(0,0,255)
		love.graphics.setLine(1)
		love.graphics.translate(self.sternPos.x, self.sternPos.y)
		love.graphics.circle("line", 0, 0, 100)
		love.graphics.pop()
	end
end