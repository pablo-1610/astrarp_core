---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Astra RolePlay.
  
  File [luckywheelMenu] created at [22/04/2021 06:57]

  Copyright (c) Astra RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

local cat, desc = "luckywheel", "~r~Roue - Astra RolePlay"
local isWaitingServerResponse = false
local sub = function(str)
    return cat .. "_" .. str
end

Astra.netRegisterAndHandle("luckywheelOpenMenu", function(canDoFreeTurn, availablePaidTurns)
    if menuIsOpened then
        return
    end

    if isWaitingServerResponse then
        ESX.ShowNotification("~r~Une transaction est encore en cours avec le serveur...")
        return
    end

    FreezeEntityPosition(PlayerPedId(), true)
    menuIsOpened = true

    RMenu.Add(cat, sub("main"), RageUI.CreateMenu(nil, desc, nil, nil, "casinoui_lucky_wheel", "casinoui_lucky_wheel"))
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
            end, function()
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