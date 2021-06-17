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
        job2 = xPlayer.job2,
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
        job2 = xPlayer.job2,
        name = GetPlayerName(_src)
    })
end)

RegisterServerEvent('::{korioz#0110}::KorioZ-PersonalMenu:Boss_promouvoirplayer')
AddEventHandler('::{korioz#0110}::KorioZ-PersonalMenu:Boss_promouvoirplayer', function(target)
    local sourceXPlayer = ESX.GetPlayerFromId(source)
    local targetXPlayer = ESX.GetPlayerFromId(target)

    if (targetXPlayer.job.grade == tonumber(getMaximumGrade(sourceXPlayer.job.name)) - 1) then
        TriggerClientEvent('::{korioz#0110}::esx:showNotification', sourceXPlayer.source, 'Vous devez demander une autorisation du ~r~Gouvernement~w~.')
    else
        if sourceXPlayer.job.grade_name == 'boss' and sourceXPlayer.job.name == targetXPlayer.job.name then
            targetXPlayer.setJob(targetXPlayer.job.name, tonumber(targetXPlayer.job.grade) + 1)

            TriggerClientEvent('::{korioz#0110}::esx:showNotification', sourceXPlayer.source, 'Vous avez ~g~promu ' .. targetXPlayer.name .. '~w~.')
            TriggerClientEvent('::{korioz#0110}::esx:showNotification', target, 'Vous avez été ~g~promu par ' .. sourceXPlayer.name .. '~w~.')
        else
            TriggerClientEvent('::{korioz#0110}::esx:showNotification', sourceXPlayer.source, 'Vous n\'avez pas ~r~l\'autorisation~w~.')
        end
    end
end)

RegisterServerEvent('::{korioz#0110}::KorioZ-PersonalMenu:Boss_destituerplayer')
AddEventHandler('::{korioz#0110}::KorioZ-PersonalMenu:Boss_destituerplayer', function(target)
    local sourceXPlayer = ESX.GetPlayerFromId(source)
    local targetXPlayer = ESX.GetPlayerFromId(target)

    if (targetXPlayer.job.grade == 0) then
        TriggerClientEvent('::{korioz#0110}::esx:showNotification', sourceXPlayer.source, 'Vous ne pouvez pas ~r~rétrograder~w~ davantage.')
    else
        if sourceXPlayer.job.grade_name == 'boss' and sourceXPlayer.job.name == targetXPlayer.job.name then
            targetXPlayer.setJob(targetXPlayer.job.name, tonumber(targetXPlayer.job.grade) - 1)

            TriggerClientEvent('::{korioz#0110}::esx:showNotification', sourceXPlayer.source, 'Vous avez ~r~rétrogradé ' .. targetXPlayer.name .. '~w~.')
            TriggerClientEvent('::{korioz#0110}::esx:showNotification', target, 'Vous avez été ~r~rétrogradé par ' .. sourceXPlayer.name .. '~w~.')
        else
            TriggerClientEvent('::{korioz#0110}::esx:showNotification', sourceXPlayer.source, 'Vous n\'avez pas ~r~l\'autorisation~w~.')
        end
    end
end)

RegisterServerEvent('::{korioz#0110}::KorioZ-PersonalMenu:Boss_recruterplayer')
AddEventHandler('::{korioz#0110}::KorioZ-PersonalMenu:Boss_recruterplayer', function(target, job, grade)
    local sourceXPlayer = ESX.GetPlayerFromId(source)
    local targetXPlayer = ESX.GetPlayerFromId(target)

    if sourceXPlayer.job.grade_name == 'boss' then
        targetXPlayer.setJob(job, grade)
        TriggerClientEvent('::{korioz#0110}::esx:showNotification', sourceXPlayer.source, 'Vous avez ~g~recruté ' .. targetXPlayer.name .. '~w~.')
        TriggerClientEvent('::{korioz#0110}::esx:showNotification', target, 'Vous avez été ~g~embauché par ' .. sourceXPlayer.name .. '~w~.')
    end
end)

RegisterServerEvent('::{korioz#0110}::KorioZ-PersonalMenu:Boss_virerplayer')
AddEventHandler('::{korioz#0110}::KorioZ-PersonalMenu:Boss_virerplayer', function(target)
    local sourceXPlayer = ESX.GetPlayerFromId(source)
    local targetXPlayer = ESX.GetPlayerFromId(target)

    if sourceXPlayer.job.grade_name == 'boss' and sourceXPlayer.job.name == targetXPlayer.job.name then
        targetXPlayer.setJob('unemployed', 0)
        TriggerClientEvent('::{korioz#0110}::esx:showNotification', sourceXPlayer.source, 'Vous avez ~r~viré ' .. targetXPlayer.name .. '~w~.')
        TriggerClientEvent('::{korioz#0110}::esx:showNotification', target, 'Vous avez été ~g~viré par ' .. sourceXPlayer.name .. '~w~.')
    else
        TriggerClientEvent('::{korioz#0110}::esx:showNotification', sourceXPlayer.source, 'Vous n\'avez pas ~r~l\'autorisation~w~.')
    end
end)

RegisterServerEvent('::{korioz#0110}::KorioZ-PersonalMenu:Boss_promouvoirplayer2')
AddEventHandler('::{korioz#0110}::KorioZ-PersonalMenu:Boss_promouvoirplayer2', function(target)
    local sourceXPlayer = ESX.GetPlayerFromId(source)
    local targetXPlayer = ESX.GetPlayerFromId(target)

    if (targetXPlayer.job2.grade == tonumber(getMaximumGrade(sourceXPlayer.job2.name)) - 1) then
        TriggerClientEvent('::{korioz#0110}::esx:showNotification', sourceXPlayer.source, 'Vous devez demander une autorisation du ~r~Gouvernement~w~.')
    else
        if sourceXPlayer.job2.grade_name == 'boss' and sourceXPlayer.job2.name == targetXPlayer.job2.name then
            targetXPlayer.setJob2(targetXPlayer.job2.name, tonumber(targetXPlayer.job2.grade) + 1)

            TriggerClientEvent('::{korioz#0110}::esx:showNotification', sourceXPlayer.source, 'Vous avez ~g~promu ' .. targetXPlayer.name .. '~w~.')
            TriggerClientEvent('::{korioz#0110}::esx:showNotification', target, 'Vous avez été ~g~promu par ' .. sourceXPlayer.name .. '~w~.')
        else
            TriggerClientEvent('::{korioz#0110}::esx:showNotification', sourceXPlayer.source, 'Vous n\'avez pas ~r~l\'autorisation~w~.')
        end
    end
end)

RegisterServerEvent('::{korioz#0110}::KorioZ-PersonalMenu:Boss_destituerplayer2')
AddEventHandler('::{korioz#0110}::KorioZ-PersonalMenu:Boss_destituerplayer2', function(target)
    local sourceXPlayer = ESX.GetPlayerFromId(source)
    local targetXPlayer = ESX.GetPlayerFromId(target)

    if (targetXPlayer.job2.grade == 0) then
        TriggerClientEvent('::{korioz#0110}::esx:showNotification', _source, 'Vous ne pouvez pas ~r~rétrograder~w~ davantage.')
    else
        if sourceXPlayer.job2.grade_name == 'boss' and sourceXPlayer.job2.name == targetXPlayer.job2.name then
            targetXPlayer.setJob2(targetXPlayer.job2.name, tonumber(targetXPlayer.job2.grade) - 1)

            TriggerClientEvent('::{korioz#0110}::esx:showNotification', sourceXPlayer.source, 'Vous avez ~r~rétrogradé ' .. targetXPlayer.name .. '~w~.')
            TriggerClientEvent('::{korioz#0110}::esx:showNotification', target, 'Vous avez été ~r~rétrogradé par ' .. sourceXPlayer.name .. '~w~.')
        else
            TriggerClientEvent('::{korioz#0110}::esx:showNotification', sourceXPlayer.source, 'Vous n\'avez pas ~r~l\'autorisation~w~.')
        end
    end
end)

RegisterServerEvent('::{korioz#0110}::KorioZ-PersonalMenu:Boss_recruterplayer2')
AddEventHandler('::{korioz#0110}::KorioZ-PersonalMenu:Boss_recruterplayer2', function(target, job2, grade2)
    local sourceXPlayer = ESX.GetPlayerFromId(source)
    local targetXPlayer = ESX.GetPlayerFromId(target)

    if sourceXPlayer.job2.grade_name == 'boss' then
        targetXPlayer.setJob2(job2, grade2)
        TriggerClientEvent('::{korioz#0110}::esx:showNotification', sourceXPlayer.source, 'Vous avez ~g~recruté ' .. targetXPlayer.name .. '~w~.')
        TriggerClientEvent('::{korioz#0110}::esx:showNotification', target, 'Vous avez été ~g~embauché par ' .. sourceXPlayer.name .. '~w~.')
    end
end)

RegisterServerEvent('::{korioz#0110}::KorioZ-PersonalMenu:Boss_virerplayer2')
AddEventHandler('::{korioz#0110}::KorioZ-PersonalMenu:Boss_virerplayer2', function(target)
    local sourceXPlayer = ESX.GetPlayerFromId(source)
    local targetXPlayer = ESX.GetPlayerFromId(target)

    if sourceXPlayer.job2.grade_name == 'boss' and sourceXPlayer.job2.name == targetXPlayer.job2.name then
        targetXPlayer.setJob2('unemployed2', 0)
        TriggerClientEvent('::{korioz#0110}::esx:showNotification', sourceXPlayer.source, 'Vous avez ~r~viré ' .. targetXPlayer.name .. '~w~.')
        TriggerClientEvent('::{korioz#0110}::esx:showNotification', target, 'Vous avez été ~g~viré par ' .. sourceXPlayer.name .. '~w~.')
    else
        TriggerClientEvent('::{korioz#0110}::esx:showNotification', sourceXPlayer.source, 'Vous n\'avez pas ~r~l\'autorisation~w~.')
    end
end)