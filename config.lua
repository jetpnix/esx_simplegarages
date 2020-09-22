---------------------------------------
--   ESX_SIMPLEGARAGES by Dividerz   --
-- FOR SUPPORT: Arne#7777 on Discord --
---------------------------------------

Config = {}

Config.Garages = {
    sapcounsel = {
        garageName = "Rode Garage",
        getVehicle = vector3(-329.87, -780.40, 33.96),
        spawnPoint = {
            coords = vector3(-334.44, -780.75, 33.96),
            heading = 137.50
        },
        storeVehicle = {x = -341.72, y = -767.43, z = 33.96},
    },
    court = {
        garageName = "Gerechtsgebouw",
        getVehicle = {x = 275.42, y = -345.27, z = 45.17},
        spawnPoint = {x = 273.07, y = -333.91, z = 44.92, h = 160.15},
        storeVehicle = {x = 283.61, y = -342.54, z = 44.92}
    },
    canals = {
        garageName = "Vespucci Canals",
        getVehicle = {x = -1159.14, y = -740.12, z = 19.89},
        spawnPoint = {x = -1149.21, y = -739.36, z = 20.0, h = 130.92},
        storeVehicle = {x = -1146.47, y = -745.94, z = 19.62}
    }
}

Config.Impounds = {
    ["hayesdepot"] = {
        garageName = "Hayes Impound",
        getVehicle = {x = 491.0, y = -1314.69, z = 29.25},
        spawnPoint = {x = 491.0, y = -1314.69, z = 29.25, h = 304.5}
    },
    ["policedepot"] = {
        garageName = "Police Impound",
        getVehicle = {x = 409.36, y = -1622.99, z = 29.29},
        spawnPoint = {x = 404.84, y = -1642.51, z = 29.29, h = 228.84}
    }
}