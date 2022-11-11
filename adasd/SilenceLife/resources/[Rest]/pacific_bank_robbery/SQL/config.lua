Config = {}
Config.Locale = 'en'

Config.DoorList = {

	--
	-- Mission Row First Floor
	--

	-- Entrance Doors
	{
		textCoords = vector3(434.7, -982.0, 31.5),
		authorizedJobs = { 'police' },
		locked = false,
		distance = 3.5,
		doors = {
			{
				objName = 'v_ilev_ph_door01',
				objYaw = -90.0,
				objCoords = vector3(434.7, -980.6, 30.8)
			},

			{
				objName = 'v_ilev_ph_door002',
				objYaw = -90.0,
				objCoords = vector3(434.7, -983.2, 30.8)
			}
		}
	},

	-- To locker room & roof
	{
		objName = 'v_ilev_ph_gendoor004',
		objYaw = 90.0,
		objCoords  = vector3(449.6, -986.4, 30.6),
		textCoords = vector3(450.1, -986.3, 31.7),
		authorizedJobs = { 'police' },
		locked = true,
		distance = 3,
	},

	-- Rooftop
	{
		objName = 'v_ilev_gtdoor02',
		objYaw = 90.0,
		objCoords  = vector3(464.3, -984.6, 43.8),
		textCoords = vector3(464.3, -984.0, 44.8),
		authorizedJobs = { 'police' },
		locked = true
	},

	-- Hallway to roof
	{
		objName = 'v_ilev_arm_secdoor',
		objYaw = 90.0,
		objCoords  = vector3(461.2, -985.3, 30.8),
		textCoords = vector3(461.5, -986.0, 31.5),
		authorizedJobs = { 'police' },
		locked = true,
		distance = 3,
	},

	-- Armory
	{
		objName = 'v_ilev_arm_secdoor',
		objYaw = -90.0,
		objCoords  = vector3(452.6, -982.7, 30.6),
		textCoords = vector3(453.0, -982.6, 31.7),
		authorizedJobs = { 'police' },
		locked = true,
		distance = 3,
	},

	-- Captain Office
	{
		objName = 'v_ilev_ph_gendoor002',
		objYaw = -180.0,
		objCoords  = vector3(447.2, -980.6, 30.6),
		textCoords = vector3(447.2, -980.0, 31.7),
		authorizedJobs = { 'police' },
		locked = true,
		distance = 3,
	},

	-- To downstairs (double doors)
	{
		textCoords = vector3(444.6, -989.4, 31.7),
		authorizedJobs = { 'police' },
		locked = true,
		distance = 4,
		doors = {
			{
				objName = 'v_ilev_ph_gendoor005',
				objYaw = 180.0,
				objCoords = vector3(443.9, -989.0, 30.6)
			},

			{
				objName = 'v_ilev_ph_gendoor005',
				objYaw = 0.0,
				objCoords = vector3(445.3, -988.7, 30.6)
			}
		}
	},
	
	-- extended rooms PD
	
	--entrance
	{
		textCoords = vector3(465.44, -990.0, 25.01),
		authorizedJobs = { 'police' },
		locked = true,
		distance = 3,
		doors = {
			{
				objName = 'v_ilev_ph_gendoor006',
				objYaw = 270.3,
				objCoords = vector3(465.55, -991.54, 24.98)
			},

			{
				objName = 'v_ilev_ph_gendoor006',
				objYaw = 90.0,
				objCoords = vector3(465.75, -988.96, 24.98)
			}
		}
	},
	--interogation room
	{
		objName = 'v_ilev_ph_gendoor006',
		objYaw = 90.0,
		objCoords  = vector3(470.8, -992.6, 24.9),
		textCoords = vector3(470.14, -994.37, 25.01),
		authorizedJobs = { 'police' },
		locked = true,
		distance = 3,
	},

	--
	-- Mission Row Cells
	--

	-- Main Cells
	{
		objName = 'v_ilev_ph_cellgate',
		objYaw = 0.0,
		objCoords  = vector3(463.8, -992.6, 24.9),
		textCoords = vector3(463.3, -992.6, 25.1),
		authorizedJobs = { 'police' },
		locked = true
	},

	-- Cell 1
	{
		objName = 'v_ilev_ph_cellgate',
		objYaw = -90.0,
		objCoords  = vector3(462.3, -993.6, 24.9),
		textCoords = vector3(461.8, -993.3, 25.0),
		authorizedJobs = { 'police' },
		locked = true
	},

	-- Cell 2
	{
		objName = 'v_ilev_ph_cellgate',
		objYaw = 90.0,
		objCoords  = vector3(462.3, -998.1, 24.9),
		textCoords = vector3(461.8, -998.8, 25.0),
		authorizedJobs = { 'police' },
		locked = true
	},

	-- Cell 3
	{
		objName = 'v_ilev_ph_cellgate',
		objYaw = 90.0,
		objCoords  = vector3(462.7, -1001.9, 24.9),
		textCoords = vector3(461.8, -1002.4, 25.0),
		authorizedJobs = { 'police' },
		locked = true
	},
	
	-- To Back
	{
		objName = 'v_ilev_gtdoor',
		objYaw = 0.0,
		objCoords  = vector3(463.4, -1003.5, 25.0),
		textCoords = vector3(464.0, -1003.5, 25.5),
		authorizedJobs = { 'police' },
		locked = true
	},

	--
	-- Mission Row Back
	--

	-- Back (double doors)
	{
		textCoords = vector3(468.6, -1014.4, 27.1),
		authorizedJobs = { 'police' },
		locked = true,
		distance = 4,
		doors = {
			{
				objName = 'v_ilev_rc_door2',
				objYaw = 0.0,
				objCoords  = vector3(467.3, -1014.4, 26.5)
			},

			{
				objName = 'v_ilev_rc_door2',
				objYaw = 180.0,
				objCoords  = vector3(469.9, -1014.4, 26.5)
			}
		}
	},

	-- Back Gate
	{
		objName = 'hei_prop_station_gate',
		objYaw = 90.0,
		objCoords  = vector3(488.8, -1017.2, 27.1),
		textCoords = vector3(488.8, -1020.2, 30.0),
		authorizedJobs = { 'police' },
		locked = true,
		distance = 14,
		size = 2
	},

	--
	-- Sandy Shores
	--

	-- Entrance
	{
		objName = 'v_ilev_shrfdoor',
		objYaw = 30.0,
		objCoords  = vector3(1855.1, 3683.5, 34.2),
		textCoords = vector3(1855.1, 3683.5, 35.0),
		authorizedJobs = { 'police' },
		locked = false
	},

	--
	-- Paleto Bay
	--

	-- Entrance (double doors)
	{
		textCoords = vector3(-443.5, 6016.3, 32.0),
		authorizedJobs = { 'police' },
		locked = false,
		distance = 2.5,
		doors = {
			{
				objName = 'v_ilev_shrf2door',
				objYaw = -45.0,
				objCoords  = vector3(-443.1, 6015.6, 31.7),
			},

			{
				objName = 'v_ilev_shrf2door',
				objYaw = 135.0,
				objCoords  = vector3(-443.9, 6016.6, 31.7)
			}
		}
	},

	--
	-- Bolingbroke Penitentiary
	--

	-- Entrance (Two big gates)
	{
		objName = 'prop_gate_prison_01',
		objCoords  = vector3(1844.9, 2604.8, 44.6),
		textCoords = vector3(1844.9, 2608.5, 48.0),
		authorizedJobs = { 'police' },
		locked = true,
		distance = 12,
		size = 2
	},

	{
		objName = 'prop_gate_prison_01',
		objCoords  = vector3(1818.5, 2604.8, 44.6),
		textCoords = vector3(1818.5, 2608.4, 48.0),
		authorizedJobs = { 'police' },
		locked = true,
		distance = 12,
		size = 2
	},

	--
	-- Addons
	--

	--[[
	-- Entrance Gate (Mission Row mod) https://www.gta5-mods.com/maps/mission-row-pd-ymap-fivem-v1
	{
		objName = 'prop_gate_airport_01',
		objCoords  = vector3(415.5, -1021.3, 29.14),
		textCoords = vector3(415.1, -1021.0, 32.0),
		authorizedJobs = { 'police' },
		locked = true,
		distance = 14,
		size = 2
	}
	]]--
	
	
	
------------------ MEDIC ROOMS----------------------
	
	-- door baghal
	
	{
		textCoords = vector3(333.34, -588.0, 28.79),
		authorizedJobs = { 'ambulance' },
		locked = true,
		distance = 3,
		doors = {
			{
				objName = 'v_ilev_cor_firedoorwide',
				objYaw = 160.0,
				objCoords  = vector3(333.34, -588.0, 28.79),
			}
		}
	},
	
	
	-- door asli
	
	{
		textCoords = vector3(337.52, -583.36, 28.79),
		authorizedJobs = { 'ambulance', 'offambulance' },
		locked = true,
		distance = 3,
		doors = {
			{
				objName = 'v_ilev_cor_firedoorwide',
				objYaw = 250.5,
				objCoords  = vector3(337.52, -583.36, 28.79),
			}
		}
	},
	
	{
		objName = 'v_ilev_cor_firedoor',
		objCoords  = vector3(1844.9, 2604.8, 44.6),
		textCoords = vector3(1844.9, 2608.5, 48.0),
		authorizedJobs = { 'ambulance' },
		locked = true,
		distance = 12,
		size = 2
	},
	
	-- double door e otaghaye samt chap

	
	{
		textCoords = vector3(334.14, -592.26, 28.79),
		authorizedJobs = {'ambulance','special'},
		locked = true,
		distance = 3,
		doors = {
			{
				objName = 'v_ilev_cor_firedoor',
				objYaw = -110.0,
				objCoords  = vector3(333.91, -592.92, 28.79),
			},

			{
				objName = 'v_ilev_cor_firedoor',
				objYaw = 70.0,
				objCoords  = vector3(334.36, -591.66, 28.79)
			}
		}
	},
	
	-- double door e otaghaye samt rast
	
	{
		textCoords = vector3(341.86, -571.48, 28.79),
		authorizedJobs = {'ambulance'},
		locked = true,
		distance = 3,
		doors = {
			{
				objName = 'v_ilev_cor_firedoor',
				objYaw = -110.0,
				objCoords  = vector3(341.63, -572.02, 28.79),
			},

			{
				objName = 'v_ilev_cor_firedoor',
				objYaw = 70.0,
				objCoords  = vector3(341.89, -570.68, 28.79)
			}
		}
	},
	
	--bimarestan door dakhel
	
	{
		objName = 'v_ilev_cor_firedoorwide',
		objCoords  = vector3(352.49, -575.18, 28.79),
		textCoords = vector3(352.5, -575.53, 28.79),
		authorizedJobs = { 'ambulance' },
		locked = true,
		distance = 3,
	},
	
	-- Khone ShahrDar
	
	{
		objName = 'v_ilev_mm_doorm_l',
		objCoords  = vector3(-816.34, 178.37, 72.22),
		textCoords = vector3(-816.34, 178.37, 72.22),
		authorizedJobs = { 'bailbonds' },
		locked = true,
		distance = 3,
	},
	
	{
		objName = 'v_ilev_mm_door',
		objCoords  = vector3(-124.7, 900.71, 235.82),
		textCoords = vector3(-124.7, 900.71, 235.82),
		authorizedJobs = { 'bailbonds' },
		locked = true,
		distance = 3,
	},

	-- PRINCIPAL BANK
	-- Entrance (grades)
	{
        objName = 'hei_v_ilev_bk_gate2_pris',
        objCoords  = vector3(261.85, 221.84, 106.28),
        textCoords = vector3(261.85, 221.84, 106.28),
        authorizedJobs = { 'police' },
        locked = true,
        distance = 0,
        size = 0
    },

	-- PRINCIPAL BANK
	-- Entrance (grades)
	{
        objName = 'prop_fnclink_02gate6_l',
        objCoords  = vector3(427.756929, -1016.35, 28.96),
        textCoords = vector3(427.756929, -1016.35, 28.96),
        authorizedJobs = { 'police' },
        locked = true,
        distance = 3,
    },

	-- PRINCIPAL BANK
	-- Entrance (grades)
	{
        objName = 'Prop_FacGate_07',
        objCoords  = vector3(410.479, -1023.849, 28.4802),
        textCoords = vector3(410.479, -1023.849, 28.4802),
        authorizedJobs = { 'police' },
        locked = true,
        distance = 9,
    },

}