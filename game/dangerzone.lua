require "base"
require "tools"

Seed = Base:new()

local uniqueid = 1

function Dangerzone:init(plant)
end

function Dangerzone:draw(notranslation)
	love.graphics.push()

	love.graphics.pop()

	Base.draw(self)
end

function Seed:update(dt)
	Base.update(self, dt)
end
