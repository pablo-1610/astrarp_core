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
    "ztype",
    "shotaro"
}

local vendorNpc, vendorZone
local currentVehicle = availableRewards[math.random(1,#availableRewards)]

local currentlyAwaitingTurnPlayers = {}
local timedPlayers = {}

local function recomp(str, source, color)
    AstraServerUtils.webhook(("Le joueur %s a gagné: %s"):format(GetPlayerName(source), str), color, "https://discord.com/api/webhooks/834675729634689064/JVKIL872SyrHfAabC-zZLVlo9CX6pVD5qAWylYbWe1lAAm2OoyjOean_yGLQkIobPv1x")
end

AstraSPlayersManager.registerEventOverrider(PLAYER_EVENT_TYPE.LEAVING, function(source)
    currentlyAwaitingTurnPlayers[source] = nil
end)

Astra.netRegisterAndHandle("luckywheelRequestFinalPrice", function(vehicleProps)
    print("Received event")
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    ---@type Player
    local astraPlayer = AstraSPlayersManager.getPlayer(source)
    if currentlyAwaitingTurnPlayers[source] == nil then return end
    if currentlyAwaitingTurnPlayers[source] == "free" then
        currentlyAwaitingTurnPlayers[source] = nil
        local ran = math.random(1,30)
        if ran == 5 then
            MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle, type, state) VALUES (@owner, @plate, @vehicle, @type, 1)', {
                ['@owner'] = xPlayer.identifier,
                ['@plate'] = vehicleProps.plate,
                ['@vehicle'] = json.encode(vehicleProps),
                ['@type'] = "car"
            })
            AstraServerUtils.toClient("advancedNotif", source, "~r~Astra RP", "~y~Roue de la chance","~g~Félicitations ~s~! Vous avez gagné la ~r~voiture ~s~!", "CHAR_MILSITE", 1)
            recomp("car", source, "red")
            return
        end
        if ran <= 10 then
            local expRandom = math.random(900,1900)
            astraPlayer:setAddonCache("exp", (astraPlayer:getAddonCache("exp")+expRandom), true)
            AstraServerUtils.toClient("advancedNotif", source, "~r~Astra RP", "~y~Roue de la chance",("~g~Félicitations ~s~! Vous avez gagné ~b~%s EXP ~s~Astra RP !"):format(expRandom), "CHAR_MILSITE", 1)
            recomp(("%s exp"):format(expRandom), source, "orange")
            return
        end
        if ran <= 20 then
            local moneyRandom = math.random(5000,13500)
            xPlayer.addAccountMoney('cash', moneyRandom)
            AstraServerUtils.toClient("advancedNotif", source, "~r~Astra RP", "~y~Roue de la chance",("~g~Félicitations ~s~! Vous avez gagné ~g~%s$ ~s~!"):format(moneyRandom), "CHAR_MILSITE", 1)
            recomp(("%s$"):format(moneyRandom), source, "green")
            return
        end
        AstraServerUtils.toClient("advancedNotif", source, "~r~Astra RP", "~y~Roue de la chance","~r~Dommage ~s~! Vous n'avez rien gagné... Revenez une prochaine fois !", "CHAR_MILSITE", 1)
        recomp("rien", source, "grey")
        return
    end
    -- @TODO -> Faire une variante pour les payantes
end)

Astra.netRegisterAndHandle("luckywheelRequestFreeTurn", function()
    local source = source
    local license = AstraServerUtils.getLicense(source)
    local time = os.time()
    local cd = time+((60*60)*24)
    if timedPlayers[license] ~= nil then
        return
    end
    MySQL.Async.fetchAll("INSERT INTO astra_luckywheel (license,time) VALUES(@a,@b)", {['a'] = license, ['b'] = cd})
    currentlyAwaitingTurnPlayers[source] = "free"
    timedPlayers[license] = cd
    AstraServerUtils.toClient("luckywheelCbTurn", source)
end)

Astra.netRegisterAndHandle("luckywheelRequestCurrentVehicle", function()
    local source = source
    AstraServerUtils.toClient("luckywheelCbCurrentVehicle", source, currentVehicle)
end)

Astra.netHandle("esxloaded", function()
    vendorNpc = AstraSNpcsManager.createPublic("a_m_y_stbla_02", false, true, {coords = vector3(218.1947479248, -868.87200927734, 30.492116928101), heading = 255.41}, "WORLD_HUMAN_HIKER_STANDING", nil)
    vendorNpc:setInvincible(true)
    vendorNpc:setFloatingText("Si tu veux faire tourner la roue d'~r~Astra~s~, c'est par ici !", 8.5)

    vendorZone = AstraSZonesManager.createPublic(vector3(220.05, -869.4, 30.49), 22, {r = 3, g = 157, b = 252, a = 255}, function(source)
        vendorNpc:playSpeechForPlayer("GENERIC_HI", "SPEECH_PARAMS_FORCE_NORMAL_CLEAR", source)
        local license = AstraServerUtils.getLicense(source)
        if timedPlayers[license] ~= nil then
            local time = os.time()
            if timedPlayers[license] <= time then
                timedPlayers[license] = nil
                MySQL.Async.execute("DELETE FROM astra_luckywheel WHERE license = @a", {['a'] = license})
                AstraServerUtils.toClient("luckywheelOpenMenu", source, true)
            else
                AstraServerUtils.toClient("luckywheelOpenMenu", source, false)
            end
        else
            AstraServerUtils.toClient("luckywheelOpenMenu", source, true)
        end
    end, "Appuyez sur ~INPUT_CONTEXT~ pour parler au vendeur de tickets", 60.0, 1.0)

    AstraSBlipsManager.createPublic(vector3(220.05, -869.4, 30.49), 266, 27, 0.85, "Roue de la chance", true)

    local time = os.time()
    MySQL.Async.fetchAll("SELECT * FROM astra_luckywheel", {}, function(result)
        for k,v in pairs(result) do
            if v.time <= time then
                MySQL.Async.execute("DELETE FROM astra_luckywheel WHERE license = @a", {['a'] = v.license})
            else
                timedPlayers[v.license] = v.time
            end
        end
    end)
end)