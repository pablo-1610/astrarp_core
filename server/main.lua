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
