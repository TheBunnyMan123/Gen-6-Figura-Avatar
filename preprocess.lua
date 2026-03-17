local pre_utils = require("libs.TheKillerBunny.preprocess_utils")
local parser = require("libs.dumbParser")
local scripts = listFiles("", true)
local conf = pre_utils.config ---@type PreprocessUtils.Config

for _, v in pairs(scripts) do
	local script = silly_backports:getScript(v)
	local flags = pre_utils.get_flags()

	if conf.strip_host_only and flags.host_only then
		silly_backports:addScript(v, nil, "NBT")
		return
	end

	local tokens = parser.tokenize(script)
	local final
	if conf.minify then
		final = parser.minify(tokens, conf.optimize)
	elseif conf.optimize then
		final = parser.optimize(tokens)
	end

	silly_backports:addScript(v, parser.toLua(final))
end

silly_backports:addScript("preprocess", nil, "NBT")
silly_backports:addScript("libs.dumbParser", nil, "NBT")

