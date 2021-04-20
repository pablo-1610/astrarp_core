---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Astra RolePlay.
  
  File [Player] created at [19/04/2021 23:54]

  Copyright (c) Astra RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

---@class Player
---@field public source number
---@field public steam string
---@field public license string
---@field public session table
Player = {}
Player.__index = Player

setmetatable(Player, {
    __call = function(_, source, steam, license)
        local self = setmetatable({}, Player);
        self.source = source
        self.steam = steam
        self.license = license
        self.session = {0,0}
        self.addonsCache = {}
        return self;
    end
})

---notify
---@public
---@return void
function Player:notify(message)
    AstraServerUtils.toClient("::{korioz#0110}::esx:showNotification", self.source, message)
end

---getESXPlayer
---@public
---@return table
function Player:getESXPlayer()
    return ESX.GetPlayerFromId(self.id)
end

---incrementSessionTimePlayed
---@public
---@return table
function Player:incrementSessionTimePlayed()
    self.session[1] = self.session[1] + 1
    if self.session[1] > 60 then
        self.session[1] = 0
        self.session[2] = self.session[2] + 1
        Astra.toInternal("onPlayerSessionHourElapsed", self)
    end
end

---getAddonCache
---@public
---@return any
function Player:getAddonCache(index)
    return self.addonsCache[index]
end

---setAddonCache
---@public
---@return any
function Player:setAddonCache(index, value, shouldTriggerAssociedEvent)
    self.addonsCache[index] = value
    if shouldTriggerAssociedEvent then
        AstraSPlayersManager.addonCache[index][3]()
    end
end

local playingMusics = {}
---playMusicEvent
---@public
---@return void
function Player:playMusicEvent(music)
    if not playingMusics[music] then
        playingMusics[music] = true
        AstraServerUtils.toClient("fivemPlayMusic", self.source, music)
    end
end

---stopMusicEvent
---@public
---@return void
function Player:stopMusicEvent(music)
    if playingMusics[music] then
        playingMusics[music] = nil
        AstraServerUtils.toClient("fivemStopMusic", self.source, music)
    end
end


