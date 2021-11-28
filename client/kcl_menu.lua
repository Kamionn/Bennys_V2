
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

function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)
    AddTextEntry('FMMC_KEY_TIP1', TextEntry) 
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)
    blockinput = true
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do 
        Citizen.Wait(0)
    end
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult() 
        Citizen.Wait(500) 
        blockinput = false
        return result 
    else
        Citizen.Wait(500) 
        blockinput = false 
        return nil 
    end
end

-- [Menu RageUi V2]
local open = false 
local kbennysmenurageuiv2 = RageUI.CreateMenu("Benny's", 'motorworks',0,100,nil,nil)
local kbennyssubmenurageuiv2 = RageUI.CreateSubMenu(kbennysmenurageuiv2, nil, "bennys")
local kbennymecanossubmenurageuiv2 = RageUI.CreateSubMenu(kbennysmenurageuiv2, nil, "bennys")
kbennysmenurageuiv2.Display.Header = true 
kbennysmenurageuiv2.Closed = function()
  open = false
end

-- [Fonction du Menu ]
function OpenMenukbennys()
	if open then 
		open = false
		RageUI.Visible(kbennysmenurageuiv2, false)
		return
	else
		open = true 
		RageUI.Visible(kbennysmenurageuiv2, true)
		CreateThread(function()
		while open do 
		   RageUI.IsVisible(kbennysmenurageuiv2,function()
			RageUI.Checkbox("Prendre votre service", nil, servicekbennys, {}, {
                onChecked = function(index, items)
                    servicekbennys = true
					ESX.ShowNotification("~g~Vous avez pris votre service !")
                    TriggerServerEvent('kbennys:prisedeservice')
                end,
                onUnChecked = function(index, items)
                    servicekbennys = false
					ESX.ShowNotification("~r~Vous avez quitter votre service !")
                    TriggerServerEvent('kbennys:quitteleservice')
                end})
	if servicekbennys then

           RageUI.Separator("~o~↓ Annonces ↓")

            RageUI.Button("Annonces bennys", nil, {RightLabel = "→→"}, true , {
                  onSelected = function()
                end}, kbennyssubmenurageuiv2 )      
            
                RageUI.Button("Dépannage", nil, {RightLabel = "→→"}, true , {
                    onSelected = function()
                  end}, kbennymecanossubmenurageuiv2)    
           
            RageUI.Button("Faire une Facture", nil, {RightLabel = "→→"}, true , {
                onSelected = function()
                    amount = KeyboardInput("Montant de la facture",nil,3)
                    amount = tonumber(amount)
                    local player, distance = ESX.Game.GetClosestPlayer()
                    if player ~= -1 and distance <= 3.0 then
                    if amount == nil then
                        ESX.ShowNotification("~r~Problèmes~s~: Montant invalide")
                    else
                        local playerPed        = PlayerPedId() 
                        Citizen.Wait(5000)
                        TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), 'society_bennys', ('bennys'), amount)
                        Citizen.Wait(100)
                        ESX.ShowNotification("~g~Vous avez bien envoyer la facture")
                    end
                    else
                    ESX.ShowNotification("~r~Problèmes~s~: Aucun joueur à proximitée")
                    end
                end});
             end
        end)

    RageUI.IsVisible(kbennyssubmenurageuiv2 ,function() 

           RageUI.Button("Annonce ~g~[Ouvertures]", nil, {RightLabel = "→"}, true , {
			onSelected = function()
				TriggerServerEvent('Ouvre:kbennys')
			end
		})

		RageUI.Button("Annonce ~r~[Fermetures]", nil, {RightLabel = "→"}, true , {
			onSelected = function()
				TriggerServerEvent('Ferme:kbennys')
			end
		})

		RageUI.Button("Annonce ~y~[Recrutement]", nil, {RightLabel = "→"}, true , {
			onSelected = function()
				TriggerServerEvent('Recru:kbennys')
			end
		})
    end)


        RageUI.IsVisible(kbennymecanossubmenurageuiv2,function() 

			RageUI.Button("Réparer le véhicule", nil, {RightLabel = "→→"}, true, {
				onSelected = function()
					local playerPed = PlayerPedId()
					local vehicle   = ESX.Game.GetVehicleInDirection()
					local coords    = GetEntityCoords(playerPed)
		
					if IsPedSittingInAnyVehicle(playerPed) then
						ESX.ShowNotification('Sortez de la voiture')
						return
					end
		
					if DoesEntityExist(vehicle) then
						isBusy = true
						TaskStartScenarioInPlace(playerPed, 'PROP_HUMAN_BUM_BIN', 0, true)
						Citizen.CreateThread(function()
							Citizen.Wait(20000)
		
							SetVehicleFixed(vehicle)
							SetVehicleDeformationFixed(vehicle)
							SetVehicleUndriveable(vehicle, false)
							SetVehicleEngineOn(vehicle, true, true)
							ClearPedTasksImmediately(playerPed)
		
							ESX.ShowNotification('la voiture est réparer')
							isBusy = false
						end)
					else
						ESX.ShowNotification('Aucun véhicule à proximiter')
					end
		 
				end,}) 
				
				RageUI.Button("Nettoyer véhicule", nil, {RightLabel = "→→"}, true , {
					onSelected = function()
						local playerPed = PlayerPedId()
						local vehicle   = ESX.Game.GetVehicleInDirection()
						local coords    = GetEntityCoords(playerPed)
			
						if IsPedSittingInAnyVehicle(playerPed) then
							ESX.ShowNotification('Sortez de la voiture')
							return
						end
			
						if DoesEntityExist(vehicle) then
							isBusy = true
							TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_MAID_CLEAN', 0, true)
							Citizen.CreateThread(function()
								Citizen.Wait(10000)
			
								SetVehicleDirtLevel(vehicle, 0)
								ClearPedTasksImmediately(playerPed)
			
								ESX.ShowNotification('Voiture nettoyée')
								isBusy = false
							end)
						else
							ESX.ShowNotification('Aucun véhicule trouvée')
						end
						end,})

								RageUI.Button("Crocheter véhicule", nil, {RightLabel = "→→"}, true , {
				onSelected = function()
						local playerPed = PlayerPedId()
						local vehicle = ESX.Game.GetVehicleInDirection()
						local coords = GetEntityCoords(playerPed)
			
						if IsPedSittingInAnyVehicle(playerPed) then
							ESX.ShowNotification('Action impossible')
							return
						end
			
						if DoesEntityExist(vehicle) then
							isBusy = true
							TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_WELDING', 0, true)
							Citizen.CreateThread(function()
								Citizen.Wait(10000)
			
								SetVehicleDoorsLocked(vehicle, 1)
								SetVehicleDoorsLockedForAllPlayers(vehicle, false)
								ClearPedTasksImmediately(playerPed)
			
								ESX.ShowNotification('Véhicule déverrouillé')
								isBusy = false
							end)
						else
							ESX.ShowNotification('Aucune voiture autour')
						end
				end,})
						
				   RageUI.Button("Mettre véhicule en fourriere", nil, {RightLabel = "→→"}, true , {
					onSelected = function()
						local playerPed = PlayerPedId()

						if IsPedSittingInAnyVehicle(playerPed) then
							local vehicle = GetVehiclePedIsIn(playerPed, false)
			
							if GetPedInVehicleSeat(vehicle, -1) == playerPed then
								ESX.ShowNotification('la voiture a été mis en fourrière')
								ESX.Game.DeleteVehicle(vehicle)
							   
							else
								ESX.ShowNotification('Sortez de la voiture')
							end
						else
							local vehicle = ESX.Game.GetVehicleInDirection()
			
							if DoesEntityExist(vehicle) then
								TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TIME_OF_DEATH', 0, true)
							Citizen.CreateThread(function()
								Citizen.Wait(10000)
								ClearPedTasks(playerPed)
                                Citizen.Wait(5000)
								ESX.ShowNotification('La voiture à été placer en fourrière')
								ESX.Game.DeleteVehicle(vehicle)
								end)
							else
								ESX.ShowNotification('Aucune voiture autour')
							end
						 end
				    end,})
                 end)
           Wait(0)
         end
      end)
    end
 end

-- [Ouverture du Menu]
Keys.Register('F6', 'bennys', 'Ouvrir le menu bennys', function()
	if ESX.PlayerData.job and ESX.PlayerData.job.name == 'bennys' then
        OpenMenukbennys()
	end
end)

--- Blips

local pos = vector3(-202.82, -1324.78, 4.875902)
Citizen.CreateThread(function()
	local blip = AddBlipForCoord(pos)

	SetBlipSprite (blip, 446)
	SetBlipDisplay(blip, 4)
	SetBlipScale  (blip, 0.6)
	SetBlipColour (blip, 51)
	SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName('STRING')
	AddTextComponentSubstringPlayerName("~r~[Job] ~w~I Benny's")
	EndTextCommandSetBlipName(blip)
end)

-- kbennys by ! Kamion#1323