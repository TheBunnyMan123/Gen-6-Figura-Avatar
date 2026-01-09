local song = {}

local throbbed = false
function pings.song_receive(data, total_segments, segment, name)
	if name == "" then return end
	if name ~= song.name then song = {} end
	song.name = name
	song[segment] = data

	if segment == 1 then
		throbbed = false
	end

	if not throbbed then
		throbbed = true
		throbber.add()
	end

	if #song == total_segments and player:isLoaded() then
		throbber.sub()
		local to_play = table.concat(song)
		sounds:newSound("pinged", to_play)
		local final_song = sounds["pinged"]
		final_song:setPos(player:getPos())
		final_song:play()
	end

end

local tick = 0
local to_send = ""
local send_total_segments = 0
local current_segment = 0
local file_name = ""
function events.TICK()
	tick = tick + 1
	if (current_segment > send_total_segments) or (tick % 30 ~= 0) then return end
	
	pings.song_receive(to_send:sub((current_segment - 1) * 768 + 1, current_segment * 768),
		send_total_segments, current_segment, file_name)
	host:actionbar(string.format("%s: %d/%d sent", file_name, current_segment, send_total_segments))
	current_segment = current_segment + 1
end

function send_song(path)
	local stream = file:openReadStream(path)
	local buffer = data:createBuffer()
	buffer:readFromStream(stream)
	buffer:setPosition(0)
	file_name = path .. tostring(tick)

	current_segment = 1
	to_send = buffer:readBase64(buffer:available())
	send_total_segments = math.ceil(#to_send / 768)
		
	stream:close()
	buffer:close()
end

