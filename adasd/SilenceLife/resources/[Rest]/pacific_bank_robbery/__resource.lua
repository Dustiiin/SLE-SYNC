-- ESX Service

resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

client_scripts {
	"config.lua",
	"client/functions.lua",
	"client/computer.lua",
	"client/main.lua"
}

server_scripts {
	"config.lua",
	"server/main.lua"
}

this_is_a_map 'yes'