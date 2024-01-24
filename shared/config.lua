Config = {
    Locale  = 'en',
    progresstype = "progressCircle",                                         -- progressBar, progressCircle 
    debug = false,
}

Config.Peds = {
    Main = {
        coords = {
            {x = -1273.25695, y = -1371.68249, z = 3.30285, h = 22.30249}
        },
        model = "cs_joeminuteman",
        scenario = "",
    },
    DeliveryPeds = {
        [1] = {
            model = "cs_joeminuteman",
            coords = {
                {x = -680.72882080078, y = 5797.8251953125, z = 17.330945968628, h = 252.55224609375}
            }
        },
        [2] = {
            model = "cs_joeminuteman",
            coords = {
                {x = 906.34606933594, y = 3588.6572265625, z = 33.292285919189, h = 270.63647460938}
            }
        },
        [3] = {
            model = "cs_joeminuteman",
            coords = {
                {x = 1112.6649169922, y = -2277.9399414063, z = 30.215587615967, h = 175.69189453125}
            }
        },
        [4] = {
            model = "cs_joeminuteman",
            coords = {
                {x = -2170.5383300781, y = 4281.53125, z = 49.025283813477, h = 237.28207397461}
            }
        }
    }
}
Config.Menu = {
    vehicle = {
        easy = {
            [1] = {
                label = "Dubsta 2",
                model = "dubsta2",
                payout = 10000
            },
            [2] = {
                label = "Karin BeeJay XL",
                model = "bjxl",
                payout = 9000
            },
            [3] = {
                label = "Phoenix",
                model = "phoenix",
                payout = 15000
            },
            [4] = {
                label = "Declasse Tornado",
                model = "tornado",
                payout = 8000
            } -- don't forget when you add more cars to add , 
            --[[
                [5] = { -- this number must always be 1 greater than the previous number
                label = "Declasse Tornado", -- this name is displayed to the player on ox_lib
                model = "tornado", -- name of the vehicle model
                payout = 8000 -- how much the player gets paid
            } 
            ]]
        }
    }
}
