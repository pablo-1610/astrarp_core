---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Astra RolePlay.
  
  File [main] created at [10/06/2021 19:27]

  Copyright (c) Astra RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

local itemsTable = {}

Astra.netHandle("esxloaded", function()
    MySQL.Async.fetchAll("SELECT * FROM items", {}, function(result)
        for k,v in pairs(result) do
            itemsTable[v.name] = { label = v.label, canDrop = (v.canDrop or true) }
        end
    end)
end)

ESX.RegisterServerCallback('menugetbills', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local bills = {}

    MySQL.Async.fetchAll('SELECT * FROM billing WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.identifier
    }, function(result)
        for i = 1, #result, 1 do
            table.insert(bills, {
                id = result[i].id,
                label = result[i].label,
                amount = result[i].amount
            })
        end

        cb(bills)
    end)
end)

---@ERR698
Astra.netRegisterAndHandle("requestDropItem", function(name)
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    local inv = {}

    for k,v in pairs(xPlayer.getInventory(true)) do
        inv[v.name] = {name = v.name, label = itemsTable[v.name].label, count = v.count, canDrop = itemsTable[v.name].canDrop}
    end

    print(name)
    print(json.encode(inv[name]))
    print(json.encode(inv[name].canDrop))
    if not inv[name] or not inv[name].canDrop then
        AstraServerUtils.toClient("cbTransaction", _src, "~r~Une erreur est survenue (Erreur #698)")
        return
    end

    xPlayer.removeInventoryItem(name, 1)
    inv[name].count = (inv[name].count-1)
    if inv[name].count <= 0 then
        inv[name] = nil
    end
    AstraServerUtils.toClient("cbTransaction", _src)
    AstraServerUtils.toClient("cbF5Data", _src, {
        inventory = inv,
        weapons = xPlayer.getLoadout(),
        accounts = xPlayer.getAccounts(),
        job = xPlayer.job,
        orga = xPlayer.job2,
        name = GetPlayerName(_src)
    })
end)

Astra.netRegisterAndHandle("requestF5Infos", function()
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    local inv, loadout = {}, {}

    for k,v in pairs(xPlayer.getInventory(true)) do
        inv[v.name] = {name = v.name, label = itemsTable[v.name].label, count = v.count, canDrop = itemsTable[v.name].canDrop}
    end

    for k,v in pairs(xPlayer.getLoadout()) do
        loadout[v.label] = {v.ammo, v.name}
    end

    print(json.encode(xPlayer.getLoadout()))
    AstraServerUtils.toClient("cbF5Data", _src, {
        inventory = inv,
        weapons = loadout,
        accounts = xPlayer.getAccounts(),
        job = xPlayer.job,
        orga = xPlayer.job2,
        name = GetPlayerName(_src)
    })
end)