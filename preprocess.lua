local pre_utils = require("libs.TheKillerBunny.preprocess_utils")
local scripts = listFiles("", true)

for _, v in pairs(scripts) do
	local flags = pre_utils.get_flags(silly_backports:getScript(v))

	if flags.host_only then
		silly_backports:addScript(v, nil, "NBT")
	end
end

silly_backports:addScript("preprocess", nil)

