local pre_utils = require("libs.TheKillerBunny.preprocess_utils")
local async = require("libs.TheKillerBunny.async")

local scripts = listFiles("", true)
local conf = pre_utils.config ---@type PreprocessUtils.Config

local remove = {
	"preprocess",
	"libs.dumbParser"
}

async.forpairs(scripts, function( _, v)
	local script = silly_backports:getScript(v)
	local flags = pre_utils.get_flags(script)

	if conf.strip_host_only and flags.host_only then
		remove[#remove + 1] = v
		return
	end
end, function()
	async.forpairs(remove, function(_, v)
		silly_backports:addScript(v, nil, "NBT")
	end, function() end)
end)

