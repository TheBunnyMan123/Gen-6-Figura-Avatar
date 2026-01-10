local head = models.models.model.root.Player.Head
local sound = sounds["entity.cat.ambient"]
local ent = head:newEntity("cat")
local last_screen_y, screen_y = 0, 0

sound:setSubtitle("Bunny Meows")
ent:setNbt("minecraft:cat", '{NoAI:1b,Sitting:1b,variant:"minecraft:jellie",CollarColor:14b}')
	:setRot(0, 180)
	:setPos(0, 1, -1)
	:setScale(0.3)

local showing = false

function pings.screen_up(enable)
	showing = enable
end

wheel:newAction():setItem("cat_spawn_egg"):setTitle("Reveal the Secret"):setOnToggle(function(enable) pings.screen_up(enable) end)

local tick = 0
function events.TICK()
	tick = tick + 1
	if tick % (20 * 30) == 0 then
		pings.screen_up(showing)
	end

	last_screen_y = screen_y
	screen_y = math.clamp(screen_y + (showing and 1 or -1), 0, 7)
	if tick % 20 == 0 and math.random() < 0.001 then
		sound:setPos(player:getPos()):play()
	end
end

function events.RENDER(delta)
	head.Screen:setPos(0, math.lerp(last_screen_y, screen_y, delta),  0)
	ent:setPos(0, vanilla_model.HEAD:getOriginPos().y + 1.5, -0.75)
end

