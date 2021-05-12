--[[
  This file is part of Astra RolePlay.

  Copyright (c) Astra RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

AstraClientSoundsManager = {}

AstraClientSoundsManager.playSound = function(soundFile, soundVolume)
    SendNUIMessage({
        transactionType = 'playSound',
        transactionFile = soundFile,
        transactionVolume = soundVolume
    })
end

AstraClientSoundsManager.playSound3d = function(soundFile, soundVolume, coords, heading)
    SendNUIMessage({
        playSound3d = true,
        transactionFile = soundFile,
        transactionVolume = soundVolume,
        audioCoords = coords,
        audioRot = heading or 0.0,
    })
end

AstraClientSoundsManager.playYouTube = function(id, url, volume, isLoop)
    PlayUrl(id,url,volume,isLoop)
end
