fx_version 'cerulean'
games {'gta5'}

author 'Clementinise'
description 'RepairKit script for FiveM ESX servers'
version '3.2'

client_scripts {
	'@es_extended/locale.lua',

	'config.lua',
	'client/*.lua',
	'locales/*.lua'
}

server_scripts {
	'@es_extended/locale.lua',

	'config.lua',
	'server/*.lua',
	'locales/*.lua'
}
