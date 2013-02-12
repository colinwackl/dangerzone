require "Entity"
require "tools"
require "Bullet"
require "Sprite"
Vector = require "hump.vector"
Class = require "hump.class"
timer = require "hump.timer"

Crate = Class({function(self, dataPath)
	Entity.construct(self, dataPath)	
end,
name = "Crate", inherits = Entity})

function Crate:initPhysics(physworld)
	local square = {}
	
	square.body = love.physics.newBody(physworld, self.pos.x, self.pos.y, "dynamic") --place the body in the center of the world and make it dynamic, so it can move around
	square.body:setMass(15) --give it a mass of 15
	square.body:setAngularDamping(0)
	square.body:setAngularVelocity(1000)
	square.body:setAngle(math.rad(45))
	square.shape = love.physics.newRectangleShape( self.bounds:width(), self.bounds:height()) --the ball's shape has a radius of 20
	square.fixture = love.physics.newFixture(square.body, square.shape, 1) --attach shape to body and give it a friction of 1
	square.fixture:setRestitution(0.4) --let the ball bounce

	self.physics = square
end

function Crate:initSprite(strData, strAnimation)
	self.sprite = Sprite:new()
	self.sprite:init(strData, strAnimation)
end

function Crate:setAnimation(strAnimation)
	self.sprite:setAnimation(strAnimation)
end

function Crate:updateSprite(dt)
	self.sprite:setPosition(self.pos)
	self.sprite:setRotation(self.physics.body:getAngle())
	self.sprite:update(dt)
end

function Crate:draw()
	-- love.graphics.setColor(self.data.colour[1], self.data.colour[2], self.data.colour[3], self.data.colour[4] or 255)
	-- love.graphics.rectangle("fill", self.pos.x, self.pos.y, 100, 100)
	self.sprite:draw()
end