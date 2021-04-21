---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Astra RolePlay.
  
  File [main] created at [21/04/2021 14:59]

  Copyright (c) Astra RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

local cat, desc = "locationvehicle", "~y~Location - Astra RolePlay"
local isWaitingServerResponse = false
local antiCanceller = false
local spawnHeading = 245.0
local availableSpawns = {
    vector3(-797.78271484375, -115.54744720459, 37.462551116943),
    vector3(-801.77978515625, -117.78839874268, 37.467105865479),
    vector3(-805.42761230469, -119.87323760986, 37.488952636719),
    vector3(-809.13006591797, -122.10496520996, 37.514785766602),
    vector3(-813.09875488281, -124.04654693604, 37.515056610107),
    vector3(-817.31896972656, -126.1947479248, 37.511924743652),
    vector3(-821.43371582031, -128.29609680176, 37.507671356201),
    vector3(-825.65600585938, -130.35119628906, 37.492588043213),
    vector3(-828.89752197266, -132.65342712402, 37.533657073975),
    vector3(-832.91027832031, -134.79016113281, 37.542789459229),
    vector3(-836.40002441406, -137.00712585449, 37.602336883545),
    vector3(-840.60955810547, -139.01634216309, 37.654891967773),
}
local sub = function(str)
    return cat .. "_" .. str
end

Astra.netRegisterAndHandle("locationCb", function(model)
    if model then
        AstraClientUtils.toServer("setOnPublicBucket")
        Citizen.SetTimeout(1000, function()
            model = GetHashKey(model)
            local vehicle = CreateVehicle(model, availableSpawns[math.random(1,#availableSpawns)], spawnHeading, true, false)
            SetVehicleEngineOn(vehicle, 1, 1, 0)
            SetVehicleCustomPrimaryColour(vehicle, 33,33,33)
            SetVehicleCustomSecondaryColour(vehicle, 33,33,33)
            TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
        end)
    end
    isWaitingServerResponse = false
end)

Astra.netRegisterAndHandle("locationOpenMenu", function(available, accounts)
    if menuIsOpened then
        return
    end

    if isWaitingServerResponse then
        ESX.ShowNotification("~r~Une transaction est encore en cours avec le serveur...")
        return
    end

    if antiCanceller then
        return
    end

    local isLocationLoaded = false
    local selectedCarId = nil
    FreezeEntityPosition(PlayerPedId(), true)
    menuIsOpened = true
    AstraClientUtils.toServer("genPlayerBucket")

    RMenu.Add(cat, sub("main"), RageUI.CreateMenu("Location", desc, nil, nil, "tespascool", "interaction_bgd"))
    RMenu:Get(cat, sub("main")).Closable = false
    RMenu:Get(cat, sub("main")).Closed = function()
    end

    RMenu.Add(cat, sub("pay"), RageUI.CreateSubMenu(RMenu:Get(cat, sub("main")), "Location", desc, nil, nil, "tespascool", "interaction_bgd"))
    RMenu:Get(cat, sub("pay")).Closed = function()
    end

    RageUI.Visible(RMenu:Get(cat, sub("main")), true)
    local cam, previewVeh
    Astra.newThread(function()
        for k,v in pairs(available) do
            local model = GetHashKey(v.model)
            RequestModel(model)
            while not HasModelLoaded(model) do Wait(1) end
        end
        cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 0)
        SetCamCoord(cam, -821.81, -114.63, 40.47)
        PointCamAtCoord(cam, -816.26, -112.45, 37.58)
        SetCamActive(cam, true)
        RenderScriptCams(1, 1500, 1500, 1)
        PointCamAtCoord(cam, -816.26, -112.45, 37.58)
        Astra.newWaitingThread(1500, function()
            previewVeh = CreateVehicle(available[1].model, -816.26, -112.45, 37.58, 90.0, false, false)
            SetVehicleCustomPrimaryColour(previewVeh, 33,33,33)
            SetVehicleCustomSecondaryColour(previewVeh, 33,33,33)
            SetVehicleEngineOn(previewVeh, 1, 1, 0)
            SetEntityAlpha(previewVeh,200)
            SetVehicleUndriveable(previewVeh, true)
            FreezeEntityPosition(previewVeh, true)
            isLocationLoaded = true
            RMenu:Get(cat, sub("main")).Closable = true
        end)
    end)
    Astra.newThread(function()
        while menuIsOpened do
            if isLocationLoaded and previewVeh ~= nil then
                SetEntityHeading(previewVeh, GetEntityHeading(previewVeh)+0.5)
            end
            Wait(1)
        end
    end)

    Astra.newThread(function()
        while menuIsOpened do
            local shouldStayOpened = false
            local function tick()
                shouldStayOpened = true
            end
            RageUI.IsVisible(RMenu:Get(cat, sub("main")), true, true, true, function()
                tick()
                if isLocationLoaded then
                    RageUI.Separator("↓ ~y~Véhicules disponibles ~s~↓")
                    for id, v in pairs(available) do
                        RageUI.ButtonWithStyle(("→ ~b~%s"):format(v.label), "Appuyez pour louer ce véhicule", { RightLabel = ("~g~%s$ ~s~→→"):format(ESX.Math.GroupDigits(v.price)) }, accounts[1] >= v.price or accounts[2] >= v.price, function(_, a, s)
                            if a then
                                if GetEntityModel(previewVeh) ~= GetHashKey(v.model) then
                                    DeleteEntity(previewVeh)
                                    previewVeh = CreateVehicle(GetHashKey(v.model), -816.26, -112.45, 37.58, 90.0, false, false)
                                    SetVehicleCustomPrimaryColour(previewVeh, 33,33,33)
                                    SetVehicleCustomSecondaryColour(previewVeh, 33,33,33)
                                    SetVehicleEngineOn(previewVeh, 1, 1, 0)
                                    SetEntityAlpha(previewVeh,200)
                                    SetVehicleUndriveable(previewVeh, true)
                                    FreezeEntityPosition(previewVeh, true)
                                end
                            end
                            if s then
                                selectedCarId = id
                            end
                        end, RMenu:Get(cat, sub("pay")))
                    end
                else
                    RageUI.Separator("")
                    RageUI.Separator(("%sChargement..."):format(AstraGameUtils.warnVariator))
                    RageUI.Separator("")
                end
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get(cat, sub("pay")), true, true, true, function()
                tick()
                RageUI.Separator("↓ ~y~Sélectionnez un moyen de paiement ~s~↓")
                RageUI.ButtonWithStyle("→ Payer en ~b~liquide", nil, {}, accounts[1] >= available[selectedCarId].price and not isWaitingServerResponse, function(_, _, s)
                    if s then
                        shouldStayOpened = false
                        isWaitingServerResponse = true
                        AstraClientUtils.toServer("locationPayCar", selectedCarId, 1)
                    end
                end)
                RageUI.ButtonWithStyle("→ Payer en ~y~banque", nil, {}, accounts[2] >= available[selectedCarId].price and not isWaitingServerResponse, function(_, _, s)
                    if s then
                        shouldStayOpened = false
                        isWaitingServerResponse = true
                        AstraClientUtils.toServer("locationPayCar", selectedCarId, 2)
                    end
                end)

            end, function()
            end)

            if not shouldStayOpened and menuIsOpened then
                menuIsOpened = false
            end
            Wait(0)
        end
        RMenu:Delete(cat, sub("main"))
        RMenu:Delete(cat, sub("pay"))
        antiCanceller = true
        RenderScriptCams(0, 1500,1500,0)
        Astra.newWaitingThread(1500, function()
            AstraClientUtils.toServer("setOnPublicBucket")
            FreezeEntityPosition(PlayerPedId(), false)
            antiCanceller = false
        end)
        if previewVeh ~= nil then
            DeleteEntity(previewVeh)
        end
        SetCamActive(cam, false)
    end)
end)