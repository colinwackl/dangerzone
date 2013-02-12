require "Base"
require "hump.vector"
require "spritemanager"

Sprite = Base:new()
Sprite.position = vector(0, 0)
Sprite.rotation = 0
Sprite.baseLayer = {}
Sprite.effect = {}

function Sprite:init(strData, strAnimation)
	self.baseLayer = spritemanager.createSprite()
	self.baseLayer.strData = strData
	self.baseLayer.animation = strAnimation
	self.baseLayer:setData(self.baseLayer.strData, self.baseLayer.animation, true)
	self.baseLayer.sprData.image:setFilter("linear", "linear")
end

function Sprite:setPosition(pos)
	self.position = pos
end

function Sprite:setRotation(rot)
	self.rotation = rot
end

function Sprite:setAnimation(animation)
	self.baseLayer:setAnimation(animation, true)
end

function Sprite:update(dt)
	--Sprite.effect:update(dt)

	self.baseLayer.x = self.position.x
	self.baseLayer.y = self.position.y

	self.baseLayer.rotation = self.rotation

	self.baseLayer:update(dt)
end

function Sprite:draw()
	--self.effect:setEffect()
	self.baseLayer:draw()
	--self.effect:clearEffect()
end
