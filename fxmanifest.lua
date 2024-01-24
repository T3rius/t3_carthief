fx_version 'cerulean'
game 'gta5'
author 'terius2474'
description 'T3_Carthief'
version '1.0'
lua54 'yes'

client_scripts {
    'client/cl_**.lua',
}

server_scripts {
    'server/sv_**.lua',
}

shared_scripts {
    '@es_extended/imports.lua',
    '@es_extended/locale.lua',
    '@ox_lib/init.lua',
    'shared/**.lua',
    'locales/*.lua',
}