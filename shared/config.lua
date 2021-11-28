-- config.lua
kbennysLogs = ""-- Votre Webhook 

Config = {

    TextCoffre = "Appuyez sur ~o~[E] ~s~pour accèder au ~o~coffre ~s~!",  -- Texte Menu coffre
    TextBoss = "Appuyez sur ~o~[E] ~s~pour pour accèder au ~o~action patron ~s~!",  -- Texte Menu Boss
    TextGarageVehicule = "Appuyez sur ~o~[E] ~s~pour accèder au ~o~garage ~s~!",  -- Texte Garage Voiture
    TextAccueil = "Appuyez sur ~o~[E] ~s~pour parler au secrétaire ~s~!",  -- Accueil
   
 kbennysVehicules = { 
	{buttoname = "Flatbed", rightlabel = "→→", spawnname = "flatbed", spawnzone = vector3(-187.14, -1290.21, 31.38), headingspawn = 269.41}, -- Garage Voiture
	{buttoname = "Dépanneuse", rightlabel = "→→", spawnname = "towtruck", spawnzone = vector3(-189.63, -1284.31, 31.22), headingspawn = 272.120}, -- Garage limousine
	{buttoname = "Dépanneuse2", rightlabel = "→→", spawnname = "towtruck2", spawnzone = vector3(-189.63, -1284.31, 31.22), headingspawn = 272.120}, -- Garage camion
},

Position = {
	    Boss = {vector3(-195.51, -1336.37, 30.89)}, -- coordonnée Menu boss 
	    Coffre = {vector3(-205.55, -1332.70, 30.89)}, -- coordonnée Menu coffre 
        Accueil = {vector3(-205.40, -1328.88, 30.32)}, -- coordonnée Menu Pour Accueil 
        GarageVehicule = {vector3(-192.17, -1287.40, 31.30)}, -- coordonnée Menu Garage Vehicule
    }
}

-- kbennys by ! Kamion#1323