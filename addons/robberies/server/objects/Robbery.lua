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
---@field public name string

---@field protected savedInfos table
---@field protected isActive boolean


---@field protected entryZone number
---@field protected exitZone number
---@field protected exitBlip number

---@field protected blip number
---@field protected difficultyIndex number


Robbery = {}
Robbery.__index = Robbery

setmetatable(Robbery, {
    __call = function(_, receivedId, robberyInfos)
        local self = setmetatable({}, Robbery);
        self.isActive = true
        self.id = receivedId
        self.difficultyIndex = robberyInfos.difficultyIndex
        self.interior = robberyInfos.interior
        self.possibleObjects = robberyInfos.possibleObjects
        self.possibleOponents = robberyInfos.possibleOponents
        self.name = robberyInfos.name
        self.savedInfos = robberyInfos
        self.blip = AstraSBlipsManager.createPublic(robberyInfos.entry, 171, 47, 0.90, "Cambriolage", true)
        self.entryZone = AstraSZonesManager.createPublic(robberyInfos.entry, 22, { r = 255, g = 0, b = 0, a = 255 }, function(source)
            self:openMenu(source)
        end, "Appuyez sur ~INPUT_CONTEXT~ pour vérifier la serrure", 25.0, 1.0)
        self.exitZone = AstraSZonesManager.createPrivate(AstraSharedRobberiesInteriors[self.interior].out, 22, { r = 255, g = 0, b = 0, a = 255 }, function(source)
            self:exitRobbery(source, false)
        end, "Appuyez sur ~INPUT_CONTEXT~ pour sortir de cette propriétée", 150.0, 1.0, {})
        self.exitBlip = AstraSBlipsManager.createPrivate(AstraSharedRobberiesInteriors[self.interior].out, 126, 69, 0.75, "Sortie", false)
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
        self.entryZone = AstraSZonesManager.createPublic(self.savedInfos.entry, 22, { r = 255, g = 0, b = 0, a = 255 }, function(source)
            self:openMenu(source)
        end, "Appuyez sur ~INPUT_CONTEXT~ pour vérifier la serrure", 25.0, 1.0)
        self.blip = AstraSBlipsManager.createPublic(self.savedInfos.entry, 171, 47, 0.90, "Cambriolage", true)
        self.isActive = true
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
    AstraSRobberiesManager.players[source] = { id = self.id, bag = {} }
    SetPlayerRoutingBucket(source, (15000 + source))
    AstraSBlipsManager.delete(self.blip)
    AstraSZonesManager.delete(self.entryZone)
    AstraServerUtils.toClient("robberiesStart", source)
    AstraServerUtils.toClient("playScenario", source, "CODE_HUMAN_MEDIC_TEND_TO_DEAD", Astra.second(30), true)
    self.isActive = false
    Astra.newWaitingThread(Astra.second(30), function()
        self:startCooldown()
        AstraServerUtils.toClient("robberiesEnter", source, { outSideRobbery = self.savedInfos.entry, entryRobbery = AstraSharedRobberiesInteriors[self.interior].entry, possibleOponents = self.possibleOponents, objects = self.possibleObjects, itemsTable = AstraSharedRobberiesItems, special = self.savedInfos.specialTaskOnPed or 0 })
        AstraSZonesManager.addAllowed(self.exitZone, source)
        AstraSBlipsManager.addAllowed(self.exitBlip, source)
    end)
end

---exitRobbery
---@public
---@return void
function Robbery:exitRobbery(source, failed)
    if not failed then
        local total = 0
        for k, v in pairs(AstraSRobberiesManager.players[source].bag) do
            total = total + v.price
        end
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.addAccountMoney("cash", total)
        TriggerClientEvent("::{korioz#0110}::esx:showNotification", source, ("~g~Bravo ! Vous remportez ~y~%s$~g~ pour votre cambriolage !"):format(total))
        if total > 0 then
            AstraServerUtils.webhook(("%s a réussi le cambriolage \"__%s__\" pour __%s__$"):format(GetPlayerName(source), self.name, total), "green", "https://discord.com/api/webhooks/842087237486247936/C88Mge0gbwuvcrZDDNEWNOGRV1UhNbBuftNfZp2Ewv9b1-sKM6Tl0HwuQsdps8ohFtus")
        else
            AstraServerUtils.webhook(("%s a réussi le cambriolage \"__%s__\" sans rien emporter"):format(GetPlayerName(source), self.name), "orange", "https://discord.com/api/webhooks/842087237486247936/C88Mge0gbwuvcrZDDNEWNOGRV1UhNbBuftNfZp2Ewv9b1-sKM6Tl0HwuQsdps8ohFtus")
        end
    end
    AstraSRobberiesManager.players[source] = nil
    SetPlayerRoutingBucket(source, 0)
    AstraSZonesManager.removeAllowed(self.exitZone, source)
    AstraSBlipsManager.removeAllowed(self.exitBlip, source)
    AstraServerUtils.toClient("destroy", source, "robb")
    AstraServerUtils.toClient("robberiesExit", source, self.savedInfos.entry)
    if failed then
        AstraServerUtils.webhook(("%s est mort dans le cambriolage \"__%s__\""):format(GetPlayerName(source),self.name), "red", "https://discord.com/api/webhooks/842087237486247936/C88Mge0gbwuvcrZDDNEWNOGRV1UhNbBuftNfZp2Ewv9b1-sKM6Tl0HwuQsdps8ohFtus")
    end
end
