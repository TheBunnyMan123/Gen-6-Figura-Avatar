local pointer_pos, last_pointer_pos = vec(0, 0, 0), vec(0, 0, 0)
local pointer = models.models.model.root.Player.Head.Laser
local laser = require("libs.GNamimates.line").new()
	:setWidth(0.00625)
	:setColor(1, 0.1, 0.1)

local tick = 0
local active = false
local laser_on = false
local laser_on_next = false

function pings.set_enabled(enabled)
	active = enabled
end

local action = wheel:newAction()
	:setTitle("Laser Pointer")
	:setItem("glowstone")
	:setOnToggle(function(enabled)
		pings.set_enabled(enabled)
	end)

function events.TICK()
	tick = tick + 1
	last_pointer_pos = pointer_pos:copy()
	
	if tick % (20 * 30) == 0 then
		pings.set_enabled(active)
	end

	if laser_on_next then
		laser_on = true
	else
		laser_on = false
	end
	
	if active then
		laser_on_next = true
		pointer_pos.x = 0
	else
		laser_on_next = false
		pointer_pos.x = -1
	end
end

function is_visible()
	if not player:isLoaded() then return false end
	if player:isInvisible() or player:getGamemode() == "SPECTATOR" or not laser_on_next then
		return false
	end

	return laser_on
end

events[host:isHost() and "WORLD_RENDER" or "RENDER"] = function(delta)
	pointer:setPos(math.lerp(last_pointer_pos, pointer_pos, delta))
	laser:setVisible(is_visible()):update()
	if not laser_on then return end

	local ray_start = pointer.Lens:partToWorldMatrix():apply()
	local ray_end = ray_start + player:getLookDir(delta) * 100
	local block, block_pos = raycast:block(ray_start, ray_end, "VISUAL", "NONE")
	local entity, entity_pos = raycast:entity(ray_start, ray_end, function(ent) return ent ~= player end)

	if block and entity then
		local block_diff = (block_pos - ray_start):length()
		local entity_diff = (entity_pos - ray_start):length()

		if block_diff > entity_diff then
			ray_end = entity_pos
		else
			ray_end = block_pos
		end
	else
		ray_end = entity_pos or block_pos or ray_end
	end

	laser:setAB(ray_start, ray_end):immediateUpdate()
end

