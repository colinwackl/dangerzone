-- Generated by Pumpkin

local data = {}

local path = ...
if type(path) ~= "string" then
	path = "."
end
data.image = love.graphics.newImage(path.."cell.sprite.png")
data.image:setFilter("nearest", "nearest")
data.animations = {
	flesheater={
		[0]={u=850, v=1888, w=64, h=80, offsetX=33, offsetY=39, duration=0.0833333},
		[1]={u=850, v=1968, w=64, h=80, offsetX=33, offsetY=39, duration=0.0833333},
		[2]={u=1203, v=379, w=64, h=80, offsetX=33, offsetY=39, duration=0.0833333},
		[3]={u=850, v=1968, w=64, h=80, offsetX=33, offsetY=39, duration=0.0833333},
		[4]={u=1019, v=459, w=64, h=80, offsetX=33, offsetY=39, duration=0.0833333},
		scale=1
	},
	flesheater_glow={
		[0]={u=453, v=432, w=96, h=112, offsetX=46, offsetY=53, duration=0.0833333},
		[1]={u=569, v=925, w=96, h=112, offsetX=46, offsetY=53, duration=0.0833333},
		[2]={u=665, v=925, w=96, h=112, offsetX=46, offsetY=53, duration=0.0833333},
		[3]={u=761, v=925, w=96, h=112, offsetX=46, offsetY=53, duration=0.0833333},
		[4]={u=800, v=666, w=96, h=112, offsetX=46, offsetY=53, duration=0.0833333},
		scale=1
	},
	bullet={
		[0]={u=893, v=1387, w=32, h=32, offsetX=16, offsetY=17, duration=0.0833333},
		[1]={u=2019, v=379, w=28, h=28, offsetX=14, offsetY=16, duration=0.0833333},
		scale=1
	},
	bullet_glow={
		[0]={u=1077, v=1579, w=63, h=64, offsetX=31, offsetY=32, duration=0.0833333},
		[1]={u=1140, v=1579, w=63, h=64, offsetX=31, offsetY=32, duration=0.0833333},
		scale=1
	},
	icon_link={
		[0]={u=347, v=1804, w=83, h=83, offsetX=41, offsetY=40, duration=0.0333333},
		[1]={u=1008, v=658, w=83, h=83, offsetX=41, offsetY=40, duration=0.0333333},
		[2]={u=1085, v=546, w=83, h=83, offsetX=41, offsetY=40, duration=0.0333333},
		[3]={u=1091, v=629, w=83, h=83, offsetX=41, offsetY=40, duration=0.0333333},
		[4]={u=1168, v=546, w=83, h=83, offsetX=41, offsetY=40, duration=0.0666667},
		[5]={u=1091, v=629, w=83, h=83, offsetX=41, offsetY=40, duration=0.0333333},
		[6]={u=1085, v=546, w=83, h=83, offsetX=41, offsetY=40, duration=0.0333333},
		[7]={u=1008, v=658, w=83, h=83, offsetX=41, offsetY=40, duration=0.0333333},
		scale=1
	},
	head={
		[0]={u=800, v=778, w=112, h=112, offsetX=56, offsetY=56, duration=0.0833333},
		[1]={u=896, v=666, w=112, h=112, offsetX=56, offsetY=56, duration=0.0833333},
		[2]={u=973, v=546, w=112, h=112, offsetX=56, offsetY=56, duration=0.0833333},
		[3]={u=896, v=666, w=112, h=112, offsetX=56, offsetY=56, duration=0.0833333},
		[4]={u=973, v=546, w=112, h=112, offsetX=56, offsetY=56, duration=0.0833333},
		scale=1
	},
	head_glow={
		[0]={u=443, v=1420, w=233, h=234, offsetX=116, offsetY=114, duration=0.0333333},
		[1]={u=443, v=1654, w=233, h=234, offsetX=116, offsetY=114, duration=0.0333333},
		[2]={u=676, v=1420, w=233, h=234, offsetX=116, offsetY=114, duration=0.0333333},
		[3]={u=694, v=1654, w=233, h=234, offsetX=116, offsetY=114, duration=0.0333333},
		[4]={u=927, v=1654, w=233, h=234, offsetX=116, offsetY=114, duration=0.0333333},
		[5]={u=694, v=1654, w=233, h=234, offsetX=116, offsetY=114, duration=0.0333333},
		[6]={u=676, v=1420, w=233, h=234, offsetX=116, offsetY=114, duration=0.0333333},
		[7]={u=443, v=1654, w=233, h=234, offsetX=116, offsetY=114, duration=0.0333333},
		scale=1
	},
	body_grey_glow={
		[0]={u=845, v=1037, w=128, h=224, offsetX=65, offsetY=106, duration=0.0833333},
		scale=1
	},
	body_grey={
		[0]={u=909, v=1419, w=96, h=192, offsetX=49, offsetY=92, duration=0.0833333},
		[1]={u=1005, v=1387, w=96, h=192, offsetX=49, offsetY=92, duration=0.0833333},
		[2]={u=1160, v=1643, w=96, h=192, offsetX=49, offsetY=92, duration=0.0833333},
		[3]={u=1005, v=1387, w=96, h=192, offsetX=49, offsetY=92, duration=0.0833333},
		[4]={u=1160, v=1643, w=96, h=192, offsetX=49, offsetY=92, duration=0.0833333},
		scale=1
	},
	body={
		[0]={u=347, v=849, w=96, h=192, offsetX=49, offsetY=92, duration=0.0833333},
		[1]={u=347, v=1420, w=96, h=192, offsetX=49, offsetY=92, duration=0.0833333},
		[2]={u=347, v=1612, w=96, h=192, offsetX=49, offsetY=92, duration=0.0833333},
		[3]={u=347, v=1420, w=96, h=192, offsetX=49, offsetY=92, duration=0.0833333},
		[4]={u=347, v=1612, w=96, h=192, offsetX=49, offsetY=92, duration=0.0833333},
		scale=1
	},
	body_glow={
		[0]={u=717, v=1037, w=128, h=224, offsetX=66, offsetY=108, duration=0.0833333},
		scale=1
	},
	heart={
		[0]={u=605, v=379, w=96, h=160, offsetX=49, offsetY=81, duration=0.0833333},
		[1]={u=701, v=379, w=96, h=160, offsetX=49, offsetY=81, duration=0.0833333},
		[2]={u=797, v=379, w=96, h=160, offsetX=49, offsetY=81, duration=0.0833333},
		[3]={u=701, v=379, w=96, h=160, offsetX=49, offsetY=81, duration=0.0833333},
		[4]={u=797, v=379, w=96, h=160, offsetX=49, offsetY=81, duration=0.0833333},
		scale=1
	},
	heart_glow={
		[0]={u=1208, v=1835, w=128, h=192, offsetX=65, offsetY=91, duration=0.0833333},
		scale=1
	},
	trail={
		[0]={u=2023, v=0, w=22, h=22, offsetX=11, offsetY=11, duration=0.0833333},
		scale=1
	},
	trail_glow={
		[0]={u=453, v=379, w=48, h=48, offsetX=24, offsetY=25, duration=0.0833333},
		scale=1
	},
	port={
		[0]={u=347, v=747, w=100, h=102, offsetX=50, offsetY=50, duration=0.0833333},
		[1]={u=1008, v=778, w=96, h=96, offsetX=48, offsetY=47, duration=0.0833333},
		[2]={u=347, v=327, w=106, h=105, offsetX=53, offsetY=51, duration=0.0833333},
		[3]={u=347, v=432, w=106, h=105, offsetX=53, offsetY=51, duration=0.0833333},
		[4]={u=912, v=778, w=96, h=98, offsetX=48, offsetY=47, duration=0.0833333},
		[5]={u=347, v=537, w=106, h=105, offsetX=53, offsetY=51, duration=0.0833333},
		[6]={u=347, v=642, w=106, h=105, offsetX=53, offsetY=51, duration=0.0833333},
		scale=1
	},
	port_glow={
		[0]={u=196, v=1895, w=128, h=132, offsetX=64, offsetY=65, duration=0.0833333},
		[1]={u=827, v=1261, w=126, h=126, offsetX=64, offsetY=60, duration=0.0833333},
		[2]={u=324, v=1895, w=133, h=132, offsetX=67, offsetY=65, duration=0.0833333},
		[3]={u=1075, v=1888, w=133, h=132, offsetX=67, offsetY=65, duration=0.0833333},
		[4]={u=953, v=1261, w=124, h=126, offsetX=62, offsetY=61, duration=0.0833333},
		[5]={u=717, v=1888, w=133, h=132, offsetX=67, offsetY=65, duration=0.0833333},
		[6]={u=694, v=1261, w=133, h=132, offsetX=67, offsetY=65, duration=0.0833333},
		scale=1
	},
	body_hit={
		[0]={u=0, v=0, w=347, h=379, offsetX=178, offsetY=178, duration=0.0833333},
		[1]={u=0, v=379, w=347, h=379, offsetX=178, offsetY=178, duration=0.0833333},
		[2]={u=0, v=758, w=347, h=379, offsetX=178, offsetY=178, duration=0.0833333},
		[3]={u=0, v=1137, w=347, h=379, offsetX=178, offsetY=178, duration=0.0833333},
		[4]={u=0, v=1516, w=347, h=379, offsetX=178, offsetY=178, duration=0.0833333},
		[5]={u=457, v=0, w=347, h=379, offsetX=178, offsetY=178, duration=0.0833333},
		[6]={u=804, v=0, w=347, h=379, offsetX=178, offsetY=178, duration=0.0833333},
		[7]={u=1151, v=0, w=347, h=379, offsetX=178, offsetY=178, duration=0.0833333},
		[8]={u=1498, v=0, w=347, h=379, offsetX=178, offsetY=178, duration=0.0833333},
		[9]={u=453, v=546, w=347, h=379, offsetX=178, offsetY=178, duration=0.0833333},
		[10]={u=347, v=1041, w=347, h=379, offsetX=178, offsetY=178, duration=0.0833333},
		scale=1
	},
	gun={
		[0]={u=457, v=925, w=56, h=116, offsetX=28, offsetY=87, duration=0.0833333},
		[1]={u=513, v=1888, w=56, h=154, offsetX=28, offsetY=121, duration=0.0833333},
		[2]={u=549, v=379, w=56, h=162, offsetX=28, offsetY=135, duration=0.0833333},
		[3]={u=457, v=1888, w=56, h=156, offsetX=28, offsetY=127, duration=0.0833333},
		[4]={u=140, v=1895, w=56, h=134, offsetX=28, offsetY=105, duration=0.0833333},
		[5]={u=513, v=925, w=56, h=116, offsetX=28, offsetY=87, duration=0.0833333},
		scale=1
	},
	body_bullet={
		[0]={u=1013, v=1611, w=32, h=34, offsetX=16, offsetY=17, duration=0.0833333},
		[1]={u=973, v=1611, w=40, h=42, offsetX=20, offsetY=20, duration=0.0833333},
		[2]={u=501, v=379, w=42, h=42, offsetX=20, offsetY=21, duration=0.0833333},
		scale=1
	},
	spikey={
		[0]={u=347, v=0, w=109, h=109, offsetX=56, offsetY=56, duration=0.0833333},
		[1]={u=347, v=109, w=109, h=109, offsetX=56, offsetY=56, duration=0.0833333},
		[2]={u=347, v=218, w=109, h=109, offsetX=56, offsetY=56, duration=0.0833333},
		scale=1
	},
	spikey_glow={
		[0]={u=0, v=1895, w=140, h=142, offsetX=71, offsetY=69, duration=0.0833333},
		scale=1
	},
	spikey_hit={
		[0]={u=896, v=890, w=112, h=112, offsetX=54, offsetY=50, duration=0.0333333},
		[1]={u=845, v=546, w=126, h=120, offsetX=65, offsetY=50, duration=0.0333333},
		[2]={u=569, v=1888, w=148, h=154, offsetX=72, offsetY=74, duration=0.0333333},
		[3]={u=1845, v=366, w=174, h=180, offsetX=88, offsetY=89, duration=0.0333333},
		[4]={u=1845, v=0, w=178, h=183, offsetX=90, offsetY=90, duration=0.0666667},
		[5]={u=1845, v=366, w=174, h=180, offsetX=88, offsetY=89, duration=0.0333333},
		[6]={u=927, v=1888, w=148, h=154, offsetX=72, offsetY=74, duration=0.0333333},
		[7]={u=893, v=379, w=126, h=120, offsetX=65, offsetY=50, duration=0.0333333},
		[8]={u=1845, v=183, w=178, h=183, offsetX=90, offsetY=90, duration=0.0333333},
		scale=1
	},
	gun_idle={
		[0]={u=457, v=925, w=56, h=116, offsetX=27, offsetY=86, duration=0.0333333},
		scale=1
	},
}
data.quad = love.graphics.newQuad(0, 0, 1, 1, data.image:getWidth(), data.image:getHeight())

return data
