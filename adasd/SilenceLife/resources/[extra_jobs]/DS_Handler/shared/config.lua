Config = {}

Config.Debug = true

Config.Framework = 'ESX'

Config.AutoHideRadar = false

Config.PedDataRefreshInterval = 100
Config.ReycastDistance = 40

Config.MinimumCrashForce = 900
Config.MinimumCrashSpeed = 25

Config.Directions = {
	[0] = 'N',
	[45] = 'NW',
	[90] = 'W',
	[135] = 'SW', 
	[180] = 'S', 
	[225] = 'SE', 
	[270] = 'E', 
	[315] = 'NE', 
	[360] = 'N'
}

Config.Zones = {
	['AIRP'] = 'Los Santos International Airport',
	['ALAMO'] = 'Alamo Sea',
	['ALTA'] = 'Alta',
	['ARMYB'] = 'Fort Zancudo',
	['BANHAMC'] = 'Banham Canyon Dr',
	['BANNING'] = 'Banning',
	['BEACH'] = 'Vespucci Beach',
	['BHAMCA'] = 'Banham Canyon',
	['BRADP'] = 'Braddock Pass',
	['BRADT'] = 'Braddock Tunnel',
	['BURTON'] = 'Burton',
	['CALAFB'] = 'Calafia Bridge',
	['CANNY'] = 'Raton Canyon',
	['CCREAK'] = 'Cassidy Creek',
	['CHAMH'] = 'Chamberlain Hills',
	['CHIL'] = 'Vinewood Hills',
	['CHU'] = 'Chumash',
	['CMSW'] = 'Chiliad Mountain State Wilderness',
	['CYPRE'] = 'Cypress Flats',
	['DAVIS'] = 'Davis',
	['DELBE'] = 'Del Perro Beach',
	['DELPE'] = 'Del Perro',
	['DELSOL'] = 'La Puerta',
	['DESRT'] = 'Grand Senora Desert',
	['DOWNT'] = 'Downtown',
	['DTVINE'] = 'Downtown Vinewood',
	['EAST_V'] = 'East Vinewood',
	['EBURO'] = 'El Burro Heights',
	['ELGORL'] = 'El Gordo Lighthouse',
	['ELYSIAN'] = 'Elysian Island',
	['GALFISH'] = 'Galilee',
	['GOLF'] = 'GWC and Golfing Society',
	['GRAPES'] = 'Grapeseed',
	['GREATC'] = 'Great Chaparral',
	['HARMO'] = 'Harmony',
	['HAWICK'] = 'Hawick',
	['HORS'] = 'Vinewood Racetrack',
	['HUMLAB'] = 'Humane Labs and Research',
	['JAIL'] = 'Bolingbroke Penitentiary',
	['KOREAT'] = 'Little Seoul',
	['LACT'] = 'Land Act Reservoir',
	['LAGO'] = 'Lago Zancudo',
	['LDAM'] = 'Land Act Dam',
	['LEGSQU'] = 'Legion Square',
	['LMESA'] = 'La Mesa',
	['LOSPUER'] = 'La Puerta',
	['MIRR'] = 'Mirror Park',
	['MORN'] = 'Morningwood',
	['MOVIE'] = 'Richards Majestic',
	['MTCHIL'] = 'Mount Chiliad',
	['MTGORDO'] = 'Mount Gordo',
	['MTJOSE'] = 'Mount Josiah',
	['MURRI'] = 'Murrieta Heights',
	['NCHU'] = 'North Chumash',
	['NOOSE'] = 'N.O.O.S.E',
	['OCEANA'] = 'Pacific Ocean',
	['PALCOV'] = 'Paleto Cove',
	['PALETO'] = 'Paleto Bay',
	['PALFOR'] = 'Paleto Forest',
	['PALHIGH'] = 'Palomino Highlands',
	['PALMPOW'] = 'Palmer-Taylor Power Station',
	['PBLUFF'] = 'Pacific Bluffs',
	['PBOX'] = 'Pillbox Hill',
	['PROCOB'] = 'Procopio Beach',
	['RANCHO'] = 'Rancho',
	['RGLEN'] = 'Richman Glen',
	['RICHM'] = 'Richman',
	['ROCKF'] = 'Rockford Hills',
	['RTRAK'] = 'Redwood Lights Track',
	['SANAND'] = 'San Andreas',
	['SANCHIA'] = 'San Chianski Mountain Range',
	['SANDY'] = 'Sandy Shores',
	['SKID'] = 'Mission Row',
	['SLAB'] = 'Stab City',
	['STAD'] = 'Maze Bank Arena',
	['STRAW'] = 'Strawberry',
	['TATAMO'] = 'Tataviam Mountains',
	['TERMINA'] = 'Terminal',
	['TEXTI'] = 'Textile City',
	['TONGVAH'] = 'Tongva Hills',
	['TONGVAV'] = 'Tongva Valley',
	['VCANA'] = 'Vespucci Canals',
	['VESP'] = 'Vespucci',
	['VINE'] = 'Vinewood',
	['WINDF'] = 'Ron Alternates Wind Farm',
	['WVINE'] = 'West Vinewood',
	['ZANCUDO'] = 'Zancudo River',
	['ZP_ORT'] = 'Port of South Los Santos',
	['ZQ_UAR'] = 'Davis Quartz'
}

Config.ScriptZones = {
	['test'] = {
		Name = 'test',
		Job = false,
		DrawText = 'Press [~g~E~w~] to test',
		TextDistance = 10,
		InteractDistance = 2,
		Positions = {
			[1] = {x = 0.0, y = 0.0, z = 0.0},
		},
		Metadata = {}
	},
}