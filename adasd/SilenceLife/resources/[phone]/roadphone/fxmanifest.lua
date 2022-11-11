fx_version 'bodacious'

game 'gta5'

author 'RoadToSix'
description 'RoadPhone FiveM Phone'
version '0.6.2.1'

lua54 'yes'

ui_page 'public/html/static/index.html'

data_file 'DLC_ITYP_REQUEST' 'stream/prop/phone.ytyp'

files {
    'public/html/static/fonts/fontawesome-free-6.2.0-web/css/*.css',
    'public/html/static/fonts/fontawesome-free-6.2.0-web/webfonts/**.**',
    'public/html/static/fonts/*.*',
    "public/html/static/module/*.js",
    "public/html/static/module/**/**/*.js",
    "public/html/static/module/**/**/**/*.js",
    "public/html/static/module/**/*.js",
    'public/html/static/index.html',
    'public/html/static/*.js',
    'public/html/static/**/*.js',
    'public/html/static/config/*.json',
    'public/html/static/img/**/*.**',
    'public/html/static/img/icons/**/*.**',
    'public/html/static/img/icons/**/**/*.**',
    'public/html/static/css/*.css',
    'public/html/static/sound/*.ogg',
    'public/html/static/sound/games/snake/*.mp3'
}

shared_scripts {
    '@es_extended/locale.lua',
    'config.lua',
    'locales/*.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    "API.lua",
    "server/versionscheck.lua",
    "server/server.lua",
    "server/serverAPI/serverAPI.lua",
    "server/bank.lua",
    "server/encrochat.lua",
    "server/gps.lua",
    "server/yellowpages.lua",
    "server/serverAPI/garage.lua",
    "server/mail.lua",
    "server/crypto.lua"
}

client_scripts {
    'client/client.lua',
    'client/clientAPI.lua',
    'client/photo.lua',
    'client/yellowpages.lua',
    'client/vehicle_names.lua',
    'client/encrochat.lua',
    'client/garage.lua',
    'client/music.lua',
    'client/mail.lua'
    
}

dependencies {
    'es_extended',
	'oxmysql',
    'xsound'
}

escrow_ignore {
    'config.lua',
    'server/serverAPI/*.lua',
    'client/clientAPI.lua',
    'client/vehicle_names.lua',
    'client/photo.lua',
    'API.lua',
    'locales/*.lua'
}

exports {
    'isFlightmode',
    'isFlashlight',
    'togglePhone',
    'checkPhoneOpen',
    'getPhoneNumber',
    'isInCall',
    'startCall'
}

server_exports {
    'sendMessage',
    'getPlayerFromPhone',
    'removecrypto',
    'addcrypto',
    'checkcryptoamount',
    'addBankTransaction'
}


dependency '/assetpacks'