---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Astra RolePlay.
  
  File [main] created at [19/04/2021 23:51]

  Copyright (c) Astra RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

AstraSPlayersManager = {}
AstraSPlayersManager.eventOverrider = {}
AstraSPlayersManager.addonCache = {}
AstraSPlayersManager.list = {}

AstraSPlayersManager.registerAddonCache = function(index, onConnect, onDisconnect, onChange)
    AstraServerUtils.trace(("Enregistrement d'un cache joueur: ^3%s"):format(index), AstraPrefixes.dev)
    AstraSPlayersManager.addonCache[index] = { onConnect, onDisconnect, onChange }
end

AstraSPlayersManager.registerEventOverrider = function(type, func)
    AstraSPlayersManager.eventOverrider[(#AstraSPlayersManager.eventOverrider + 1)] = { on = type, handle = func }
end

AstraSPlayersManager.exists = function(source)
    return AstraSPlayersManager.list[source] ~= nil
end

AstraSPlayersManager.createPlayer = function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    local steam, license = xPlayer.identifier, AstraServerUtils.getLicense(source)
    AstraSPlayersManager.list[source] = Player(source, steam, license)
end

AstraSPlayersManager.getPlayer = function(source)
    return AstraSPlayersManager.list[source]
end

AstraSPlayersManager.removePlayer = function(source)
    AstraSPlayersManager.list[source] = nil
end

Astra.netHandleBasic("playerDropped", function(reason)
    local source = source
    if not AstraSPlayersManager.exists(source) then
        return
    end
    AstraServerUtils.trace(("Déconnexion de %s"):format(GetPlayerName(source)), AstraPrefixes.dev)
    for _, eventOverriderInfos in pairs(AstraSPlayersManager.eventOverrider) do
        if eventOverriderInfos.on == PLAYER_EVENT_TYPE.LEAVING then
            eventOverriderInfos.handle(source)
        end
    end
    for _, handlers in pairs(AstraSPlayersManager.addonCache) do
        handlers[2](AstraSPlayersManager.list[source])
    end
    AstraSPlayersManager.removePlayer(source)
end)

Astra.netHandleBasic('::{korioz#0110}::esx:playerLoaded', function(source, xPlayer)
    local source = source
    AstraServerUtils.trace(("Connexion de %s"):format(GetPlayerName(source)), AstraPrefixes.dev)
    AstraSPlayersManager.createPlayer(source)
    for _, eventOverriderInfos in pairs(AstraSPlayersManager.eventOverrider) do
        if eventOverriderInfos.on == PLAYER_EVENT_TYPE.CONNECTED then
            eventOverriderInfos.handle(source)
        end
    end
    for _, handlers in pairs(AstraSPlayersManager.addonCache) do
        handlers[1](AstraSPlayersManager.list[source])
    end
end)

Astra.newRepeatingTask(function()
    ---@param player Player
    for _, player in pairs(AstraSPlayersManager.list) do
        player:incrementSessionTimePlayed()
    end
end, nil, 0, Astra.second(60))