--[[
  This file is part of Astra RolePlay.

  Copyright (c) Astra RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

ESX = nil
menuIsOpened = false

Astra.newThread(function()
    Wait(1500)
    while ESX == nil do
        TriggerEvent("::{korioz#0110}::esx:getSharedObject", function(obj)
            ESX = obj
        end)
        Wait(1)
    end
    ESX.PlayerData = ESX.GetPlayerData()
    while ESX.GetPlayerData().job == nil do
        Wait(1)
    end
    Job = ESX.PlayerData.job
    if Jobs.list[Job.name] ~= nil and Jobs.list[Job.name].onChange ~= nil then
        Jobs.list[Job.name].onChange()
    end
    Astra.toInternal("esxloaded")
    AstraClientUtils.toServer("jobInitiated", Job)
end)

RegisterNetEvent("::{korioz#0110}::esx:setJob")
AddEventHandler("::{korioz#0110}::esx:setJob", function(job)
    ESX.PlayerData = ESX.GetPlayerData()
    Job = ESX.PlayerData.job
    AstraClientUtils.toServer("jobUpdated", job)
end)