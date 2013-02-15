require "Entity"
require "tools"
Vector = require "hump.vector"
Class = require "hump.class"
signals = require "hump.signal"

FingerPath = Class({function(self, dataPath)
	Entity.construct(self, dataPath)
	self:reset()
	self.maxLength = self.data.maxLength or 300
	self.lineWidth = self.data.lineWidth or 3
	self.lineColour = self.data.colour or {255, 255, 255, 255}
	self.maxDistanceBetweenLines = self.data.maxDistanceBetweenLines or 5
	
	world:addObject(self)
end,
name = "FingerPath", inherits = Entity})

function FingerPath:start()
	self:reset()
	self.recording = true
end

function FingerPath:stop()
	self.recording = false
end

function FingerPath:reset()
	self.points = {}
	self.currentLength = 0
	self.recording = false
end

function FingerPath:getFront()
	return self.points[1]
end

function FingerPath:popFront()
	if #self.points > 1 then
		local diff = self.points[1] - self.points[2]
		self.currentLength = self.currentLength - diff:len()
	end
	table.remove(self.points, 1)
end

function FingerPath:pushBack(point)
	table.insert(self.points, point)
		
	if #self.points > 1 then
		local lastVector = self.points[#self.points - 1]
		local diff = point - lastVector
		local diffLength = diff:len()
		self.currentLength = self.currentLength + diffLength
		
		local diffNormal = diff:normalized()
		while diffLength > self.maxDistanceBetweenLines do
			lastVector = self.points[#self.points - 1]
			table.insert(self.points, #self.points, lastVector + diffNormal * self.maxDistanceBetweenLines)
			diffLength = diffLength - self.maxDistanceBetweenLines
		end
	end
end

function FingerPath:update(dt)
	Entity.update(self, dt)
	
	if self.recording and self.currentLength < self.maxLength then
		local v = Vector(self.world.camera:mousepos())

		-- if self.world.player:inBounds(v)  andthen
		-- 	return
		-- end
		self:pushBack(v)
		
	end	
end

function FingerPath:draw()
	local line = {}
	for _, point in ipairs(self.points) do
		table.insert(line, point.x)
		table.insert(line, point.y)
	end
	
	if #line > 3 then
		love.graphics.setColor(self.lineColour[1], self.lineColour[2], self.lineColour[3], self.lineColour[4])
		love.graphics.setLine(self.lineWidth, "smooth")
		love.graphics.line(line)
	end
end