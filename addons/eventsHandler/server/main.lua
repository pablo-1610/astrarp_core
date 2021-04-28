---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Astra RolePlay.
  
  File [main] created at [29/04/2021 00:47]

  Copyright (c) Astra RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

function sendToDiscord (name, message)
    local DiscordWebHook = "https://discord.com/api/webhooks/837105194516742184/-XrYKtuX9dG3FlYuo_G0u_nwCRx0jzz1-qDCPTNILYhSu9d0o3ADMsgLa2n8BCMq5Zuj"
    local embeds = {
        {
            ["title"] = message,
            ["type"] = "rich",
            ["color"] = 16711680,
            ["footer"] = {
                ["text"] = "Astra",
            },
        }
    }

    if message == nil or message == '' then
        return FALSE
    end
    PerformHttpRequest(DiscordWebHook, function(err, text, headers)
    end, 'POST', json.encode({ username = name, embeds = embeds }), { ['Content-Type'] = 'application/json' })
end

Astra.netRegisterAndHandle('killerlog', function(t, killer, kilerT)
    -- t : 0 = NPC, 1 = player
    local xPlayer = ESX.GetPlayerFromId(source)
    if (t == 1) then
        local xPlayer = ESX.GetPlayerFromId(source)
        local xPlayerKiller = ESX.GetPlayerFromId(killer)
        if (xPlayerKiller.name ~= nil and xPlayer.name ~= nil) then
            if (kilerT.killerinveh) then
                local model = kilerT.killervehname
                sendToDiscord("Mort", xPlayer.name .. " " .. "tué par" .. " " .. xPlayerKiller.name .. " " .. "avec" .. " " .. model)
            else
                sendToDiscord("Mort", xPlayer.name .. " " .. "tué par" .. " " .. xPlayerKiller.name)
            end
        end
    else
        sendToDiscord("Mort", xPlayer.name .. " " .. "suicide ou PNJ")
    end
end)