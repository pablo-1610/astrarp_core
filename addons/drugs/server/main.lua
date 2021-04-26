---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Astra RolePlay.
  
  File [main] created at [26/04/2021 18:18]

  Copyright (c) Astra RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

AstraSDrugsManager = {}
AstraSDrugsManager.list = {}
AstraSDrugsManager.onCooldown = {}

Astra.netHandle("esxloaded", function()
    for id, drug in pairs(AstraSharedDrugsList) do
        Drug(drug.harvest.position, drug.treatment.position, drug.sell.position, {harvest = drug.harvest, treatment = drug.treatment, sell = drug.sell})
    end
end)