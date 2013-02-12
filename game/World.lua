vector = require("hump.vector")

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
World.quad = {}
World.image = {}

local physobjs = {}

function World:draw()
	love.graphics.setColorMode("replace")
	love.graphics.drawq(World.image, World.quad, 0, 0, 0, 
		0.5, 0.5, 
		0, 0)

	-- --draw sky
	-- love.graphics.setColor(128,128,255,100)
	-- love.graphics.rectangle("fill", 0,0, 
	-- 						love.graphics.getWidth(), love.graphics.getHeight() * self.pctsky)

	-- --draw horizon
	-- love.graphics.setColor(0, 128, 0, 100)
	-- love.graphics.rectangle("fill", 0, self.pctsky * love.graphics.getHeight(),
	-- 						love.graphics.getWidth(), love.graphics.getHeight() * self.pcthorizon)

	-- --draw ground
	-- love.graphics.setColor(0,192, 0, 100)
	-- love.graphics.rectangle("fill", 0, (self.pctsky + self.pcthorizon) * love.graphics.getHeight(), 
	-- 						love.graphics.getWidth(), (1.0 - self.pctsky - self.pcthorizon) * love.graphics.getHeight())

	for i,v in ipairs(self.objects) do
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

	--love.graphics.draw(World.image, 0, 0, 0, 
	--	1, 1, 
	--	0, 0)
end

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

	table.insert(self.objects, obj)
end

function World:removeObject(obj)
    for i, v in ipairs(self.objects) do
	    if v == obj then
	    	v.world = nil
	        table.remove(self.objects,i)

	        if v.physics then
	        	v.physics.body:setActive(false)
	        end

	        return
	    end
	end
end


function World:randomSpot()
	local bounds = self:getGroundBounds()

	return vector( bounds.left + (bounds.right - bounds.left) * math.random(),
				    bounds.top + (bounds.bottom - bounds.top) * math.random() ) 

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


function World:init()
	love.physics.setMeter(128)
	local world = love.physics.newWorld(0, 0, true)

	self.physworld = world

	physobjs.bottom = {}
	physobjs.bottom.body = love.physics.newBody(world, 0, love.graphics.getHeight() + 2)
	physobjs.bottom.shape = love.physics.newRectangleShape( self.maxx - self.minx, 1)
	physobjs.bottom.fixture = love.physics.newFixture(physobjs.bottom.body, physobjs.bottom.shape)

	physobjs.top = {}
	physobjs.top.body = love.physics.newBody(world, 0, 0 - 2)
	physobjs.top.shape = love.physics.newRectangleShape( self.maxx - self.minx, 1)
	physobjs.top.fixture = love.physics.newFixture(physobjs.top.body, physobjs.top.shape)

	physobjs.left = {}
	physobjs.left.body = love.physics.newBody(world, 0, 0 - 2)
	physobjs.left.shape = love.physics.newRectangleShape(1, self.maxy - self.miny)
	physobjs.left.fixture = love.physics.newFixture(physobjs.left.body, physobjs.left.shape)

	physobjs.right = {}
	physobjs.right.body = love.physics.newBody(world, love.graphics.getWidth() + 2, 0)
	physobjs.right.shape = love.physics.newRectangleShape(1, self.maxy - self.miny)
	physobjs.right.fixture = love.physics.newFixture(physobjs.right.body, physobjs.right.shape)

	World.image = love.graphics.newImage("res/bg.png")
	World.image:setFilter("linear", "linear")
	--World.quad = love.graphics.newQuad(0, 0, World.image:getWidth(), World.image:getHeight(), World.image:getWidth(), World.image:getHeight())
	World.quad = love.graphics.newQuad(0, 0, love.graphics.getWidth() * 2, love.graphics.getHeight() * 2, love.graphics.getWidth() * 2, love.graphics.getHeight() * 2)
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
	for i,obj in ipairs(self.objects) do
		if obj:inBounds(vector(x,y)) then
			return obj
		end
	end
end



function World:update(dt)

	local physdt = dt

	if SPEEDUP then
		physdt = dt / 10.0
	end

	self.physworld:update(physdt)
	for i,v in ipairs(self.objects) do
		if v.lifetime ~= nil and v.lifetime < 0 then
			self:removeObject(v)
		else
			v:update(dt)
		end
	end
end
