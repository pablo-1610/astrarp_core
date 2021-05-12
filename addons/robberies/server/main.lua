---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Astra RolePlay.
  
  File [main] created at [11/05/2021 20:34]

  Copyright (c) Astra RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

AstraSRobberiesManager = {}
AstraSRobberiesManager.list = {}

Astra.netHandle("esxloaded", function()
    for id, robberyInfos in pairs(AstraSharedRobberies) do
        ---@type Robbery
        local robbery = Robbery(robberyInfos)
        AstraSRobberiesManager.list[robbery.id] = robbery
    end
end)

Astra.netRegisterAndHandle("robberiesStart", function(id)
    local _src = source
    ---@type Robbery
    local robbery = AstraSRobberiesManager.list[id]
    robbery:handleStart(_src)
end)