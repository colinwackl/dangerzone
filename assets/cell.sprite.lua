-- Generated by Pumpkin

local data = {}

local path = ...
if type(path) ~= "string" then
	path = "."
end
data.image = love.graphics.newImage(path.."cell.sprite.png")
data.image:setFilter("nearest", "nearest")
data.animations = {
	body={
		[0]={u=128, v=224, w=96, h=192, offsetX=50, offsetY=102, duration=0.0333333},
		[1]={u=224, v=224, w=96, h=192, offsetX=50, offsetY=102, duration=0.0333333},
		[2]={u=448, v=192, w=96, h=190, offsetX=50, offsetY=102, duration=0.0333333},
		[3]={u=224, v=224, w=96, h=192, offsetX=50, offsetY=102, duration=0.0333333},
		[4]={u=448, v=192, w=96, h=190, offsetX=50, offsetY=102, duration=0.0333333},
		scale=1
	},
	body_glow={
		[0]={u=0, v=0, w=128, h=224, offsetX=63, offsetY=113, duration=0.0333333},
		[1]={u=0, v=224, w=128, h=224, offsetX=63, offsetY=113, duration=0.0333333},
		[2]={u=128, v=0, w=128, h=224, offsetX=63, offsetY=113, duration=0.0333333},
		[3]={u=0, v=224, w=128, h=224, offsetX=63, offsetY=113, duration=0.0333333},
		[4]={u=128, v=0, w=128, h=224, offsetX=63, offsetY=113, duration=0.0333333},
		scale=1
	},
	head={
		[0]={u=384, v=384, w=112, h=112, offsetX=59, offsetY=61, duration=0.0333333},
		[1]={u=512, v=382, w=112, h=112, offsetX=59, offsetY=61, duration=0.0333333},
		[2]={u=624, v=382, w=112, h=112, offsetX=59, offsetY=61, duration=0.0333333},
		[3]={u=512, v=382, w=112, h=112, offsetX=59, offsetY=61, duration=0.0333333},
		[4]={u=624, v=382, w=112, h=112, offsetX=59, offsetY=61, duration=0.0333333},
		scale=1
	},
	head_glow={
		[0]={u=640, v=160, w=144, h=144, offsetX=75, offsetY=73, duration=0.0333333},
		[1]={u=736, v=0, w=144, h=144, offsetX=75, offsetY=73, duration=0.0333333},
		[2]={u=880, v=0, w=144, h=144, offsetX=75, offsetY=73, duration=0.0333333},
		[3]={u=736, v=0, w=144, h=144, offsetX=75, offsetY=73, duration=0.0333333},
		[4]={u=880, v=0, w=144, h=144, offsetX=75, offsetY=73, duration=0.0333333},
		scale=1
	},
	heart={
		[0]={u=512, v=0, w=96, h=160, offsetX=49, offsetY=83, duration=0.0333333},
		[1]={u=544, v=160, w=96, h=160, offsetX=49, offsetY=83, duration=0.0333333},
		[2]={u=608, v=0, w=96, h=160, offsetX=49, offsetY=83, duration=0.0333333},
		[3]={u=544, v=160, w=96, h=160, offsetX=49, offsetY=83, duration=0.0333333},
		[4]={u=608, v=0, w=96, h=160, offsetX=49, offsetY=83, duration=0.0333333},
		scale=1
	},
	heart_glow={
		[0]={u=256, v=0, w=128, h=192, offsetX=64, offsetY=95, duration=0.0333333},
		[1]={u=320, v=192, w=128, h=192, offsetX=64, offsetY=95, duration=0.0333333},
		[2]={u=384, v=0, w=128, h=192, offsetX=64, offsetY=95, duration=0.0333333},
		[3]={u=320, v=192, w=128, h=192, offsetX=64, offsetY=95, duration=0.0333333},
		[4]={u=384, v=0, w=128, h=192, offsetX=64, offsetY=95, duration=0.0333333},
		scale=1
	},
	trail={
		[0]={u=0, v=496, w=9, h=9, offsetX=4, offsetY=5, duration=0.0333333},
		[1]={u=9, v=496, w=9, h=9, offsetX=4, offsetY=5, duration=0.0333333},
		[2]={u=18, v=496, w=9, h=9, offsetX=4, offsetY=5, duration=0.0333333},
		[3]={u=27, v=496, w=9, h=9, offsetX=4, offsetY=5, duration=0.0333333},
		[4]={u=36, v=496, w=9, h=9, offsetX=4, offsetY=5, duration=0.0333333},
		[5]={u=45, v=496, w=9, h=9, offsetX=4, offsetY=5, duration=0.0333333},
		scale=1
	},
	trail_glow={
		[0]={u=0, v=448, w=48, h=48, offsetX=22, offsetY=24, duration=0.0333333},
		[1]={u=48, v=448, w=48, h=48, offsetX=22, offsetY=24, duration=0.0333333},
		[2]={u=96, v=448, w=46, h=46, offsetX=21, offsetY=23, duration=0.0333333},
		[3]={u=142, v=416, w=42, h=42, offsetX=19, offsetY=21, duration=0.0333333},
		[4]={u=96, v=448, w=46, h=46, offsetX=21, offsetY=23, duration=0.0333333},
		[5]={u=48, v=448, w=48, h=48, offsetX=22, offsetY=24, duration=0.0333333},
		scale=1
	},
}
data.quad = love.graphics.newQuad(0, 0, 1, 1, data.image:getWidth(), data.image:getHeight())

return data