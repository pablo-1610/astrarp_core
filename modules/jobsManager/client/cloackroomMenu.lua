---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Astra RolePlay.

  Copyright (c) Astra RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

local isWithWorkingClothes = false
local badgeFromValue = {}

Astra.newWaitingThread(100, function()
    badgeFromValue = {
        [true] = RageUI.BadgeStyle.Clothes,
        [false] = RageUI.BadgeStyle.Tick
    }
end)

local byIndex = {
    [true] = "M",
    [false] = "F"
}
local cat, desc = "jobcloackroom", "~y~Vestiaires de travail"
local sub = function(str)
    return cat .. "_" .. str
end

Astra.netRegisterAndHandle("openCloackroom", function(job)
    if menuIsOpened then
        return
    end

    FreezeEntityPosition(PlayerPedId(), true)
    menuIsOpened = true

    RMenu.Add(cat, sub("main"), RageUI.CreateMenu(nil, desc, nil, nil, "root_cause", "shopui_title_vangelico"))
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
                RageUI.Separator("↓ ~y~Tenues disponibles ~s~↓")
                RageUI.ButtonWithStyle("Tenue de ville", "Vous permets d'enfiler votre tenue de ville", { RightBadge = badgeFromValue[not isWithWorkingClothes] }, true, function(_, _, s)
                    if s and isWithWorkingClothes then
                        isWithWorkingClothes = false

                        ESX.TriggerServerCallback('::{korioz#0110}::esx_skin:getPlayerSkin', function(skin)
                            TriggerEvent('::{korioz#0110}::skinchanger:loadSkin', skin)
                        end)
                    end
                end)
                RageUI.ButtonWithStyle("Tenue de travail", "Vous permets d'enfiler votre tenue de travail", { RightBadge = badgeFromValue[isWithWorkingClothes] }, true, function(_, _, s)
                    if s and not isWithWorkingClothes then
                        isWithWorkingClothes = true
                        TriggerEvent('::{korioz#0110}::skinchanger:getSkin', function(skin)
                            TriggerEvent('::{korioz#0110}::skinchanger:loadClothes', skin, AstraSharedCustomJobs[job].clothes[Job.grade_name][byIndex[skin.sex == 0]])
                        end)
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
    end)
end)