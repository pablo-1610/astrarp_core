--[[
  This file is part of Astra RolePlay.

  Copyright (c) Astra RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

Astra.netRegisterAndHandle("setBucket", function(bucketID)
    local source = source
    SetPlayerRoutingBucket(bucketID, 0)
end)

Astra.netRegisterAndHandle("setOnPublicBucket", function()
    local source = source
    SetPlayerRoutingBucket(source, 0)
end)