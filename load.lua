wheel = action_wheel:newPage()
action_wheel:setPage(wheel)

for _, v in pairs(listFiles "scripts.init") do
	require(v)
end

for _, v in pairs(listFiles "scripts.common") do
	require(v)
end

