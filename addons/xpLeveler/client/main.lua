---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Astra RolePlay.
  
  File [main] created at [19/04/2021 23:23]

  Copyright (c) Astra RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

local pvpEnabled = false
local noPvPOpacity = 180
Astra.newRepeatingTask(function()
    if not pvpEnabled then
        SetCanAttackFriendly(PlayerPedId(), false, false)
        DisablePlayerFiring(PlayerPedId(), true)
        DisableControlAction(0, 140, true)
    end
end, nil, 0, 1)


Astra.netRegisterAndHandle("levelInitFirst", function(level)
    Wait(5000)
    XNL_SetInitialXPLevels(level, true, true)
    if level >= 2000 then
        SetEntityAlpha(PlayerPedId(), 255)
        pvpEnabled = true
    else
        SetEntityAlpha(PlayerPedId(), noPvPOpacity)
    end
end)

Astra.netRegisterAndHandle("levelGain", function(level)
    SetAudioFlag("AvoidMissionCompleteDelay", true)
    PlayMissionCompleteAudio("FRANKLIN_BIG_01")
    XNL_AddPlayerXP((level-XNL_CurrentPlayerXP))
    if level >= 2000 and not pvpEnabled then
        pvpEnabled = true
        SetEntityAlpha(PlayerPedId(), 255)
        AstraGameUtils.advancedNotification("~r~Astra RP", "~y~Système de niveau", "~g~Félicitations~s~, vous venez d'atteindre les 2000XP, vous pouvez désormais taper et acheter des armes à l'armurerie !", "CHAR_AMMUNATION", 1)
    end
end)

Astra.netRegisterAndHandle("levelRem", function(level, rem)
    XNL_RemovePlayerXP(rem)
    if level < 2000 and pvpEnabled then
        SetEntityAlpha(PlayerPedId(), noPvPOpacity)
        pvpEnabled = false
    end
end)