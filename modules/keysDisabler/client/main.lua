---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Astra RolePlay.
  
  File [main.lua] created at [11/06/2021 13:07]

  Copyright (c) Astra RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

AstraCKeysDisabler = {}

AstraCKeysDisabler.disableKey = function(key)
    AstraCKeysDisabler[key] = true
end

AstraCKeysDisabler.enableKey = function(key)
    AstraCKeysDisabler[key] = nil
    Wait(150)
    EnableControlAction(0, key, true)
end

Astra.netHandle("esxloaded", function()
    Astra.newThread(function()
        while true do
            for k,v in pairs(AstraCKeysDisabler) do
                DisableControlAction(0, k, true)
            end
            Wait(0)
        end
    end)
end)