Config = {}

Config.ItemNeeded = "net_cracker"
Config.MaxLives = 3 -- this is the max lives in hacking thing don't set more than 5. thank you
Config.CopsNeeded = 3 -- number of cops required to start the robbery
Config.BlackMoney = true -- true for black_money and false for cash
Config.AlertInChat = true -- true or false only
Config.AlertInChatMessage = "'NEWS' ^7 Robbery in progress at ^1"

Config.Trolley = {
    ["cash"] = { 700, 1000 }, -- this is what you receive every cash stack math.random(1, 2)
    ["model"] = GetHashKey("hei_prop_hei_cash_trolly_01")
}

Config.EmptyTrolley = {
    ["model"] = GetHashKey("hei_prop_hei_cash_trolly_03")
}

Config.Bank = {
    ["Principal Bank"] = {
        ["start"] = { 
            ["pos"] = vector3(253.67, 228.26, 101.68), 
            ["heading"] = 74.31 
        },
        ["door"] = { 
            ["pos"] = vector3(254.12199291992, 225.50576782227, 101.87346405029),
            ["model"] = 961976194
        },
        ["device"] = {
            ["model"] = -160937700
        },
        ["trolleys"] = {
			["1"] = { 
                ["pos"] = vector3(255.96, 218.73, 101.68), 
                ["heading"] = 343.21 + 180.0
            },
            ["2"] = { 
                ["pos"] = vector3(254.94, 216.06, 101.68), 
                ["heading"] = 160.91 + 180.0
            },
            ["3"] = { 
                ["pos"] = vector3(264.64, 212.0, 101.67), 
                ["heading"] = 338.37 + 0.0
            },
            ["4"] = { 
                ["pos"] = vector3(262.20, 212.88, 101.68), 
                ["heading"] = 338.37 + 0.0
            },
			["5"] = { 
                ["pos"] = vector3(263.20, 216.39, 101.68), 
                ["heading"] = 338.37 + 180.0
            },
            ["6"] = { 
                ["pos"] = vector3(266.17, 215.38, 101.68), 
                ["heading"] = 338.37 + 180.0
            },
        }
    }
}