require "Entity"
require "tools"
Vector = require "hump.vector"
Class = require "hump.class"

SpawnManager = Class({function(self, dataPath)
	Entity.construct(self, dataPath)
	self.shooters = {}
	self.currentLevel = 0
	self.targetShooters = 0
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

end

function SpawnManager:draw()
	Entity.draw(self)
end