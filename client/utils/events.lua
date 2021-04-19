--[[
  This file is part of Astra RolePlay.

  Copyright (c) Astra RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

AstraClientUtils = {}

AstraClientUtils.toServer = function(eventName, ...)
    TriggerServerEvent("astra:" .. Astra.hash(eventName), ...)
end