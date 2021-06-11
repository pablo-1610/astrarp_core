---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Astra RolePlay.
  
  File [main] created at [10/06/2021 19:26]

  Copyright (c) Astra RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

RegisterCommand("+openF5", function()
    Astra.toInternal("openPersonnalMenu")
end, false)

RegisterKeyMapping("+openF5", "Ouverture du menu personnel", "keyboard", "f5")