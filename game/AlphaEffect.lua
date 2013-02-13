require "Base"
require "hump.vector"

AlphaEffect = Base:new()

local path = ...
if type(path) ~= "string" then
	path = "."
end

function AlphaEffect:load()
	local src = [[
		extern number alpha;

		vec4 effect(vec4 color, Image tex, vec2 tc, vec2 pc)
		{
			vec4 sample = Texel(tex, tc);
			sample.a = min(sample.a, alpha);
			return sample;
		}
	]]

	self.effect = love.graphics.newPixelEffect(src)
	self.effect:send('alpha', 1)

end

function AlphaEffect:setEffect()
	love.graphics.setPixelEffect(self.effect)
end

function AlphaEffect:clearEffect()
	love.graphics.setPixelEffect()
end

function AlphaEffect:setAlpha(alpha)
	self.effect:send('alpha', alpha)
end
