local vanilla_head = vanilla_model.HEAD
local head = models.models.model.root.Head
local eyes = head.Eyes

local head_pos = vec(0, 0, 0)
local old_head_rot, head_rot = vec(0, 0, 0), vec(0, 0, 0)
local old_eye_pos, eye_pos= vec(0, 0, 0), vec(0, 0, 0)

function events.TICK()
	local vanilla_rot = vanilla_head:getOriginRot()
	old_head_rot = head_rot
	old_eye_pos = eye_pos
	head_rot = vanilla_rot * 0.25
	eye_pos = (head_rot).yx_:mul(-0.04, 0.04)
	head_pos = vanilla_head:getOriginPos()
end

function events.RENDER(delta)
	head:setRot(-math.lerp(old_head_rot, head_rot, 1 + delta))
	eyes:setPos(math.lerp(old_eye_pos, eye_pos, delta))
end

