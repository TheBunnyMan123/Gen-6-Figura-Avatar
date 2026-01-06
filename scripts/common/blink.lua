local eyes = models.models.model.root.Head.Eyes

local old_scale, new_scale = vec(1, 0, 1), vec(1, 0, 1)
local delay = 0
local last_focused, focused = true, true

function pings.set_focused(value)
	focused = value
end

function events.TICK()
	old_scale = new_scale
	delay = delay - 1

	if delay <= 0 or not focused then
		new_scale = vec(1, 0, 1)
		delay = math.random(80, 120)
	else
		new_scale = vec(1, 1, 1)
	end


	if not host:isHost() then return end
	focused = client.isWindowFocused()

	if focused ~= last_focused then
		pings.set_focused(focused)
		last_focused = focused
	end
end

function events.RENDER(delta)
	eyes:setScale(math.lerp(old_scale, new_scale, delta))
end

