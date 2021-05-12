---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Astra RolePlay.
  
  File [main] created at [26/04/2021 19:16]

  Copyright (c) Astra RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

local busy = false

Astra.netRegisterAndHandle("playScenario", function(scenario, ms, instant)
    if busy then return end
    busy = true
    TriggerEvent("dp:setCanX", false)
    TaskStartScenarioInPlace(PlayerPedId(), scenario, -1, instant or false)
    Astra.newWaitingThread(ms, function()
        if instant then
            ClearPedTasksImmediately(PlayerPedId())
        else
            ClearPedTasks(PlayerPedId())
        end
        TriggerEvent("dp:setCanX", true)
        busy = false
    end)
end)