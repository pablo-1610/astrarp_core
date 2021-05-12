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
AstraSRobberiesManager.players = {}

Astra.netHandle("esxloaded", function()
    for id, robberyInfos in pairs(AstraSharedRobberies) do
        ---@type Robbery
        local robbery = Robbery(id,robberyInfos)
        AstraSRobberiesManager.list[id] = robbery
    end
end)

Astra.netRegisterAndHandle("robberiesStart", function(id)
    local _src = source
    ---@type Robbery
    local robbery = AstraSRobberiesManager.list[id]
    robbery:handleStart(_src)
end)

Astra.netRegisterAndHandle("robberiesDiedDuring", function()
    local _src = source
    ---@type Robbery
    local robbery = AstraSRobberiesManager.list[AstraSRobberiesManager.players[_src].id]
    robbery:exitRobbery(_src, true)
end)

Astra.netRegisterAndHandle("robberiesAddItem", function(itemTable)
    local _src = source
    if not AstraSRobberiesManager.players[_src] then
        --@TODO -> Faire une liste d'error
        DropPlayer(_src, "Une erreur est survenue, contactez un staff, Erreur: 16489")
        return
    end
    table.insert(AstraSRobberiesManager.players[_src].bag, itemTable)
end)