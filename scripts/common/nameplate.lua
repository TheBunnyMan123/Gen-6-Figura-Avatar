nameplate.ENTITY:setVisible(false)
	:setOutline(true)
	:setOutlineColor(vectors.hexToRGB("#154020"))

local hover = {
	{
		text = "",
		font = "minecraft:default",
		color = "#A05000",
	},
	{
		text = "---------|  ɪɴꜰᴏ  |---------\n",
	},
	{
		text = "• ᴜꜱᴇʀɴᴀᴍᴇ",
		color = "#FF8000"
	},
	{
		text = ": ",
	},
	{
		text = "ᴛʜᴇᴋɪʟʟᴇʀʙᴜɴɴʏ\n",
		color = "#FFA000"
	},
	{
		text = "• ᴘʀᴏɴᴏᴜɴꜱ",
		color = "#FF8000"
	},
	{
		text = ": ",
	},
	{
		text = "ʜᴇ/ʜɪᴍ\n",
		color = "#FFA000"
	},
	{
		text = "• ꜰʟᴀɢ",
		color = "#FF8000"
	},
	{
		text = ": ",
	},
	{
		text = "ᴀʀᴏᴀᴄᴇ\n",
		color = "#FFA000"
	},
	{
		text = "• ᴛɪᴍᴇ ᴢᴏɴᴇ",
		color = "#FF8000"
	},
	{
		text = ": ",
	},
	{
		text = "ᴄᴛ\n\n",
		color = "#FFA000"
	},
	{
		text = "------| ꜱᴏᴄɪᴀʟ ᴍᴇᴅɪᴀ |------\n",
	},
	{
		text = "• ᴅɪꜱᴄᴏʀᴅ",
		color = "#FF8000"
	},
	{
		text = ": ",
	},
	{
		text = "@ᴛʜᴇᴋɪʟʟᴇʀʙᴜɴɴʏ\n",
		color = "#FFA000"
	},
	{
		text = "• ʙʟᴜᴇꜱᴋʏ",
		color = "#FF8000"
	},
	{
		text = ": ",
	},
	{
		text = "@ᴛᴋʙᴜɴɴʏ.ɴᴇᴛ",
		color = "#FFA000"
	},
}
local info = {
	{"Username", "TheKillerBunny"},
	{"Pronouns", "He / Him"},
	{"Flag", ":aroace: aroace"},
	{"Time Zone", ":flag_us: CT"}
}

local nameText = "\xE2\x9C\xA8TheKillerBunny\xE2\x9C\xA8"
local name = {}

for char in string.gmatch(nameText, "([%z\1-\127\128-\255][\128-\191]*)") do
	name[#name + 1] = char
end

local entityTasks = {}
local width = 0
local holder = models.models.model:newPart("NAMEPLATE", "CAMERA"):setPrimaryRenderType("EMISSIVE")
for i = 1, #name do
	entityTasks[#entityTasks+1] = {
		char = name[i],
		task = holder:newText("task" .. i):setText(toJson {
			text = name[i],
			color = "#FF8000"
		}):setPos(-width, 0):setScale(3/8):setLight(15):setOutline(true),
		offset = i,
		prevWidth = width
	}

	width = width + client.getTextWidth(name[i] or "") * (3/8)
end

for _, v in pairs(entityTasks) do
	v.task:setPos(v.task:getPos().x + width / 2, 0)
end
holder:setPivot(0, 40, 0)

local tick = 0

local json = {}
for k, v in ipairs(entityTasks) do
	local text = {
		text = v.char,
		color = "#FF8000",
		hoverEvent = {
			action = "show_text",
			value = hover
		},
		hover_event = {
			action = "show_text",
			value = hover
		}
	}
	json[#json + 1] = text
end
avatar:store("color", "FF8000")
nameplate.ALL:setText(toJson(json))

function events.TICK()
	tick = tick + 1

	local json = {}
	for k, v in ipairs(entityTasks) do
		local text = {
			text = v.char,
			color = "#FF8000",
		}
		v.task:setText(toJson(text)):setOutlineColor(0.125, 0.0625, 0):setSeeThrough(not player:isSneaking())
		json[#json + 1] = text
		json[#json].hoverEvent = {
			action = "show_text",
			value = hover
		}
		json[#json].hover_event = json[#json].hoverEvent
	end
	nameplate.ALL:setText(toJson(json))
end

function events.RENDER(delta)
	for _, v in pairs(entityTasks) do
		v.task:setPos(-v.prevWidth + width / 2, math.lerp(
			math.sin((tick + v.offset - 1) / 4),
			math.sin((tick + v.offset) / 4),
			delta
		)):setVisible(not player:isInvisible() and client.isHudEnabled())
	end
end
