---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Astra RolePlay.
  
  File [configuration] created at [11/05/2021 20:37]

  Copyright (c) Astra RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

local interiors = {
    {entry = vector3(-781.74, 316.08, 217.64), out = vector3(-786.37, 315.88, 217.64)}
}

local items = {
    {name = "Téléviseur", timeToTake = Astra.second(2), resellerPrice = 150, prop = "ch_prop_ch_arcade_big_screen"}
}

AstraSharedRobberiesInteriors = interiors

AstraSharedRobberies = {

    {
        interior = 1,
        entry = vector3(66.02, -1008.19, 29.36),
        copsCalledAfter = Astra.second(15),
        forcedExitAfter = Astra.second(30),
        possibleObjects = {
            -- Item Type / Qty
            {1, 1}
        },
        possibleOponents = {
            1,1,1
        }
    }

}