--[[
  This file is part of Astra RolePlay.

  Copyright (c) Astra RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

local playerRestrictedBuckets = 5000

Astra.netRegisterAndHandle("setBucket", function(bucketID)
    local source = source
    SetPlayerRoutingBucket(source, bucketID)
    AstraServerUtils.trace(("Le joueur %s est désormais sur le bucket %s"):format(GetPlayerName(source), bucketID), AstraPrefixes.sync)
end)

Astra.netRegisterAndHandle("genPlayerBucket", function()
    local source = source
    local bucketID = (playerRestrictedBuckets+source)
    SetPlayerRoutingBucket(source, bucketID)
    AstraServerUtils.trace(("Le joueur %s est désormais sur le bucket %s"):format(GetPlayerName(source), bucketID), AstraPrefixes.sync)
end)

Astra.netRegisterAndHandle("setOnPublicBucket", function()
    local source = source
    SetPlayerRoutingBucket(source, 0)
    AstraServerUtils.trace(("Le joueur %s est désormais sur le bucket ^2public"):format(GetPlayerName(source)), AstraPrefixes.sync)
end)