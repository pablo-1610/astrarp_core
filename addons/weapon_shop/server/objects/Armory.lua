---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Astra RolePlay.
  
  File [Armory] created at [20/04/2021 16:20]

  Copyright (c) Astra RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

---@class Armory
---@field public id number
---@field public zone number
---@field public npc Npc
---@field public blip Blip
Armory = {}
Armory.__index = Armory

setmetatable(Armory, {
    __call = function(_,infos)
        local self = setmetatable({}, Armory);
        self.id = (#AstraSArmoriesManager.list+1)
        if infos.npc ~= nil then
            self.npc = AstraSNpcsManager.createPublic("s_m_m_ammucountry", false, true, {coords = infos.npc.pos, heading = infos.npc.heading}, "WORLD_HUMAN_CLIPBOARD", nil)
            self.npc:setInvincible(true)
            self.npc:setDisplayInfos({name = "[Vendeur] Joe Ammunation", range = 6.5, color = 55})
        end
        self.blip = AstraSBlipsManager.createPublic(infos.pos, 110, 6, 0.8, "Ammunation", true)
        self.zone = AstraSZonesManager.createPublic(infos.pos, 22, {r = 255, g = 0, b = 0, a = 255}, function(source)
            if AstraSPlayersManager.exists(source) then
                ---@type Player
                local astraPlayer = AstraSPlayersManager.getPlayer(source)
                local exp = astraPlayer:getAddonCache("exp")
                if exp < 2000 then
                    if self.npc then
                        self.npc:playSpeechForPlayer("GENERIC_INSULT_HIGH", "SPEECH_PARAMS_FORCE_NORMAL_CLEAR", source)
                    end
                    AstraServerUtils.toClient("advancedNotif", source, "~r~Armurerie","~y~Accès interdit !","Vous ne pouvez pas accéder à l'armurerie car votre niveau est trop bas, vous devez minimum atteindre le niveau ~b~3 ~s~sur Astra !", "CHAR_AMMUNATION", 1)
                else
                    if self.npc then
                        self.npc:playSpeechForPlayer("GENERIC_HI", "SPEECH_PARAMS_FORCE_NORMAL_CLEAR", source)
                    end
                    Astra.toInternal("ammunationOpenMenu", source, self.id)
                end
            else
                TriggerClientEvent("::{korioz#0110}::esx:showNotification", source, "~r~Une erreur est survenue")
            end
        end, "Appuyez sur ~INPUT_CONTEXT~ pour ouvrir l'armurerie", 20.0, 1.0)
        AstraSArmoriesManager.list[self.id] = self
        return self;
    end
})
