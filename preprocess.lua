#delete

local pre_utils = require("libs.TheKillerBunny.preprocess_utils")
local async = require("libs.TheKillerBunny.async")

local scripts = listFiles("", true)
local conf = pre_utils.config ---@type PreprocessUtils.Config
local remove = {}

async.forpairs(scripts, function( _, v)
	local script = silly_backports:getScript(v)
	local flags = pre_utils.get_flags(script)

	if flags.host_only or flags.delete then
		remove[#remove + 1] = v
		return
	end
end, function()
	async.forpairs(remove, function(_, v)
		silly_backports:addScript(v, nil, "NBT")
	end, function() end)
end)

