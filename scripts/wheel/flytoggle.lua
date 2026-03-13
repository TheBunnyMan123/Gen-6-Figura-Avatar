#host_only
local toggle = wheel:newAction():setTitle("Fly"):setItem("elytra"):setOnToggle(function() end)

function events.TICK()
	if player:getGamemode() == "CREATIVE" then
		toggle:setToggled(true)
	end

	local enabled = (toggle:isToggled() and host:getSlot("armor.chest"):getID() ~= "minecraft:elytra")
	silly:setCanFly(enabled)

	if host:isFlying() and not enabled then
		toggle:setToggled(true)
	end
end

