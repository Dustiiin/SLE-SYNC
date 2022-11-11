resource_manifest_version '77731fab-63ca-442c-a67b-abc70f28dfa5'

files {
    'vehicles.meta',
    'carvariations.meta',
    'carcols.meta',
    'handling.meta',
    'vehiclelayouts.meta',
    'audioconfig/w211_game.dat151.nametable',
    'audioconfig/w211_game.dat151.rel',
    'audioconfig/w211_sounds.dat54.nametable',
    'audioconfig/w211_sounds.dat54.rel',
    'sfx/dlc_w211/w211.awc',
    'sfx/dlc_w211/w211_npc.awc',
}

data_file 'HANDLING_FILE' 'handling.meta'
data_file 'VEHICLE_METADATA_FILE' 'vehicles.meta'
data_file 'CARCOLS_FILE' 'carcols.meta'
data_file 'VEHICLE_VARIATION_FILE' 'carvariations.meta'
data_file 'VEHICLE_LAYOUTS_FILE' 'vehiclelayouts.meta'
data_file 'AUDIO_GAMEDATA' 'audioconfig/w211_game.dat'
data_file 'AUDIO_SOUNDDATA' 'audioconfig/w211_sounds.dat'
data_file 'AUDIO_WAVEPACK' 'sfx/dlc_w211'

client_script 'vehicle_names.lua'