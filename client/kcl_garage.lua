-- kcl_garage.lua
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(6000)
	end
  while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
    end
    if ESX.IsPlayerLoaded() then
  ESX.PlayerData = ESX.GetPlayerData()
  end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

-- [Menu RageUi V2]
local open = false 
local kbennysgarage = RageUI.CreateMenu("Garage", "Benny's",0,100,nil,nil)
kbennysgarage.Display.Header = true 
kbennysgarage.Closed = function()
  open = false
end

-- [Fonction du Menu]
function OpenMenuGaragekbennys()
     if open then 
         open = false
         RageUI.Visible(kbennysgarage, false)
         return
     else
         open = true 
         RageUI.Visible(kbennysgarage, true)
         CreateThread(function()
         while open do 
            RageUI.IsVisible(kbennysgarage,function() 

              RageUI.Button("Ranger votre véhicule", nil, {RightLabel = "→→"}, true , {
                onSelected = function()
                  local veh,dist4 = ESX.Game.GetClosestVehicle(playerCoords)
                  if dist4 < 4 then
                      DeleteEntity(veh)
                      RageUI.CloseAll()
                  end
                end})

              RageUI.Separator("~h~↓ Véhicules ↓")
                for k,v in pairs(Config.kbennysVehicules) do
                RageUI.Button(v.buttoname, nil, {RightLabel = "→→"}, true , {
                    onSelected = function()
                        if not ESX.Game.IsSpawnPointClear(vector3(v.spawnzone.x, v.spawnzone.y, v.spawnzone.z), 10.0) then
                        ESX.ShowNotification("~g~kbennys\n~r~Point de spawn bloquée")
                        else
                        local model = GetHashKey(v.spawnname)
                        RequestModel(model)
                        while not HasModelLoaded(model) do Wait(10) end
                        local kbennysveh = CreateVehicle(model, v.spawnzone.x, v.spawnzone.y, v.spawnzone.z, v.headingspawn, true, false)
                        SetVehicleNumberPlateText(kbennysveh, "kbennys"..math.random(50, 999))
                        SetVehicleFixed(kbennysveh)
                        TaskWarpPedIntoVehicle(PlayerPedId(),  kbennysveh,  -1)
                        SetVehRadioStation(kbennysveh, 0)
                        RageUI.CloseAll()
                      end
                    end})
                  end
               end)
            Wait(0)
          end
       end)
    end
 end

-- [Ouverture du Menu]
Citizen.CreateThread(function()
  while true do 
      local wait = 750
      if ESX.PlayerData.job and ESX.PlayerData.job.name == 'bennys' then
          for k in pairs(Config.Position.GarageVehicule) do 
              local plyCoords = GetEntityCoords(PlayerPedId() , false)
              local pos = Config.Position.GarageVehicule
              local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, pos[k].x, pos[k].y, pos[k].z)
              if dist <= 7.0 then 
                  wait = 0
                  Visual.Subtitle(Config.TextGarageVehicule, 1)
                  if IsControlJustPressed(1,51) then
                      OpenMenuGaragekbennys()
                  end
              end
          end
      end
  Citizen.Wait(wait)
  end
end)

--kbennys by ! Kamion#1323