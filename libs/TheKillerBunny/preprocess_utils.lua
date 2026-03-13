local m = {}	

function m.get_flags(script)
	local flags_line = script:match("^#([^\n]*)") or ""
	local flags = {}

	for v in (flags_line .. ","):gmatch("([^,]+),") do
		flags[v] = true
	end

	return flags
end

return m

