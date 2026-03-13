local throbber_part = models.models.model.root.Player.Head.Screen.Throbber
local eyes = models.models.model.root.Player.Head.Screen.Eyes
throbber = {}

local throbbing = 0
function throbber.add()
	throbbing = throbbing + 1
end

function throbber.sub()
	throbbing = throbbing - 1
end


local tick = 0
function events.TICK()
	throbber_part:setVisible(throbbing >= 1)
	eyes:setVisible(throbbing < 1)
	if throbbing < 1 then return end
	tick = tick + 1
	throbber_part.Throbber:setUVPixels(0, (math.floor(tick / 2) % 8) * 11)
end

