Vector = require "hump.vector"
Class = require "hump.class"
HumpCamera = require "hump.camera"
timer = require "hump.timer"

Camera = Class({name = "Camera", inherits = HumpCamera, function(self, x, y, zoom, rot)
	-- HACK: inherit from this uninheritable class
	local c = HumpCamera(x, y, zoom, rot)
	for i, v in pairs(c) do self[i] = v end
	for i, v in pairs(getmetatable(c)) do self[i] = v end
	
	
end} )

local function updateZoom(dt, delay, args)
	args.current = args.current + (args.range * dt)
	args.camera:zoomTo(args.current)
end

local function updateZoomAfter(_, args)
	args.camera:zoomTo(args.final)
	if args.after then
		args.after()
	end
end

function Camera:setScaleOverTime(destination, duration, after)
	timer.cancel(self.zoomTimerHandle)
	self.zoomTimerHandle = timer.do_for(duration, updateZoom, updateZoomAfter,
		{camera = self, current = self.scale, range = (destination - self.scale) / duration, final = destination, after = after})
	
end