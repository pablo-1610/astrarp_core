--[[
  This file is part of Astra RolePlay.

  Copyright (c) Astra RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

AstraSNpcsManager = {}
AstraSNpcsManager.list = {}

AstraSNpcsManager.createPublic = function(model, ai, frozen, position, animation, onCreate)
    local npc = Npc(model, ai, frozen, position, animation, false)
    npc:setOnCreate(onCreate or function() end)
    AstraServerUtils.toAll("newNpc", npc)
    return npc
end

AstraSNpcsManager.createPrivate = function(model, ai, frozen, position, animation, baseAllowed, onCreate)
    local npc = Npc(model, ai, frozen, position, animation, true, baseAllowed)
    local players = ESX.GetPlayers()
    for k, v in pairs(players) do
        if npc:isAllowed(v) then
            AstraServerUtils.toClient("newNpc", v, npc)
        end
    end
    return npc
end

AstraSNpcsManager.addAllowed = function(npcId, playerId)
    if not AstraSNpcsManager.list[npcId] then
        return
    end
    ---@type Npc
    local npc = AstraSNpcsManager.list[npcId]
    if npc:isAllowed(playerId) then
        print(Astra.prefix(AstraPrefixes.npcs,("Tentative d'ajouter l'ID %s au npc %s alors qu'il est déjà autorisé"):format(playerId, npcId)))
        return
    end
    npc:addAllowed(playerId)
    AstraServerUtils.toClient("newNpc", playerId, npc)
    AstraSNpcsManager.list[npcId] = npc
end

AstraSNpcsManager.removeAllowed = function(npcId, playerId)
    if not AstraSNpcsManager.list[npcId] then
        return
    end
    ---@type Npc
    local npc = AstraSNpcsManager.list[npcId]
    if not npc:isAllowed(playerId) then
        print(Astra.prefix(AstraPrefixes.npcs,("Tentative de supprimer l'ID %s au blip %s alors qu'il n'est déjà pas autorisé"):format(playerId, npcId)))
        return
    end
    npc:removeAllowed(playerId)
    AstraServerUtils.toClient("delNpc", playerId, npcId)
    AstraSNpcsManager.list[npcId] = npc
end

AstraSNpcsManager.updateOne = function(source)
    local npcs = {}
    ---@param npc Npc
    for npcId, npc in pairs(AstraSNpcsManager.list) do
        if npc:isRestricted() then
            if npc:isAllowed(source) then
                npcs[npcId] = npc
            end
        else
            npcs[npcId] = npc
        end
    end
    AstraServerUtils.toClient("cbNpcs", source, npcs)
end

Astra.netRegisterAndHandle("requestPredefinedNpcs", function()
    local source = source
    AstraSNpcsManager.updateOne(source)
end)

