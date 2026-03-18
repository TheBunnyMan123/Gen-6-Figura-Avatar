nameplate.ENTITY:setVisible(false)
	:setOutline(true)
	:setOutlineColor(vectors.hexToRGB("#154020"))

local colors = {
	"#804000",
	"#FF8000",
	"#FFA000"
}

if avatar:getUUID() ~= "1dcce150-0064-4905-879c-43ef64dd97d7" then
	colors = {
		"#00A0A0",
		"#00FFFF",
		"#00CCCC"
	}
end

local hover = {
	{
		text = "",
		font = "minecraft:default",
		color = colors[1],
	},
	{
		text = "---------|  ɪɴꜰᴏ  |---------\n",
	},
	{
		text = "• ᴜꜱᴇʀɴᴀᴍᴇ",
		color = colors[2]
	},
	{
		text = ": ",
	},
	{
		text = "ᴛʜᴇᴋɪʟʟᴇʀʙᴜɴɴʏ\n",
		color = colors[3]
	},
	{
		text = "• ᴘʀᴏɴᴏᴜɴꜱ",
		color = colors[2]
	},
	{
		text = ": ",
	},
	{
		text = "ʜᴇ/ʜɪᴍ\n",
		color = colors[3]
	},
	{
		text = "• ꜰʟᴀɢ",
		color = colors[2]
	},
	{
		text = ": ",
	},
	{
		text = "ᴀʀᴏᴀᴄᴇ\n",
		color = colors[3]
	},
	{
		text = "• ᴛɪᴍᴇ ᴢᴏɴᴇ",
		color = colors[2]
	},
	{
		text = ": ",
	},
	{
		text = "ᴄᴛ\n\n",
		color = colors[3]
	},
	{
		text = "------| ꜱᴏᴄɪᴀʟ ᴍᴇᴅɪᴀ |------\n",
	},
	{
		text = "• ᴅɪꜱᴄᴏʀᴅ",
		color = colors[2]
	},
	{
		text = ": ",
	},
	{
		text = "@ᴛʜᴇᴋɪʟʟᴇʀʙᴜɴɴʏ\n",
		color = colors[3]
	},
	{
		text = "• ʙʟᴜᴇꜱᴋʏ",
		color = colors[2]
	},
	{
		text = ": ",
	},
	{
		text = "@ᴛᴋʙᴜɴɴʏ.ɴᴇᴛ",
		color = colors[3]
	},
}
local info = {
	{"Username", "TheKillerBunny"},
	{"Pronouns", "He / Him"},
	{"Flag", ":aroace: aroace"},
	{"Time Zone", ":flag_us: CT"}
}

local nameText = "\xE2\x9C\xA8Bunny\xE2\x9C\xA8"
nameplate.ALL:setText(toJson {
	text = nameText,
	hoverEvent = {
		action = "show_text",
		value = hover
	},
	hover_event = {
		action = "show_text",
		value = hover
	}
})

local tick = 0
local plate = models.models.model.root.Nameplate
plate:setSecondaryRenderType("EMISSIVE")
:setSecondaryTexture("CUSTOM", textures["textures.nameplate"])
:setParentType("CAMERA")
plate.FrontLayer:setColor(vectors.hexToRGB(colors[2]))
plate.BackLayer:setColor(vectors.hexToRGB(colors[1]))

function events.TICK()
	tick = tick + 1
	plate:setVisible(client.isHudEnabled())
end

function events.RENDER(delta)
	plate.FrontLayer:setPos(0, math.sin(math.lerp(tick - 1, tick, delta) / 10), 0)
	plate.BackLayer:setPos(0, math.sin(math.lerp(tick - 3, tick - 2, delta) / 10) * 1.2, 0)
end
