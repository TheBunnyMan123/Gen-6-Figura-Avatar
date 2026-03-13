local anims = {
	["Kazotsky Kick"] = animations["models.model"].kazotsky
}

anims["Kazotsky Kick"]:setSpeed(0.6)

function pings.animate(anim)
	for _, v in pairs(anims) do
		v:stop()
	end

	if anim then
		anims[anim]:play()
	end
end

local page = action_wheel:newPage("anims")
page:newAction():setTitle("back"):setItem("arrow"):setOnLeftClick(function()
	action_wheel:setPage(wheel)
end)
page:newAction():setTitle("stop"):setItem("barrier"):setOnLeftClick(function()
	pings.animate()
end)
wheel:newAction():setTitle("Animations"):setOnLeftClick(function()
	action_wheel:setPage(page)
end):setItem("player_head{SkullOwner:TheKillerBunny}")

for k, v in pairs(anims) do
	page:newAction():setTitle(k):setOnLeftClick(function()
		pings.animate(k)
	end):setItem("player_head{SkullOwner:TheKillerBunny}")
end

