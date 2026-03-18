local pre_utils = require("libs.TheKillerBunny.preprocess_utils")
local async = require("libs.TheKillerBunny.async")

local parser = require("libs.dumbParser")
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

	local tokens = parser.tokenize(script)
	local parsed = parser.parse(tokens)
	local final
	if conf.minify then
		final = parser.minify(parsed, conf.optimize)
		silly_backports:addScript(v, parser.toLua(final))
	elseif conf.optimize then
		final = parser.optimize(parsed)
		silly_backports:addScript(v, parser.toLua(final))
	end
end, function()
	async.forpairs(remove, function(_, v)
		silly_backports:addScript(v, nil, "NBT")
	end, function() end)
end)

