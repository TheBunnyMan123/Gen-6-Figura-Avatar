local suc, err = pcall(require, "preprocess")

wheel = action_wheel:newPage()
action_wheel:setPage(wheel)

for _, v in pairs(listFiles "scripts.init") do
	require(v)
end

for _, v in pairs(listFiles("scripts", true)) do
	require(v)
end

if not host:isHost() then return end
if not file:allowed() then return end
if not host:isAvatarUploaded() then return end

local pre_utils = require("libs.TheKillerBunny.preprocess_utils")
if not pre_utils.strip_host_only then return end

local function find_avatar(path)
	local next = {}
	for _, v in pairs(file:list(path)) do
		if not file:isDirectory(path .. "/" .. v) then
			goto continue
		end

		if file:exists(path .. "/" .. v .. "/.gen6") then
			return path .. "/" .. v
		else
			next[#next + 1] = v
		end

		::continue::
	end

	for _, v in pairs(next) do
		local ret = find_avatar(path .."/" .. v)

		if ret then
			return ret
		end
	end
end

local function load_scripts(path)
	for _, v in pairs(file:list(path)) do
		if file:isDirectory(path .. "/" .. v) then
			load_scripts(path .. "/" .. v)
		elseif v:match(".lua$") then
			local contents = file:readString(path .. "/" .. v)
			local flags = pre_utils.get_flags(contents)

			if flags.host_only then
				local prefix = path:match("^.+scripts/")
				local scriptName = "scripts" .. path:sub(#prefix, #path):gsub("/", ".") .. "." .. v:gsub(".lua$", "")
				load(contents, scriptName)()
			end
		end
	end
end

local data_avatar = find_avatar(".")
if not data_avatar then
	error("Could not find avatar in data dir")
end

load_scripts(data_avatar .. "/scripts")

