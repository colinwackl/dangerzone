require "Base"
require "tools"
Vector = require "hump.vector"
Class = require "hump.class"

Entity = Class({function(self)
	self.pos = vector(0, 0)
end, inherits = Base})

Entity.pos = vector(0, 0)

function Entity:load(path)
	path =  'data/' .. path
	if string.find(path, ".lua") == nil then path = path .. ".lua" end
	assert(love.filesystem.exists(path))
	
	self.data = love.filesystem.load(path)()
	
end

function Entity:update(dt)
	--print("self.super:update(dt)",  self.super)
	Base.update(self, dt)
end

function Entity:draw()
	Base.draw(self)
end