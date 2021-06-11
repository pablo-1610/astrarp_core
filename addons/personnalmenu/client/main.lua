---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Astra RolePlay.
  
  File [main] created at [10/06/2021 19:26]

  Copyright (c) Astra RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

local isPointing, isHandsUp, isCrouching, isRagdoll = false, false, false, false

Astra.netHandle("esxloaded", function()
    AstraCKeysDisabler.disableKey(36)
end)

RegisterCommand("+openF5", function()
    Astra.toInternal("openPersonnalMenu")
end, false)

RegisterCommand("+point", function()
    Astra.toInternal("point", (not isPointing))
end, false)

RegisterCommand("+handsUp", function()
    Astra.toInternal("handsUp", (not isHandsUp))
end, false)

RegisterCommand("+crouch", function()
    Astra.toInternal("crouch", (not isCrouching))
end, false)

RegisterCommand("+ragdoll", function()
    Astra.toInternal("ragdoll", (not isRagdoll))
end, false)

Astra.netHandle("ragdoll", function(override)
    if not IsPedOnFoot(PlayerPedId()) then
        return
    end
    isRagdoll = override
    if isRagdoll then
        SetPedToRagdoll(PlayerPedId(), 1000, 1000, 0, 0, 0, 0)
        Astra.newThread(function()
            while isRagdoll do
                Wait(950)
                ResetPedRagdollTimer(PlayerPedId())
            end
        end)
    end
end)

Astra.netHandle("crouch", function(override)
    isCrouching = override
    if isCrouching then
        ESX.Streaming.RequestAnimSet('move_ped_crouched')
        SetPedMovementClipset(PlayerPedId(), 'move_ped_crouched', 0.25)
        RemoveAnimSet('move_ped_crouched')
    else
        ResetPedMovementClipset(PlayerPedId(), 0.0)
    end
end)

Astra.netHandle("handsUp", function(override)
    isHandsUp = override
    if isHandsUp then
        ESX.Streaming.RequestAnimDict('random@mugging3')
        TaskPlayAnim(PlayerPedId(), 'random@mugging3', 'handsup_standing_base', 8.0, -8.0, -1, 49, 0.0, false, false, false)
        RemoveAnimDict('random@mugging3')
    else
        ClearPedSecondaryTask(PlayerPedId())
        isPointing = false
    end
end)
Astra.netHandle("point", function(override)
    isPointing = override
    if isPointing then
        ESX.Streaming.RequestAnimDict('anim@mp_point')
        SetPedConfigFlag(PlayerPedId(), 36, true)
        TaskMoveNetworkByName(PlayerPedId(), 'task_mp_pointing', 0.5, false, 'anim@mp_point', 24)
        RemoveAnimDict('anim@mp_point')
        Astra.newThread(function()
            while isPointing do
                local ped = PlayerPedId()
                local camPitch = GetGameplayCamRelativePitch()

                if camPitch < -70.0 then
                    camPitch = -70.0
                elseif camPitch > 42.0 then
                    camPitch = 42.0
                end

                camPitch = (camPitch + 70.0) / 112.0
                local camHeading = GetGameplayCamRelativeHeading()
                local cosCamHeading = Cos(camHeading)
                local sinCamHeading = Sin(camHeading)

                if camHeading < -180.0 then
                    camHeading = -180.0
                elseif camHeading > 180.0 then
                    camHeading = 180.0
                end
                camHeading = (camHeading + 180.0) / 360.0
                local coords = GetOffsetFromEntityInWorldCoords(ped, (cosCamHeading * -0.2) - (sinCamHeading * (0.4 * camHeading + 0.3)), (sinCamHeading * -0.2) + (cosCamHeading * (0.4 * camHeading + 0.3)), 0.6)
                local rayHandle, blocked = GetShapeTestResult(StartShapeTestCapsule(coords.x, coords.y, coords.z - 0.2, coords.x, coords.y, coords.z + 0.2, 0.4, 95, ped, 7))
                SetTaskMoveNetworkSignalFloat(ped, 'Pitch', camPitch)
                SetTaskMoveNetworkSignalFloat(ped, 'Heading', (camHeading * -1.0) + 1.0)
                SetTaskMoveNetworkSignalBool(ped, 'isBlocked', blocked)
                SetTaskMoveNetworkSignalBool(ped, 'isFirstPerson', N_0xee778f8c7e1142e2(N_0x19cafa3c87f7c2ff()) == 4)
                Wait(0)
            end
        end)
    else
        RequestTaskMoveNetworkStateTransition(PlayerPedId(), 'Stop')

        if not IsPedInjured(PlayerPedId()) then
            ClearPedSecondaryTask(PlayerPedId())
        end

        SetPedConfigFlag(PlayerPedId(), 36, false)
        ClearPedSecondaryTask(PlayerPedId())
        isHandsUp = false
    end
end)

RegisterKeyMapping("+openF5", "Ouverture du menu personnel", "keyboard", "f5")
RegisterKeyMapping("+point", "Pointer du doigt", "keyboard", "b")
RegisterKeyMapping("+handsUp", "Lever les mains", "keyboard", "OEM_3")
RegisterKeyMapping("+crouch", "S'accroupir", "keyboard", "LCONTROL")
RegisterKeyMapping("+ragdoll", "S'endormir / Tomber", "keyboard", "")
