---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Astra RolePlay.
  
  File [main] created at [21/04/2021 21:01]

  Copyright (c) Astra RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

local availableRewards = {
    "t20",
    "adder"
}

local vendorNpc, vendorZone
local currentVehicle = availableRewards[math.random(1, #availableRewards)]

local currentlyAwaitingTurnPlayers = {}
local timedPlayers = {}

local paidTurns = {}

Astra.netHandle("addPaidTurn", function(license)
    if not paidTurns[license] then
        paidTurns[license] = 0
        MySQL.Async.insert("INSERT INTO astra_luckwheel_paid (license) VALUES(@a)", {
            ['a'] = license
        })
    else
        paidTurns[license] = paidTurns[license] + 1
        MySQL.Async.execute("UPDATE astra_luckwheel_paid SET ammount = ammount + 1 WHERE license = @a", {
            ['a'] = license
        })
    end
end)

Astra.netHandle("removePaidTurn", function(license)
    if not paidTurns[license] then
        return
    end
    local final = (paidTurns[license] - 1)
    if final <= 0 then
        paidTurns[license] = nil
        MySQL.Async.execute("DELETE FROM astra_luckwheel_paid WHERE license = @a", {
            ['a'] = license
        })
    else
        paidTurns[license] = final
        MySQL.Async.execute("UPDATE astra_luckwheel_paid SET ammount = ammount - 1 WHERE license = @a", {
            ['a'] = license
        })
    end
end)

local function countPaidTurns(license)
    return paidTurns[license] or 0
end

local function recomp(str, source, color)
    AstraServerUtils.webhook(("Le joueur %s a gagné: %s"):format(GetPlayerName(source), str), color, "https://discord.com/api/webhooks/843427294667603999/YCrKltBCszywMv4Eo-AjfL3SSuXlhx_LoMhTf7W22PLUeS7oXSJnIJBREEO75WeUX-v9")
end

AstraServerUtils.registerConsoleCommand("luckywheelSetCar", function(source, args)
    currentVehicle = args[1]
    AstraServerUtils.trace("Véhicule de la roue changée !", AstraPrefixes.succes)
    AstraServerUtils.toAll("luckywheelVehicleChange", args[1])
end)

AstraSPlayersManager.registerEventOverrider(PLAYER_EVENT_TYPE.LEAVING, function(source)
    currentlyAwaitingTurnPlayers[source] = nil
end)

Astra.netRegisterAndHandle("luckywheelRequestFinalPrice", function(vehicleProps)
    print("Received event")
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    ---@type Player
    local astraPlayer = AstraSPlayersManager.getPlayer(source)
    if currentlyAwaitingTurnPlayers[source] == nil then
        return
    end
    if currentlyAwaitingTurnPlayers[source] == "free" then
        currentlyAwaitingTurnPlayers[source] = nil
        local ran = math.random(1, 30)
        if ran == 5 then
            MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle, type, state) VALUES (@owner, @plate, @vehicle, @type, 1)', {
                ['@owner'] = xPlayer.identifier,
                ['@plate'] = vehicleProps.plate,
                ['@vehicle'] = json.encode(vehicleProps),
                ['@type'] = "car"
            })
            AstraServerUtils.toClient("advancedNotif", source, "~r~Astra RP", "~y~Roue de la chance", "~g~Félicitations ~s~! Vous avez gagné la ~r~voiture ~s~!", "CHAR_MILSITE", 1)
            recomp("car", source, "red")
            return
        end
        if ran <= 10 then
            local expRandom = math.random(900, 1900)
            astraPlayer:setAddonCache("exp", (astraPlayer:getAddonCache("exp") + expRandom), true)
            AstraServerUtils.toClient("advancedNotif", source, "~r~Astra RP", "~y~Roue de la chance", ("~g~Félicitations ~s~! Vous avez gagné ~b~%s EXP ~s~Astra RP !"):format(expRandom), "CHAR_MILSITE", 1)
            recomp(("%s exp"):format(expRandom), source, "orange")
            return
        end
        if ran <= 20 then
            local moneyRandom = math.random(5000, 13500)
            xPlayer.addAccountMoney('cash', moneyRandom)
            AstraServerUtils.toClient("advancedNotif", source, "~r~Astra RP", "~y~Roue de la chance", ("~g~Félicitations ~s~! Vous avez gagné ~g~%s$ ~s~!"):format(moneyRandom), "CHAR_MILSITE", 1)
            recomp(("%s$"):format(moneyRandom), source, "green")
            return
        end
        AstraServerUtils.toClient("advancedNotif", source, "~r~Astra RP", "~y~Roue de la chance", "~r~Dommage ~s~! Vous n'avez rien gagné... Revenez une prochaine fois !", "CHAR_MILSITE", 1)
        recomp("rien", source, "grey")
        return
    elseif currentlyAwaitingTurnPlayers[source] == "paid" then
        currentlyAwaitingTurnPlayers[source] = nil
        local ran, plate = math.random(1, 30), AstraGameUtils.GeneratePlate()
        if ran == 5 then
            -- INSERT INTO tebex_players_wallet (identifiers, transaction, price, currency, points) VALUES ('{id}', '{transaction}', '{packagePrice}', '{currency}', '1500')
            local identifier = AstraServerUtils.getIdentifiers(source);
            if (identifier['fivem']) then
                local before, after = identifier['fivem']:match("([^:]+):([^:]+)")
                MySQL.Async.execute("INSERT INTO tebex_players_wallet (identifiers, transaction, price, currency, points) VALUES (@a, 'Roue', '0', 'EUR', '1500')", {
                    ['a'] = after
                })
            end
            AstraServerUtils.toClient("advancedNotif", source, "~r~Astra RP", "~y~Roue de la chance", "~g~Félicitations ~s~! Vous avez gagné la ~r~1500 Pultions~s~!", "CHAR_MILSITE", 1)
            return
        end
        if ran <= 10 then
            MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle, type, state) VALUES (@owner, @plate, @vehicle, @type, 1)', {
                ['@owner'] = xPlayer.identifier,
                ['@plate'] = vehicleProps.plate,
                ['@vehicle'] = "{\"model\":"..Astra.hash("sultanrs")..",\"plate\":\""..plate.."\"}",
                ['@type'] = "car"
            })
            AstraServerUtils.toClient("advancedNotif", source, "~r~Astra RP", "~y~Roue de la chance", "~g~Félicitations ~s~! Vous avez gagné la ~r~Sultan RS ~s~!", "CHAR_MILSITE", 1)
            return
        end
        if ran <= 20 then
            local moneyRandom = 250000
            xPlayer.addAccountMoney('cash', moneyRandom)
            AstraServerUtils.toClient("advancedNotif", source, "~r~Astra RP", "~y~Roue de la chance", ("~g~Félicitations ~s~! Vous avez gagné ~g~%s$ ~s~!"):format(moneyRandom), "CHAR_MILSITE", 1)
            return
        end
        AstraServerUtils.toClient("advancedNotif", source, "~r~Astra RP", "~y~Roue de la chance", "~r~Dommage ~s~! Vous n'avez rien gagné... Revenez une prochaine fois !", "CHAR_MILSITE", 1)
        recomp("rien", source, "grey")
        return
    end
    -- @TODO -> Faire une variante pour les payantes
end)

Astra.netRegisterAndHandle("luckywheelRequestFreeTurn", function()
    local source = source
    local license = AstraServerUtils.getLicense(source)
    local time = os.time()
    local cd = time + ((60 * 60) * 24)
    if timedPlayers[license] ~= nil then
        return
    end
    MySQL.Async.fetchAll("INSERT INTO astra_luckywheel (license,time) VALUES(@a,@b)", { ['a'] = license, ['b'] = cd })
    currentlyAwaitingTurnPlayers[source] = "free"
    timedPlayers[license] = cd
    AstraServerUtils.toClient("luckywheelCbTurn", source)
end)

Astra.netRegisterAndHandle("luckywheelRequestPaidTurn", function()
    local source = source
    local license = AstraServerUtils.getLicense(source)
    if countPaidTurns(license) <= 0 then
        return
    end
    Astra.toInternal("removePaidTurn", license)
    currentlyAwaitingTurnPlayers[source] = "paid"
    AstraServerUtils.toClient("luckywheelCbTurn", source)
end)

Astra.netRegisterAndHandle("luckywheelRequestCurrentVehicle", function()
    local source = source
    AstraServerUtils.toClient("luckywheelCbCurrentVehicle", source, currentVehicle)
end)

Astra.netHandle("esxloaded", function()
    MySQL.Async.fetchAll("SELECT * FROM astra_luckwheel_paid", {}, function(result)
        for k,v in pairs(result) do
            paidTurns[v.license] = v.ammount
        end
    end)
    vendorNpc = AstraSNpcsManager.createPublic("a_m_y_stbla_02", false, true, { coords = vector3(218.1947479248, -868.87200927734, 30.492116928101), heading = 255.41 }, "WORLD_HUMAN_HIKER_STANDING", nil)
    vendorNpc:setInvincible(true)
    vendorNpc:setFloatingText("Si tu veux faire tourner la roue d'~r~Astra~s~, c'est par ici !", 8.5)

    vendorZone = AstraSZonesManager.createPublic(vector3(220.05, -869.4, 30.49), 22, { r = 3, g = 157, b = 252, a = 255 }, function(source)
        vendorNpc:playSpeechForPlayer("GENERIC_HI", "SPEECH_PARAMS_FORCE_NORMAL_CLEAR", source)
        local license = AstraServerUtils.getLicense(source)
        if timedPlayers[license] ~= nil then
            local time = os.time()
            if timedPlayers[license] <= time then
                timedPlayers[license] = nil
                MySQL.Async.execute("DELETE FROM astra_luckywheel WHERE license = @a", { ['a'] = license })
                AstraServerUtils.toClient("luckywheelOpenMenu", source, true, countPaidTurns(license))
            else
                AstraServerUtils.toClient("luckywheelOpenMenu", source, false, countPaidTurns(license))
            end
        else
            AstraServerUtils.toClient("luckywheelOpenMenu", source, true, countPaidTurns(license))
        end
    end, "Appuyez sur ~INPUT_CONTEXT~ pour parler au vendeur de tickets", 60.0, 1.0)

    AstraSBlipsManager.createPublic(vector3(220.05, -869.4, 30.49), 266, 27, 0.85, "Roue de la chance", true)

    local time = os.time()
    MySQL.Async.fetchAll("SELECT * FROM astra_luckywheel", {}, function(result)
        for k, v in pairs(result) do
            if v.time <= time then
                MySQL.Async.execute("DELETE FROM astra_luckywheel WHERE license = @a", { ['a'] = v.license })
            else
                timedPlayers[v.license] = v.time
            end
        end
    end)
end)