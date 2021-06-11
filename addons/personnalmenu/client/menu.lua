---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Astra RolePlay.
  
  File [menu] created at [10/06/2021 19:26]

  Copyright (c) Astra RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

local cat, desc, title, transaction, bills, localData, localSelectedItem, localSelectedWeapon = "menuperso", "Mon personnage - Astra RolePlay", "AstraRP", false, {}, false


local availableAccounts = {
    ["cash"] = "~g~Cash",
    ["bank"] = "~b~Banque",
    ["dirtycash"] = "~r~Sale"
}



local trad = {
    ['animation_title'] = 'Animations',

    ['animation_party_title'] = 'Festives',
    ['animation_party_smoke'] = 'Fumer une cigarette',
    ['animation_party_playsong'] = 'Jouer de la musique',
    ['animation_party_dj'] = 'DJ',
    ['animation_party_beer'] = 'Bière en Zik',
    ['animation_party_dancing'] = 'Faire la Fête',
    ['animation_party_airguitar'] = 'Air Guitar',
    ['animation_party_shagging'] = 'Air Shagging',
    ['animation_party_rock'] = 'Rock\'n\'roll',
    ['animation_party_drunk'] = 'Bourré sur place',
    ['animation_party_vomit'] = 'Vomir en voiture',

    ['animation_salute_title'] = 'Salutations',
    ['animation_salute_saluate'] = 'Saluer',
    ['animation_salute_serrer'] = 'Serrer la main',
    ['animation_salute_tchek'] = 'Tchek',
    ['animation_salute_bandit'] = 'Salut bandit',
    ['animation_salute_military'] = 'Salut Militaire',

    ['animation_work_title'] = 'Travail',
    ['animation_work_suspect'] = 'Se rendre',
    ['animation_work_fisherman'] = 'Pêcheur',
    ['animation_work_inspect'] = 'Police : enquêter',
    ['animation_work_radio'] = 'Police : parler à la radio',
    ['animation_work_circulation'] = 'Police : circulation',
    ['animation_work_binoculars'] = 'Police : jumelles',
    ['animation_work_harvest'] = 'Agriculture : récolter',
    ['animation_work_repair'] = 'Dépanneur : réparer le moteur',
    ['animation_work_observe'] = 'Médecin : observer',
    ['animation_work_talk'] = 'Taxi : parler au client',
    ['animation_work_bill'] = 'Taxi : donner la facture',
    ['animation_work_buy'] = 'Epicier : donner les courses',
    ['animation_work_shot'] = 'Barman : servir un shot',
    ['animation_work_picture'] = 'Journaliste : Prendre une photo',
    ['animation_work_notes'] = 'Tout : Prendre des notes',
    ['animation_work_hammer'] = 'Tout : Coup de marteau',
    ['animation_work_beg'] = 'SDF : Faire la manche',
    ['animation_work_statue'] = 'SDF : Faire la statue',

    ['animation_mood_title'] = 'Humeurs',
    ['animation_mood_felicitate'] = 'Féliciter',
    ['animation_mood_nice'] = 'Super',
    ['animation_mood_you'] = 'Toi',
    ['animation_mood_come'] = 'Viens',
    ['animation_mood_what'] = 'Keskya ?',
    ['animation_mood_me'] = 'A moi',
    ['animation_mood_seriously'] = 'Je le savais, putain',
    ['animation_mood_tired'] = 'Etre épuisé',
    ['animation_mood_shit'] = 'Je suis dans la merde',
    ['animation_mood_facepalm'] = 'Facepalm',
    ['animation_mood_calm'] = 'Calme-toi',
    ['animation_mood_why'] = 'Qu\'est ce que j\'ai fait ?',
    ['animation_mood_fear'] = 'Avoir peur',
    ['animation_mood_fight'] = 'Fight ?',
    ['animation_mood_notpossible'] = 'C\'est pas Possible !',
    ['animation_mood_embrace'] = 'Enlacer',
    ['animation_mood_fuckyou'] = 'Doigt d\'honneur',
    ['animation_mood_wanker'] = 'Branleur',
    ['animation_mood_suicide'] = 'Balle dans la tête',

    ['animation_sports_title'] = 'Sports',
    ['animation_sports_muscle'] = 'Montrer ses muscles',
    ['animation_sports_weightbar'] = 'Barre de musculation',
    ['animation_sports_pushup'] = 'Faire des pompes',
    ['animation_sports_abs'] = 'Faire des abdos',
    ['animation_sports_yoga'] = 'Faire du yoga',

    ['animation_other_title'] = 'Divers',
    ['animation_other_sit'] = 'S\'asseoir',
    ['animation_other_waitwall'] = 'Attendre contre un mur',
    ['animation_other_ontheback'] = 'Couché sur le dos',
    ['animation_other_stomach'] = 'Couché sur le ventre',
    ['animation_other_clean'] = 'Nettoyer',
    ['animation_other_cooking'] = 'Préparer à manger',
    ['animation_other_search'] = 'Position de Fouille',
    ['animation_other_selfie'] = 'Prendre un selfie',
    ['animation_other_door'] = 'Ecouter à une porte',

    ['animation_pegi_title'] = 'PEGI 21',
    ['animation_pegi_hsuck'] = 'Homme se faire suc** en voiture',
    ['animation_pegi_fsuck'] = 'Femme suc** en voiture',
    ['animation_pegi_hfuck'] = 'Homme bais** en voiture',
    ['animation_pegi_ffuck'] = 'Femme bais** en voiture',
    ['animation_pegi_scratch'] = 'Se gratter les couilles',
    ['animation_pegi_charm'] = 'Faire du charme',
    ['animation_pegi_golddigger'] = 'Pose michto',
    ['animation_pegi_breast'] = 'Montrer sa poitrine',
    ['animation_pegi_strip1'] = 'Strip Tease 1',
    ['animation_pegi_strip2'] = 'Strip Tease 2',
    ['animation_pegi_stripfloor'] = 'Strip Tease au sol',

    ['animation_attitudes_title'] = 'Démarche',
}

local function _U(str)
    return (trad[str] or "ERR")
end

local Config = {
    Animations = {
        {
            name = 'party',
            label = _U('animation_party_title'),
            items = {
                {label = _U('animation_party_smoke'), type = "scenario", data = {anim = "WORLD_HUMAN_SMOKING"}},
                {label = _U('animation_party_playsong'), type = "scenario", data = {anim = "WORLD_HUMAN_MUSICIAN"}},
                {label = _U('animation_party_dj'), type = "anim", data = {lib = "anim@mp_player_intcelebrationmale@dj", anim = "dj"}},
                {label = _U('animation_party_beer'), type = "scenario", data = {anim = "WORLD_HUMAN_DRINKING"}},
                {label = _U('animation_party_dancing'), type = "scenario", data = {anim = "WORLD_HUMAN_PARTYING"}},
                {label = _U('animation_party_airguitar'), type = "anim", data = {lib = "anim@mp_player_intcelebrationmale@air_guitar", anim = "air_guitar"}},
                {label = _U('animation_party_shagging'), type = "anim", data = {lib = "anim@mp_player_intcelebrationfemale@air_shagging", anim = "air_shagging"}},
                {label = _U('animation_party_rock'), type = "anim", data = {lib = "mp_player_int_upperrock", anim = "mp_player_int_rock"}},
                {label = _U('animation_party_drunk'), type = "anim", data = {lib = "amb@world_human_bum_standing@drunk@idle_a", anim = "idle_a"}},
                {label = _U('animation_party_vomit'), type = "anim", data = {lib = "oddjobs@taxi@tie", anim = "vomit_outside"}}
            }
        },
        {
            name = 'salute',
            label = _U('animation_salute_title'),
            items = {
                {label = _U('animation_salute_saluate'), type = "anim", data = {lib = "gestures@m@standing@casual", anim = "gesture_hello"}},
                {label = _U('animation_salute_serrer'), type = "anim", data = {lib = "mp_common", anim = "givetake1_a"}},
                {label = _U('animation_salute_tchek'), type = "anim", data = {lib = "mp_ped_interaction", anim = "handshake_guy_a"}},
                {label = _U('animation_salute_bandit'), type = "anim", data = {lib = "mp_ped_interaction", anim = "hugs_guy_a"}},
                {label = _U('animation_salute_military'), type = "anim", data = {lib = "mp_player_int_uppersalute", anim = "mp_player_int_salute"}}
            }
        },
        {
            name = 'work',
            label = _U('animation_work_title'),
            items = {
                {label = _U('animation_work_suspect'), type = "anim", data = {lib = "random@arrests@busted", anim = "idle_c"}},
                {label = _U('animation_work_fisherman'), type = "scenario", data = {anim = "world_human_stand_fishing"}},
                {label = _U('animation_work_inspect'), type = "anim", data = {lib = "amb@code_human_police_investigate@idle_b", anim = "idle_f"}},
                {label = _U('animation_work_radio'), type = "anim", data = {lib = "random@arrests", anim = "generic_radio_chatter"}},
                {label = _U('animation_work_circulation'), type = "scenario", data = {anim = "WORLD_HUMAN_CAR_PARK_ATTENDANT"}},
                {label = _U('animation_work_binoculars'), type = "scenario", data = {anim = "WORLD_HUMAN_BINOCULARS"}},
                {label = _U('animation_work_harvest'), type = "scenario", data = {anim = "world_human_gardener_plant"}},
                {label = _U('animation_work_repair'), type = "anim", data = {lib = "mini@repair", anim = "fixing_a_ped"}},
                {label = _U('animation_work_observe'), type = "scenario", data = {anim = "CODE_HUMAN_MEDIC_KNEEL"}},
                {label = _U('animation_work_talk'), type = "anim", data = {lib = "oddjobs@taxi@driver", anim = "leanover_idle"}},
                {label = _U('animation_work_bill'), type = "anim", data = {lib = "oddjobs@taxi@cyi", anim = "std_hand_off_ps_passenger"}},
                {label = _U('animation_work_buy'), type = "anim", data = {lib = "mp_am_hold_up", anim = "purchase_beerbox_shopkeeper"}},
                {label = _U('animation_work_shot'), type = "anim", data = {lib = "mini@drinking", anim = "shots_barman_b"}},
                {label = _U('animation_work_picture'), type = "scenario", data = {anim = "WORLD_HUMAN_PAPARAZZI"}},
                {label = _U('animation_work_notes'), type = "scenario", data = {anim = "WORLD_HUMAN_CLIPBOARD"}},
                {label = _U('animation_work_hammer'), type = "scenario", data = {anim = "WORLD_HUMAN_HAMMERING"}},
                {label = _U('animation_work_beg'), type = "scenario", data = {anim = "WORLD_HUMAN_BUM_FREEWAY"}},
                {label = _U('animation_work_statue'), type = "scenario", data = {anim = "WORLD_HUMAN_HUMAN_STATUE"}}
            }
        },
        {
            name = 'mood',
            label = _U('animation_mood_title'),
            items = {
                {label = _U('animation_mood_felicitate'), type = "scenario", data = {anim = "WORLD_HUMAN_CHEERING"}},
                {label = _U('animation_mood_nice'), type = "anim", data = {lib = "mp_action", anim = "thanks_male_06"}},
                {label = _U('animation_mood_you'), type = "anim", data = {lib = "gestures@m@standing@casual", anim = "gesture_point"}},
                {label = _U('animation_mood_come'), type = "anim", data = {lib = "gestures@m@standing@casual", anim = "gesture_come_here_soft"}},
                {label = _U('animation_mood_what'), type = "anim", data = {lib = "gestures@m@standing@casual", anim = "gesture_bring_it_on"}},
                {label = _U('animation_mood_me'), type = "anim", data = {lib = "gestures@m@standing@casual", anim = "gesture_me"}},
                {label = _U('animation_mood_seriously'), type = "anim", data = {lib = "anim@am_hold_up@male", anim = "shoplift_high"}},
                {label = _U('animation_mood_tired'), type = "scenario", data = {lib = "amb@world_human_jog_standing@male@idle_b", anim = "idle_d"}},
                {label = _U('animation_mood_shit'), type = "scenario", data = {lib = "amb@world_human_bum_standing@depressed@idle_a", anim = "idle_a"}},
                {label = _U('animation_mood_facepalm'), type = "anim", data = {lib = "anim@mp_player_intcelebrationmale@face_palm", anim = "face_palm"}},
                {label = _U('animation_mood_calm'), type = "anim", data = {lib = "gestures@m@standing@casual", anim = "gesture_easy_now"}},
                {label = _U('animation_mood_why'), type = "anim", data = {lib = "oddjobs@assassinate@multi@", anim = "react_big_variations_a"}},
                {label = _U('animation_mood_fear'), type = "anim", data = {lib = "amb@code_human_cower_stand@male@react_cowering", anim = "base_right"}},
                {label = _U('animation_mood_fight'), type = "anim", data = {lib = "anim@deathmatch_intros@unarmed", anim = "intro_male_unarmed_e"}},
                {label = _U('animation_mood_notpossible'), type = "anim", data = {lib = "gestures@m@standing@casual", anim = "gesture_damn"}},
                {label = _U('animation_mood_embrace'), type = "anim", data = {lib = "mp_ped_interaction", anim = "kisses_guy_a"}},
                {label = _U('animation_mood_fuckyou'), type = "anim", data = {lib = "mp_player_int_upperfinger", anim = "mp_player_int_finger_01_enter"}},
                {label = _U('animation_mood_wanker'), type = "anim", data = {lib = "mp_player_int_upperwank", anim = "mp_player_int_wank_01"}},
                {label = _U('animation_mood_suicide'), type = "anim", data = {lib = "mp_suicide", anim = "pistol"}}
            }
        },
        {
            name = 'sports',
            label = _U('animation_sports_title'),
            items = {
                {label = _U('animation_sports_muscle'), type = "anim", data = {lib = "amb@world_human_muscle_flex@arms_at_side@base", anim = "base"}},
                {label = _U('animation_sports_weightbar'), type = "anim", data = {lib = "amb@world_human_muscle_free_weights@male@barbell@base", anim = "base"}},
                {label = _U('animation_sports_pushup'), type = "anim", data = {lib = "amb@world_human_push_ups@male@base", anim = "base"}},
                {label = _U('animation_sports_abs'), type = "anim", data = {lib = "amb@world_human_sit_ups@male@base", anim = "base"}},
                {label = _U('animation_sports_yoga'), type = "anim", data = {lib = "amb@world_human_yoga@male@base", anim = "base_a"}}
            }
        },
        {
            name = 'other',
            label = _U('animation_other_title'),
            items = {
                {label = _U('animation_other_sit'), type = "anim", data = {lib = "anim@heists@prison_heistunfinished_biztarget_idle", anim = "target_idle"}},
                {label = _U('animation_other_waitwall'), type = "scenario", data = {anim = "world_human_leaning"}},
                {label = _U('animation_other_ontheback'), type = "scenario", data = {anim = "WORLD_HUMAN_SUNBATHE_BACK"}},
                {label = _U('animation_other_stomach'), type = "scenario", data = {anim = "WORLD_HUMAN_SUNBATHE"}},
                {label = _U('animation_other_clean'), type = "scenario", data = {anim = "world_human_maid_clean"}},
                {label = _U('animation_other_cooking'), type = "scenario", data = {anim = "PROP_HUMAN_BBQ"}},
                {label = _U('animation_other_search'), type = "anim", data = {lib = "mini@prostitutes@sexlow_veh", anim = "low_car_bj_to_prop_female"}},
                {label = _U('animation_other_selfie'), type = "scenario", data = {anim = "world_human_tourist_mobile"}},
                {label = _U('animation_other_door'), type = "anim", data = {lib = "mini@safe_cracking", anim = "idle_base"}}
            }
        },
        {
            name = 'pegi',
            label = _U('animation_pegi_title'),
            items = {
                {label = _U('animation_pegi_hsuck'), type = "anim", data = {lib = "oddjobs@towing", anim = "m_blow_job_loop"}},
                {label = _U('animation_pegi_fsuck'), type = "anim", data = {lib = "oddjobs@towing", anim = "f_blow_job_loop"}},
                {label = _U('animation_pegi_hfuck'), type = "anim", data = {lib = "mini@prostitutes@sexlow_veh", anim = "low_car_sex_loop_player"}},
                {label = _U('animation_pegi_ffuck'), type = "anim", data = {lib = "mini@prostitutes@sexlow_veh", anim = "low_car_sex_loop_female"}},
                {label = _U('animation_pegi_scratch'), type = "anim", data = {lib = "mp_player_int_uppergrab_crotch", anim = "mp_player_int_grab_crotch"}},
                {label = _U('animation_pegi_charm'), type = "anim", data = {lib = "mini@strip_club@idles@stripper", anim = "stripper_idle_02"}},
                {label = _U('animation_pegi_golddigger'), type = "scenario", data = {anim = "WORLD_HUMAN_PROSTITUTE_HIGH_CLASS"}},
                {label = _U('animation_pegi_breast'), type = "anim", data = {lib = "mini@strip_club@backroom@", anim = "stripper_b_backroom_idle_b"}},
                {label = _U('animation_pegi_strip1'), type = "anim", data = {lib = "mini@strip_club@lap_dance@ld_girl_a_song_a_p1", anim = "ld_girl_a_song_a_p1_f"}},
                {label = _U('animation_pegi_strip2'), type = "anim", data = {lib = "mini@strip_club@private_dance@part2", anim = "priv_dance_p2"}},
                {label = _U('animation_pegi_stripfloor'), type = "anim", data = {lib = "mini@strip_club@private_dance@part3", anim = "priv_dance_p3"}}
            }
        },
        {
            name = 'attitudes',
            label = _U('animation_attitudes_title'),
            items = {
                {label = "Normal M", type = "attitude", data = {lib = "move_m@confident", anim = "move_m@confident"}},
                {label = "Normal F", type = "attitude", data = {lib = "move_f@heels@c", anim = "move_f@heels@c"}},
                {label = "Depressif", type = "attitude", data = {lib = "move_m@depressed@a", anim = "move_m@depressed@a"}},
                {label = "Depressif F", type = "attitude", data = {lib = "move_f@depressed@a", anim = "move_f@depressed@a"}},
                {label = "Business", type = "attitude", data = {lib = "move_m@business@a", anim = "move_m@business@a"}},
                {label = "Determine", type = "attitude", data = {lib = "move_m@brave@a", anim = "move_m@brave@a"}},
                {label = "Casual", type = "attitude", data = {lib = "move_m@casual@a", anim = "move_m@casual@a"}},
                {label = "Trop mange", type = "attitude", data = {lib = "move_m@fat@a", anim = "move_m@fat@a"}},
                {label = "Hipster", type = "attitude", data = {lib = "move_m@hipster@a", anim = "move_m@hipster@a"}},
                {label = "Blesse", type = "attitude", data = {lib = "move_m@injured", anim = "move_m@injured"}},
                {label = "Intimide", type = "attitude", data = {lib = "move_m@hurry@a", anim = "move_m@hurry@a"}},
                {label = "Hobo", type = "attitude", data = {lib = "move_m@hobo@a", anim = "move_m@hobo@a"}},
                {label = "Malheureux", type = "attitude", data = {lib = "move_m@sad@a", anim = "move_m@sad@a"}},
                {label = "Muscle", type = "attitude", data = {lib = "move_m@muscle@a", anim = "move_m@muscle@a"}},
                {label = "Choc", type = "attitude", data = {lib = "move_m@shocked@a", anim = "move_m@shocked@a"}},
                {label = "Sombre", type = "attitude", data = {lib = "move_m@shadyped@a", anim = "move_m@shadyped@a"}},
                {label = "Fatigue", type = "attitude", data = {lib = "move_m@buzzed", anim = "move_m@buzzed"}},
                {label = "Pressee", type = "attitude", data = {lib = "move_m@hurry_butch@a", anim = "move_m@hurry_butch@a"}},
                {label = "Fier", type = "attitude", data = {lib = "move_m@money", anim = "move_m@money"}},
                {label = "Petite course", type = "attitude", data = {lib = "move_m@quick", anim = "move_m@quick"}},
                {label = "Mangeuse d'homme", type = "attitude", data = {lib = "move_f@maneater", anim = "move_f@maneater"}},
                {label = "Impertinent", type = "attitude", data = {lib = "move_f@sassy", anim = "move_f@sassy"}},
                {label = "Arrogante", type = "attitude", data = {lib = "move_f@arrogant@a", anim = "move_f@arrogant@a"}}
            }
        }
    }
}

local sub = function(str)
    return cat .. "_" .. str
end

Astra.netRegisterAndHandle("cbF5Data", function(data)
    localData = data
end)

Astra.netRegisterAndHandle("cbTransaction", function(message)
    transaction = false
    if message then
        ESX.ShowNotification(message)
    end
end)

Astra.netHandle("openPersonnalMenu", function()
    if menuIsOpened then
        return
    end

    localData, localSelectedItem, localSelectedWeapon = nil, nil, nil

    menuIsOpened = true

    RMenu.Add(cat, sub("main"), RageUI.CreateMenu(title, desc, nil, nil, "tespascool", "interaction_bgd"))
    RMenu:Get(cat, sub("main")).Closed = function()
    end

    RMenu.Add(cat, sub("bills"), RageUI.CreateSubMenu(RMenu:Get(cat, sub("main")), title, desc, nil, nil, "tespascool", "interaction_bgd"))
    RMenu:Get(cat, sub("bills")).Closed = function()
    end

    RMenu.Add(cat, sub("identity"), RageUI.CreateSubMenu(RMenu:Get(cat, sub("main")), title, desc, nil, nil, "tespascool", "interaction_bgd"))
    RMenu:Get(cat, sub("identity")).Closed = function()
    end

    RMenu.Add(cat, sub("identity_self"), RageUI.CreateSubMenu(RMenu:Get(cat, sub("identity")), title, desc, nil, nil, "tespascool", "interaction_bgd"))
    RMenu:Get(cat, sub("identity_self")).Closed = function()
    end

    RMenu.Add(cat, sub("identity_accounts"), RageUI.CreateSubMenu(RMenu:Get(cat, sub("identity")), title, desc, nil, nil, "tespascool", "interaction_bgd"))
    RMenu:Get(cat, sub("identity_accounts")).Closed = function()
    end

    RMenu.Add(cat, sub("inv"), RageUI.CreateSubMenu(RMenu:Get(cat, sub("main")), title, desc, nil, nil, "tespascool", "interaction_bgd"))
    RMenu:Get(cat, sub("inv")).Closed = function()
    end

    RMenu.Add(cat, sub("inv_obj"), RageUI.CreateSubMenu(RMenu:Get(cat, sub("inv")), title, desc, nil, nil, "tespascool", "interaction_bgd"))
    RMenu:Get(cat, sub("inv_obj")).Closed = function()
    end

    RMenu.Add(cat, sub("inv_obj_select"), RageUI.CreateSubMenu(RMenu:Get(cat, sub("inv_obj")), title, desc, nil, nil, "tespascool", "interaction_bgd"))
    RMenu:Get(cat, sub("inv_obj_select")).Closed = function()
    end

    RMenu.Add(cat, sub("inv_weapon"), RageUI.CreateSubMenu(RMenu:Get(cat, sub("inv")), title, desc, nil, nil, "tespascool", "interaction_bgd"))
    RMenu:Get(cat, sub("inv_weapon")).Closed = function()
    end

    RMenu.Add(cat, sub("inv_weapon_select"), RageUI.CreateSubMenu(RMenu:Get(cat, sub("inv_weapon")), title, desc, nil, nil, "tespascool", "interaction_bgd"))
    RMenu:Get(cat, sub("inv_weapon_select")).Closed = function()
    end

    RMenu.Add(cat, 'animation', RageUI.CreateSubMenu(RMenu:Get(cat, sub("main")), title, desc, nil, nil, "tespascool", "interaction_bgd"))
    RMenu:Get(cat, 'animation').Closed = function()
    end

    for i = 1, #Config.Animations, 1 do
        RMenu.Add('animation', Config.Animations[i].name, RageUI.CreateSubMenu(RMenu.Get(cat, 'animation'), Config.Animations[i].label))
    end


    RageUI.Visible(RMenu:Get(cat, sub("main")), true)

    Astra.newThread(function()
        while menuIsOpened do
            local shouldStayOpened = false
            local function tick()
                shouldStayOpened = true
            end

            RageUI.IsVisible(RMenu:Get(cat, sub("main")), true, true, true, function()
                tick()
                RageUI.Separator("↓ ~g~Menu personnel ~s~↓")

                RageUI.ButtonWithStyle("Inventaire", nil, { RightLabel = "→→" }, true, function(_, _, s)
                end, RMenu:Get(cat, sub("inv")))

                RageUI.ButtonWithStyle("Portefeuille", nil, { RightLabel = "→→" }, true, function(_, _, s)
                end, RMenu:Get(cat, sub("identity")))

                RageUI.ButtonWithStyle("Factures", nil, { RightLabel = "→→" }, true, function(_, _, s)
                    if s then
                        ESX.TriggerServerCallback('menugetbills', function(b) bills = b print(json.encode(b)) end)
                    end
                end, RMenu:Get(cat, sub("bills")))

                -- Vétements & accessoires
                RageUI.ButtonWithStyle("Personnage", nil, { RightLabel = "→→" }, true, function(_, _, s)
                    if s then

                    end
                end)

                RageUI.ButtonWithStyle("Animations", nil, { RightLabel = "→→" }, true, function(_, _, s)
                end, RMenu:Get(cat, 'animation'))

                RageUI.ButtonWithStyle("Gestion", nil, { RightLabel = "→→" }, true, function(_, _, s)
                    if s then

                    end
                end)

                RageUI.ButtonWithStyle("Véhicule", nil, { RightLabel = "→→" }, IsPedInAnyVehicle(PlayerPedId(), false), function(_, _, s)
                end)
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get(cat, 'animation'), true, true, true, function()
                tick()
                RageUI.Separator("↓ ~g~Animations ~s~↓")
                for i = 1, #Config.Animations, 1 do
                    RageUI.ButtonWithStyle(Config.Animations[i].label, nil, {RightLabel = "→→→"}, true, function() end, RMenu:Get(cat, Config.Animations[i].name))
                end
            end, function()
            end)


            RageUI.IsVisible(RMenu:Get(cat, sub("bills")), true, true, true, function()
                tick()
                RageUI.Separator("↓ ~g~Mes factures ~s~↓")
                local it = 0
                for i = 1, #bills, 1 do
                    it = (it+1)
                    RageUI.Button(bills[i].label, nil, {RightLabel = '$' .. ESX.Math.GroupDigits(bills[i].amount)}, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            ESX.TriggerServerCallback('::{korioz#0110}::esx_billing:payBill', function()
                                ESX.TriggerServerCallback('::{korioz#0110}::KorioZ-PersonalMenu:Bill_getBills', function(b) bills = b end)
                            end, bills[i].id)
                        end
                    end)
                end
                if it <= 0 then
                    RageUI.ButtonWithStyle("Vous êtes en règle !", nil, {}, true)
                end
            end, function()
            end)


            RageUI.IsVisible(RMenu:Get(cat, sub("identity")), true, true, true, function()
                tick()
                RageUI.Separator("↓ ~g~Mon personnage ~s~↓")
                RageUI.ButtonWithStyle("Mon identité", nil, { RightLabel = "→→" }, true, function(_, _, s)
                end, RMenu:Get(cat, sub("identity_self")))

                RageUI.ButtonWithStyle("Mes comptes", nil, { RightLabel = "→→" }, true, function(_, _, s)
                end, RMenu:Get(cat, sub("identity_accounts")))
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get(cat, sub("identity_self")), true, true, true, function()
                tick()
                RageUI.Separator("↓ ~g~Informations ~s~↓")
                RageUI.ButtonWithStyle(("Métier: %s (~o~%s~s~)"):format(localData.job.label, localData.job.grade_label), nil, {}, true)
                RageUI.ButtonWithStyle(("Orga: %s (~o~%s~s~)"):format(localData.orga.label, localData.orga.grade_label), nil, {}, true)
                RageUI.Separator("↓ ~y~Interactions ~s~↓")
                RageUI.ButtonWithStyle("Montrer ma carte d'identité", nil, {}, true, function(_,_,s)
                    if s then
                        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

                        if closestDistance ~= -1 and closestDistance <= 3.0 then
                            ESX.ShowNotification("~o~Vous montrez vos papiers...")
                            TriggerServerEvent('::{korioz#0110}::jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer))
                        else
                            ESX.ShowNotification("~r~Aucun joueur à proximité !")
                        end
                    end
                end)
                RageUI.ButtonWithStyle("Montrer mon permis de conduire", nil, {}, true, function(_,_,s)
                    if s then
                        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

                        if closestDistance ~= -1 and closestDistance <= 3.0 then
                            ESX.ShowNotification("~o~Vous montrez vos papiers...")
                            TriggerServerEvent('::{korioz#0110}::jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer), 'driver')
                        else
                            ESX.ShowNotification("~r~Aucun joueur à proximité !")
                        end
                    end
                end)
                RageUI.ButtonWithStyle("Montrer mon permis de port d'arme", nil, {}, true, function(_,_,s)
                    if s then
                        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

                        if closestDistance ~= -1 and closestDistance <= 3.0 then
                            ESX.ShowNotification("~o~Vous montrez vos papiers...")
                            TriggerServerEvent('::{korioz#0110}::jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer), 'weapon')
                        else
                            ESX.ShowNotification("~r~Aucun joueur à proximité !")
                        end
                    end
                end)
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get(cat, sub("identity_accounts")), true, true, true, function()
                tick()
                RageUI.Separator("↓ ~g~Comptes ~s~↓")
                for k,v in pairs(localData.accounts) do
                    if availableAccounts[v.name] then
                        RageUI.ButtonWithStyle(("Argent (%s~s~): ~g~%s$"):format(availableAccounts[v.name], ESX.Math.GroupDigits(v.money)), nil, {}, true, function(_,_,s)

                        end)
                    end
                end
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get(cat, sub("inv")), true, true, true, function()
                tick()
                RageUI.Separator("↓ ~g~Mon sac ~s~↓")
                RageUI.ButtonWithStyle("Objets", nil, { RightLabel = "→→" }, true, function(_, _, s)
                end, RMenu:Get(cat, sub("inv_obj")))

                RageUI.ButtonWithStyle("Armes", nil, { RightLabel = "→→" }, true, function(_, _, s)
                end, RMenu:Get(cat, sub("inv_weapon")))
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get(cat, sub("inv_obj")), true, true, true, function()
                tick()
                RageUI.Separator("↓ ~g~Mes objets ~s~↓")
                local it = 0
                for k,v in pairs(localData.inventory) do
                    it = (it + 1)
                    RageUI.ButtonWithStyle(("%s ~b~(%s)"):format(v.label, ESX.Math.GroupDigits(v.count)), nil, {}, true, function(_,_,s)
                        if s then
                            localSelectedItem = k
                        end
                    end, RMenu:Get(cat, sub("inv_obj_select")))
                end
                if it <= 0 then
                    RageUI.Separator("")
                    RageUI.Separator("~r~C'est bien vide ici...")
                    RageUI.Separator("~r~(Vous n'avez aucun objet)")
                    RageUI.Separator("")
                end
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get(cat, sub("inv_weapon")), true, true, true, function()
                tick()
                RageUI.Separator("↓ ~g~Mes armes ~s~↓")
                local it = 0
                for k,v in pairs(localData.weapons) do
                    it = (it + 1)
                    RageUI.ButtonWithStyle(("%s ~b~(%s balles)"):format(k, ESX.Math.GroupDigits(v[1])), nil, {}, true, function(_,_,s)
                        if s then
                            localSelectedWeapon = k
                        end
                    end, RMenu:Get(cat, sub("inv_weapon_select")))
                end
                if it <= 0 then
                    RageUI.Separator("")
                    RageUI.Separator("~r~C'est bien vide ici...")
                    RageUI.Separator("~r~(Vous n'avez aucune arme)")
                    RageUI.Separator("")
                end
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get(cat, sub("inv_weapon_select")), true, true, true, function()
                tick()
                if transaction then
                    RageUI.Separator("")
                    RageUI.Separator(("%sTransaction avec le serveur en cours..."):format(AstraGameUtils.dangerVariator))
                    RageUI.Separator("")
                else
                    if localSelectedWeapon and localData.weapons[localSelectedWeapon] then
                        RageUI.Separator(("↓ ~g~%s ~b~(%s balles)~s~ ↓"):format(localSelectedWeapon, ESX.Math.GroupDigits(localData.weapons[localSelectedWeapon][1])))
                        RageUI.ButtonWithStyle("Donner (~r~Arme~s~)", nil, {}, true, function(_,_,s)
                            if s then
                                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

                                if closestDistance ~= -1 and closestDistance <= 3 then
                                    local closestPed = GetPlayerPed(closestPlayer)

                                    if IsPedOnFoot(closestPed) then
                                        TriggerServerEvent('::{korioz#0110}::esx:giveInventoryItem', GetPlayerServerId(closestPlayer), 'item_weapon', localData.weapons[localSelectedWeapon][2], nil)
                                        AstraClientUtils.toServer("requestF5Infos")
                                    else
                                        ESX.ShowNotification("~r~Aucun joueur à proximité !")
                                    end
                                else
                                    ESX.ShowNotification("~r~Aucun joueur à proximité !")
                                end
                            end
                        end)
                        RageUI.ButtonWithStyle("Donner (~o~Munitions~s~)", nil, {}, true, function(_,_,s)
                            if s then
                                local qty = AstraMenuUtils.inputBox("Quantité", "", 5, true)
                                if qty ~= nil and tonumber(qty) ~= nil and tonumber(qty) > 0 then
                                    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

                                    if closestDistance ~= -1 and closestDistance <= 3 then
                                        local closestPed = GetPlayerPed(closestPlayer)

                                        if IsPedOnFoot(closestPed) then
                                            TriggerServerEvent('::{korioz#0110}::esx:giveInventoryItem', GetPlayerServerId(closestPlayer), 'item_ammo', localData.weapons[localSelectedWeapon][2], qty)
                                            AstraClientUtils.toServer("requestF5Infos")
                                        else
                                            ESX.ShowNotification("~r~Aucun joueur à proximité !")
                                        end
                                    else
                                        ESX.ShowNotification("~r~Aucun joueur à proximité !")
                                    end
                                else
                                    ESX.ShowNotification("~r~Quantité invalide !")
                                end
                            end
                        end)
                    else
                        RageUI.GoBack()
                    end
                end
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get(cat, sub("inv_obj_select")), true, true, true, function()
                tick()
                if transaction then
                    RageUI.Separator("")
                    RageUI.Separator(("%sTransaction avec le serveur en cours..."):format(AstraGameUtils.dangerVariator))
                    RageUI.Separator("")
                else
                    if localSelectedItem and localData.inventory[localSelectedItem] then
                        RageUI.Separator(("↓ ~g~%s ~b~(%s)~s~ ↓"):format(localData.inventory[localSelectedItem].label, ESX.Math.GroupDigits(localData.inventory[localSelectedItem].count)))
                        RageUI.ButtonWithStyle("Utiliser", nil, {}, true, function(_,_,s)
                            if s then
                                TriggerServerEvent('::{korioz#0110}::esx:useItem', localSelectedItem)
                                AstraClientUtils.toServer("requestF5Infos")
                            end
                        end)

                        RageUI.ButtonWithStyle("Donner", nil, {}, true, function(_,_,s)
                            if s then
                                local qty = AstraMenuUtils.inputBox("Quantité", "", 5, true)
                                if qty ~= nil and tonumber(qty) ~= nil and tonumber(qty) > 0 then
                                    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

                                    if closestDistance ~= -1 and closestDistance <= 3 then
                                        local closestPed = GetPlayerPed(closestPlayer)

                                        if IsPedOnFoot(closestPed) then
                                            TriggerServerEvent('::{korioz#0110}::esx:giveInventoryItem', GetPlayerServerId(closestPlayer), 'item_standard', localSelectedItem, tonumber(qty))
                                            AstraClientUtils.toServer("requestF5Infos")
                                        else
                                            ESX.ShowNotification("~r~Aucun joueur à proximité !")
                                        end
                                    else
                                        ESX.ShowNotification("~r~Aucun joueur à proximité !")
                                    end
                                else
                                    ESX.ShowNotification("~r~Quantité invalide !")
                                end
                            end
                        end)

                        RageUI.ButtonWithStyle("Jeter", nil, {}, localData.inventory[localSelectedItem].canDrop, function(_,_,s)
                            if s then
                                transaction = true
                                AstraClientUtils.toServer("requestDropItem", localSelectedItem)
                            end
                        end)
                    else
                        RageUI.GoBack()
                    end
                end
            end, function()
            end)

            if not shouldStayOpened and menuIsOpened then
                menuIsOpened = false
            end
            Wait(0)
        end
        RMenu:Delete(cat, sub("main"))
        RMenu:Delete(cat, sub("inv"))
        RMenu:Delete(cat, sub("inv_obj"))
        RMenu:Delete(cat, sub("inv_obj_select"))
        RMenu:Delete(cat, sub("inv_weapon"))
        RMenu:Delete(cat, sub("inv_weapon_select"))
    end)

    AstraClientUtils.toServer("requestF5Infos")
end)