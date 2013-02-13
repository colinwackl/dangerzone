require "Entity"
require "tools"
Vector = require "hump.vector"
Class = require "hump.class"

SpawnManager = Class({function(self, dataPath)
	Entity.construct(self, dataPath)
	self.shooters = {}
	self.currentLevel = 1
	self.targetShooters = 0

	self.spawnRadius = 800
end,
name = "SpawnManager", inherits = Entity})

function SpawnManager:addEnemy(enemy)
	self.shooters[enemy] = enemy
	enemy.signals:register("destroyed", function(...) self:enemyDestroyed(...) end)
end

function SpawnManager:enemyDestroyed(enemy)
	self.shooters[enemy] = nil
end

function SpawnManager:getShooterCount()
	local shooterCount = 0
	for _, _ in pairs(self.shooters) do
		shooterCount = shooterCount + 1
	end
	
	return shooterCount
end

function SpawnManager:updateLevel()
	if self.currentLevel > #self.data.levels - 1 then return end
	
	local nextLevelData = self.data.levels[self.currentLevel + 1]
	local crateCount = self.world.player:getCrateCount()
	if crateCount >= nextLevelData.cratesNeeded then
		local function after() self.world:updateBoundaries() end
		self.world.camera:setScaleOverTime(nextLevelData.zoom, 6, after)
		
		self.targetShooters = nextLevelData.shooters
		self.currentLevel = self.currentLevel + 1
	end
end

function SpawnManager:update(dt)
	Entity.update(self, dt)
	self:updateLevel()

	if self:getShooterCount() < self.data.levels[self.currentLevel].shooters then
		local enemy = Enemy("enemy", player)
		enemy:setPosition(self:getSpawnPosition())
		enemy.vel.x, enemy.vel.y = (math.random() * 20) - 10, (math.random() * 20) - 10
		spawnManager:addEnemy(enemy)
		self.world:addObject(enemy)
	end
end

function SpawnManager:draw()
	Entity.draw(self)

	-- love.graphics.push()
	-- love.graphics.setColor(0,0,255)
	-- love.graphics.setLine(1)
	-- love.graphics.translate(self.world.camera:pos())
	-- love.graphics.circle("line", 0, 0, self.spawnRadius)
	-- love.graphics.pop()
end

function SpawnManager:getSpawnPosition()

	local position = self.world:randomSpotOnScreen()
	local center = vector(self.world.camera:pos())

	local distX = center.x - position.x
	local distY = center.y - position.y
	local squaredist = (distX * distX) + (distY * distY)
	while squaredist < (self.spawnRadius * self.spawnRadius) do
		position = self.world:randomSpotOnScreen()
		distX = center.x - position.x
		distY = center.y - position.y
		squaredist = (distX * distX) + (distY * distY)
	end
	return vector(position.x, position.y)
end