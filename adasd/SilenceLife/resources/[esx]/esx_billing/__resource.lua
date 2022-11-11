resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'Hamudi Billing'

author 'nico-pergande.dev'

version '2.3.1'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'locales/de.lua',
	'locales/en.lua',
	'config.lua',
	'server/main.lua'
}

client_scripts {
	'@es_extended/locale.lua',
	'locales/de.lua',
	'locales/en.lua',
	'config.lua',
	'client/main.lua'
}

dependency 'es_extended'