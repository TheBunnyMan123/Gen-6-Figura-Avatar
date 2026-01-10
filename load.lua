wheel = action_wheel:newPage()
action_wheel:setPage(wheel)

for _, v in pairs(listFiles "scripts.init") do
	require(v)
end

for _, v in pairs(listFiles "scripts.common") do
	require(v)
end

if host:isHost() then
	for _, v in pairs(listFiles "scripts.host") do
		require(v)
	end
end

