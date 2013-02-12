require "Entity"
require "tools"
require "Bullet"
require "LayeredSprite"
Vector = require "hump.vector"
Class = require "hump.class"
timer = require "hump.timer"

Beam = Class({function(self, dataPath)
	Entity.construct(self, dataPath)	
end,
name = "Beam", inherits = Entity})

function Beam:initPhysics(physworld, body1, body2, maxLength)
	self.joint = love.physics.newRopeJoint(body1, body2, body1:getX() * love.physics:getMeter(), body1:getY() * love.physics:getMeter(), body2:getX() * love.physics:getMeter(), body2:getY() * love.physics:getMeter(), maxLength,  true)
end

function Beam:initSprite(strData, strAnimation)
	--self.sprite = LayeredSprite:new()
	--self.sprite:init(strData, strAnimation)
end

function Beam:setAnimation(strAnimation)
	--self.sprite:setAnimation(strAnimation)
end

function Beam:updateSprite(dt)
	--self.sprite:setPosition(self.pos)
	--self.sprite:setRotation(self.physics.body:getAngle())
	--self.sprite:update(dt)
end

function Beam:draw()	
	if DEBUG and self.joint ~= nil then
			love.graphics.setColor(255,0,0)
			love.graphics.setLineWidth(1)
			love.graphics.line(self.joint:getAnchors())
	end
end

function Beam:destroy()
	self.joint:destroy()
end