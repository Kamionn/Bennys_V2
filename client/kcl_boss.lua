-- kcl_boss.lua
ESX = nil
societykbennys = nil

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
local kbennysboss = RageUI.CreateMenu("Boss", "Benny's",0,100,nil,nil)
kbennysboss.Display.Header = true 
kbennysboss.Closed = function()
  open = false
end

-- [Fonction du Menu]

function aboss()
    TriggerEvent('esx_society:openBossMenu', 'bennys', function(data, menu)
        menu.close()
    end, {wash = false})
end

function Bosskbennys()
	if open then 
		open = false
		RageUI.Visible(kbennysboss, false)
		return
	else
		open = true 
		RageUI.Visible(kbennysboss, true)
		CreateThread(function()
		while open do 
		   RageUI.IsVisible(kbennysboss,function() 
            
			if societykbennys ~= nil then
                RageUI.Button('Argent de la société :', nil, {RightLabel = "~o~"..societykbennys.."$"}, true, {onSelected = function()end});   
            end

            RageUI.Separator("~o~↓ bennys ↓")
            
            RageUI.Button('Retirer de l\'argent.', nil, {RightLabel = ">"}, true, {onSelected = function()
                local money = KeyboardInput('Combien voulez vous retirer :', '', 10)
                TriggerServerEvent("kbennys:withdrawMoney","society_"..ESX.PlayerData.job.name ,money)
                RefreshMoney()
            end});   

            RageUI.Button('Déposer de l\'argent.', nil, {RightLabel = ">"}, true, {onSelected = function()
                local money = KeyboardInput('Combien voulez vous retirer :', '', 10)
                TriggerServerEvent("kbennys:depositMoney","society_"..ESX.PlayerData.job.name ,money)
                RefreshMoney()
            end});  

            RageUI.Button('Rafraichir le compte.', nil, {RightLabel = ">"}, true, {onSelected = function()
                RefreshMoney()
            end}); 

            RageUI.Button('Accéder aux actions de Management.', nil, {RightLabel = ">"}, true, {onSelected = function()
                aboss()
                RageUI.CloseAll()
            end}); 

          end)
		 Wait(0)
		end
	 end)
  end
end

function RefreshMoney()
    if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'boss' then
        ESX.TriggerServerCallback('kbennys:getSocietyMoney', function(money)
            societykbennys = money
        end, "society_"..ESX.PlayerData.job.name)
    end
end

function Updatessocietykbennysmoney(money)
    societykbennys = ESX.Math.GroupDigits(money)
end

function KeyboardInput(TextEntry, ExampleText, MaxStringLength)
    AddTextEntry('FMMC_KEY_TIP1', TextEntry .. ':')
	DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLength)
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

 -- [Ouverture du Menu]
Citizen.CreateThread(function()
    while true do
        local wait = 750
        if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'boss' then
            for k in pairs(Config.Position.Boss) do
                local plyCoords = GetEntityCoords(PlayerPedId() , false)
                local pos = Config.Position.Boss
                local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, pos[k].x, pos[k].y, pos[k].z)
                if dist <= 1.0 then
                    wait = 0
                    Visual.Subtitle(Config.TextBoss, 1)
                    if IsControlJustPressed(1,51) then
                        Bosskbennys()
                    end
                end
            end
        end
    Citizen.Wait(wait)
    end
end)

-- kbennys by ! Kamion#1323