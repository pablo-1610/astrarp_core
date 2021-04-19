--[[
  This file is part of Astra RolePlay.

  Copyright (c) Astra RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

---@class Blip
---@field public blipId number
---@field public position table
---@field public sprite number
---@field public color number
---@field public scale number
---@field public text string
---@field public shortRange boolean
---@field public restricted boolean
---@field public allowed table
Blip = {}
Blip.__index = Blip

setmetatable(Blip, {
    __call = function(_, position, sprite, color, scale, text, shortRange, restricted, baseAllowed)
        local self = setmetatable({}, Blip)
        self.blipId = (#AstraSBlipsManager.list + 1)
        self.position = position
        self.sprite = sprite
        self.color = color
        self.scale = scale
        self.text = text
        self.shortRange = shortRange
        self.restricted = restricted
        self.allowed = baseAllowed or {}
        AstraSBlipsManager.list[self.blipId] = self
        return self
    end
})

---setRestriction
---@public
---@return void
function Blip:setRestriction(boolean)
    self.restricted = boolean
end

---isRestricted
---@public
---@return boolean
function Blip:isRestricted()
    return self.restricted
end

---clearAllowed
---@public
---@return void
function Blip:clearAllowed()
    self.allowed = {}
end

---isAllowed
---@public
---@return boolean
function Blip:isAllowed(source)
    return self.allowed[source] ~= nil
end

---addAllowed
---@public
---@return void
function Blip:addAllowed(source)
    self.allowed[source] = true
end

---removeAllowed
---@public
---@return void
function Blip:removeAllowed(source)
    self.allowed[source] = nil
end
