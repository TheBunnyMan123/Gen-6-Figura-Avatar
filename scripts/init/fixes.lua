-- Thanks 4P5 :3

if client.compareVersions(client.getVersion(), "1.21.1") > 0 then
	local old_rend = figuraMetatables.RendererAPI.__index
	figuraMetatables.RendererAPI.__index = function(self, name)
		return name == "setBlockOutlineColor"
		and function(self, ...)
			old_rend(self, "setBlockOutlineColor")(self, ...)
			local rgba = renderer:getBlockOutlineColor()
			rgba.rgba = rgba and rgba.argb
			return old_rend(self, "setBlockOutlineColor")(self, rgba)
		end
		or old_rend(self, name)
	end

	local old_tex = figuraMetatables.Texture.__index
	figuraMetatables.Texture.__index = function(self, name)
		return name == "fill"
		and function(self, x, y, w, h, rgba)
			if type(rgba) == "Vector3" then
				return old_tex(self, "fill")(self, x, y, w, h, rgba.bgr_:add(0, 0, 0, 1))
			end

			rgba.rgba = rgba and rgba.abgr
			return old_tex(self, "fill")(self, x, y, w, h, rgba)
		end
		or old_tex(self, name)
	end
end

