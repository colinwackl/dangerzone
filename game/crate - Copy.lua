require "Entity"
require "tools"
require "Bullet"
require "LayeredSprite"
Vector = require "hump.vector"
Class = require "hump.class"
timer = require "hump.timer"

Crate = Class({function(self, dataPath)
	Entity.construct(self, dataPath)	
end,
name = "Beam", inherits = Entity})

function Beam:initPhysics(physworld, body1, body2, maxLength)
	local ropeJoint = {}
	
	ropeJoint = love.physics:newRopeJoint(body1, body2, body1:getX(), body1.getY(), body2:getX(), body2.getY(), maxLength)

	self.joint = ropeJoint
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
	--love.graphics.setColor(self.data.colour[1], self.data.colour[2], self.data.colour[3], self.data.colour[4] or 255)
	--love.graphics.rectangle("fill", self.pos.x, self.pos.y, 100, 100)
	--self.sprite:draw()
	
	if DEBUG and self.bounds ~= nil then
		--love.graphics.push()
		--love.graphics.translate(self.pos.x, self.pos.y)
		love.graphics.setColor(255,0,0)
		love.graphics.line("line", self.joint:getAnchors())
		--love.graphics.pop()
	end
end

function Beam:destroy()
	self.joint:destroy()
end