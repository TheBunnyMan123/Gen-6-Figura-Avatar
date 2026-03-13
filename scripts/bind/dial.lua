-- TODO: Add dial-up sound
-- TODO 2: Use Niko's action wheel thing (lib.homemade.action_wheel_extensions)
--	-- You got permission
print("Look at scripts/binds/dial.lua")

local s1 = sounds["sounds.dtmf"]
local s2 = sounds["sounds.dtmf"]
local sound_tbl = {}
local dial = false
local tick = 0

s1:setSubtitle("DTMF tone 1")
s2:setSubtitle("DTMF tone 2")

function pings.set_dial(state)
	dial = state
end

for x = 0, 2 do
	sound_tbl[x + 1] = {}
	for y = 0, 3 do
		local freq1 = 1209
		local freq2 = 697

		if x == 1 then
			freq1 = 1336
		elseif x == 2 then
			freq1 = 1477
		end

		if y == 1 then
			freq2 = 770
		elseif y == 2 then
			freq2 = 852
		elseif y == 3 then
			freq2 = 941
		end

		sound_tbl[x + 1][y + 1] = {
			freq1,
			freq2
		}
	end
end

keybinds:newKeybind("Dial", "key.keyboard.grave.accent", false):setOnPress(function()
	pings.set_dial(true)
end):setOnRelease(function()
	pings.set_dial(false)
end)

local last_x = 0
local last_y = 0
function events.TICK()
	tick = tick + 1
	
	if not dial then return end
	if tick % 2 ~= 0 then return end
	
	local x, y
	repeat
		x = math.random(1, 3)
	until x ~= last_x
	repeat
		y = math.random(1, 4)
	until y ~= last_y

	local sound = sound_tbl[x][y]

	s1:stop():setPitch(sound[1] / 1000):setPos(player:getPos()):play()
	s2:stop():setPitch(sound[2] / 1000):setPos(player:getPos()):play()
end

