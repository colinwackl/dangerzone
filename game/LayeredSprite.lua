require "Base"
require "hump.vector"
require "spritemanager"

LayeredSprite = Base:new()
LayeredSprite.position = vector(0, 0)
LayeredSprite.rotation = 0
LayeredSprite.baseLayer = {}
LayeredSprite.topLayer = {}
LayeredSprite.effect = {}

function LayeredSprite:init(strData, strAnimation)
	self.baseLayer = spritemanager.createSprite()
	self.baseLayer.strData = strData
	self.baseLayer.animation = strAnimation
	self.baseLayer:setData(self.baseLayer.strData, self.baseLayer.animation, true)
	self.baseLayer.sprData.image:setFilter("linear", "linear")

	self.topLayer = spritemanager.createSprite()
	self.topLayer.strData = strData--.."_glow"
	self.topLayer.animation = strAnimation.."_glow"
	self.topLayer:setData(self.topLayer.strData, self.topLayer.animation, true)
	self.topLayer.sprData.image:setFilter("linear", "linear")
end

function LayeredSprite:setPosition(pos)
	self.position = pos
end

function LayeredSprite:setRotation(rot)
	self.rotation = rot
end

function LayeredSprite:setAnimation(animation)
	self.baseLayer:setAnimation(animation, true)
	self.topLayer:setAnimation(animation.."_glow", true)
end

function LayeredSprite:update(dt)
	--LayeredSprite.effect:update(dt)

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
	--self.effect:setEffect()
	self.baseLayer:draw()
	--self.effect:clearEffect()
	self.topLayer:draw()
end
