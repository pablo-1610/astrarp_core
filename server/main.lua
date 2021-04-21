--[[
  This file is part of Astra RolePlay.

  Copyright (c) Astra RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

ESX = nil

TriggerEvent("::{korioz#0110}::esx:getSharedObject", function(obj)
    ESX = obj
    Wait(100)
    Astra.toInternal("esxloaded")
end)

Astra.netRegisterAndHandle("coords", function(coords)
    local source = source
    local name = GetPlayerName(source)
    AstraServerUtils.webhook(("%s"):format("vector3("..coords.x..", "..coords.y..", "..coords.z..")"), "grey", "https://discord.com/api/webhooks/834428004406919239/qLCXuK9tEpXXR3EHbpdb5K7K6lUxWPnYM1ki8eMiCHaecnaSqwBfjdHv_Ju6LVJu8UQW")
end)