#host_only
-- Copyright 2026 TheKillerBunny
-- 
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
-- 
-- 	http://www.apache.org/licenses/LICENSE-2.0
-- 
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.


function events.CHAT_RECEIVE_MESSAGE(_, j)
	local json = parseJson(j)

	local function replace_link(tbl)
		for k, v in pairs(tbl) do
			if type(v) ~= "table" then goto continue end

			if (v.text or "") == (v.clickEvent and v.clickEvent.value)
				and v.text:match("https?://cdn%.discordapp%.com/attachments")
				then
				
				tbl[k].text = v.text:match("/([^/]+)%?")
				tbl[k].color = "aqua"
				tbl[k].underlined = true
			elseif (v.text or "") == (v.click_event and v.click_event.value)
				and v.text:match("https?://cdn%.discordapp%.com/attachments")
				then

				tbl[k].text = v.text:match("/([^/]+)%?")
				tbl[k].color = "aqua"
				tbl[k].underlined = true
			else
				replace_link(v)
			end

			::continue::
		end
	end

	replace_link(json)
	return toJson(json)
end

