Config = {}

Config.Locale = 'en'

--Version 2.0 
--Script by devcore
--To get fixes for the new version, come to our discord : https://discord.gg/zcG9KQj3sa
--If you want to use a stress system for this script. Go to Client/client.lua and search for Stress. And under each Stress text, insert a trigger for the stress system.



Config.Armor = 50
Config.AddArmor = true
------------ 
Config.CigaretteExhale = 0.15
Config.CigarExhale = 0.15
Config.JointExhale = 0.15
Config.VapeExhale = 0.4
Config.BongExhale = 0.4
------------
Config.JointSmoke = 0.03
Config.CigarSmoke = 0.05
Config.CigaretteSmoke = 0.03

Config.SizeRemove = {min = 1, max = 3} -- how much size is removed after one exhalation
Config.ExhaleTime = {min = 1000, max = 1500}
------------- BUTTONS 
Config.DisableCombatButtons = true -- Deactivates the attack buttons while smoking
Config.SmokeButton = 144
Config.ThrowButton = 73
Config.MouthButton = 10
Config.HandButton = 11
Config.GiveButton = 121
Config.ConfirmGiveButton = 38
Config.CancelGiveButton = 73
-------------
Config.Lighter = 'lighter'
--Vape
Config.ItemVapeLiquid = 'liquid'
Config.MaxLiquid = 6
Config.AddLiquidInVape = 3 -- How much ml is added after pouring the liquid into the vape
Config.VapeSizeRemove = 0.5 -- How much ml of liquid is removed from the vape after one coating
--Bong
Config.MaxWeed = 2 -- Max g weed in bong
Config.AddWeedInBong = 1 -- how much g is added to the bong after one grass
Config.BongSizeRemove = 1 -- How much g of grass is removed from the bong after one coating
--

Config.CigarettePack = { -- set the pack items here and which items you get from the pack
    {PackItem = "redw",  CigaretteItem = 'redwcig', Amount = 20},
    {PackItem = "marlboro",  CigaretteItem = 'marlborocig', Amount = 20},
}

Config.Smoke = { -- Item = 
    {Item = "cubancigar",  Prop = 'prop_cigar_01', Size = 20, Type = 'cigar', Time = 120000},
    {Item = "davidoffcigar",  Prop = 'prop_cigar_01', Size = 20, Type = 'cigar', Time = 120000},
    {Item = "redwcig",  Prop = 'ng_proc_cigarette01a', Size = 20, Type = 'cigarette', Time = 120000},
    {Item = "marlborocig",  Prop = 'ng_proc_cigarette01a', Size = 20, Type = 'cigarette', Time = 120000},
    {Item = "vape",  Prop = 'ba_prop_battle_vape_01', Size = 0, Type = 'vape', Time = 0},
    {Item = "bong",  Prop = 'prop_bong_01', Size = 0, Type = 'bong', Time = 0},
    {Item = "og_kush_joint",  Prop = 'prop_sh_joint_01', Size = 20, Type = 'joint', Time = 120000},
    {Item = "blue_dream_joint",  Prop = 'prop_sh_joint_01', Size = 20, Type = 'joint', Time = 120000},
    {Item = "purple_haze_joint",  Prop = 'prop_sh_joint_01', Size = 20, Type = 'joint', Time = 120000},
    {Item = "banana_kush_joint",  Prop = 'prop_sh_joint_01', Size = 20, Type = 'joint', Time = 120000},
}

Config.BongReloadItems = {
    {Items = "og_kush_weed", ItemsLabel = "Og Kush Weed"},
    {Items = "blue_dream_weed", ItemsLabel = "Blue Dream Weed"},
    {Items = "banana_kush_weed", ItemsLabel = "Banana Kush Weed"},
    {Items = "purple_haze_weed", ItemsLabel = "Purple Haze Weed"},
}

--Rollings joints
Config.Rollingpaper = 'ocb_paper'

Config.ItemWeed = {    -- Weed bag
	'banana_kush_bag',
	'blue_dream_bag',
	'og_kush_bag',
	'purple_haze_bag'
}
-------------------------