--      Misc
--
game        'gta5'
fx_version  'cerulean'
lua54       'yes'

author      'SilenceLife'
description 'SilenceLife Server'
version     '1.0'

--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--
--      Files
--
--ui_page 'html/index.html'
--files   { "html/**"}

files {
    "data/**",
}

data_file "WEAPONINFO_FILE_PATCH"   "data/Weapons/*.meta"

data_file 'WEAPON_METADATA_FILE'   'data/Lasertag/weaponarchetypesSPR.meta'
data_file 'WEAPON_ANIMATIONS_FILE' 'data/Lasertag/weaponanimationsSPR.meta'
data_file 'WEAPONINFO_FILE'        'data/Lasertag/weaponSPR.meta'
data_file 'WEAPONINFO_FILE_PATCH'  'data/Lasertag/weapons.meta'
data_file 'TEXTFILE_METAFILE'      'data/Lasertag/dlctext.meta'
data_file 'PED_PERSONALITY_FILE'   'data/Lasertag/pedpersonalitySPR.meta'



--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--
--      wichtige Resources
--
dependency {
    "es_extended",
}

--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--
--      Client
--
client_scripts {    
	'@es_extended/locale.lua',
    "locales/**",
    "config/**",    
    "client/_global/_main.lua",
    "client/ui/NativeUI.lua",
    "client/**"
}

--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--
--      Server
--
server_scripts {    
	'@async/async.lua',
	'@mysql-async/lib/MySQL.lua',
	'@oxmysql/lib/MySQL.lua',
	'@es_extended/locale.lua',
    "locales/**",
    "config/**",
    "server/_global/_main.lua",
    "server/**"    
}

--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--
--      Exports
--
exports {
    "Exp_XNL_SetInitialXPLevels",
    "Exp_XNL_AddPlayerXP",
    "Exp_XNL_RemovePlayerXP",
    "Exp_XNL_GetCurrentPlayerXP",
    "Exp_XNL_GetLevelFromXP",
    "Exp_XNL_GetCurrentPlayer",
    "Exp_XNL_GetCurrentPlayerLevel",
    "getDeathCause",
    "getLevelFromXP"
}

--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
