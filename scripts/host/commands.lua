local prev_source = {path="",heads={}}
local function get_resource_heads(chest, str, path, type, shulker)
	local buf, idx, uuid
	local heads = {}
	if prev_source.path == path then
		heads = prev_source.heads
		goto cached
	else
		prev_source.path = path
	end

	buf = data:createBuffer()
	buf:writeByteArray(str)
	buf:setPosition(0)
	idx = 0
	uuid = ""
	for i = 1, 8 do
		uuid = uuid .. string.char(math.random(0, 255))
	end

	while buf:available() >= 1 do
		idx = idx + 1
		local read = 20000
		if buf:available() < read then
			read = buf:available()
		end
		local buf2 = data:createBuffer()
		buf2:writeByteArray("resource;" .. string.char(idx) .. uuid .. buf:readByteArray(read))
		buf2:setPosition(0)

		if chest then
			heads[#heads + 1] = {
				SkullOwner = {
					Id = {1481619325, 1543653003, -1514517150, -829510686},
					Properties = {
						textures = {{
							Value = buf2:readBase64(buf2:available())
						}}
					},
					Name = "4P5"
				},
				display = {
					Lore = {
						toJson {
							text = path .. " (part " .. idx .. ")",
							color = "yellow"
						}
					},
					Name = toJson {
						text = type .. " Data",
						color = "aqua",
						italic = false
					}
				}
			}
			buf2:close()
		else
			host:setSlot("inventory." .. idx, "player_head" .. toJson({
				SkullOwner = {
					Id = {1481619325, 1543653003, -1514517150, -829510686},
					Properties = {
						textures = {{
							Value = buf2:readBase64(buf2:available())
						}}
					},
					Name = "4P5"
				},
				display = {
					Lore = {
						toJson {
							text = path .. " (part " .. idx .. ")",
							color = "yellow"
						}
					},
					Name = toJson {
						text = type .. " Data",
						color = "aqua",
						italic = false
					}
				}
			}):gsub('"Id":%[','"Id":[I;'))
			buf2:close()
		end
	end

	prev_source.heads = heads
	::cached::

	if chest then
		local idx = 0
		for i = 1, #heads, 26 do
			idx = idx + 1
			if idx ~= shulker then goto continue end
			for j = 1, 26 do
				if not heads[i + j - 1] then break end
				
				host:setSlot("inventory." .. j,
					"player_head" .. toJson(heads[i+j-1]):gsub(
						'"Id":%[',
						'"Id":[I;'
					)
				)
			end

			::continue::
		end
	end
end

local commands
commands = {
	help = function(full)
		local json = {}
		for k in pairs(commands) do
			json[#json + 1] = {
				{
					text = "!" .. k,
					color = "green"
				},
				{
					text = ", ",
					color = "gray"
				}
			}
		end
		printJson(toJson(json))
	end,
	testzone = function(full)
		host:sendChatCommand("tp @s 123980 65 198872 0 0")
	end,
	orbitallaser = function(full)
		host:sendChatCommand("tp @s 12783 155 1322 180 0")
	end,
	badapple = function(full)
		host:sendChatCommand("tp @s 2113 64 225 30 0")
	end,
	song = function(full)
		local path = "songs/" .. full:gsub("!song ",""):gsub(" %d$", "")
		local shulker = tonumber(full:match("%d$") or "1")
		if not path then 
			print(full)
			return
		end
		local buf = data:createBuffer()
		local rds = file:openReadStream(path)
		buf:readFromStream(rds)
		buf:setPosition(0)
		local str = buf:readByteArray(buf:available())
		buf:close()
		rds:close()
		
		if shulker == 1 and math.ceil(#str / (20000 * 26)) > 1 then
			print(tostring(math.ceil(#str / (20000 * 26))) .. " shulkers")
		end

		if #str > 20000 then
			buf = data:createBuffer()
			buf:writeByteArray("jukebox;")
			buf:setPosition(0)
			get_resource_heads(#str > (20000 * 26), str, path, "Song", shulker)
			host:setSlot("inventory.0", "player_head" .. toJson({
				SkullOwner = {
					Id = {1481619325, 1543653003, -1514517150, -829510686},
					Properties = {
						textures = {{
							Value = buf:readBase64(buf:available())
						}}
					},
					Name = "4P5"
				},
				display = {
					Lore = {
						toJson {
							text = "Place on top of data head",
							color = "yellow"
						}
					},
					Name = toJson {
						text = "Song",
						color = "aqua",
						italic = false
					}
				}
			}):gsub('"?Id"?:%[','"Id":[I;'))
			buf:close()
		else
			buf = data:createBuffer()
			buf:writeByteArray("jukebox;" .. str)
			buf:setPosition(0)

			host:setSlot("inventory.0", "player_head" .. toJson({
				SkullOwner = {
					Id = {1481619325, 1543653003, -1514517150, -829510686},
					Properties = {
						textures = {{
							Value = buf:readBase64(buf:available())
						}}
					},
					Name = "4P5"
				},
				display = {
					Lore = {
						toJson {
							text = path,
							color = "yellow"
						}
					},
					Name = toJson {
						text = "Song",
						color = "aqua",
						italic = false
					}
				}
			}):gsub('"?Id"?:%[','"Id":[I;'))
			buf:close()
		end
	end,
	midi = function(full)
		local path = "midis/" .. full:gsub("!midi ",""):gsub(" %d$", "")
		local shulker = tonumber(full:match("%d$") or "1")
		if not path then 
			print(full)
			return
		end
		local buf = data:createBuffer()
		local rds = file:openReadStream(path)
		buf:readFromStream(rds)
		buf:setPosition(0)
		local str = buf:readByteArray(buf:available())
		buf:close()
		rds:close()

		if shulker == 1 and math.ceil(#str / (20000 * 26)) > 1 then
			print(tostring(math.ceil(#str / (20000 * 26))) .. " shulkers")
		end

		if #str > 20000 then
			buf = data:createBuffer()
			buf:writeByteArray("midi;")
			buf:setPosition(0)
			get_resource_heads(#str > (20000 * 26), str, path, "MIDI", shulker)
			host:setSlot("inventory.0", "player_head" .. toJson({
				SkullOwner = {
					Id = {1481619325, 1543653003, -1514517150, -829510686},
					Properties = {
						textures = {{
							Value = buf:readBase64(buf:available())
						}}
					},
					Name = "4P5"
				},
				display = {
					Lore = {
						toJson {
							text = "Place on top of data head",
							color = "yellow"
						}
					},
					Name = toJson {
						text = "MIDI",
						color = "aqua",
						italic = false
					}
				}
			}):gsub('"?Id"?:%[','"Id":[I;'))
			buf:close()
		else
			buf = data:createBuffer()
			buf:writeByteArray("midi;" .. str)
			buf:setPosition(0)

			host:setSlot("inventory.0", "player_head" .. toJson({
				SkullOwner = {
					Id = {1481619325, 1543653003, -1514517150, -829510686},
					Properties = {
						textures = {{
							Value = buf:readBase64(buf:available())
						}}
					},
					Name = "4P5"
				},
				display = {
					Lore = {
						toJson {
							text = path,
							color = "yellow"
						}
					},
					Name = toJson {
						text = "MIDI",
						color = "aqua",
						italic = false
					}
				}
			}):gsub('"?Id"?:%[','"Id":[I;'))
			buf:close()
		end
	end
}

function events.CHAT_SEND_MESSAGE(msg)
	for cmd, func in pairs(commands) do
		if msg:match("^!" .. cmd .. " ") or  msg:match("^!" .. cmd .. "$") then
			func(msg)
			host:appendChatHistory(msg)
			return ""
		end
	end

	return msg
end

