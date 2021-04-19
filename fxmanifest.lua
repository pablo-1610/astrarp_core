--[[
  This file is part of Astra RolePlay.

  Copyright (c) Astra RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

fx_version 'adamant'

game 'gta5'

ui_page "web/index.html"

files {
    'web/index.html',
    'web/*.js',
    'client/sound/html/imgs/*.svg',
    'client/sound/html/imgs/*.png',
    'web/sounds/*.ogg'
}

shared_scripts {
    "shared/main.lua",
    "shared/utils/*.lua",
    "modules/**/shared/*.lua",
    "addons/**/shared/*.lua"
}

client_scripts {
    "client/jobList.lua",
    "client/main.lua",

    "client/utils/*.lua",

    "modules/**/client/*.lua",
    "modules/**/client/objects/*.lua",

    "addons/**/client/*.lua",
    "addons/**/client/objects/*.lua",

    "addons/teamspeak/client/radios/*.lua",

    "services/RageUI/client/RMenu.lua",
    "services/RageUI/client/menu/RageUI.lua",
    "services/RageUI/client/menu/Menu.lua",
    "services/RageUI/client/menu/MenuController.lua",
    "services/RageUI/client/components/*.lua",
    "services/RageUI/client/menu/elements/*.lua",
    "services/RageUI/client/menu/items/*.lua",
    "services/RageUI/client/menu/panels/*.lua",
    "services/RageUI/client/menu/windows/*.lua",
}

server_scripts {
    "@mysql-async/lib/MySQL.lua",
    "server/*.lua",
    "server/utils/*.lua",

    "modules/**/server/*.lua",
    "modules/**/server/objects/*.lua",

    "addons/**/server/*.lua",
    "addons/**/server/objects/*.lua",
    "addons/tasks/server/tasks/*.lua"
}