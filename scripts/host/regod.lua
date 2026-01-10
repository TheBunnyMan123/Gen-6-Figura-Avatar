function events.CHAT_RECEIVE_MESSAGE(raw)
	local user = raw:match("God disabled by (%S+)")
	if user then
		host:sendChatCommand("god")
		host:sendChatCommand("ungod " .. user)
		host:sendChatCommand("kill" .. user)
	end
end

