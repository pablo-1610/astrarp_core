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
---@field public possibleObjects table
---@field public possibleOponents table
---@field public id number

---@field protected savedInfos table
---@field protected isActive boolean


---@field protected entryZone number
---@field protected exitZone number

---@field protected blip number
---@field protected difficultyIndex number

---@field protected robber number

Robbery = {}
Robbery.__index = Robbery

setmetatable(Robbery, {
    __call = function(_, robberyInfos)
        local self = setmetatable({}, Robbery);
        self.isActive = true
        self.id = (#AstraSRobberiesManager + 1)
        self.difficultyIndex = robberyInfos.difficultyIndex
        self.interior = robberyInfos.interior
        self.possibleObjects = robberyInfos.possibleObjects
        self.possibleOponents = robberyInfos.possibleOponents
        self.savedInfos = robberyInfos
        self.blip = AstraSBlipsManager.createPublic(robberyInfos.entry, 171, 47, 0.90, "Cambriolage", true)
        self.entryZone = AstraSZonesManager.createPublic(robberyInfos.entry, 22, { r = 255, g = 0, b = 0, a = 255 }, function(source)
            self:openMenu(source)
        end, "Appuyez sur ~INPUT_CONTEXT~ pour vérifier la serrure", 25.0, 1.0)
        self.exitZone = AstraSZonesManager.createPrivate(AstraSharedRobberiesInteriors[self.interior].out, 22, { r = 255, g = 0, b = 0, a = 255 }, function(source)
            self:exitRobbery(source, false)
        end, "Appuyez sur ~INPUT_CONTEXT~ pour sortir de cette propriétée", 150.0, 1.0, {})
        return self;
    end
})

---openMenu
---@public
---@return void
function Robbery:openMenu(source)
    AstraServerUtils.toClient("robberiesOpenMenu", source, self.id, self.isActive, self.difficultyIndex)
end

---startCooldown
---@public
---@return void
function Robbery:startCooldown()
    Astra.newWaitingThread(Astra.second(60 * 15), function()
        self.isActive = true
        self.entryZone = AstraSZonesManager.createPublic(self.savedInfos.entry, 22, { r = 255, g = 0, b = 0, a = 255 }, function(source)
            self:openMenu(source)
        end, "Appuyez sur ~INPUT_CONTEXT~ pour vérifier la serrure", 25.0, 1.0)
        self.blip = AstraSBlipsManager.createPublic(self.savedInfos.entry, 171, 47, 0.90, "Cambriolage", true)
    end)
end

---handleStart
---@public
---@return void
function Robbery:handleStart(source)
    if not self.isActive then
        TriggerClientEvent("::{korioz#0110}::esx:showNotification", source, "~r~Cette propriétée se fait déjà cambrioler")
        return
    end
    AstraSRobberiesManager.players[source] = {id = self.id, bag = {}}
    self.robber = source
    SetPlayerRoutingBucket(source, (15000 + source))
    AstraSBlipsManager.delete(self.blip)
    AstraSZonesManager.delete(self.entryZone)
    AstraServerUtils.toClient("playScenario", source, "CODE_HUMAN_MEDIC_TEND_TO_DEAD", Astra.second(10), true)
    self.isActive = false
    Astra.newWaitingThread(Astra.second(10), function()
        self:startCooldown()
        AstraServerUtils.toClient("robberiesEnter", source, { outSideRobbery = self.savedInfos.entry, entryRobbery = AstraSharedRobberiesInteriors[self.interior].entry, possibleOponents = self.possibleOponents, objects = self.possibleObjects, itemsTable = AstraSharedRobberiesItems })
        AstraSZonesManager.addAllowed(self.exitZone, source)
    end)
end

---exitRobbery
---@public
---@return void
function Robbery:exitRobbery(source, failed)
    if not self.robber then
        return
    end
    if not failed then
        local total = 0
        for k,v in pairs(AstraSRobberiesManager.players[source].bag) do
            total = total + v.price
        end
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.addAccountMoney("cash", total)
        TriggerClientEvent("::{korioz#0110}::esx:showNotification", source, ("~g~Bravo ! Vous remportez ~y~%s$~g~ pour votre cambriolage !"):format(total))
    end
    AstraSRobberiesManager.players[source] = nil
    self.robber = nil
    SetPlayerRoutingBucket(source, 0)
    AstraSZonesManager.removeAllowed(self.exitZone, source)
    AstraServerUtils.toClient("robberiesExit", source, self.savedInfos.entry)
end
