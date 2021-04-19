--[[
  This file is part of Astra RolePlay.

  Copyright (c) Astra RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

AstraSZonesManager = {}
AstraSZonesManager.list = {}

AstraSZonesManager.createPublic = function(location, type, color, onInteract, helpText, drawDist, itrDist)
    local zone = Zone(location, type, color, onInteract, helpText, drawDist, itrDist, false)
    local marker = { id = zone.zoneID, type = zone.type, color = zone.color, help = zone.helpText, position = zone.location, distances = { zone.drawDist, zone.itrDist } }
    AstraServerUtils.toAll("newMarker", marker)
    return zone.zoneID
end

AstraSZonesManager.createPrivate = function(location, type, color, onInteract, helpText, drawDist, itrDist, baseAllowed)
    local zone = Zone(location, type, color, onInteract, helpText, drawDist, itrDist, true, baseAllowed)
    local marker = { id = zone.zoneID, type = zone.type, color = zone.color, help = zone.helpText, position = zone.location, distances = { zone.drawDist, zone.itrDist } }
    local players = ESX.GetPlayers()
    for k, v in pairs(players) do
        if zone:isAllowed(v) then
            AstraServerUtils.toClient("newMarker", v, marker)
        end
    end
    return zone.zoneID
end

AstraSZonesManager.addAllowed = function(zoneID, playerId)
    if not AstraSZonesManager.list[zoneID] then
        return
    end
    ---@type Zone
    local zone = AstraSZonesManager.list[zoneID]
    if zone:isAllowed(playerId) then
        print(Astra.prefix(AstraPrefixes.zones,("Tentative d'ajouter l'ID %s à la zone %s alors qu'il est déjà autorisé"):format(playerId,zoneID)))
        return
    end
    zone:addAllowed(playerId)
    local marker = { id = zone.zoneID, type = zone.type, color = zone.color, help = zone.helpText, position = zone.location, distances = { zone.drawDist, zone.itrDist } }
    AstraServerUtils.toClient("newMarker", playerId, marker)
    AstraSZonesManager.list[zoneID] = zone
end

AstraSZonesManager.removeAllowed = function(zoneID, playerId)
    if not AstraSZonesManager.list[zoneID] then
        return
    end
    ---@type Zone
    local zone = AstraSZonesManager.list[zoneID]
    if not zone:isAllowed(playerId) then
        print(Astra.prefix(AstraPrefixes.zones,("Tentative de supprimer l'ID %s à la zone %s alors qu'il n'est déjà pas autorisé"):format(playerId,zoneID)))
        return
    end
    zone:removeAllowed(playerId)
    AstraServerUtils.toClient("delMarker", playerId, zoneID)
    AstraSZonesManager.list[zoneID] = zone
end

AstraSZonesManager.updatePrivacy = function(zoneID, newPrivacy)
    if not AstraSZonesManager.list[zoneID] then
        return
    end
    ---@type Zone
    local zone = AstraSZonesManager.list[zoneID]
    local wereAllowed = {}
    local wasRestricted = zone:isRestricted()
    if zone:isRestricted() then
        wereAllowed = zone.allowed
    end
    zone.allowed = {}
    zone:setRestriction(newPrivacy)
    if zone:isRestricted() then
        local players = ESX.GetPlayers()
        if not wasRestricted then
            for _, playerId in pairs(players) do
                local isAllowedtoSee = false
                for _, allowed in pairs(wereAllowed) do
                    if allowed == playerId then
                        isAllowedtoSee = true
                    end
                end
                if not isAllowedtoSee then
                    AstraServerUtils.toClient("delMarker", playerId, zone.zoneID)
                end
            end
        end
    else
        if wasRestricted then
            for _, playerId in pairs(players) do
                local isAllowedtoSee = false
                for _, allowed in pairs(wereAllowed) do
                    if allowed == playerId then
                        isAllowedtoSee = true
                    end
                end
                if isAllowedtoSee then
                    local marker = { id = zone.zoneID, type = zone.type, color = zone.color, help = zone.helpText, position = zone.location, distances = { zone.drawDist, zone.itrDist } }
                    AstraServerUtils.toClient("newMarker", playerId, marker)
                end
            end
        end
    end
    AstraSZonesManager.list[zoneID] = zone
end

AstraSZonesManager.delete = function(zoneID)
    if not AstraSZonesManager.list[zoneID] then
        return
    end
    ---@type Zone
    local zone = AstraSZonesManager.list[zoneID]
    if zone:isRestricted() then
        local players = ESX.GetPlayers()
        for k, playerId in pairs(players) do
            if zone:isAllowed(playerId) then
                AstraServerUtils.toClient("delMarker", playerId, zoneID)
            end
        end
    else
        AstraServerUtils.toAll("delMarker", zoneID)
    end
end

AstraSZonesManager.updateOne = function(source)
    local markers = {}
    ---@param zone Zone
    for zoneID, zone in pairs(AstraSZonesManager.list) do
        if zone:isRestricted() then
            if zone:isAllowed(source) then
                markers[zoneID] = { id = zone.zoneID, type = zone.type, color = zone.color, help = zone.helpText, position = zone.location, distances = { zone.drawDist, zone.itrDist } }
            end
        else
            markers[zoneID] = { id = zone.zoneID, type = zone.type, color = zone.color, help = zone.helpText, position = zone.location, distances = { zone.drawDist, zone.itrDist } }
        end
    end
    AstraServerUtils.toClient("cbZones", source, markers)
end

Astra.netRegisterAndHandle("requestPredefinedZones", function()
    local source = source
    AstraSZonesManager.updateOne(source)
end)

Astra.netRegisterAndHandle("interactWithZone", function(zoneID)
    local source = source
    if not AstraSZonesManager.list[zoneID] then
        DropPlayer("[Astra] Tentative d'intéragir avec une zone inéxistante.")
        return
    end
    ---@type Zone
    local zone = AstraSZonesManager.list[zoneID]
    zone:interact(source)
end)