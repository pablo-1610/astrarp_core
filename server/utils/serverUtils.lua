--[[
  This file is part of Astra RolePlay.

  Copyright (c) Astra RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

AstraServerUtils = {}

AstraServerUtils.toClient = function(eventName, targetId, ...)
    TriggerClientEvent("astra:" .. Astra.hash(eventName), targetId, ...)
end

AstraServerUtils.toAll = function(eventName, ...)
    TriggerClientEvent("astra:" .. Astra.hash(eventName), -1, ...)
end

AstraServerUtils.getLicense = function(source)
    for k, v in pairs(GetPlayerIdentifiers(source)) do
        if string.sub(v, 1, string.len("license:")) == "license:" then
            return v
        end
    end
    return ""
end

AstraServerUtils.trace = function(message, prefix)
    print("[^1Astra^7] (" .. prefix .. "^7) " .. message .. "^7")
end

local webhookColors = {
    ["red"] = 16711680,
    ["green"] = 56108,
    ["grey"] = 8421504,
    ["orange"] = 16744192
}

AstraServerUtils.webhook = function(message, color, url)
    local DiscordWebHook = url
    local embeds = {
        {
            ["title"] = message,
            ["type"] = "rich",
            ["color"] = webhookColors[color],
            ["footer"] = {
                ["text"] = "Astra Logs",
            },
        }
    }
    PerformHttpRequest(DiscordWebHook, function(err, text, headers)
    end, 'POST', json.encode({ username = "Astra Logs", embeds = embeds }), { ['Content-Type'] = 'application/json' })
end

Astra.newRepeatingTask(function()
    local restrictedZones, publicZones = 0, 0
    local restrictedBlips, publicBlips = 0, 0
    local restrictedNpcs, publicNpcs = 0, 0
    ---@param zone Zone
    for _, zone in pairs(AstraSZonesManager.list) do
        if zone:isRestricted() then
            restrictedZones = restrictedZones + 1
        else
            publicZones = publicZones + 1
        end
    end
    ---@param blip Blip
    for _, blip in pairs(AstraSBlipsManager.list) do
        if blip:isRestricted() then
            restrictedBlips = restrictedBlips + 1
        else
            publicBlips = publicBlips + 1
        end
    end
    ---@param npc Npc
    for _, npc in pairs(AstraSNpcsManager.list) do
        if npc:isRestricted() then
            restrictedNpcs = restrictedNpcs + 1
        else
            publicNpcs = publicNpcs + 1
        end
    end
    AstraServerUtils.trace(("Zones: %s%i%s (+%s%i%s) | Blips: %s%i%s (+%s%i%s) | Npcs: %s%i%s (+%s%i%s)"):format(
            "^2",
            publicZones,
            "^7",
            "^3",
            restrictedZones,
            "^7",
            "^2",
            publicBlips,
            "^7",
            "^3",
            restrictedBlips,
            "^7",
            "^2",
            publicNpcs,
            "^7",
            "^3",
            restrictedNpcs,
            "^7"
    ), AstraPrefixes.dev)
end, nil, 0, Astra.second(30))