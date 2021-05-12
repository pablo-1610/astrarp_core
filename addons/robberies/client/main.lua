---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Astra RolePlay.
  
  File [main] created at [11/05/2021 20:35]

  Copyright (c) Astra RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

local currentlyRobbing, objects, blips, bag, bagValue, population, displayingObjectInfos = false, {}, {}, {}, 0, {}, false

local specialAdditionalTasks = {
    [1] = function(ped)
        if GetEntityModel(ped) == GetHashKey("mp_m_securoguard_01") then
            SetPedAccuracy(ped, 35)
            SetPedCombatMovement(ped, 1)
            GiveWeaponComponentToPed(ped, GetHashKey('WEAPON_HEAVYPISTOL'), GetHashKey('COMPONENT_AT_PI_FLSH'))
            GiveWeaponComponentToPed(ped, GetHashKey('WEAPON_HEAVYPISTOL'), GetHashKey('COMPONENT_AT_PI_SUPP'))
        end

        if GetEntityModel(ped) == GetHashKey("s_m_m_armoured_01") then
            SetPedArmour(ped, 200)
            --SetPedCombatMovement(ped, 3)
            SetPedAccuracy(ped, 20)
        end

        if GetEntityModel(ped) == GetHashKey("u_m_y_juggernaut_01") then
            SetPedArmour(ped, 200)
            SetPedMaxHealth(ped, 800)
            SetEntityHealth(ped, GetEntityMaxHealth(ped))
            SetPedCombatMovement(ped, 3)
            SetPedAccuracy(ped, 8)
        end
    end
}

local function initParallelThread()
    Astra.newThread(function()
        while currentlyRobbing do
            for k, v in pairs(population) do
                if DoesEntityExist(v) and not IsPedDeadOrDying(v, 1) then
                    PlayAmbientSpeech1(v, "GENERIC_INSULT_HIGH", "SPEECH_PARAMS_FORCE_NORMAL_CLEAR", 0)
                end
            end
            if IsPedDeadOrDying(PlayerPedId(), 1) then
                currentlyRobbing = false
                AstraClientUtils.toServer("robberiesDiedDuring")
                Wait(3500)
                TriggerEvent("::{korioz#0110}::esx_ambulancejob:revive")
                ESX.ShowNotification("~r~Vous avez échoué, vous ne gagnez rien !")
            end
            Wait(4500)
        end
    end)
    Astra.newThread(function()
        while currentlyRobbing do
            if not displayingObjectInfos then
                local a = 0
                for k, v in pairs(objects) do
                    a = a + 1
                end
                AddTextEntry("TIMER", ("Cambriolage en cours:~n~~o~Objets~s~: ~o~%s ~s~restants ~s~[~g~%s$~s~]"):format(a, bagValue))
                DisplayHelpTextThisFrame("TIMER", 0)
            end
            Wait(0)
        end
    end)
    Astra.newThread(function()
        local interval = 0
        while currentlyRobbing do
            local pos = GetEntityCoords(PlayerPedId())
            displayingObjectInfos = false
            for id, objectInfos in pairs(objects) do
                local co = vector3(objectInfos.coords.x, objectInfos.coords.y, ((objectInfos.coords.z - 0.15) + objectInfos.additionalZ))
                DrawMarker(22, co, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.35, 0.35, 0.35, 255, 153, 0, 255, 55555, false, true, 2, false, false, false, false)
                local dist = #(pos - objectInfos.coords)
                if dist <= objectInfos.iter then
                    displayingObjectInfos = true
                    AddTextEntry("HELP", ("Appuyez sur ~INPUT_CONTEXT~ pour ramasser cet objet~n~~n~~y~Objet~s~: %s~n~~o~Quantité~s~: %s~n~~g~Valeur~s~: %s~g~$~n~~p~Ramassage~s~: %s~p~s"):format(objectInfos.name, objectInfos.count, objectInfos.price, (objectInfos.timeToTake / 1000)))
                    DisplayHelpTextThisFrame("HELP", 0)
                    if IsControlJustPressed(0, 51) then
                        FreezeEntityPosition(PlayerPedId(), true)
                        TaskStartScenarioInPlace(PlayerPedId(), "CODE_HUMAN_MEDIC_TEND_TO_DEAD", -1, true)
                        Astra.newWaitingThread(objectInfos.timeToTake, function()
                            FreezeEntityPosition(PlayerPedId(), false)
                            ClearPedTasksImmediately(PlayerPedId())
                            table.insert(bag, { order = #bag, infos = objectInfos })
                            --@TODO -> Respecter la valeur order pour faire un recap après le cambriolage
                            AstraClientUtils.toServer("robberiesAddItem", objectInfos)
                            bagValue = bagValue + objectInfos.price
                            DeleteEntity(objectInfos.entity)
                            RemoveBlip(blips[id])
                            blips[id] = nil
                            objects[id] = nil
                        end)
                    end
                end
            end
            Wait(0)
        end
    end)
end

Astra.netRegisterAndHandle("robberiesEnter", function(infosTable)
    currentlyRobbing = true
    pvpEnabled = true
    local entry = infosTable.entryRobbery
    DoScreenFadeOut(1200)
    while not IsScreenFadedOut() do
        Wait(1)
    end
    SetEntityCoords(PlayerPedId(), entry, false, false, false, false)
    for _, v in pairs(infosTable.objects) do
        local itemInfos = infosTable.itemsTable[v[1]]
        local prop = GetHashKey(itemInfos.prop)
        RequestModel(prop)
        print(("[Astra] Requesting model %s..."):format(itemInfos.prop))
        while not HasModelLoaded(prop) do
            Wait(1)
        end
        print(("[Astra] Loaded item %s !"):format(itemInfos.prop))
        local object = CreateObject(prop, v[3], false, false, false)
        PlaceObjectOnGroundProperly(object)
        local objectId = (#objects + 1)
        objects[objectId] = { name = itemInfos.name, count = v[2], entity = object, coords = v[3], timeToTake = itemInfos.timeToTake, additionalZ = (itemInfos.additionalZ or 0.0), iter = itemInfos.itr }
        objects[objectId].price = (itemInfos.resellerPrice * v[2])
        local blip = AddBlipForCoord(v[3])
        SetBlipScale(blip, 0.60)
        SetBlipAsShortRange(blip, false)
        SetBlipSprite(blip, 364)
        SetBlipColour(blip, 44)
        SetBlipFlashes(blip, true)
        BeginTextCommandSetBlipName("TEST")
        AddTextEntry("TEST", "Object à voler")
        EndTextCommandSetBlipName(blip)
        blips[objectId] = blip
    end
    for id, v in pairs(infosTable.possibleOponents) do
        local model = GetHashKey(v[1])
        RequestModel(model)
        while not HasModelLoaded(model) do
            Wait(1)
        end
        local ped = CreatePed(9, model, v[2], v[3], false, false)
        if v[4] ~= nil then
            TaskStartScenarioInPlace(ped, v[4], -1, false)
        end
        if v[5] ~= nil then
            GiveWeaponToPed(ped, GetHashKey(v[5]), 1000, false, true)
        end
        if infosTable.special ~= 0 then
            specialAdditionalTasks[infosTable.special](ped)
        end
        population[id] = ped
    end
    initParallelThread()
    Wait(250)
    DoScreenFadeIn(1200)
    while not IsScreenFadedIn() do
        Wait(1)
    end
    local group = AddRelationshipGroup("FAMILY")
    SetRelationshipBetweenGroups(5, GetHashKey("PLAYERS"), group)
    SetRelationshipBetweenGroups(5, group, GetHashKey("PLAYERS"))
    SetRelationshipBetweenGroups(5, GetHashKey("PLAYER"), group)
    SetRelationshipBetweenGroups(5, group, GetHashKey("PLAYER"))
    SetRelationshipBetweenGroups(0, group, group)

    SetRelationshipBetweenGroups(5, GetHashKey("PLAYERS"), GetHashKey("FAMILY"))
    SetRelationshipBetweenGroups(5, GetHashKey("FAMILY"), GetHashKey("PLAYERS"))
    SetRelationshipBetweenGroups(5, GetHashKey("PLAYER"), GetHashKey("FAMILY"))
    SetRelationshipBetweenGroups(5, GetHashKey("FAMILY"), GetHashKey("PLAYER"))
    SetRelationshipBetweenGroups(0, GetHashKey("FAMILY"), GetHashKey("FAMILY"))

    for k, v in pairs(population) do
        if DoesEntityExist(v) then
            SetPedRelationshipGroupHash(v, GetHashKey("FAMILY"))
            SetPedRelationshipGroupDefaultHash(v, GetHashKey("FAMILY"))
            SetBlockingOfNonTemporaryEvents(v, false)
            SetPedHearingRange(v, 10000.0)
            SetPedSeeingRange(v, 10000.0)
            SetPedCombatAttributes(v, 0, true)
            SetPedCombatAttributes(v, 5, true)
            SetPedCombatAttributes(v, 46, true)
            local blip = AddBlipForEntity(v)
            SetBlipAsShortRange(blip, false)
            SetBlipScale(blip, 0.50)
            SetBlipSprite(blip, 303)
            SetBlipColour(blip, 59)
            BeginTextCommandSetBlipName("BLIP")
            AddTextEntry("BLIP", "Habitant")
            EndTextCommandSetBlipName(blip)
            TaskCombatPed(v, PlayerPedId(), 0, 16)
            blips[#blips + 1] = blip
        end
    end
end)

Astra.netRegisterAndHandle("robberiesStart", function()
    print("[Astra] Started music")
    PlayUrl("robb", "https://www.youtube.com/watch?v=_5vGqtbfuDY", 0.22, false)
end)

Astra.netRegisterAndHandle("robberiesExit", function(exit)
    currentlyRobbing = false
    for k, v in pairs(objects) do
        if DoesEntityExist(v.entity) then
            DeleteEntity(v.entity)
        end
    end
    for k, v in pairs(blips) do
        if DoesBlipExist(v) then
            RemoveBlip(v)
        end
    end
    for k, v in pairs(population) do
        if DoesEntityExist(v) then
            DeleteEntity(v)
        end
    end
    blips = {}
    population = {}
    objects = {}
    bag = {}
    bagValue = 0
    DoScreenFadeOut(800)
    while not IsScreenFadedOut() do
        Wait(1)
    end
    SetEntityCoords(PlayerPedId(), exit, false, false, false, false)
    Wait(250)
    DoScreenFadeIn(1200)
    while not IsScreenFadedIn() do
        Wait(1)
    end
    AddTextEntry("ZZ", "~r~")
    DisplayHelpTextThisFrame("ZZ", 0)
    if level < 2000 then
        pvpEnabled = false
    end
end)