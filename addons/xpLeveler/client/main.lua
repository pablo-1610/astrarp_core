---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Astra RolePlay.
  
  File [main] created at [19/04/2021 23:23]

  Copyright (c) Astra RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

Astra.netRegisterAndHandle("levelInitFirst", function(level)
    Wait(5000)
    XNL_SetInitialXPLevels(level, true, true)
end)

Astra.netRegisterAndHandle("levelGain", function(level)
    XNL_AddPlayerXP(level)
end)