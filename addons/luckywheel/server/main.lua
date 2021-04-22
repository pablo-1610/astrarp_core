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
    "autarch"
}

local vendorNpc, vendorZone
local currentVehicle = availableRewards[math.random(1,#availableRewards)]

local timedPlayers = {}

Astra.netHandle("esxloaded", function()
    vendorNpc = AstraSNpcsManager.createPublic("a_m_y_stbla_02", false, true, {coords = vector3(218.1947479248, -868.87200927734, 30.492116928101), heading = 255.41}, "WORLD_HUMAN_HIKER_STANDING", nil)
    vendorNpc:setInvincible(true)
    vendorNpc:setFloatingText("Si tu veux faire tourner la roue d'~r~Astra~s~, c'est par ici !", 8.5)

    vendorZone = AstraSZonesManager.createPublic(vector3(220.05, -869.4, 30.49), 22, {r = 3, g = 157, b = 252, a = 255}, function(source)
        vendorNpc:playSpeechForPlayer("GENERIC_HI", "SPEECH_PARAMS_FORCE_NORMAL_CLEAR", source)
        AstraServerUtils.toClient("luckywheelOpenMenu", source, true, true)
    end, "Appuyez sur ~INPUT_CONTEXT~ pour parler au vendeur de tickets", 60.0, 1.0)
end)

Astra.netRegisterAndHandle("luckywheelRequestCurrentVehicle", function()
    local source = source
    AstraServerUtils.toClient("luckywheelCbCurrentVehicle", source, currentVehicle)
end)