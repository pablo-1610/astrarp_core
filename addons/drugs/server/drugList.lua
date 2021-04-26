---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Astra RolePlay.
  
  File [drugList] created at [26/04/2021 18:28]

  Copyright (c) Astra RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

AstraSharedDrugsList = {
    {
        name = "Weed",

        harvest = {
            position = { coords = vector3(1431.29, 6350.15, 23.99) },
            reward = { item = "coke", count = 1 },
            interval = 5,
        },

        treatment = {
            position = { coords = vector3(1431.6408691406, 6344.765625, 23.984991073608) },
            reward = { item = "coke_pooch", count = 1 },
            requiered = { item = "coke", count = 1 },
            interval = 5,
        },

        sell = {
            position = { coords = vector3(1435.5296630859, 6332.486328125, 23.959579467773) },
            npc = {
                position = { coords = vector3(1436.72, 6332.51, 23.92), heading = 93.75 },
                model = "a_m_m_rurmeth_01"
            },
            reward = { account = "dirtycash", genReward = function()
                local possibilities = {
                    1500,
                    1000,
                    2000
                }
                return possibilities[math.random(1, #possibilities)]
            end },
            requiered = { item = "coke_pooch", count = 2 },
            interval = 15
        }
    }
}