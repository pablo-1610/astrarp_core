---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Astra RolePlay.
  
  File [Robbery] created at [11/05/2021 20:35]

  Copyright (c) Astra RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

---@class Robbery
---@field public interior number
---@field public copsCalledAfter number
---@field public forcedExitAfter number
---@field public possibleObjects table
---@field public possibleOponents table
---@field public id number

---@field protected savedInfos table
---@field protected isActive boolean
---@field protected entryZone number
---@field protected blip number
Robbery = {}
Robbery.__index = Robbery

setmetatable(Robbery, {
    __call = function(_, robberyInfos)
        local self = setmetatable({}, Robbery);
        self.isActive = true
        self.id = (#AstraSRobberiesManager + 1)
        self.interior = robberyInfos.interior
        self.copsCalledAfter = robberyInfos.copsCalledAfter
        self.forcedExitAfter = robberyInfos.forcedExitAfter
        self.possibleObjects = robberyInfos.possibleObjects
        self.possibleOponents = robberyInfos.possibleOponents
        self.savedInfos = robberyInfos
        self.blip = AstraSBlipsManager.createPublic(robberyInfos.entry, 171, 47, 0.90, "Cambriolage", true)
        self.entryZone = AstraSZonesManager.createPublic(robberyInfos.entry, 22, {r = 255, g = 0, b = 0, a = 255}, function(source)
            self:openMenu(source)
        end, "Appuyez sur ~INPUT_CONTEXT~ pour vérifier la serrure", 25.0, 1.0)
        return self;
    end
})

---openMenu
---@public
---@return void
function Robbery:openMenu(source)
    AstraServerUtils.toClient("robberiesOpenMenu", source, self.id, self.isActive, self.copsCalledAfter, self.possibleOponents)
end

---handleStart
---@public
---@return void
function Robbery:handleStart(source)
    if not self.isActive then
        TriggerClientEvent("::{korioz#0110}::esx:showNotification", source, "~r~Cette propriétée se fait déjà cambrioler")
        return
    end
    AstraSBlipsManager.delete(self.blip)
    AstraSZonesManager.delete(self.entryZone)
    AstraServerUtils.toClient("playScenario", source, "CODE_HUMAN_MEDIC_TEND_TO_DEAD", Astra.second(30), true)
    self.isActive = false
end
