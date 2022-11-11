version '5.5'

author 'jaksam1074'

client_scripts {
    -- Callbacks
    "utils/callbacks/cl_callbacks.lua",

    -- Miscellaneous
    "utils/miscellaneous/sh_miscellaneous.lua",
    "utils/miscellaneous/cl_miscellaneous.lua",

    -- Settings
    "utils/settings/cl_settings.lua",

    -- Framework
    'utils/framework/sh_framework.lua',
    'utils/framework/cl_framework.lua',

    -- Integrations
    'integrations/sh_*.lua',
    'integrations/cl_*.lua',

    -- Locales
    "locales/*",
    
    -- Actual client files
    'client/actions/*.lua',
    'client/markers/*.lua',
    'client/main.lua',
    'client/nui_callbacks.lua'
}

server_scripts {
    -- Dependency
    '@mysql-async/lib/MySQL.lua',
    
    -- Callbacks
    "utils/callbacks/sv_callbacks.lua",

    -- Miscellaneous
    "utils/miscellaneous/sh_miscellaneous.lua",
    "utils/miscellaneous/sv_miscellaneous.lua",

    -- Settings
    "utils/settings/sv_settings.lua",

    -- Framework
    'utils/framework/sh_framework.lua',
    'utils/framework/sv_framework.lua',    

    -- Dependency
    '@mysql-async/lib/MySQL.lua',

    -- Integrations
    'integrations/sh_*.lua',
    'integrations/sv_*.lua',

    -- Locales
    'locales/*.lua',
    
    -- Database creation
    'utils/database/database.lua',
    
    -- Actual server files
    'server/main.lua',
    'server/code_integrator.lua',
    'server/functions.lua',
    'server/actions.lua',
    'server/markers/*.lua',
    'server/database.lua',
}

ui_page 'html/index.html'

files {
    'html/menu_translations/*.json',
    'html/index.html',
    'html/index.js',
    'html/index.css',
}

fx_version 'cerulean'
game 'gta5'

dependencies {
    '/onesync',
    '/server:4752'
}

lua54 'yes' 

escrow_ignore {
    -- Integration files
    "integrations/*.lua",

    -- Locales
    "locales/*.lua",

    -- Exceptions 
    "client/actions/actions.lua",
    "client/markers/garage_owned.lua",
    "server/markers/garage_owned.lua",
}
dependency '/assetpacks'