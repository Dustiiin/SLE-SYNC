fx_version 'bodacious'
game 'gta5'

author 'myScripts'
description 'myClothesshop'
version '2.0.0'

lua54 'yes'

escrow_ignore {
  'config.lua',
  'client.lua',
  'server.lua',
}


client_scripts {
    "@NativeUILua_Reloaded/src/NativeUIReloaded.lua",
    'config.lua',
    'client_escrow.lua',
    'client.lua',
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'config.lua',
	'server.lua',
}
dependency '/assetpacks'
dependency '/assetpacks'