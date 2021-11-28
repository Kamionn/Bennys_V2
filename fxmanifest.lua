fx_version 'cerulean'
games { 'gta5' };

description "kbennys -> https://discord.gg/3tMabKgXgX"

version "2.0"

Author "kamion"

shared_scripts {
    "shared/config.lua",
}

client_scripts {
    "RageUI/RMenu.lua",
    "RageUI/menu/RageUI.lua",
    "RageUI/menu/Menu.lua",
    "RageUI/menu/MenuController.lua",
    "RageUI/components/*.lua",
    "RageUI/menu/elements/*.lua",
    "RageUI/menu/items/*.lua",
    "RageUI/menu/panels/*.lua",
    "RageUI/menu/windows/*.lua",
}

client_scripts {
    '@es_extended/locale.lua',
    'client/kcl_garage.lua',
    'client/kcl_menu.lua',
    'client/kcl_boss.lua',
    'client/kcl_coffre.lua',
    'client/kcl_ped.lua',
    'client/kcl_accueil.lua',
    'client/kcl_kcl_blips.lua'
}

server_script {
    '@mysql-async/lib/MySQL.lua',
    '@es_extended/locale.lua',
    'server/kserver.lua',
}