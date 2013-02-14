require "Base"
require "hump.vector"
require "spritemanager"
require "AlphaEffect"

LayeredSprite = Base:new()
LayeredSprite.position = vector(0, 0)
LayeredSprite.rotation = 0
LayeredSprite.baseLayer = {}
LayeredSprite.topLayer = {}
LayeredSprite.effect = {}

function LayeredSprite:init(strData, strAnimation)
	self.baseLayer = spritemanager.createSprite()
	self.baseLayer.strData = strData--.."_glow"
	self.baseLayer.animation = strAnimation.."_glow"
	if self.baseLayer:hasAnimation(self.baseLayer.animation) then
		self.baseLayer:setData(self.baseLayer.strData, self.baseLayer.animation, true)
		self.baseLayer.sprData.image:setFilter("linear", "linear")
	end

	self.topLayer = spritemanager.createSprite()
	self.topLayer.strData = strData
	self.topLayer.animation = strAnimation
	self.topLayer:setData(self.topLayer.strData, self.topLayer.animation, true)
	self.topLayer.sprData.image:setFilter("linear", "linear")

	self.effect = AlphaEffect:new()
	self.effect:load()
end

function LayeredSprite:setPosition(pos)
	self.position = pos
end

function LayeredSprite:setAlpha(alpha)
	self.effect:setAlpha(alpha)
end

function LayeredSprite:setRotation(rot)
	self.rotation = rot
end

function LayeredSprite:setAnimation(animation)
	self.baseLayer:setAnimation(animation, true)
	self.topLayer:setAnimation(animation.."_glow", true)
end

function LayeredSprite:update(dt)
	self.effect:update(dt)

	self.baseLayer.x = self.position.x
	self.baseLayer.y = self.position.y

	self.baseLayer.rotation = self.rotation

	self.topLayer.x = self.position.x
	self.topLayer.y = self.position.y

	self.topLayer.rotation = self.rotation

	self.baseLayer:update(dt)
	self.topLayer:update(dt)
end

function LayeredSprite:draw()
	self.effect:setEffect()
	self.baseLayer:draw()
	self.topLayer:draw()
	self.effect:clearEffect()
end
