---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Astra RolePlay.

  Copyright (c) Astra RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

Astra.netRegisterAndHandle("openBossMenu", function(job)
    TriggerEvent('::{korioz#0110}::esx_society:openBossMenu', job, function(data, menu)
        menu.close()
    end, { wash = false })
end)