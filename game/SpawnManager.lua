require "Entity"
require "tools"
Vector = require "hump.vector"
Class = require "hump.class"

SpawnManager = Class({function(self, dataPath)
	Entity.construct(self, dataPath)
	self.shooters = {}
	self.spikey = {}
	self.crates = {}
	self.currentLevel = 0
	self.targetShooters = 0
	self.targetSpikey = 0
	self.targetCrates = 0

	self.spawnRadius = 800
end,
name = "SpawnManager", inherits = Entity})

function SpawnManager:addEnemy(enemy, t)
	t[enemy] = enemy
	enemy.signals:register("destroyed", function(...) self:enemyDestroyed(...) end)
end

function SpawnManager:enemyDestroyed(enemy)
	self.shooters[enemy] = nil
	self.spikey[enemy] = nil
end

function SpawnManager:addCrate(crate)
	self.crates[crate] = crate
	crate.signals:register("destroyed", function(...) self:crateDestroyed(...) end)
end

function SpawnManager:crateDestroyed(crate)
	self.crates[crate] = nil
end

function SpawnManager:getEnemyCount(t)
	local count = 0
	for _, _ in pairs(t) do
		count = count + 1
	end
	
	return count
end

function SpawnManager:getCrateCount()
	local crateCount = 0
	for _, _ in pairs(self.crates) do
		crateCount = crateCount + 1
	end
	
	return crateCount
end

function SpawnManager:updateLevel()
	if self.currentLevel > #self.data.levels - 1 then return end
	
	local nextLevelData = self.data.levels[self.currentLevel + 1]
	local crateCount = self.world.player:getCrateCount()
	if nextLevelData and crateCount >= nextLevelData.cratesNeeded then
		local function after() self.world:updateBoundaries() end
		self.world.camera:setScaleOverTime(nextLevelData.zoom, 6, after)
		
		self.targetShooters = nextLevelData.shooters or self.targetShooters
		self.targetCrates = nextLevelData.crates or self.targetCrates
		self.targetSpikey = nextLevelData.spikey or self.targetSpikey
		self.crateSpawnChances = nextLevelData.crateChances or self.crateSpawnChances
		
		-- normalize spawn chance
		local totalChances = 0
		for _, chance in pairs(self.crateSpawnChances) do
			totalChances = totalChances + chance
		end
		
		for name, chance in pairs(self.crateSpawnChances) do
			self.crateSpawnChances[name] = chance / totalChances
		end
		
		self.currentLevel = self.currentLevel + 1
		
	end
end

function SpawnManager:update(dt)
	Entity.update(self, dt)
	self:updateLevel()

	if self:getEnemyCount(self.shooters) < self.targetShooters then
		local enemy = Enemy("enemy", player)
		local speed = math.max(0.2, math.random())
		enemy:setPosition(self:getSpawnPosition())
		enemy.vel.x, enemy.vel.y = (speed * 20) - 10, (speed * 20) - 10
		spawnManager:addEnemy(enemy, self.shooters)
	end
	
	if self:getCrateCount() < self.targetCrates then
		local r = math.random()
		local crateData = nil
		local cumulative = 0
		for name, changes in pairs(self.crateSpawnChances) do
			if r < cumulative + changes then
				crateData = name
				break
			end
			cumulative = cumulative + changes
		end
		
		local crate = Crate(crateData)
		crate:setPosition(self:getSpawnPosition())
		crate.vel.x, crate.vel.y = (math.random() * 20) - 10, (math.random() * 20) - 10
		spawnManager:addCrate(crate)
	end
	
	if self:getEnemyCount(self.spikey) < self.targetSpikey then
		local enemy = Enemy("SpikeyEnemy", player)
		local speed = math.max(0.4, math.random())
		enemy:setPosition(self:getSpawnPosition())
		enemy.vel.x, enemy.vel.y = (speed * 400) - 200, (speed * 400) - 200
		spawnManager:addEnemy(enemy, self.shooters)
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
	local position = self.world:randomSpot()
	local center = vector(self.world.camera:pos())

	local distX = center.x - position.x
	local distY = center.y - position.y
	local squaredist = (distX * distX) + (distY * distY)
	while squaredist < (self.spawnRadius * self.spawnRadius) do
		position = self.world:randomSpot()
		distX = center.x - position.x
		distY = center.y - position.y
		squaredist = (distX * distX) + (distY * distY)
	end
	return vector(position.x, position.y)
end