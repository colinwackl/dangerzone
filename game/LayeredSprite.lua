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
	self.baseLayer.strData = strData
	self.baseLayer.animation = strAnimation.."_glow"
	self.baseLayer:setData(self.baseLayer.strData, nil, true)
	--print("self.baseLayer.animation: ", self.baseLayer.animation)
	--print("self.baseLayer.strData: ", self.baseLayer.strData)
	if self.baseLayer:hasAnimation(self.baseLayer.animation) then
		self.baseLayer:setAnimation(self.baseLayer.animation)
		self.baseLayer.sprData.image:setFilter("linear", "linear")
	else
		self.baseLayer:setData()
	end

	self.topLayer = spritemanager.createSprite()
	self.topLayer.strData = strData
	self.topLayer.animation = strAnimation
	self.topLayer:setData(self.topLayer.strData, self.topLayer.animation, true)
	self.topLayer.sprData.image:setFilter("linear", "linear")
	
	self.animation = strAnimation

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

function LayeredSprite:setData(sprite, animation, keepTime)
	local glow = animation.."_glow"
	if self.baseLayer:hasAnimation(glow) then
		self.baseLayer:setData(sprite, animation, keepTime)
	end
	
	self.topLayer:setData(sprite, animation, keepTime)
	self.animation = animation
end

function LayeredSprite:setAnimation(animation)
	local glow = animation.."_glow"
	if self.baseLayer:hasAnimation(glow) then
		self.baseLayer:setAnimation(glow, true)
	end
	
	self.topLayer:setAnimation(animation, true)
	self.animation = animation
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
