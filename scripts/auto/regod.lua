#host_only

local punish = false
wheel:newAction():setTitle("Punish ungod"):setItem("nether_star"):setOnToggle(function(state)
	punish = state
end)

function events.CHAT_RECEIVE_MESSAGE(raw)
	local user = raw:match("God disabled by ([^%s.]+)")
	if user then
		host:sendChatCommand("god")
		if punish then
			host:sendChatCommand("ungod " .. user)
			host:sendChatCommand("kill " .. user)
		end
	end
end

