--[[
  This file is part of Astra RolePlay.

  Copyright (c) Astra RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

AstraSBlipsManager = {}
AstraSBlipsManager.list = {}

AstraSBlipsManager.createPublic = function(position, sprite, color, scale, text, shortRange)
    local blip = Blip(position, sprite, color, scale, text, shortRange, false)
    AstraServerUtils.toAll("newBlip", blip)
    return blip.blipId
end

AstraSBlipsManager.createPrivate = function(position, sprite, color, scale, text, shortRange, baseAllowed)
    local blip = Blip(position, sprite, color, scale, text, shortRange, true, baseAllowed)
    local players = ESX.GetPlayers()
    for k, v in pairs(players) do
        if blip:isAllowed(v) then
            AstraServerUtils.toClient("newBlip", v, blip)
        end
    end
    return blip.blipId
end

AstraSBlipsManager.addAllowed = function(blipID, playerId)
    if not AstraSBlipsManager.list[blipID] then
        return
    end
    ---@type Blip
    local blip = AstraSBlipsManager.list[blipID]
    if blip:isAllowed(playerId) then
        print(Astra.prefix(AstraPrefixes.blips,("Tentative d'ajouter l'ID %s au blip %s alors qu'il est déjà autorisé"):format(playerId,blipID)))
        return
    end
    blip:addAllowed(playerId)
    AstraServerUtils.toClient("newBlip", playerId, blip)
    AstraSBlipsManager.list[blipID] = blip
end

AstraSBlipsManager.removeAllowed = function(blipID, playerId)
    if not AstraSBlipsManager.list[blipID] then
        return
    end
    ---@type Blip
    local blip = AstraSBlipsManager.list[blipID]
    if not blip:isAllowed(playerId) then
        print(Astra.prefix(AstraPrefixes.blips,("Tentative de supprimer l'ID %s au blip %s alors qu'il n'est déjà pas autorisé"):format(playerId,blipID)))
        return
    end
    blip:removeAllowed(playerId)
    AstraServerUtils.toClient("delBlip", playerId, blipID)
    AstraSBlipsManager.list[blipID] = blip
end

AstraSBlipsManager.updateOne = function(source)
    local blips = {}
    ---@param blip Blip
    for blipID, blip in pairs(AstraSBlipsManager.list) do
        if blip:isRestricted() then
            if blip:isAllowed(source) then
                blips[blipID] = blip
            end
        else
            blips[blipID] = blip
        end
    end
    AstraServerUtils.toClient("cbBlips", source, blips)
end

AstraSBlipsManager.delete = function(blipID)
    if not AstraSBlipsManager.list[blipID] then
        return
    end
    ---@type Zone
    local blip = AstraSBlipsManager.list[blipID]
    if blip:isRestricted() then
        local players = ESX.GetPlayers()
        for k, playerId in pairs(players) do
            if blip:isAllowed(playerId) then
                AstraServerUtils.toClient("delBlip", playerId, blipID)
            end
        end
    else
        AstraServerUtils.toAll("delBlip", blipID)
    end
end

Astra.netRegisterAndHandle("requestPredefinedBlips", function()
    local source = source
    AstraSBlipsManager.updateOne(source)
end)