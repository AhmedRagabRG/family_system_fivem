-- FXVersion Version
fx_version 'adamant'
games { 'gta5' }

-- Client Scripts
client_scripts {
    'client/main.lua'
}

-- Server Scripts
server_scripts {
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