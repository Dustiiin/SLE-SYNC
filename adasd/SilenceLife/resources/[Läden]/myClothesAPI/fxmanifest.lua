fx_version 'bodacious'
game 'gta5'

author 'myScripts'
description 'myClothesApi'
version '1.1.0'

lua54 'yes'

escrow_ignore {
  'config.lua',
  'client.lua',
  'server.lua',
}

client_scripts {
	'@NativeUI/NativeUI.lua',
	'config.lua',
	'client.lua',
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'config.lua',
	'server.lua',
	
}
dependency '/assetpacks'