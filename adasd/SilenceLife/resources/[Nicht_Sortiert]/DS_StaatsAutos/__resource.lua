resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'Carpack v1'

files {
	'data/**/carcols.meta',
	'data/**/carvariations.meta',
	'data/**/handling.meta',
	'data/**/vehiclelayouts.meta',
	'data/**/vehicles.meta',
	'data/**/clip_sets.xml',
	'data/vehiclelayouts_formula.meta',
	'data/vehiclelayouts_zhaba.meta',
	'data/vehiclelayouts.meta',
  	'data/vehiclelayouts_rrocket.meta',
  	'data/vehiclelayouts_s80.meta',
  	'data/vehicleweapons_paragon2.meta',
}

	data_file 'VEHICLE_LAYOUTS_FILE'	'data/**/vehiclelayouts.meta'
	data_file 'HANDLING_FILE'			'data/**/handling.meta'
	data_file 'VEHICLE_METADATA_FILE'	'data/**/vehicles.meta'
	data_file 'CARCOLS_FILE'			'data/**/carcols.meta'
	data_file 'VEHICLE_VARIATION_FILE'	'data/**/carvariations.meta'
	data_file 'DLC_LIST_FILE'            'data/**/uparmorhmvdes/dlclist.xml'
	data_file 'CLIP_SETS_FILE' 'data/**/clip_sets.xml'
	data_file 'VEHICLE_LAYOUTS_FILE' 'data/vehiclelayouts_formula.meta'
	data_file 'VEHICLE_LAYOUTS_FILE' 'data/vehiclelayouts_zhaba.meta'
	data_file 'VEHICLE_LAYOUTS_FILE' 'data/vehiclelayouts.meta'
	data_file 'VEHICLE_LAYOUTS_FILE' 'data/vehiclelayouts_rrocket.meta'
	data_file 'VEHICLE_LAYOUTS_FILE' 'data/vehiclelayouts_s80.meta'
	data_file 'WEAPONINFO_FILE' 'data/vehicleweapons_paragon2.meta'




client_script 'names.lua'