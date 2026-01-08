local vanilla_head = vanilla_model.HEAD
local head = models.models.model.root.Head
local eyes = head.Eyes

local old_eye_pos, eye_pos= vec(0, 0, 0), vec(0, 0, 0)

function events.TICK()
	local vanilla_rot = vanilla_head:getOriginRot()
	old_eye_pos = eye_pos
	eye_pos = (vanilla_rot / 3).yx_:mul(-0.02, 0.03)
	
	eye_pos.x = math.clamp(eye_pos.x, -0.9, 0.9)
	eye_pos.y = math.clamp(eye_pos.y, -0.9, 0.9)
end

function events.RENDER(delta, ctx)
	eyes:setPos(math.lerp(old_eye_pos, eye_pos, delta))
end


local function copy(part, name)
	local new = part:copy(name)

	for _, v in pairs(part:getChildren()) do
		local copied = copy(v, v:getName())
		copied:remove()
		new:addChild(copied)
		new:removeChild(v)
	end

	return new
end
local skull = copy(head, "skull"):setParentType("SKULL"):setPos(0, -24, 0)
local skull_eyes = skull.Eyes:setLight(15):setPrimaryRenderType("EMISSIVE_SOLID")
models:addChild(skull)

local function dir_to_angle(dir)
	local yaw = math.atan2(dir.x, dir.z)
	local pitch = math.atan2(dir.y, dir.xz:length())
	return vec(-math.deg(pitch), -math.deg(yaw), 0)
end

function events.SKULL_RENDER(delta, block)
	local viewer = client.getViewer()

	if not block then
		skull_eyes:setPos(0, 0, 0)
		return
	end

	if not viewer:isLoaded() then return end

	local viewer_eye = viewer:getPos(delta):add(0, viewer:getEyeHeight())
	local eye_pos = vec(0, 0, 0)

	if block:getID() == "minecraft:player_wall_head" then
		local block_rot = block:getProperties()["facing"]
		local block_offset = vec(0, 0, 0)

		if block_rot == "east" then
			block_rot = 90
			block_offset.x = 0.25
		elseif block_rot == "south" then
			block_rot = 180
			block_offset.z = 0.25
		elseif block_rot == "west" then
			block_rot = 270
			block_offset.x = -0.25
		else
			block_rot = 0
			block_offset.z = -0.25
		end

		eye_pos = dir_to_angle(viewer_eye - block:getPos():add(0.5, 0.5, 0.5):add(block_offset)).yx_
		eye_pos.x = eye_pos.x - block_rot
	else
		local block_rot = tonumber(block:getProperties()["rotation"]) * 22.5
		eye_pos = dir_to_angle(viewer_eye - block:getPos():add(0.5, 0.25, 0.5)).yx_
		eye_pos.x = eye_pos.x - block_rot
	end

	eye_pos.x = eye_pos.x + 180

	if eye_pos.x > 180 then
		eye_pos.x = (eye_pos.x - 360)
	end

	eye_pos.y = eye_pos.y * -1

	eye_pos.x = math.clamp(eye_pos.x * 0.03, -0.9, 0.9)
	eye_pos.y = math.clamp(eye_pos.y * 0.03, -1, 1)
	skull_eyes:setPos(eye_pos.xy_)
end

