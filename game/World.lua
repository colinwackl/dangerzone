vector = require("hump.vector")
require "Boundary"
require "BgParticleSystem"

World = Base:new()
World.pctsky = 0.6
World.pcthorizon = 0.34
World.objects = {}

World.minx = 0
World.maxx = 1280 * 3
World.miny = 0
World.maxy = 960 * 3
World.thickness = 100

World.radiationdensity = 0.1
World.radiationrange = 3
World.baserads = 0.5
World.radiationfalloff = 2.5

World.groundresolution = 40
World.ground = {}
World.particles = {}

local physobjs = {}

-- t,l,b,r
function World:getGroundBounds()
	local t =  { 
		top = self:getGroundHeight(),
		left = 0,
		bottom = self:getGroundHeight(),
		right = love.graphics.getWidth(),
	}

	return t
end

function World:getGroundHeight()
	return love.graphics.getHeight() * (self.pctsky + self.pcthorizon) 
end

function World:addObject(obj)
	obj.world = self
	if obj.onAddToWorld then
		obj:onAddToWorld(self)
	end
	if obj.physics then
		obj.physics.body:setActive(true)
	end

	self.objects[obj] = obj
end

function World:removeObject(obj)
	if self.objects[obj] then
		obj.world = nil
		self.objects[obj] = nil

		if obj.physics then
			obj.physics.body:setActive(false)
		end
	end
end

function World:randomSpot(scale)
	scale = scale or 1
	return vector( math.random(self:getLeft(), self:getRight()) * scale, math.random(self:getTop(), self:getBottom() * scale) ) 
end

function World:randomSpotOnScreen(scale)
	scale = scale or 1
	return vector( math.random(self:getLeft(), self:getRight()), math.random(self:getTop(), self:getBottom()) ) 
end

function World:debugDrawGround()

	local y = self:getGroundHeight()
	--for i=1,table.maxn(self.ground) do
	--	slice = self.ground[i]
	for i,slice in ipairs(self.ground) do
		local x = self.minx + (i - 1) * self.groundresolution
		local mx = self.minx + i * self.groundresolution
		--draw radiation as horizontal line

		local a = slice.radiation * 255
		love.graphics.setColor(255, 0, 0, a)
		love.graphics.line(x, y, mx, y)
		--draw it as a vertical line too cause ugh
		love.graphics.setColor(255,0,0)
		local nx = x + (mx - x) * 0.5
		love.graphics.line(nx, y, nx, y - slice.radiation * 100)


		-- draw nutrition as a brown line
		local nx = x + (mx - x) * 0.4
		love.graphics.setColor(114,45,0)
		love.graphics.line(nx, y, nx, y - slice.nutrition * 50)

		-- draw water as a blue line
		local wx = x + (mx - x) * 0.6
		love.graphics.setColor(0,255,255)
		love.graphics.line(wx, y, wx, y - slice.water * 50)
	end

end

function World:getPatch(pos)
	local index = math.floor( (pos.x - self.minx) / self.groundresolution ) + 1
	return self.ground[index]
end

function World:addStableParticle(r, g, b)
	local image = love.graphics.newImage("res/circle.png")
	local p = BgParticleSystem(image, 40)
	table.insert(self.particles, p)
	p:setColors(r, g, b, 0, r, g, b, 255, r, g, b, 0)
	p:setEmissionRate(10)
	p:setSizes(0.1, 2.5)
	p:setDirection(1)
	p:setParticleLife(15, 30)
	
	local function periodic(particles, dt)
		local spot = self:randomSpot(3)
		particles:setPosition(spot.x, spot.y)
	end
	p:setPeriodic(0.1, periodic, math.huge)
	p:start()
end

function World:addFastSmallParticle(r, g, b)
	local image = love.graphics.newImage("res/smallparticle.png")
	local p = BgParticleSystem(image, 40)
	table.insert(self.particles, p)
	p:setColors(r, g, b, 0, r, g, b, 255, r, g, b, 0)
	p:setEmissionRate(2)
	p:setSizes(1, 1.5)
	p:setRotation(0, math.pi * 2)
	p:setDirection(math.random() * math.pi * 2)
	p:setSpeed(15, 100)
	p:setParticleLife(3, 6)
	
	local function periodic(particles, dt)
		local spot = self:randomSpot()
		particles:setPosition(spot.x, spot.y)
		p:setDirection(math.random() * math.pi * 2)
	end
	p:setPeriodic(0.1, periodic, math.huge)
	p:start()

end

function World:init()
	love.physics.setMeter(128)
	local world = love.physics.newWorld(0, 0, true)

	self.physworld = world
	self.availablePorts = {}
	world:setCallbacks( self.beginContact, self.endContact, self.preSolve, self.postSolve )
	
	self.boundaries = {left = Boundary(), right = Boundary(), top = Boundary(), bottom = Boundary()}
	self:updateBoundaries()
	
	self:addStableParticle(188, 187, 183)
	
	self:addFastSmallParticle(188, 187, 183)
	
end

function World:updateBoundaries()
	for name, boundary in pairs(self.boundaries) do
		boundary:updateBoundary(name, self.camera)
	end
end

function World:addCirclePhysics(obj)
	local circle = {}
	
	circle.body = love.physics.newBody(self.physworld, obj.pos.x, obj.pos.y, "dynamic") --place the body in the center of the world and make it dynamic, so it can move around
	circle.body:setMass(15) --give it a mass of 15
	circle.body:setAngularDamping(12)
	circle.shape = love.physics.newCircleShape( obj.size.x / 2 ) --the ball's shape has a radius of 20
	circle.fixture = love.physics.newFixture(circle.body, circle.shape, 1) --attach shape to body and give it a friction of 1
	circle.fixture:setRestitution(0.4) --let the ball bounce

	obj.physics = circle

	 

	--circle.body:applyForce(100, 100)
end

function World:addSquarePhysics(obj)
	local square = {}
	
	square.body = love.physics.newBody(self.physworld, obj.pos.x, obj.pos.y, "dynamic") --place the body in the center of the world and make it dynamic, so it can move around
	square.body:setMass(15) --give it a mass of 15
	square.body:setAngularDamping(12)
	square.shape = love.physics.newRectangleShape( obj.size.x, obj.size.y) --the ball's shape has a radius of 20
	square.fixture = love.physics.newFixture(square.body, square.shape, 1) --attach shape to body and give it a friction of 1
	square.fixture:setRestitution(0.4) --let the ball bounce

	obj.physics = square

	table.insert( physobjs, square )

	--square.body:applyForce(-2100, -2500)
end

function World:create()
	--add initial seed somewhere:

end

function World:getClickedObject(x, y)
	for i,obj in pairs(self.objects) do
		if obj:inBounds(vector(x,y)) then
			return obj
		end
	end
end

function World:findEntityFromFixture(fixture)
	return fixture:getUserData()
end

function World.beginContact(a, b, c)
	World.signal(a, b, c, "beginContact")
end

function World.endContact(a, b, c)
	World.signal(a, b, c, "endContact")
end

function World.preSolve(a, b, c)
	World.signal(a, b, c, "preSolve")
end

function World.postSolve(a, b, c)
	World.signal(a, b, c, "postSolve")
end

function World.signal(a, b, c, name)
	local aEntity, bEntity = a:getUserData(), b:getUserData()
	if aEntity and aEntity:is_a(Entity) and bEntity and bEntity:is_a(Entity) then
		aEntity.signals:emit(name, aEntity, bEntity, c)
		bEntity.signals:emit(name, bEntity, aEntity, c)
	end
end

--[[local cameraPosX, cameraPosY = camera:pos()
local width, height = love.graphics.getWidth() * (1 / camera.scale), love.graphics.getHeight() * (1 / camera.scale)
local left, right, top, bottom = cameraPosX - (width / 2), cameraPosX + (width / 2), cameraPosY - (height / 2), cameraPosY + (height / 2)]]

function World:getWidth()
	return love.graphics.getWidth() * (1 / self.camera.scale)
end

function World:getHeight()
	return love.graphics.getHeight() * (1 / self.camera.scale)
end

function World:getLeft()
	local x = self.camera:pos()
	return x - (self:getWidth() / 2)
end

function World:getRight()
	local x = self.camera:pos()
	return x + (self:getWidth()  / 2)
end

function World:getTop()
	local _, y = self.camera:pos()
	return y - (self:getHeight() / 2)
end

function World:getBottom()
	local _, y = self.camera:pos()
	return y + (self:getHeight() / 2)
end

function World:getClosestAvailablePort(pos, compatibleWith)
	local bestPort, bestDistance = nil, math.huge
	for i, port in pairs(self.availablePorts) do
		if compatibleWith == nil or port:isCompatible(compatibleWith) then
			local diff = port.pos - pos 
			local currentDistance = diff:len2()
			if currentDistance < bestDistance then
				bestPort, bestDistance = port, currentDistance
			end
		end
	end
	
	if bestPort then
		bestDistance = (bestPort.pos - pos):len()
	end
	
	return bestPort, bestDistance
end

function World:update(dt)

	local physdt = dt

	if SPEEDUP then
		physdt = dt / 10.0
	end

	self.physworld:update(physdt)
	for i,v in pairs(self.objects) do
		if v.lifetime ~= nil and v.lifetime < 0 then
			self:removeObject(v)
		else
			v:update(dt)
		end
	end
	
	for _, particle in ipairs(self.particles) do
		particle:update(dt)
	end
end

function World:draw()
	love.graphics.setColorMode("replace")
	
	love.graphics.setColorMode("modulate")
	for _, particle in ipairs(self.particles) do
		particle:draw()
	end

	for i,v in pairs(self.objects) do
		v:draw()
	end

	if DRAWPHYSICS then
		--love.graphics.setColor(72, 160, 14) -- set the drawing color to green for the ground
		--love.graphics.polygon("fill", physobjs.ground.body:getWorldPoints(physobjs.ground.shape:getPoints())) -- draw a "filled in" polygon using the ground's coordinates

		for i,v in ipairs(physobjs) do
			if v.body:isActive() then
				if v.shape:type() == "CircleShape" then
					love.graphics.setColor(255, 0, 0) --set the drawing color to red for the ball
					love.graphics.circle("fill", v.body:getX(), v.body:getY(), v.shape:getRadius())
				elseif v.shape:type() == "PolygonShape" then
					love.graphics.setColor(255, 0, 0) --set the drawing color to red for the ball
					love.graphics.push()
					love.graphics.translate(v.body:getX(), v.body:getY())
					love.graphics.polygon("fill", v.shape:getPoints())
					love.graphics.pop()
				end
			end
		end
	end
end
