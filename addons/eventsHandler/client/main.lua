---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Astra RolePlay.
  
  File [main] created at [29/04/2021 00:47]

  Copyright (c) Astra RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

local base = 0
Astra.newThread(function()
    local isDead = false
    local hasBeenDead = false
    local diedAt
    while true do
        Wait(0)
        local player = PlayerId()
        if NetworkIsPlayerActive(player) then
            local ped = PlayerPedId()
            if IsPedFatallyInjured(ped) and not isDead then
                isDead = true
                if not diedAt then
                    diedAt = GetGameTimer()
                end
                local killer, killerweapon = NetworkGetEntityKillerOfPlayer(player)
                local killerentitytype = GetEntityType(killer)
                local killertype = -1
                local killerinvehicle = false
                local killervehiclename = ''
                local killervehicleseat = 0
                if killerentitytype == 1 then
                    killertype = GetPedType(killer)
                    if IsPedInAnyVehicle(killer, false) == 1 then
                        killerinvehicle = true
                        killervehiclename = GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(killer)))
                        killervehicleseat = GetPedVehicleSeat(killer)
                    else
                        killerinvehicle = false
                    end
                end

                local killerid = GetPlayerByEntityID(killer)
                if killer ~= ped and killerid ~= nil and NetworkIsPlayerActive(killerid) then
                    killerid = GetPlayerServerId(killerid)
                else
                    killerid = -1
                end

                if killer == ped or killer == -1 then
                    AstraClientUtils.toServer('killerlog', 0, killertype, { table.unpack(GetEntityCoords(ped)) })
                    hasBeenDead = true
                else
                    AstraClientUtils.toServer('killerlog', 1, killerid, { killertype = killertype, weaponhash = killerweapon, killerinveh = killerinvehicle, killervehseat = killervehicleseat, killervehname = killervehiclename, killerpos = table.unpack(GetEntityCoords(ped)) })
                    hasBeenDead = true
                end
            elseif not IsPedFatallyInjured(ped) then
                isDead = false
                diedAt = nil
            end
        end
    end
end)