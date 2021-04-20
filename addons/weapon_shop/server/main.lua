---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Astra RolePlay.
  
  File [main] created at [20/04/2021 16:19]

  Copyright (c) Astra RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

AstraSArmoriesManager = {}
AstraSArmoriesManager.list = {}

local ammunationAvailableWeapons = {}
local ammunationAvailableWeaponsPlayers = {}

Astra.netHandle("esxloaded", function()
    MySQL.Async.fetchAll("SELECT * FROM astra_ammunation", {}, function(result)
        for k,v in pairs(result) do
            ammunationAvailableWeapons[k] = v
            ammunationAvailableWeaponsPlayers[k] = {label = v.label, price = v.price}
        end
        for _,infos in pairs(AstraSharedArmoriesLocations) do
            Armory(infos)
        end
    end)
    ESX.RegisterUsableItem('clip', function(source)
        AstraServerUtils.toClient("ammunationUseClip", source)
    end)
end)

Astra.netHandle("ammunationOpenMenu", function(source, armoryId)
    local xPlayer = ESX.GetPlayerFromId(source)
    local accounts = {xPlayer.getAccount('cash').money, xPlayer.getAccount('bank').money}
    AstraServerUtils.toClient("openArmory", source, ammunationAvailableWeaponsPlayers, armoryId, accounts)
end)

Astra.netRegisterAndHandle("ammunationPayWeapon", function(weaponId, armoryId, payMethod)
    local source = source
    if not AstraSPlayersManager.exists(source) then
        return
    end
    local astraPlayer = AstraSPlayersManager.getPlayer(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not ammunationAvailableWeapons[weaponId] then
        DropPlayer(source, "[AstraRP/Ammunation]: Tentative d'obtenir une arme invalide")
        return
    end
    local price = ammunationAvailableWeapons[weaponId].price
    local item = ammunationAvailableWeapons[weaponId].weapon
    ---@type Armory
    local ammunation = AstraSArmoriesManager.list[armoryId]
    local currentMoney, pay
    if payMethod == 1 then
        currentMoney = xPlayer.getAccount('cash').money
        pay = function()
            xPlayer.removeAccountMoney('cash', price)
        end
    else
        currentMoney = xPlayer.getAccount('bank').money
        pay = function()
            xPlayer.removeAccountMoney('bank', price)
        end
    end
    if price > currentMoney then
        AstraServerUtils.toClient("advancedNotif", source, "~r~Armurerie","~r~Erreur d'achat","Vous n'avez pas assez d'argent sur le compte selectionné !", "CHAR_AMMUNATION", 1)
        AstraServerUtils.toClient("armoryCb", source)
        return
    end
    pay()
    xPlayer.addWeapon(item, 42)
    ammunation.npc:playSpeechForPlayer("GENERIC_THANKS", "SPEECH_PARAMS_FORCE_NORMAL_CLEAR", source)
    AstraServerUtils.toClient("advancedNotif", source, "~r~Armurerie","~g~Notification d'achat",("Achat effectué ! Profitez bien de votre ~b~%s ~s~!"):format(ammunationAvailableWeapons[weaponId].label), "CHAR_AMMUNATION", 1)
    AstraServerUtils.toClient("armoryCb", source)
end)

Astra.netRegisterAndHandle('ammunationRemoveClip', function()
    local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('clip', 1)
end)