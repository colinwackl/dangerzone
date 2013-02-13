require "Entity"
Vector = require "hump.vector"
Class = require "hump.class"

ChainLink = Class({function(self, dataPath)
	Entity.construct(self, dataPath)
	self.renderLink = true
	self.points = { Vector(0, 0), Vector(0, 0) }
	self.sprites = {}
	for i = 1, self.data.dotCount do
		local sprite = LayeredSprite:new()
		sprite:init("cell.sprite", "trail")
		table.insert(self.sprites, sprite)
	end
	
	end,
name = "ChainLink", inherits = Entity})

function ChainLink:start()
	self.renderLink = true
end

function ChainLink:stop()
	self.renderLink = false
end

function ChainLink:update(dt)
	Entity.update(self, dt)
	
	local diff = self.points[2] - self.points[1]
	local totalDistance = diff:len()
	diff:normalize_inplace()
	
	local currentDistance = 0
	local spriteCount = #self.sprites
	for i = 1, spriteCount do
		local v = self.points[1] + (diff * currentDistance)
		local sprite = self.sprites[i]
		sprite:setPosition(v)
		currentDistance = currentDistance + totalDistance / spriteCount
		
		sprite:update(dt)
	end
	
end

function ChainLink:draw()
	Entity.draw(self)
	
	if self.renderLink then
		for _, sprite in ipairs(self.sprites) do
			sprite:draw()
		end
	end
end