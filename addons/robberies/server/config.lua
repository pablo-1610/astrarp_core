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
    {name = "Hi-Fi", timeToTake = Astra.second(2), resellerPrice = 150, prop = "as_prop_as_speakerdock"},
    {name = "Lampe", timeToTake = Astra.second(5), resellerPrice = 300, prop = "apa_mp_h_floorlamp_a", additionalZ = 1.50}
}

AstraSharedRobberiesInteriors = interiors
AstraSharedRobberiesItems = items

AstraSharedRobberies = {

    {
        interior = 1,
        entry = vector3(66.02, -1008.19, 29.36),
        difficultyIndex = 0.5,
        possibleObjects = {
            -- Item Type / Qty
            {1, 1, vector3(-780.84, 341.18, 216.84)},
            {2, 1, vector3(-788.95, 322.45, 217.04)},
            {2, 1, vector3(-790.6, 343.2, 216.84)}
        },
        possibleOponents = {
            {"a_m_m_eastsa_02", vector3(-791.8, 342.61, 216.84), 228.0, "WORLD_HUMAN_AA_COFFEE", "weapon_snspistol"},
            {"a_m_m_paparazzi_01", vector3(-799.57, 339.2, 220.44), 183.53, nil, "weapon_snspistol"}
        }
    }

}