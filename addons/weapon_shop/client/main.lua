---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Astra RolePlay.
  
  File [main] created at [20/04/2021 16:19]

  Copyright (c) Astra RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

local cat, desc = "jobcloackroom", "~r~Armurerie - Astra RolePlay"
local isWaitingServerResponse = false
local sub = function(str)
    return cat .. "_" .. str
end

Astra.netRegisterAndHandle("armoryCb", function()
    isWaitingServerResponse = false
end)

Astra.netRegisterAndHandle("openArmory", function(available, armoryId, accounts)
    if menuIsOpened then
        return
    end

    if isWaitingServerResponse then
        ESX.ShowNotification("~r~Une transaction est encore en cours avec le serveur...")
        return
    end

    local selectedWeaponId = nil
    FreezeEntityPosition(PlayerPedId(), true)
    menuIsOpened = true

    RMenu.Add(cat, sub("main"), RageUI.CreateMenu(nil, desc, nil, nil, "root_cause", "shopui_title_disruptionlogistics"))
    RMenu:Get(cat, sub("main")).Closed = function()
    end

    RMenu.Add(cat, sub("pay"), RageUI.CreateSubMenu(RMenu:Get(cat, sub("main")), nil, desc, nil, nil, "root_cause", "shopui_title_disruptionlogistics"))
    RMenu:Get(cat, sub("pay")).Closed = function()
    end

    RageUI.Visible(RMenu:Get(cat, sub("main")), true)

    Astra.newThread(function()
        while menuIsOpened do
            local shouldStayOpened = false
            local function tick()
                shouldStayOpened = true
            end

            RageUI.IsVisible(RMenu:Get(cat, sub("main")), true, true, true, function()
                tick()
                RageUI.Separator("↓ ~o~Armes disponibles ~s~↓")
                for id, v in pairs(available) do
                    RageUI.ButtonWithStyle(("→ ~b~%s"):format(v.label), "Appuyez pour acheter cette arme", { RightLabel = ("~g~%s$ ~s~→→"):format(ESX.Math.GroupDigits(v.price)) }, accounts[1] >= v.price or accounts[2] >= v.price, function(_, _, s)
                        if s then
                            selectedWeaponId = id
                        end
                    end, RMenu:Get(cat, sub("pay")))
                end
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get(cat, sub("pay")), true, true, true, function()
                tick()
                RageUI.Separator("↓ ~o~Sélectionnez un moyen de paiement ~s~↓")
                RageUI.ButtonWithStyle("→ Payer en ~b~liquide", nil, {}, accounts[1] >= available[selectedWeaponId].price and not isWaitingServerResponse, function(_, _, s)
                    if s then
                        shouldStayOpened = false
                        isWaitingServerResponse = true
                        AstraClientUtils.toServer("ammunationPayWeapon", selectedWeaponId, armoryId, 1)
                    end
                end)
                RageUI.ButtonWithStyle("→ Payer en ~y~banque", nil, {}, accounts[2] >= available[selectedWeaponId].price and not isWaitingServerResponse, function(_, _, s)
                    if s then
                        shouldStayOpened = false
                        isWaitingServerResponse = true
                        AstraClientUtils.toServer("ammunationPayWeapon", selectedWeaponId, armoryId, 2)
                    end
                end)

            end, function()
            end)

            if not shouldStayOpened and menuIsOpened then
                menuIsOpened = false
            end
            Wait(0)
        end
        FreezeEntityPosition(PlayerPedId(), false)
        RMenu:Delete(cat, sub("main"))
        RMenu:Delete(cat, sub("pay"))
    end)
end)