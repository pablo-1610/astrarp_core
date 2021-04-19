--[[
  This file is part of Astra RolePlay.

  Copyright (c) Astra RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

Astra = {}
Astra.newThread = Astra.CreateThread
Astra.newWaitingThread = Astra.SetTimeout
Citizen.CreateThread, CreateThread, Citizen.SetTimeout, SetTimeout, InvokeNative = nil, nil, nil, nil, nil

Job = nil
Jobs = {}
Jobs.list = {}

AstraPrefixes = {
    zones = "^1ZONE",
    blips = "^1BLIPS",
    npcs = "^1NPCS",
    dev = "^4INFOS",
    sync = "^6SYNC",
    jobs = "^6JOBS"
}

Astra.prefix = function(title, message)
    return ("[^Astra^7] (%s^7) %s" .. "^7"):format(title, message)
end