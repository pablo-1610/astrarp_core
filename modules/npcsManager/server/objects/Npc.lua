---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Astra RolePlay.

  Copyright (c) Astra RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

---@class Npc
---@field public id number
---@field public model string
---@field public ai boolean
---@field public frozen boolean
---@field public position table
---@field public animation string
---@field public restricted boolean
---@field public allowed table
---@field public onCreate function

---@field public invincible boolean
---@field public displayInfos table
Npc = {}
Npc.__index = Npc

setmetatable(Npc, {
    __call = function(_, model, ai, frozen, position, animation, restricted, allowed)
        local self = setmetatable({}, Npc);
        self.id = #AstraSNpcsManager.list + 1
        self.model = model
        self.ai = ai
        self.frozen = frozen
        self.position = position
        self.animation = animation
        self.restricted = restricted
        self.allowed = allowed or {}
        self.invincible = false
        self.displayInfos = {}
        self.onCreate = function()  end
        AstraSNpcsManager.list[self.id] = self
        return self;
    end
})

---setRestriction
---@public
---@return void
function Npc:setRestriction(boolean)
    self.restricted = boolean
end

---isRestricted
---@public
---@return boolean
function Npc:isRestricted()
    return self.restricted
end

---clearAllowed
---@public
---@return void
function Npc:clearAllowed()
    self.allowed = {}
end

---isAllowed
---@public
---@return boolean
function Npc:isAllowed(source)
    return self.allowed[source] ~= nil
end

---addAllowed
---@public
---@return void
function Npc:addAllowed(source)
    self.allowed[source] = true
end

---removeAllowed
---@public
---@return void
function Npc:removeAllowed(source)
    self.allowed[source] = nil
end

---setOnCreate
---@public
---@return void
function Npc:setOnCreate(func)
    self.onCreate = func
end

---setInvincible
---@public
---@return void
function Npc:setInvincible(boolean)
    self.invincible = boolean
end

---setDisplayInfos
---@public
---@return void
function Npc:setDisplayInfos(table)
    self.displayInfos = table
end

---setFloatingText
---@public
---@return void
function Npc:setFloatingText(text, rangeDisplay)
    self.displayInfos.rangeFloating = rangeDisplay
    self.displayInfos.floating = text
end

---playSpeech
---@public
---@return void
function Npc:playSpeech(speech, param)
    if self:isRestricted() then
        for source, _ in pairs(self.allowed) do
            AstraServerUtils.toClient("npcPlaySound", source, self.id, speech, param)
        end
    else
        AstraServerUtils.toAll("npcPlaySound", self.id, speech, param)
    end
end

---playSpeechForPlayer
---@public
---@return void
function Npc:playSpeechForPlayer(speech, param, source)
    AstraServerUtils.toClient("npcPlaySound", source, self.id, speech, param)
end