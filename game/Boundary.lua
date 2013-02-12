require "Entity"
require "tools"
Vector = require "hump.vector"
Class = require "hump.class"

Boundary = Class({function(self, dataPath)
	Entity.construct(self, dataPath)
	self.physicsBodyType = "static"
	self:setBounds({x = 20, y = 20 }) -- temp until updateBoundary is called
	
end,
name = "Boundary", inherits = Entity})

function Boundary:updateBoundary(side, camera)
	if self.physics then
		local fixture = self.physics.fixtures[1]
		self.physics.fixtures[1] = nil
		fixture:destroy()
	end
	
	local cameraPosX, cameraPosY = camera:pos()
	local width, height = love.graphics.getWidth() * (1 / camera.scale), love.graphics.getHeight() * (1 / camera.scale)
	local left, right, top, bottom = cameraPosX - (width / 2), cameraPosX + (width / 2), cameraPosY - (height / 2), cameraPosY + (height / 2)
	
	local bounds = {x = 0, y = 0}
	local pos = self.pos
	if side == "left" then
		bounds.x, bounds.y = 5, height
		pos = Vector(left, cameraPosY)
	elseif side == "right" then
		bounds.x, bounds.y = 5, height
		pos = Vector(right, cameraPosY)
	elseif side == "top" then
		bounds.x, bounds.y = width, 5
		pos = Vector(cameraPosX, top)
	elseif side == "bottom" then
		bounds.x, bounds.y = width, 5
		pos = Vector(cameraPosX, bottom)
	end
	
	self:setBounds(bounds)
	self:createFixture()
	self:setPosition(pos)
end

function Boundary:draw()
	Entity.draw(self)
	
	--[[local pos = self.pos:clone()
	pos.x = pos.x - self.bounds:width() / 2
	pos.y = pos.y - self.bounds:height() / 2
	love.graphics.rectangle("fill", pos.x, pos.y, self.bounds:width(), self.bounds:height())]]
end