---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Astra RolePlay.
  
  File [menu] created at [10/06/2021 19:26]

  Copyright (c) Astra RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

local cat, desc, title, transaction, bills, localData, localSelectedItem, localSelectedWeapon = "menuperso", "Mon personnage - Astra RolePlay", "AstraRP", false, {}, false

local availableAccounts, c1, c2 = {
    ["cash"] = { "~g~Cash", true, function(closestPlayer)

    end },

    ["bank"] = { "~b~Banque", false },
    ["dirtycash"] = { "~r~Sale", true, function(closestPlayer)

    end }
}, { 'torso', 'pants', 'shoes', 'bag', 'bproof' }, { 'Ears', 'Glasses', 'Helmet', 'Mask' }

local texts = {
    ["c1_torso"] = "Haut",
    ["c1_pants"] = "Bas",
    ["c1_shoes"] = "Chaussures",
    ["c1_bag"] = "Sac",
    ["c1_bproof"] = "Gilet pare-balle",
    ["c2_Ears"] = "Oreillette",
    ["c2_Glasses"] = "Lunettes",
    ["c2_Helmet"] = "Casque",
    ["c2_Mask"] = "Masque"
}

local function getText(str)
    return (texts[str] or "err")
end

local function startAnimAction(lib, anim)
    ESX.Streaming.RequestAnimDict(lib)

    TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, 1.0, -1, 49, 0, false, false, false)
    RemoveAnimDict(lib)
end

local localSelectedManage, manageInfos = {}, nil

local function setUniform(value, plyPed)
    ESX.TriggerServerCallback('::{korioz#0110}::esx_skin:getPlayerSkin', function(skin)
        TriggerEvent('::{korioz#0110}::skinchanger:getSkin', function(skina)
            if value == 'torso' then
                startAnimAction('clothingtie', 'try_tie_neutral_a')
                Citizen.Wait(1000)
                Astra.toInternal("handsUp", false)
                Astra.toInternal("point", false)
                ClearPedTasks(plyPed)

                if skin.torso_1 ~= skina.torso_1 then
                    TriggerEvent('::{korioz#0110}::skinchanger:loadClothes', skina, { ['torso_1'] = skin.torso_1, ['torso_2'] = skin.torso_2, ['tshirt_1'] = skin.tshirt_1, ['tshirt_2'] = skin.tshirt_2, ['arms'] = skin.arms })
                else
                    TriggerEvent('::{korioz#0110}::skinchanger:loadClothes', skina, { ['torso_1'] = 15, ['torso_2'] = 0, ['tshirt_1'] = 15, ['tshirt_2'] = 0, ['arms'] = 15 })
                end
            elseif value == 'pants' then
                if skin.pants_1 ~= skina.pants_1 then
                    TriggerEvent('::{korioz#0110}::skinchanger:loadClothes', skina, { ['pants_1'] = skin.pants_1, ['pants_2'] = skin.pants_2 })
                else
                    if skin.sex == 0 then
                        TriggerEvent('::{korioz#0110}::skinchanger:loadClothes', skina, { ['pants_1'] = 61, ['pants_2'] = 1 })
                    else
                        TriggerEvent('::{korioz#0110}::skinchanger:loadClothes', skina, { ['pants_1'] = 15, ['pants_2'] = 0 })
                    end
                end
            elseif value == 'shoes' then
                if skin.shoes_1 ~= skina.shoes_1 then
                    TriggerEvent('::{korioz#0110}::skinchanger:loadClothes', skina, { ['shoes_1'] = skin.shoes_1, ['shoes_2'] = skin.shoes_2 })
                else
                    if skin.sex == 0 then
                        TriggerEvent('::{korioz#0110}::skinchanger:loadClothes', skina, { ['shoes_1'] = 34, ['shoes_2'] = 0 })
                    else
                        TriggerEvent('::{korioz#0110}::skinchanger:loadClothes', skina, { ['shoes_1'] = 35, ['shoes_2'] = 0 })
                    end
                end
            elseif value == 'bag' then
                if skin.bags_1 ~= skina.bags_1 then
                    TriggerEvent('::{korioz#0110}::skinchanger:loadClothes', skina, { ['bags_1'] = skin.bags_1, ['bags_2'] = skin.bags_2 })
                else
                    TriggerEvent('::{korioz#0110}::skinchanger:loadClothes', skina, { ['bags_1'] = 0, ['bags_2'] = 0 })
                end
            elseif value == 'bproof' then
                startAnimAction('clothingtie', 'try_tie_neutral_a')
                Citizen.Wait(1000)
                Astra.toInternal("handsUp", false)
                Astra.toInternal("point", false)
                ClearPedTasks(plyPed)

                if skin.bproof_1 ~= skina.bproof_1 then
                    TriggerEvent('::{korioz#0110}::skinchanger:loadClothes', skina, { ['bproof_1'] = skin.bproof_1, ['bproof_2'] = skin.bproof_2 })
                else
                    TriggerEvent('::{korioz#0110}::skinchanger:loadClothes', skina, { ['bproof_1'] = 0, ['bproof_2'] = 0 })
                end
            end
        end)
    end)
end

local function setAccessory(accessory)
    ESX.TriggerServerCallback('::{korioz#0110}::esx_accessories:get', function(hasAccessory, accessorySkin)
        local _accessory = (accessory):lower()

        if hasAccessory then
            TriggerEvent('::{korioz#0110}::skinchanger:getSkin', function(skin)
                local mAccessory = -1
                local mColor = 0

                if _accessory == 'ears' then
                    startAnimAction('mini@ears_defenders', 'takeoff_earsdefenders_idle')
                    Citizen.Wait(250)
                    Astra.toInternal("handsUp", false)
                    Astra.toInternal("point", false)
                    ClearPedTasks(plyPed)
                elseif _accessory == 'glasses' then
                    mAccessory = 0
                    startAnimAction('clothingspecs', 'try_glasses_positive_a')
                    Citizen.Wait(1000)
                    Astra.toInternal("handsUp", false)
                    Astra.toInternal("point", false)
                    ClearPedTasks(plyPed)
                elseif _accessory == 'helmet' then
                    startAnimAction('missfbi4', 'takeoff_mask')
                    Citizen.Wait(1000)
                    Astra.toInternal("handsUp", false)
                    Astra.toInternal("point", false)
                    ClearPedTasks(plyPed)
                elseif _accessory == 'mask' then
                    mAccessory = 0
                    startAnimAction('missfbi4', 'takeoff_mask')
                    Citizen.Wait(850)
                    Astra.toInternal("handsUp", false)
                    Astra.toInternal("point", false)
                    ClearPedTasks(plyPed)
                end

                if skin[_accessory .. '_1'] == mAccessory then
                    mAccessory = accessorySkin[_accessory .. '_1']
                    mColor = accessorySkin[_accessory .. '_2']
                end

                local accessorySkin = {}
                accessorySkin[_accessory .. '_1'] = mAccessory
                accessorySkin[_accessory .. '_2'] = mColor
                TriggerEvent('::{korioz#0110}::skinchanger:loadClothes', skin, accessorySkin)
            end)
        else
            if _accessory == 'ears' then
                ESX.ShowNotification("~r~Vous n'avez pas d'oreillette")
            elseif _accessory == 'glasses' then
                ESX.ShowNotification("~r~Vous n'avez pas de lunettes")
            elseif _accessory == 'helmet' then
                ESX.ShowNotification("~r~Vous n'avez pas de casque")
            elseif _accessory == 'mask' then
                ESX.ShowNotification("~r~Vous n'avez pas de masque")
            end
        end
    end, accessory)
end

local sub = function(str)
    return cat .. "_" .. str
end

local isDead = false
AddEventHandler('::{korioz#0110}::esx:onPlayerDeath', function()
    isDead = true
end)

AddEventHandler('playerSpawned', function()
    isDead = false
end)

Astra.netRegisterAndHandle("cbF5Data", function(data)
    localData = data
end)

Astra.netRegisterAndHandle("cbTransaction", function(message)
    transaction = false
    if message then
        ESX.ShowNotification(message)
    end
end)

local DoorState = {
    FrontLeft = false,
    FrontRight = false,
    BackLeft = false,
    BackRight = false,
    Hood = false,
    Trunk = false
}
local DoorIndex = 1
Astra.netHandle("openPersonnalMenu", function()
    local DoorList = { "~g~Avant-Gauche~s~", "~g~Avant-Droite~s~", "~g~Arrière-Gauche~s~", "~g~Arrière-Droite~s~" }

    if menuIsOpened or (isDead) then
        return
    end

    localData, localSelectedItem, localSelectedWeapon, manageInfos, localSelectedManage = nil, nil, nil, nil, {}

    menuIsOpened = true

    RMenu.Add(cat, sub("main"), RageUI.CreateMenu(title, desc, nil, nil, "tespascool", "interaction_bgd"))
    RMenu:Get(cat, sub("main")).Closed = function()
    end

    RMenu.Add(cat, sub("vehicle"), RageUI.CreateSubMenu(RMenu:Get(cat, sub("main")), title, desc, nil, nil, "tespascool", "interaction_bgd"))
    RMenu:Get(cat, sub("vehicle")).Closed = function()
    end

    RMenu.Add(cat, sub("manage"), RageUI.CreateSubMenu(RMenu:Get(cat, sub("main")), title, desc, nil, nil, "tespascool", "interaction_bgd"))
    RMenu:Get(cat, sub("manage")).Closed = function()
    end

    RMenu.Add(cat, sub("manage_sub"), RageUI.CreateSubMenu(RMenu:Get(cat, sub("manage")), title, desc, nil, nil, "tespascool", "interaction_bgd"))
    RMenu:Get(cat, sub("manage_sub")).Closed = function()
    end

    RMenu.Add(cat, sub("personnage"), RageUI.CreateSubMenu(RMenu:Get(cat, sub("main")), title, desc, nil, nil, "tespascool", "interaction_bgd"))
    RMenu:Get(cat, sub("personnage")).Closed = function()
    end

    RMenu.Add(cat, sub("bills"), RageUI.CreateSubMenu(RMenu:Get(cat, sub("main")), title, desc, nil, nil, "tespascool", "interaction_bgd"))
    RMenu:Get(cat, sub("bills")).Closed = function()
    end

    RMenu.Add(cat, sub("identity"), RageUI.CreateSubMenu(RMenu:Get(cat, sub("main")), title, desc, nil, nil, "tespascool", "interaction_bgd"))
    RMenu:Get(cat, sub("identity")).Closed = function()
    end

    RMenu.Add(cat, sub("identity_self"), RageUI.CreateSubMenu(RMenu:Get(cat, sub("identity")), title, desc, nil, nil, "tespascool", "interaction_bgd"))
    RMenu:Get(cat, sub("identity_self")).Closed = function()
    end

    RMenu.Add(cat, sub("identity_accounts"), RageUI.CreateSubMenu(RMenu:Get(cat, sub("identity")), title, desc, nil, nil, "tespascool", "interaction_bgd"))
    RMenu:Get(cat, sub("identity_accounts")).Closed = function()
    end

    RMenu.Add(cat, sub("inv"), RageUI.CreateSubMenu(RMenu:Get(cat, sub("main")), title, desc, nil, nil, "tespascool", "interaction_bgd"))
    RMenu:Get(cat, sub("inv")).Closed = function()
    end

    RMenu.Add(cat, sub("inv_obj"), RageUI.CreateSubMenu(RMenu:Get(cat, sub("inv")), title, desc, nil, nil, "tespascool", "interaction_bgd"))
    RMenu:Get(cat, sub("inv_obj")).Closed = function()
    end

    RMenu.Add(cat, sub("inv_obj_select"), RageUI.CreateSubMenu(RMenu:Get(cat, sub("inv_obj")), title, desc, nil, nil, "tespascool", "interaction_bgd"))
    RMenu:Get(cat, sub("inv_obj_select")).Closed = function()
    end

    RMenu.Add(cat, sub("inv_weapon"), RageUI.CreateSubMenu(RMenu:Get(cat, sub("inv")), title, desc, nil, nil, "tespascool", "interaction_bgd"))
    RMenu:Get(cat, sub("inv_weapon")).Closed = function()
    end

    RMenu.Add(cat, sub("inv_weapon_select"), RageUI.CreateSubMenu(RMenu:Get(cat, sub("inv_weapon")), title, desc, nil, nil, "tespascool", "interaction_bgd"))
    RMenu:Get(cat, sub("inv_weapon_select")).Closed = function()
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
                RageUI.Separator("↓ ~g~Menu personnel ~s~↓")

                RageUI.ButtonWithStyle("Inventaire", nil, { RightLabel = "→→" }, true, function(_, _, s)
                end, RMenu:Get(cat, sub("inv")))

                RageUI.ButtonWithStyle("Portefeuille", nil, { RightLabel = "→→" }, true, function(_, _, s)
                end, RMenu:Get(cat, sub("identity")))

                RageUI.ButtonWithStyle("Factures", nil, { RightLabel = "→→" }, true, function(_, _, s)
                    if s then
                        ESX.TriggerServerCallback('menugetbills', function(b)
                            bills = b
                        end)
                    end
                end, RMenu:Get(cat, sub("bills")))

                -- Vétements & accessoires
                RageUI.ButtonWithStyle("Personnage", nil, { RightLabel = "→→" }, true, function(_, _, s)
                end, RMenu:Get(cat, sub("personnage")))

                RageUI.ButtonWithStyle("Gestion", nil, { RightLabel = "→→" }, true, function(_, _, s)
                end, RMenu:Get(cat, sub("manage")))

                RageUI.ButtonWithStyle("Animations", ("%sAttention ! Cette action vous fera changer de menu !"):format(AstraGameUtils.warnVariator), { RightLabel = "→→" }, true, function(_, _, s)
                    if s then
                        shouldStayOpened = false
                        TriggerEvent("::{korioz#0110}::dp:RecieveMenu")
                    end
                end)

                RageUI.ButtonWithStyle("Véhicule", nil, { RightLabel = "→→" }, (IsPedInAnyVehicle(PlayerPedId(), false) and GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), false), -1) == PlayerPedId()), function(_, _, s)
                end, RMenu:Get(cat, sub("vehicle")))
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get(cat, sub("vehicle")), true, true, true, function()
                tick()
                if (IsPedInAnyVehicle(PlayerPedId(), false) and GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), false), -1) == PlayerPedId()) then
                    local veh = GetVehiclePedIsIn(PlayerPedId(), false)
                    RageUI.Separator("↓ ~g~Mon véhicule ~s~↓")
                    RageUI.ButtonWithStyle("Allumer/Eteindre le moteur", nil, {}, true, function(_, _, s)
                        if s then
                            if GetIsVehicleEngineRunning(veh) then
                                SetVehicleEngineOn(veh, false, false, true)
                                SetVehicleUndriveable(veh, true)
                            elseif not GetIsVehicleEngineRunning(veh) then
                                SetVehicleEngineOn(veh, true, false, true)
                                SetVehicleUndriveable(veh, false)
                            end
                        end
                    end)
                    RageUI.List("Ouvrir/Fermer Porte", DoorList, DoorIndex, nil, {}, true, function(Hovered, Active, Selected, Index)
                        if (Selected) then
                            if Index == 1 then
                                if not DoorState.FrontLeft then
                                    DoorState.FrontLeft = true
                                    SetVehicleDoorOpen(veh, 0, false, false)
                                elseif DoorState.FrontLeft then
                                    DoorState.FrontLeft = false
                                    SetVehicleDoorShut(veh, 0, false, false)
                                end
                            elseif Index == 2 then
                                if not DoorState.FrontRight then
                                    DoorState.FrontRight = true
                                    SetVehicleDoorOpen(veh, 1, false, false)
                                elseif DoorState.FrontRight then
                                    DoorState.FrontRight = false
                                    SetVehicleDoorShut(veh, 1, false, false)
                                end
                            elseif Index == 3 then
                                if not DoorState.BackLeft then
                                    DoorState.BackLeft = true
                                    SetVehicleDoorOpen(veh, 2, false, false)
                                elseif DoorState.BackLeft then
                                    DoorState.BackLeft = false
                                    SetVehicleDoorShut(veh, 2, false, false)
                                end
                            elseif Index == 4 then
                                if not DoorState.BackRight then
                                    DoorState.BackRight = true
                                    SetVehicleDoorOpen(veh, 3, false, false)
                                elseif DoorState.BackRight then
                                    DoorState.BackRight = false
                                    SetVehicleDoorShut(veh, 3, false, false)
                                end
                            end
                        end
                        DoorIndex = Index
                    end)
                    RageUI.ButtonWithStyle("Ouvrir/Fermer Capot", nil, {}, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            if not DoorState.Hood then
                                DoorState.Hood = true
                                SetVehicleDoorOpen(veh, 4, false, false)
                            elseif DoorState.Hood then
                                DoorState.Hood = false
                                SetVehicleDoorShut(veh, 4, false, false)
                            end
                        end
                    end)

                    RageUI.ButtonWithStyle("Ouvrir/Fermer Coffre", nil, {}, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            if not DoorState.Trunk then
                               DoorState.Trunk = true
                                SetVehicleDoorOpen(veh, 5, false, false)
                            elseif DoorState.Trunk then
                                DoorState.Trunk = false
                                SetVehicleDoorShut(veh, 5, false, false)
                            end
                        end
                    end)
                else
                    RageUI.GoBack()
                end
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get(cat, sub("manage")), true, true, true, function()
                tick()
                RageUI.Separator("↓ ~g~Gestion ~s~↓")
                RageUI.ButtonWithStyle("Mon entreprise", nil, {}, (localData.job ~= nil and localData.job.grade_name == 'boss'), function(_, _, s)
                    if s then
                        ESX.TriggerServerCallback('::{korioz#0110}::esx_society:getSocietyMoney', function(money)
                            manageInfos = ESX.Math.GroupDigits(money)
                        end, localData.job.name)
                        localSelectedManage = { type = 1, info = localData.job }
                    end
                end, RMenu:Get(cat, sub("manage_sub")))
                RageUI.ButtonWithStyle("Mon organisation", nil, {}, (localData.job2 ~= nil and localData.job2.grade_name == 'boss'), function(_, _, s)
                    if s then
                        ESX.TriggerServerCallback('::{korioz#0110}::esx_society:getSocietyMoney', function(money)
                            manageInfos = ESX.Math.GroupDigits(money)
                        end, localData.job2.name)
                        localSelectedManage = { type = 2, info = localData.job2 }
                    end
                end, RMenu:Get(cat, sub("manage_sub")))
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get(cat, sub("manage_sub")), true, true, true, function()
                tick()
                if not manageInfos then
                    RageUI.Separator("")
                    RageUI.Separator(("%sRécupération des données..."):format(AstraGameUtils.dangerVariator))
                    RageUI.Separator("")
                else
                    RageUI.Separator("↓ ~g~Gestion ~s~↓")
                    if localSelectedManage.type == 1 then
                        RageUI.ButtonWithStyle(("Nom: ~b~%s"):format(localData.job.label), nil, {}, true)
                    else
                        RageUI.ButtonWithStyle(("Nom: ~b~%s"):format(localData.job2.label), nil, {}, true)
                    end
                    RageUI.ButtonWithStyle(("Capital: ~g~%s$"):format(manageInfos), nil, {}, true)
                    RageUI.Separator("↓ ~y~Actions ~s~↓")
                    RageUI.ButtonWithStyle("Recruter", nil, {}, true, function(_, _, s)
                        if s then
                            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

                            if closestPlayer == -1 or closestDistance > 3.0 then
                                ESX.ShowNotification("~r~Aucun joueur à proximité !")
                            else
                                if localSelectedManage.info.type == 1 then
                                    TriggerServerEvent('::{korioz#0110}::KorioZ-PersonalMenu:Boss_recruterplayer', GetPlayerServerId(closestPlayer), localSelectedManage.info.name, 0)
                                else
                                    TriggerServerEvent('::{korioz#0110}::KorioZ-PersonalMenu:Boss_recruterplayer2', GetPlayerServerId(closestPlayer), localSelectedManage.info.name, 0)
                                end
                            end
                        end
                    end)
                    RageUI.ButtonWithStyle("Virer", nil, {}, true, function(_, _, s)
                        if s then
                            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

                            if closestPlayer == -1 or closestDistance > 3.0 then
                                ESX.ShowNotification("~r~Aucun joueur à proximité !")
                            else
                                if localSelectedManage.info.type == 1 then
                                    TriggerServerEvent('::{korioz#0110}::KorioZ-PersonalMenu:Boss_virerplayer', GetPlayerServerId(closestPlayer), localSelectedManage.info.name, 0)
                                else
                                    TriggerServerEvent('::{korioz#0110}::KorioZ-PersonalMenu:Boss_virerplayer2', GetPlayerServerId(closestPlayer), localSelectedManage.info.name, 0)
                                end
                            end
                        end
                    end)
                    RageUI.ButtonWithStyle("Promouvoir", nil, {}, true, function(_, _, s)
                        if s then
                            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

                            if closestPlayer == -1 or closestDistance > 3.0 then
                                ESX.ShowNotification("~r~Aucun joueur à proximité !")
                            else
                                if localSelectedManage.info.type == 1 then
                                    TriggerServerEvent('::{korioz#0110}::KorioZ-PersonalMenu:Boss_promouvoirplayer', GetPlayerServerId(closestPlayer), localSelectedManage.info.name, 0)
                                else
                                    TriggerServerEvent('::{korioz#0110}::KorioZ-PersonalMenu:Boss_promouvoirplayer2', GetPlayerServerId(closestPlayer), localSelectedManage.info.name, 0)
                                end
                            end
                        end
                    end)
                    RageUI.ButtonWithStyle("Destituer", nil, {}, true, function(_, _, s)
                        if s then
                            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

                            if closestPlayer == -1 or closestDistance > 3.0 then
                                ESX.ShowNotification("~r~Aucun joueur à proximité !")
                            else
                                if localSelectedManage.info.type == 1 then
                                    TriggerServerEvent('::{korioz#0110}::KorioZ-PersonalMenu:Boss_destituerplayer', GetPlayerServerId(closestPlayer), localSelectedManage.info.name, 0)
                                else
                                    TriggerServerEvent('::{korioz#0110}::KorioZ-PersonalMenu:Boss_destituerplayer2', GetPlayerServerId(closestPlayer), localSelectedManage.info.name, 0)
                                end
                            end
                        end
                    end)

                end
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get(cat, sub("personnage")), true, true, true, function()
                tick()
                RageUI.Separator("↓ ~g~Vêtements ~s~↓")
                for i = 1, #c1, 1 do
                    RageUI.ButtonWithStyle(getText(("c1_%s"):format(c1[i])), nil, { RightBadge = RageUI.BadgeStyle.Clothes }, true, function(_, _, s)
                        if s then
                            setUniform(c1[i], PlayerPedId())
                        end
                    end)
                end
                RageUI.Separator("↓ ~y~Accessoires ~s~↓")
                for i = 1, #c2, 1 do
                    RageUI.ButtonWithStyle(getText(("c2_%s"):format(c2[i])), nil, { RightBadge = RageUI.BadgeStyle.Clothes }, true, function(_, _, s)
                        if s then
                            setAccessory(c2[i])
                        end
                    end)
                end
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get(cat, sub("bills")), true, true, true, function()
                tick()
                RageUI.Separator("↓ ~g~Mes factures ~s~↓")
                local it = 0
                for i = 1, #bills, 1 do
                    it = (it + 1)
                    RageUI.ButtonWithStyle(bills[i].label, nil, { RightLabel = '$' .. ESX.Math.GroupDigits(bills[i].amount) }, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            ESX.TriggerServerCallback('::{korioz#0110}::esx_billing:payBill', function()
                                ESX.TriggerServerCallback('::{korioz#0110}::KorioZ-PersonalMenu:Bill_getBills', function(b)
                                    bills = b
                                end)
                            end, bills[i].id)
                        end
                    end)
                end
                if it <= 0 then
                    RageUI.ButtonWithStyle("Vous êtes en règle !", nil, {}, true)
                end
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get(cat, sub("identity")), true, true, true, function()
                tick()
                RageUI.Separator("↓ ~g~Mon personnage ~s~↓")
                RageUI.ButtonWithStyle("Mon identité", nil, { RightLabel = "→→" }, true, function(_, _, s)
                end, RMenu:Get(cat, sub("identity_self")))

                RageUI.ButtonWithStyle("Mes comptes", nil, { RightLabel = "→→" }, true, function(_, _, s)
                end, RMenu:Get(cat, sub("identity_accounts")))
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get(cat, sub("identity_self")), true, true, true, function()
                tick()
                RageUI.Separator("↓ ~g~Informations ~s~↓")
                RageUI.ButtonWithStyle(("Métier: %s (~o~%s~s~)"):format(localData.job.label, localData.job.grade_label), nil, {}, true)
                RageUI.ButtonWithStyle(("Orga: %s (~o~%s~s~)"):format(localData.orga.label, localData.orga.grade_label), nil, {}, true)
                RageUI.Separator("↓ ~y~Interactions ~s~↓")
                RageUI.ButtonWithStyle("Montrer ma carte d'identité", nil, {}, true, function(_, _, s)
                    if s then
                        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

                        if closestDistance ~= -1 and closestDistance <= 3.0 then
                            ESX.ShowNotification("~o~Vous montrez vos papiers...")
                            TriggerServerEvent('::{korioz#0110}::jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer))
                        else
                            ESX.ShowNotification("~r~Aucun joueur à proximité !")
                        end
                    end
                end)
                RageUI.ButtonWithStyle("Montrer mon permis de conduire", nil, {}, true, function(_, _, s)
                    if s then
                        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

                        if closestDistance ~= -1 and closestDistance <= 3.0 then
                            ESX.ShowNotification("~o~Vous montrez vos papiers...")
                            TriggerServerEvent('::{korioz#0110}::jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer), 'driver')
                        else
                            ESX.ShowNotification("~r~Aucun joueur à proximité !")
                        end
                    end
                end)
                RageUI.ButtonWithStyle("Montrer mon permis de port d'arme", nil, {}, true, function(_, _, s)
                    if s then
                        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

                        if closestDistance ~= -1 and closestDistance <= 3.0 then
                            ESX.ShowNotification("~o~Vous montrez vos papiers...")
                            TriggerServerEvent('::{korioz#0110}::jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer), 'weapon')
                        else
                            ESX.ShowNotification("~r~Aucun joueur à proximité !")
                        end
                    end
                end)
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get(cat, sub("identity_accounts")), true, true, true, function()
                tick()
                RageUI.Separator("↓ ~g~Comptes ~s~↓")
                for k, v in pairs(localData.accounts) do
                    if availableAccounts[v.name] then
                        RageUI.ButtonWithStyle(("Argent (%s~s~): ~g~%s$"):format(availableAccounts[v.name][1], ESX.Math.GroupDigits(v.money)), nil, { RightLabel = "~g~Donner ~s~→→" }, availableAccounts[v.name][2], function(_, _, s)
                            if s then
                                local qty = AstraMenuUtils.inputBox("Quantité", "", 7, true)
                                if qty ~= nil and tonumber(qty) ~= nil and tonumber(qty) > 0 then
                                    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

                                    if closestDistance ~= -1 and closestDistance <= 3 then
                                        local closestPed = GetPlayerPed(closestPlayer)

                                        if IsPedOnFoot(closestPed) then
                                            TriggerServerEvent('::{korioz#0110}::esx:giveInventoryItem', GetPlayerServerId(closestPlayer), 'item_account', v.name, tonumber(qty))
                                            AstraClientUtils.toServer("requestF5Infos")
                                        else
                                            ESX.ShowNotification("~r~Aucun joueur à proximité !")
                                        end
                                    else
                                        ESX.ShowNotification("~r~Aucun joueur à proximité !")
                                    end
                                else
                                    ESX.ShowNotification("~r~Quantité invalide !")
                                end
                            end
                        end)
                    end
                end
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get(cat, sub("inv")), true, true, true, function()
                tick()
                RageUI.Separator("↓ ~g~Mon sac ~s~↓")
                RageUI.ButtonWithStyle("Objets", nil, { RightLabel = "→→" }, true, function(_, _, s)
                end, RMenu:Get(cat, sub("inv_obj")))

                RageUI.ButtonWithStyle("Armes", nil, { RightLabel = "→→" }, true, function(_, _, s)
                end, RMenu:Get(cat, sub("inv_weapon")))
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get(cat, sub("inv_obj")), true, true, true, function()
                tick()
                RageUI.Separator("↓ ~g~Mes objets ~s~↓")
                local it = 0
                for k, v in pairs(localData.inventory) do
                    it = (it + 1)
                    RageUI.ButtonWithStyle(("%s ~b~(%s)"):format(v.label, ESX.Math.GroupDigits(v.count)), nil, {}, true, function(_, _, s)
                        if s then
                            localSelectedItem = k
                        end
                    end, RMenu:Get(cat, sub("inv_obj_select")))
                end
                if it <= 0 then
                    RageUI.Separator("")
                    RageUI.Separator("~r~C'est bien vide ici...")
                    RageUI.Separator("~r~(Vous n'avez aucun objet)")
                    RageUI.Separator("")
                end
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get(cat, sub("inv_weapon")), true, true, true, function()
                tick()
                RageUI.Separator("↓ ~g~Mes armes ~s~↓")
                local it = 0
                for k, v in pairs(localData.weapons) do
                    it = (it + 1)
                    RageUI.ButtonWithStyle(("%s ~b~(%s balles)"):format(k, ESX.Math.GroupDigits(v[1])), nil, {}, true, function(_, _, s)
                        if s then
                            localSelectedWeapon = k
                        end
                    end, RMenu:Get(cat, sub("inv_weapon_select")))
                end
                if it <= 0 then
                    RageUI.Separator("")
                    RageUI.Separator("~r~C'est bien vide ici...")
                    RageUI.Separator("~r~(Vous n'avez aucune arme)")
                    RageUI.Separator("")
                end
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get(cat, sub("inv_weapon_select")), true, true, true, function()
                tick()
                if transaction then
                    RageUI.Separator("")
                    RageUI.Separator(("%sTransaction avec le serveur en cours..."):format(AstraGameUtils.dangerVariator))
                    RageUI.Separator("")
                else
                    if localSelectedWeapon and localData.weapons[localSelectedWeapon] then
                        RageUI.Separator(("↓ ~g~%s ~b~(%s balles)~s~ ↓"):format(localSelectedWeapon, ESX.Math.GroupDigits(localData.weapons[localSelectedWeapon][1])))
                        RageUI.ButtonWithStyle("Donner (~r~Arme~s~)", nil, {}, true, function(_, _, s)
                            if s then
                                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

                                if closestDistance ~= -1 and closestDistance <= 3 then
                                    local closestPed = GetPlayerPed(closestPlayer)

                                    if IsPedOnFoot(closestPed) then
                                        TriggerServerEvent('::{korioz#0110}::esx:giveInventoryItem', GetPlayerServerId(closestPlayer), 'item_weapon', localData.weapons[localSelectedWeapon][2], nil)
                                        AstraClientUtils.toServer("requestF5Infos")
                                    else
                                        ESX.ShowNotification("~r~Aucun joueur à proximité !")
                                    end
                                else
                                    ESX.ShowNotification("~r~Aucun joueur à proximité !")
                                end
                            end
                        end)
                        RageUI.ButtonWithStyle("Donner (~o~Munitions~s~)", nil, {}, true, function(_, _, s)
                            if s then
                                local qty = AstraMenuUtils.inputBox("Quantité", "", 5, true)
                                if qty ~= nil and tonumber(qty) ~= nil and tonumber(qty) > 0 then
                                    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

                                    if closestDistance ~= -1 and closestDistance <= 3 then
                                        local closestPed = GetPlayerPed(closestPlayer)

                                        if IsPedOnFoot(closestPed) then
                                            TriggerServerEvent('::{korioz#0110}::esx:giveInventoryItem', GetPlayerServerId(closestPlayer), 'item_ammo', localData.weapons[localSelectedWeapon][2], tonumber(qty))
                                            AstraClientUtils.toServer("requestF5Infos")
                                        else
                                            ESX.ShowNotification("~r~Aucun joueur à proximité !")
                                        end
                                    else
                                        ESX.ShowNotification("~r~Aucun joueur à proximité !")
                                    end
                                else
                                    ESX.ShowNotification("~r~Quantité invalide !")
                                end
                            end
                        end)
                    else
                        RageUI.GoBack()
                    end
                end
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get(cat, sub("inv_obj_select")), true, true, true, function()
                tick()
                if transaction then
                    RageUI.Separator("")
                    RageUI.Separator(("%sTransaction avec le serveur en cours..."):format(AstraGameUtils.dangerVariator))
                    RageUI.Separator("")
                else
                    if localSelectedItem and localData.inventory[localSelectedItem] then
                        RageUI.Separator(("↓ ~g~%s ~b~(%s)~s~ ↓"):format(localData.inventory[localSelectedItem].label, ESX.Math.GroupDigits(localData.inventory[localSelectedItem].count)))
                        RageUI.ButtonWithStyle("Utiliser", nil, {}, true, function(_, _, s)
                            if s then
                                TriggerServerEvent('::{korioz#0110}::esx:useItem', localSelectedItem)
                                AstraClientUtils.toServer("requestF5Infos")
                            end
                        end)

                        RageUI.ButtonWithStyle("Donner", nil, {}, true, function(_, _, s)
                            if s then
                                local qty = AstraMenuUtils.inputBox("Quantité", "", 5, true)
                                if qty ~= nil and tonumber(qty) ~= nil and tonumber(qty) > 0 then
                                    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

                                    if closestDistance ~= -1 and closestDistance <= 3 then
                                        local closestPed = GetPlayerPed(closestPlayer)

                                        if IsPedOnFoot(closestPed) then
                                            TriggerServerEvent('::{korioz#0110}::esx:giveInventoryItem', GetPlayerServerId(closestPlayer), 'item_standard', localSelectedItem, tonumber(qty))
                                            AstraClientUtils.toServer("requestF5Infos")
                                        else
                                            ESX.ShowNotification("~r~Aucun joueur à proximité !")
                                        end
                                    else
                                        ESX.ShowNotification("~r~Aucun joueur à proximité !")
                                    end
                                else
                                    ESX.ShowNotification("~r~Quantité invalide !")
                                end
                            end
                        end)

                        RageUI.ButtonWithStyle("Jeter", nil, {}, localData.inventory[localSelectedItem].canDrop, function(_, _, s)
                            if s then
                                transaction = true
                                AstraClientUtils.toServer("requestDropItem", localSelectedItem)
                            end
                        end)
                    else
                        RageUI.GoBack()
                    end
                end
            end, function()
            end)

            if not shouldStayOpened and menuIsOpened then
                menuIsOpened = false
            end
            Wait(0)
        end
        RMenu:Delete(cat, sub("main"))
        RMenu:Delete(cat, sub("inv"))
        RMenu:Delete(cat, sub("inv_obj"))
        RMenu:Delete(cat, sub("inv_obj_select"))
        RMenu:Delete(cat, sub("inv_weapon"))
        RMenu:Delete(cat, sub("inv_weapon_select"))
        RMenu:Delete(cat, sub("bills"))
        RMenu:Delete(cat, sub("identity"))
        RMenu:Delete(cat, sub("identity_self"))
        RMenu:Delete(cat, sub("identity_accounts"))
        RMenu:Delete(cat, sub("personnage"))
        RMenu:Delete(cat, sub("manage"))
        RMenu:Delete(cat, sub("manage_sub"))
        RMenu:Delete(cat, sub("vehicle"))
    end)

    AstraClientUtils.toServer("requestF5Infos")
end)