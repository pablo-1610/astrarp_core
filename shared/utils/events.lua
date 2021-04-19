--[[
  This file is part of Astra RolePlay.

  Copyright (c) Astra RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

---toInternal
---@public
---@return void
Astra.toInternal = function(eventName, ...)
    TriggerEvent("astra:" .. Astra.hash(eventName), ...)
end

local registredEvents = {}
local function isEventRegistred(eventName)
    for k,v in pairs(registredEvents) do
        if v == eventName then return true end
    end
    return false
end
---netRegisterAndHandle
---@public
---@return void
Astra.netRegisterAndHandle = function(eventName, handler)
    local event = "astra:" .. Astra.hash(eventName)
    if not isEventRegistred(event) then
        RegisterNetEvent(event)
        table.insert(registredEvents, event)
    end
    AddEventHandler(event, handler)
end

---netRegister
---@public
---@return void
Astra.netRegister = function(eventName)
    local event = "astra:" .. Astra.hash(eventName)
    RegisterNetEvent(event)
end

---netHandle
---@public
---@return void
Astra.netHandle = function(eventName, handler)
    local event = "astra:" .. Astra.hash(eventName)
    AddEventHandler(event, handler)
end

---netHandleBasic
---@public
---@return void
Astra.netHandleBasic = function(eventName, handler)
    AddEventHandler(eventName, handler)
end

---hash
---@public
---@return any
Astra.hash = function(notHashedModel)
    return GetHashKey(notHashedModel)
end

---second
---@public
---@return number
Astra.second = function(from)
    return from*1000
end