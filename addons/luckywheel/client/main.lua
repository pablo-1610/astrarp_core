---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Astra RolePlay.
  
  File [main] created at [21/04/2021 21:01]

  Copyright (c) Astra RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

local tb = {}
local baseCoords = 29.8
local groundCoords = 29.392116928101

currentTurn, isRolling = false, false

local roue, base, triangle, socle, veh, areEntityCreated = nil,nil,nil,nil,false
local currentVehicleRewardModel = nil

local additionalProps = {
    {model = "prop_worklight_03b", coords = vector3(229.25726318359, -883.73864746094, groundCoords), angle = 210.42},
    {model = "prop_worklight_03b", coords = vector3(219.62939453125, -880.71154785156, groundCoords), angle = 118.00},
    {model = "prop_table_03", coords = vector3(219.10478210449, -869.10400390625, 29.50), angle = 70.0},
    {model = "prop_beach_parasol_04", coords = vector3(217.58087158203, -870.22796630859, 29.50), angle = 70.0},
    {model = "prop_direct_chair_01", coords = vector3(217.41264343262, -868.03826904297, 29.50), angle = 90.0},
    {model = "prop_streetlight_12b", coords = vector3(215.29782104492, -870.73107910156, 29.40), angle = 160.5},
    {model = "prop_air_lights_02a", coords = vector3(232.35372924805, -878.88604736328, 29.40), angle = 50.0},
    {model = "prop_air_lights_02a", coords = vector3(236.97882080078, -880.50720214844, 29.40), angle = 50.0},
    {model = "prop_beer_bottle", coords = vector3(219.44566345215, -868.75756835938, 30.3), angle = 60.0},
    {model = "prop_speaker_07", coords = vector3(217.79971313477, -872.81170654297,29.40), angle = 118.0},
    {model = "stt_prop_speakerstack_01a", coords = vector3(218.15144348145, -873.60705566406, 29.40), angle = 118.0}
}

local function startSpin()
    Astra.newThread(function()
        local pos = 7
        SetEntityRotation(roue, 0, 0, 160.0, false, true);

        local deg = 0.0;
        local inc = 1;

        -- First step, increment speed
        for i = 1,200 do
            SetEntityRotation(roue, 0, -deg, 160.0, false, true);
            deg = deg + inc;

            if inc < 4 then
                inc = inc + 0.2;
            end

            Citizen.Wait(5);
        end

        while math.ceil((deg - ((inc / 0.01) / 2) % 360 - pos) % 360) >= 5 do
            SetEntityRotation(roue, 0, -deg, 160.0, false, true);
            deg = deg + inc;
            Citizen.Wait(5);
        end

        AstraClientUtils.toServer("luckywheelRequestFinalPrice", ESX.Game.GetVehicleProperties(veh))
        --Citizen.Wait(5000);
        isRolling = false;
    end)
end

local function removeAllWheelShits()
    DeleteEntity(triangle)
    triangle = nil
    DeleteEntity(base)
    base = nil
    DeleteEntity(socle)
    socle = nil
    DeleteEntity(veh)
    veh = nil
    DeleteEntity(roue)
    roue = nil
    for k,v in pairs(additionalProps) do
        if v.entity ~= nil then
            DeleteEntity(v.entity)
            additionalProps[k].entity = nil
        end
    end
    areEntityCreated = false
end

local function createAllWheelShits()
    -- Roue
    local model = GetHashKey('vw_prop_vw_luckywheel_02a')
    RequestModel(model)
    while not HasModelLoaded(model) do Wait(1) end
    roue = CreateObject(model, vector3(234.31323242188, -880.28216552734, (baseCoords)), false, false)
    -- Base
    model = GetHashKey("vw_prop_vw_luckywheel_01a")
    RequestModel(model)
    while not HasModelLoaded(model) do Wait(1) end
    base = CreateObject(model, vector3(234.31323242188, -880.28216552734, (baseCoords-0.3)), false, false)
    -- Triangle
    model = GetHashKey("vw_prop_vw_jackpot_on")
    RequestModel(model)
    while not HasModelLoaded(model) do Wait(1) end
    triangle = CreateObject(model, vector3(234.31323242188, -880.28216552734, (baseCoords+2.5)), false, false)
    -- Socle
    model = GetHashKey("vw_prop_vw_casino_podium_01a")
    RequestModel(model)
    while not HasModelLoaded(model) do Wait(1) end
    socle = CreateObject(model, vector3(226.07943725586, -877.56732177734, 29.392116928101), false, false)
    SetEntityRotation(roue, GetEntityPitch(roue), GetEntityRoll(roue), 160.0, 3, 1)
    SetEntityRotation(base, GetEntityPitch(base), GetEntityRoll(base), 160.0, 3, 1)
    SetEntityRotation(triangle, GetEntityPitch(triangle), GetEntityRoll(triangle), 160.0, 3, 1)
    -- Véhicule
    model = GetHashKey(currentVehicleRewardModel)
    RequestModel(model)
    while not HasModelLoaded(model) do Wait(1) end
    veh = CreateVehicle(model, vector3(226.07943725586, -877.56732177734, 29.592116928101), 90.0, false, false)
    FreezeEntityPosition(veh, true)
    SetVehicleDoorsLocked(veh, 2)
    SetEntityInvincible(veh, true)
    SetVehicleFixed(veh)
    SetVehicleDirtLevel(veh, 0.0)
    SetVehicleEngineOn(veh, true, true, true)
    SetVehicleLights(veh, 2)
    SetVehicleCustomPrimaryColour(veh, 33,33,33)
    SetVehicleCustomSecondaryColour(veh, 33,33,33)
    for k,v in pairs(additionalProps) do
        model = GetHashKey(v.model)
        RequestModel(model)
        while not HasModelLoaded(model) do Wait(1) end
        local prop = CreateObject(model, v.coords, false, false)
        FreezeEntityPosition(prop, true)
        SetEntityRotation(prop, GetEntityPitch(prop), GetEntityRoll(prop), v.angle, 3, 1)
        additionalProps[k].entity = prop
    end
    areEntityCreated = true
end

Astra.netRegisterAndHandle("luckywheelCbCurrentVehicle", function(vehicle)
    currentVehicleRewardModel = vehicle
end)

Astra.netRegisterAndHandle("luckywheelVehicleChange", function(vehicle)
    currentVehicleRewardModel = vehicle
    removeAllWheelShits()
end)

Astra.netHandle("luckywheelCbTurn", function()
    currentTurn = true
end)

Astra.netHandle("esxloaded", function()
    AstraClientUtils.toServer("luckywheelRequestCurrentVehicle")
    while currentVehicleRewardModel == nil do Wait(1) end
    Astra.newThread(function()
        local rot = 1.0
        while true do
            local interval = 1
            if areEntityCreated and socle ~= nil and veh ~= nil then
                rot = rot - 0.15
                SetEntityRotation(socle, GetEntityPitch(socle), GetEntityRoll(socle), rot, 3, 1)
                SetEntityHeading(veh, rot)
            else
                interval = 500
            end
            Wait(interval)
        end
    end)
    Astra.newThread(function()
        local basePos = vector3(236.00059509277, -880.18023681641, 30.492071151733)
        while true do
            local interval = 500
            local pos = GetEntityCoords(PlayerPedId())
            local dist = #(pos - basePos)
            if areEntityCreated then
                if dist > 150.0 then
                    removeAllWheelShits()
                else
                    interval = 1
                    if dist <= 1.0 and not isRolling then
                        if not currentTurn then
                            AddTextEntry("AstraRoue", "Vous n'avez pas la permission de faire tourner la roue ! Allez vous renseigner auprès du vendeur de tickets.")
                        else
                            AddTextEntry("AstraRoue", "Appuyez sur ~INPUT_CONTEXT~ pour faire tourner la roue")
                            if IsControlJustPressed(0, 51) then
                                currentTurn = false
                                isRolling = true
                                -- @TODO -> Faire tourner la roue
                                local playerPed = PlayerPedId()
                                local _lib = 'anim_casino_a@amb@casino@games@lucky7wheel@female'
                                if IsPedMale(playerPed) then
                                    _lib = 'anim_casino_a@amb@casino@games@lucky7wheel@male'
                                end
                                local lib, anim = _lib, 'enter_right_to_baseidle'
                                ESX.Streaming.RequestAnimDict(lib, function()
                                    TaskGoStraightToCoord(playerPed,  basePos.x, basePos.y, (baseCoords),  1.0,  -1,  107.2,  0.0)
                                    local hasMoved = false
                                    while not hasMoved do
                                        local coords = GetEntityCoords(PlayerPedId())
                                        if coords.x >= (basePos.x - 0.01) and coords.x <= (basePos.x + 0.01) and coords.y >= (basePos.y - 0.01) and coords.y <= (basePos.y + 0.01) then
                                            hasMoved = true
                                        end
                                        Citizen.Wait(0)
                                    end
                                    TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
                                    TaskPlayAnim(playerPed, lib, 'armraisedidle_to_spinningidle_high', 8.0, -8.0, -1, 0, 0, false, false, false)
                                    startSpin()
                                end)


                            end
                        end
                        DisplayHelpTextThisFrame("AstraRoue", 0)
                    end
                end
            else
                if dist < 150.0 then
                    createAllWheelShits()
                end
            end
            Wait(interval)
        end
    end)
end)

-- @TODO -> A enlever
RegisterCommand("bite", function()
    DeleteEntity(triangle)
    DeleteEntity(base)
    DeleteEntity(socle)
    DeleteEntity(veh)
    DeleteEntity(roue)
    for k,v in pairs(additionalProps) do
        if v.entity ~= nil then
            DeleteEntity(v.entity)
            additionalProps[k].entity = nil
        end
    end
end)

