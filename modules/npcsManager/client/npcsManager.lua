--[[
  This file is part of Astra RolePlay.

  Copyright (c) Astra RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

local genDist = 150.0
local npcs = {}
npcs.floating = {}
npcs.list = {}

Astra.netHandle("esxloaded", function()
    AstraClientUtils.toServer("requestPredefinedNpcs")
    Astra.newThread(function()
        while true do
            for _, v in pairs(npcs.floating) do
                AddTextEntry('nt', v.text)
                SetFloatingHelpTextWorldPosition(1, vector3(v.co.x, v.co.y, v.co.z+0.88))
                SetFloatingHelpTextStyle(1, 1, 2, -1, 3, 0)
                BeginTextCommandDisplayHelp('nt')
                EndTextCommandDisplayHelp(2, false, false, -1)
            end
            Wait(0)
        end
    end)
    Astra.newThread(function()
        Wait(1500)
        while true do
            local pos = GetEntityCoords(PlayerPedId())
            ---@param npc Npc
            for npcId, npc in pairs(npcs.list) do
                local npcPos = npc.position.coords
                if not npcs.list[npcId].npcHandle then
                    if #(pos - npcPos) <= genDist then
                        local model = GetHashKey(npc.model)
                        RequestModel(model)
                        while not HasModelLoaded(model) do
                            Wait(1)
                        end
                        local ped = CreatePed(9, model, npc.position.coords.x, npc.position.coords.y, npc.position.coords.z, npc.position.heading, false, false)
                        SetEntityHeading(ped, npc.position.heading)
                        SetEntityAsMissionEntity(ped, 0, 0)
                        npcs.list[npcId].npcHandle = ped
                        if npc.invincible then
                            SetEntityInvincible(ped, true)
                        end
                        if not npc.ai then
                            SetBlockingOfNonTemporaryEvents(ped, true)
                        end
                        if npc.frozen then
                            Astra.newWaitingThread(1500, function()
                                if npcs.list[npcId].npcHandle ~= nil and DoesEntityExist(npcs.list[npcId].npcHandle) then
                                    FreezeEntityPosition(ped, true)
                                    if npc.animation ~= nil then
                                        TaskStartScenarioInPlace(ped, npc.animation, -1, true)
                                    end
                                end
                            end)
                        elseif npc.animation ~= nil then
                            TaskStartScenarioInPlace(ped, npc.animation, -1, false)
                        end
                    end
                else
                    if npc.displayInfos.name ~= nil then
                        local rangeDisplay = npc.displayInfos.range
                        if #(pos - npcPos) <= rangeDisplay then
                            npcs.list[npcId].tag = CreateFakeMpGamerTag(npcs.list[npcId].npcHandle, npc.displayInfos.name, true, false, 'NPC', 1)
                            SetMpGamerTagColour(npcs.list[npcId].tag, 0, npc.displayInfos.color)
                            SetMpGamerTagVisibility(npcs.list[npcId].tag, 2, true)
                            SetMpGamerTagVisibility(npcs.list[npcId].tag, 14, true)
                            SetMpGamerTagColour(npcs.list[npcId].tag, 2, npc.displayInfos.color)
                            SetMpGamerTagColour(npcs.list[npcId].tag, 14, npc.displayInfos.color)
                            SetMpGamerTagAlpha(npcs.list[npcId].tag, 2, 255)
                            SetMpGamerTagAlpha(npcs.list[npcId].tag, 14, 255)
                            SetMpGamerTagHealthBarColor(npcs.list[npcId].tag, npc.displayInfos.color)
                        else
                            if npcs.list[npcId].tag ~= nil then
                                RemoveMpGamerTag(npcs.list[npcId].tag)
                                npcs.list[npcId].tag = nil
                            end
                        end
                    end
                    if npc.displayInfos.floating ~= nil then
                        local rangeDisplay = npc.displayInfos.rangeFloating
                        if #(pos - npcPos) <= rangeDisplay then
                            npcs.floating[npcId] = {text = npc.displayInfos.floating, co = npcPos}
                        else
                            npcs.floating[npcId] = nil
                        end
                    end
                end
            end
            Wait(1100)
        end
    end)
end)

Astra.netRegisterAndHandle("npcPlaySound", function(npcId, speech, param)
    if not npcs.list[npcId] or not npcs.list[npcId].npcHandle or not DoesEntityExist(npcs.list[npcId].npcHandle) then
        return
    end
    PlayAmbientSpeech1(npcs.list[npcId].npcHandle, speech, param)
end)

---@param npc Npc
Astra.netRegisterAndHandle("newNpc", function(npc)
    npcs.list[npc.id] = npc
end)

Astra.netRegisterAndHandle("delNpc", function(npcId)
    if npcs.list[npcId] == nil then
        return
    end
    if npcs.list[npcId].npcHandle ~= nil and DoesEntityExist(npcs.list[npcId].npcHandle) then
        DeleteEntity(npcs.list[npcId].npcHandle)
    end
    npcs.list[npcId] = nil
end)

Astra.netRegisterAndHandle("cbNpcs", function(incomingNpcs)
    npcs.list = incomingNpcs
end)