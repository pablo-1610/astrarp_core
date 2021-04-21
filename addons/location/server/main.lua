---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Astra RolePlay.
  
  File [main] created at [21/04/2021 14:59]

  Copyright (c) Astra RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

local vehiclesToSell = {
    {model = "faggio3", label = "Scooter", price = 50},
    {model = "panto", label = "Panto", price = 150},
}

local npc

Astra.netHandle("esxloaded", function()
    ---@type Npc
    npc = AstraSNpcsManager.createPublic("a_m_y_business_03", false, true, {coords = vector3(-825.07, -115.27, 37.58), heading = 214.0}, "WORLD_HUMAN_TOURIST_MAP", nil)
    npc:setInvincible(true)
    npc:setFloatingText("Louez un véhicule ici", 15.5)

    ---@type Zone
    local zone = AstraSZonesManager.createPublic(vector3(-824.35, -116.42, 37.58), 22, {r = 250, g = 203, b = 72, a = 255}, function(source)
        npc:playSpeechForPlayer("GENERIC_HI", "SPEECH_PARAMS_FORCE_NORMAL_CLEAR", source)
        local xPlayer = ESX.GetPlayerFromId(source)
        local accounts = {xPlayer.getAccount('cash').money, xPlayer.getAccount('bank').money}
        AstraServerUtils.toClient("locationOpenMenu", source, vehiclesToSell, accounts)
    end, "Appuyez sur ~INPUT_CONTEXT~ pour accéder à la location de véhicules",20.0, 1.0)

    ---@type Blip
    local blip = AstraSBlipsManager.createPublic(vector3(-824.35, -116.42, 37.58), 280, 66, 0.8, "Location de véhicules", true)
end)

Astra.netRegisterAndHandle("locationPayCar", function(vehicleId, payMethod)
    local source = source
    if not AstraSPlayersManager.exists(source) then
        return
    end
    local astraPlayer = AstraSPlayersManager.getPlayer(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not vehiclesToSell[vehicleId] then
        DropPlayer(source, "[AstraRP/Location]: Tentative d'obtenir un véhicule invalide")
        return
    end
    local price = vehiclesToSell[vehicleId].price
    local model = vehiclesToSell[vehicleId].model
    ---@type Armory
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
        AstraServerUtils.toClient("advancedNotif", source, "~r~Location","~r~Erreur d'achat","Vous n'avez pas assez d'argent sur le compte selectionné !", "CHAR_ANDREAS", 1)
        AstraServerUtils.toClient("locationCb", source)
        return
    end
    pay()

    npc:playSpeechForPlayer("GENERIC_THANKS", "SPEECH_PARAMS_FORCE_NORMAL_CLEAR", source)
    AstraServerUtils.toClient("advancedNotif", source, "~r~Location","~g~Notification d'achat",("Achat effectué ! Profitez bien de votre ~b~%s ~s~!"):format(vehiclesToSell[vehicleId].label), "CHAR_ANDREAS", 1)
    AstraServerUtils.toClient("locationCb", source, vehiclesToSell[vehicleId].model)
end)