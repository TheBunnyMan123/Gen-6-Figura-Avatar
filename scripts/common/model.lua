vanilla_model.PLAYER:setVisible(false)
vanilla_model.CAPE:setVisible(false)

models.models.model.root.Head.Eyes:setPrimaryRenderType("EMISSIVE")
models.models.model.root.Head.Throbber:setColor(1, 0.5, 0)
	:setPrimaryRenderType("EMISSIVE")

if avatar:getUUID() == "1dcce150-0064-4905-879c-43ef64dd97d7" then return end

local tex = textures["textures.skin"]
tex:fill(2, 3, 1, 4, vec(0, 1, 1))
tex:fill(5, 3, 1, 4, vec(0, 1, 1))
tex:fill(9, 9, 6, 6, vec(0, 0.1, 0.1))
tex:update()

models.models.model.root.Head.Throbber:setColor(0, 1, 1)

