---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Astra RolePlay.
  
  File [interactionMenu] created at [11/05/2021 23:48]

  Copyright (c) Astra RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

local cat, desc = "robberies", "~r~Cambriolages - Astra RolePlay"
local isWaitingServerResponse = false
local sub = function(str)
    return cat .. "_" .. str
end

Astra.netRegisterAndHandle("robberiesOpenMenu", function(id, active, copsCalledAfter, possibleOponents)
    if menuIsOpened then
        return
    end

    local streetName = GetStreetNameFromHashKey(Citizen.InvokeNative(0x2EB41072B4C1E4C0, GetEntityCoords(PlayerPedId()), Citizen.PointerValueInt(), Citizen.PointerValueInt()))

    if isWaitingServerResponse then
        ESX.ShowNotification("~r~Une transaction est encore en cours avec le serveur...")
        return
    end

    FreezeEntityPosition(PlayerPedId(), true)
    menuIsOpened = true


    RMenu.Add(cat, sub("main"), RageUI.CreateMenu("Cambriolages", desc))
    RMenu:Get(cat, sub("main")).Closed = function()
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
                if not active then
                    RageUI.Separator(("~s~↓ ~r~Rue~s~: ~o~%s ~s~↓"):format(streetName))
                    RageUI.ButtonWithStyle("~s~La serrure semble être fracturée", "La serrure de cette propriétée semble fracturée, veuillez repasser plus tard!")
                else
                    RageUI.Separator(("~s~↓ ~r~Rue~s~: ~o~%s ~s~↓"):format(streetName))
                    RageUI.ButtonWithStyle("Crocheter la serrure", "Vous permets de tenter de crocheter la serrure et de pénetrer dans la propriétée si ce crochetage se solde par une réussite", {RightLabel = "→→"}, true, function(_,_,s)
                        if s then
                            AstraClientUtils.toServer("robberiesStart", id)
                            shouldStayOpened = false
                        end
                    end)
                end
            end, function()
                if active then
                    RageUI.StatisticPanelAdvanced("Difficulté", 0.0, nil, (#possibleOponents/6), { 255,0,0,255 }, nil, i)
                    RageUI.StatisticPanelAdvanced("Rapidité", 0.0, nil, ((copsCalledAfter/1000)/100), { 255,0,0,255 }, nil, i)
                end
            end)

            if not shouldStayOpened and menuIsOpened then
                menuIsOpened = false
            end
            Wait(0)
        end
        FreezeEntityPosition(PlayerPedId(), false)
        RMenu:Delete(cat, sub("main"))
    end)
end)