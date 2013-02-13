require "tools"
Vector = require "hump.vector"
Class = require "hump.class"

BgParticleSystem = Class({name = "BgParticleSystem", function(self, image, buffer)
	buffer = buffer or 200
	self.particles = love.graphics.newParticleSystem(image, buffer)
end})

function BgParticleSystem:__index(key)
	local raw = rawget(BgParticleSystem, key)
	if raw then
		return raw
	else
		return function(_, ...)
			return self.particles[key](self.particles, ...)
		end
	end
end

local function callPeriodic(funct, args)
	args.funct(args.particles, dt)
end

function BgParticleSystem:setPeriodic(delay, funct, count)
	timer.addPeriodic(delay, callPeriodic, count, {particles = self, funct = funct})
end

function BgParticleSystem:update(dt)
	self.particles:update(dt)
end

function BgParticleSystem:draw()
	love.graphics.draw(self.particles)
end