function events.CHAT_RECEIVE_MESSAGE(raw)
	if raw:match("God disabled by %S+") then
		host:sendChatCommand("god")
	end
end

