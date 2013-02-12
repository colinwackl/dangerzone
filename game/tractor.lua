require "Base"
require "AlphaEffect"
require "Tools"

Tractor = Base:new()

local uniqueid = 1

function Tractor:init(cam, world)
	self.size = vector(30, 30)
	self.offset = vector(0,0)

	Base.init(self)

	self.cam = cam
	self.world = world

	--self.cam:worldCoords(love.mouse.getX(), love.mouse.getY())

	--Tractor.image = love.graphics.newImage("res/sprites/seed.png")--.."/palette.png")
	--Tractor.image:setFilter("linear", "linear")

	Tractor.effect = AlphaEffect:new()
	Tractor.effect:load()
end

function Tractor:draw(notranslation)
	love.graphics.push()

	--love.graphics.translate(self.pos.x, self.pos.y)
	----love.graphics.translate(-self.offset.x / 2, -self.offset.y)
	--love.graphics.setColor(173, 69, 0)
	--love.graphics.circle("fill", 0, 0, self.size.x / 2)

	Tractor.effect:setAlpha(1.0)
	Tractor.effect:setEffect()
	if not notranslation then
		love.graphics.translate(self.pos.x, self.pos.y)
	end
	love.graphics.translate(-self.offset.x, -self.offset.y)
	--love.graphics.draw(Tractor.image, 0, 0, 0,  1, 1, 0, 0)
	Tractor.effect:clearEffect()

	love.graphics.pop()

	Base.draw(self)
end

function Tractor:update(dt)
	if love.mouse.isDown("l") then
		local x,y = self.cam:worldCoords(love.mouse.getX(), love.mouse.getY())
		local hit = self.world:getClickedObject(x, y)
		if clickedInBox then				
			local tractor = self.world:getTractor()
			if tractor then
				local force_x, force_y = math.clamp((x - tractor.physics.body:getX())/100, -10000 , 10000), math.clamp((y - tractor.physics.body:getY())/100, -10000 , 10000)
				tractor.physics.body:setPosition(tractor.physics.body:getX() + force_x, tractor.physics.body:getY() + force_y)
			end
		end
	end	

	Base.update(self, dt)
end
