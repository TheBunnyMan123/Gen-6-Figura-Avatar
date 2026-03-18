---@class PreprocessUtils
local m = {}

---@class PreprocessUtils.Config
---@field optimize boolean
---@field minify boolean
---@field strip_host_only boolean
local conf = config:load("tkb$preprocessorconf") or {}
conf.optimize = conf.optimize or false
conf.minify = conf.minify or true
conf.strip_host_only = conf.strip_host_only or true

m.config = conf

function m.get_flags(script)
	local flags_line = script:match("^#([^\n]*)") or ""
	local flags = {}

	for v in (flags_line .. ","):gmatch("([^,]+),") do
		flags[v] = true
	end

	return flags
end

function m.save_conf()
	config:save("tkb$preprocessorconf", conf)
end

return m

