-- FXVersion Version
fx_version 'adamant'
games { 'gta5' }

-- Shared Scripts
shared_script '@es_extended/imports.lua'

-- Client Scripts
client_scripts {
    'config.lua',
    'client/utility.lua',
    'client/main.lua'
}

-- Server Scripts
server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'config.lua',
    'server/main.lua'
}

-- NUI Default Page
ui_page "client/html/index.html"

-- Files needed for NUI
-- DON'T FORGET TO ADD THE SOUND FILES TO THIS!
files {
    'client/html/index.html',
    -- Begin Sound Files Here...
    -- client/html/sounds/ ... .ogg
    'client/html/sounds/*.ogg'
}
