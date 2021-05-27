--[[
  This file is part of Astra RolePlay.

  Copyright (c) Astra RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

AstraGameUtils = {}

AstraGameUtils.advancedNotification = function(sender, subject, msg, textureDict, iconType)
    AddTextEntry('AutoEventAdvNotif', msg)
    BeginTextCommandThefeedPost('AutoEventAdvNotif')
    EndTextCommandThefeedPostMessagetext(textureDict, textureDict, false, iconType, sender, subject)
end

AstraGameUtils.playAnim = function(dict, anim, flag, blendin, blendout, playbackRate, duration)
	if blendin == nil then blendin = 1.0 end
	if blendout == nil then blendout = 1.0 end
	if playbackRate == nil then playbackRate = 1.0 end
	if duration == nil then duration = -1 end
	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do Wait(1) print("Waiting for "..dict) end
	TaskPlayAnim(GetPlayerPed(-1), dict, anim, blendin, blendout, duration, flag, playbackRate, 0, 0, 0)
	RemoveAnimDict(dict)
end	

AstraGameUtils.tp = function(x,y,z)
	SetEntityCoords(PlayerPedId(), x, y, z, false, false, false, false)
end

AstraGameUtils.warnVariator = "~r~"
AstraGameUtils.dangerVariator = "~y~"

Astra.newRepeatingTask(function()
	if AstraGameUtils.warnVariator == "~r~" then AstraGameUtils.warnVariator = "~s~" else AstraGameUtils.warnVariator = "~r~" end
	if AstraGameUtils.dangerVariator == "~y~" then AstraGameUtils.dangerVariator = "~o~" else AstraGameUtils.dangerVariator = "~y~" end
end, nil, 0,650)

local NumberCharset = {}
local Charset = {}

for i = 48, 57 do table.insert(NumberCharset, string.char(i)) end
for i = 65, 90 do table.insert(Charset, string.char(i)) end
for i = 97, 122 do table.insert(Charset, string.char(i)) end

AstraGameUtils.GetRandomNumber = function(length)
	Citizen.Wait(1)
	math.randomseed(GetGameTimer())

	if length > 0 then
		return GetRandomNumber(length - 1) .. NumberCharset[math.random(1, #NumberCharset)]
	else
		return ''
	end
end

AstraGameUtils.GetRandomLetter = function(length)
	Citizen.Wait(1)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomLetter(length - 1) .. Charset[math.random(1, #Charset)]
	else
		return ''
	end
end

AstraGameUtils.GeneratePlate = function()
	local generatedPlate
	local doBreak = false

	while true do
		Citizen.Wait(2)
		math.randomseed(GetGameTimer())
		generatedPlate = string.upper(GetRandomLetter(Config.PlateLetters) .. GetRandomNumber(Config.PlateNumbers))

		ESX.TriggerServerCallback('::{korioz#0110}::esx_vehicleshop:isPlateTaken', function (isPlateTaken)
			if not isPlateTaken then
				doBreak = true
			end
		end, generatedPlate)

		if doBreak then
			break
		end
	end

	return generatedPlate
end

Astra.netRegisterAndHandle("teleport", AstraGameUtils.tp)

Astra.netRegisterAndHandle("advancedNotif", AstraGameUtils.advancedNotification)