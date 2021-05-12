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
    {entry = vector3(-781.74, 316.08, 217.64), out = vector3(-786.37, 315.88, 217.64)},
    {entry = vector3(4.27, -706.87, 16.13), out = vector3(-14.12, -694.6, 16.13)}
}

local items = {
    [1] = {name = "Hi-Fi", timeToTake = Astra.second(2), resellerPrice = 1500, prop = "as_prop_as_speakerdock", itr = 1.0},
    [2] = {name = "Lampe", timeToTake = Astra.second(5), resellerPrice = 3000, prop = "apa_mp_h_floorlamp_a", additionalZ = 1.50, itr = 1.0},
    [3] = {name = "Lampe", timeToTake = Astra.second(5), resellerPrice = 3000, prop = "apa_mp_h_lit_floorlampnight_14", additionalZ = 1.50, itr = 1.0},
    [4] = {name = "Plante rare", timeToTake = Astra.second(4), resellerPrice = 4500, prop = "apa_mp_h_acc_vase_flowers_01", additionalZ = 1.0, itr = 1.0},
    [5] = {name = "Appareil photo", timeToTake = Astra.second(2), resellerPrice = 2500, prop = "prop_pap_camera_01", itr = 1.0},
    [6] = {name = "Pack d'argent", timeToTake = Astra.second(1), resellerPrice = 3500, prop = "bkr_prop_moneypack_01a", itr = 1.0},
    [7] = {name = "Bijoux rare", timeToTake = Astra.second(2), resellerPrice = 10000, prop = "p_jewel_necklace01_s", itr = 1.0},
    [8] = {name = "Caisse d'argent", timeToTake = Astra.second(30), resellerPrice = 80000, prop = "ex_prop_crate_money_bc", itr = 4.0}
}

AstraSharedRobberiesInteriors = interiors
AstraSharedRobberiesItems = items

AstraSharedRobberies = {
    -- Maison 1 (diamant)
    {
        name = "Maison Diamant",
        interior = 1,
        entry = vector3(66.02, -1008.19, 29.36),
        difficultyIndex = 0.5,
        possibleObjects = {
            -- Item Type / Qty
            {1, 1, vector3(-780.84, 341.18, 216.84)},
            {2, 1, vector3(-788.95, 322.45, 217.04)},
            {2, 1, vector3(-790.6, 343.2, 216.84)},
            {7, 1, vector3(-797.85, 336.59, 221.11)}
        },
        possibleOponents = {
            {"a_m_m_eastsa_02", vector3(-791.8, 342.61, 216.84), 228.0, "WORLD_HUMAN_AA_COFFEE", "weapon_snspistol"},
            {"a_m_m_paparazzi_01", vector3(-799.57, 339.2, 220.44), 183.53, nil, "weapon_snspistol"}
        }
    },
    -- Maison 2
    {
        name = "Maison Normale",
        interior = 1,
        entry = vector3(286.7, -790.79, 29.44);
        difficultyIndex = 0.0,
        possibleObjects = {
            {3, 1, vector3(-799.6, 327.46, 217.04)},
            {4, 1, vector3(-781.22, 333.35, 217.04)},
            {5, 1, vector3(-790.08, 331.37, 217.86)},
            {6, 1, vector3(-783.99, 338.44, 217.27)}
        },
        possibleOponents = {}
    },
    -- Union depository
    {
        name = "Union Depository",
        interior = 2,
        entry = vector3(3.05, -712.57, 32.48),
        difficultyIndex = 1.0,
        possibleObjects = {
            {8, 1, vector3(6.7369608879089, -675.09985351562, 16.130617141724)},
            {8, 1, vector3(-3.4245448112488, -671.31750488281, 16.13063621521)}
        },
        possibleOponents = {
            {"mp_m_securoguard_01", vector3(-0.96789300441742, -687.04022216797, 16.130619049072), 168.21, nil, "WEAPON_HEAVYPISTOL"},
            {"mp_m_securoguard_01", vector3(-6.3715143203735, -686.26092529297, 16.130619049072), 168.21, nil, "WEAPON_HEAVYPISTOL"},

            {"s_m_m_armoured_01", vector3(-1.5658172369003, -665.41668701172, 16.13062286377), 254.82, nil, "weapon_nightstick"},
            {"s_m_m_armoured_01", vector3(8.2164793014526, -669.10760498047, 16.130634307861), 71.59, nil, "weapon_nightstick"},

            {"s_m_m_armoured_01", vector3(4.9947552680969, -658.85064697266, 16.130634307861), 165.65, nil, "weapon_nightstick"},
            {"u_m_y_juggernaut_01", vector3(6.1883082389832, -659.29974365234, 16.130626678467), 165.65, nil, "weapon_heavyshotgun"},
            {"s_m_m_armoured_01", vector3(7.7517261505127, -660.05255126953, 16.130626678467), 165.65, nil, "weapon_nightstick"},
        },
        specialTaskOnPed = 1
    }
}