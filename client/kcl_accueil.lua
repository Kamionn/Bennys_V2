-- kcl_accueil.lua
Citizen.CreateThread(function()
  while ESX == nil do
	TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
	Citizen.Wait(6000)
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
    blockinput = true 
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "Somme", ExampleText, "", "", "", MaxStringLenght) 
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
local kbennysaccueil = RageUI.CreateMenu("Accueil", "benny's",0,100,nil,nil)
local kbennysaccueil2 = RageUI.CreateMenu("Accueil", "benny's",0,100,nil,nil)
kbennysaccueil.Display.Header = true 
kbennysaccueil.Closed = function()
  open = false
  nomprenom = nil
  numero = nil
  heurerdv = nil
  rdvmotif = nil
end

-- [Fonction du Menu]
function OpenMenuAccueilkbennys() 
    if open then 
		open = false
		RageUI.Visible(kbennysaccueil, false)
		return
	else
		open = true 
		RageUI.Visible(kbennysaccueil, true)
		CreateThread(function()
		while open do 
        RageUI.IsVisible(kbennysaccueil, function()

            RageUI.Button("Appeler un employer du bennys", nil, {RightLabel = "→→"}, not codesCooldown5 , {
                onSelected = function()
                codesCooldown5 = true 
            TriggerServerEvent('Appel:kbennys')
            ESX.ShowNotification("Vous venez d'envoyer une notification aux employers du bennys.")
            Citizen.SetTimeout(5000, function() codesCooldown5 = false end)
        end})
            RageUI.Button("Prendre Rendez-Vous", nil, {RightLabel = "→→"}, true , {
                onSelected = function()
        end}, kbennysaccueil2)     
      end)    
         
        RageUI.IsVisible(kbennysaccueil2, function()    

            RageUI.Button("Nom & Prénom", nil, {RightLabel = nomprenom}, true , {
                onSelected = function()
                DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "Prénom & Nom", " ", "", "", "", 20)
                while (UpdateOnscreenKeyboard() == 0) do
                    DisableAllControlActions(0);
                   Citizen.Wait(1)
                end
                if (GetOnscreenKeyboardResult()) then
                    nomprenom = GetOnscreenKeyboardResult() 
                end
             end})

            RageUI.Button("Numéro de Téléphone", nil, {RightLabel = numero}, true , {
                onSelected = function()
                    DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "555-", "555-", "", "", "", 10)
                    while (UpdateOnscreenKeyboard() == 0) do
                        DisableAllControlActions(0);
                       Citizen.Wait(1)
                    end
                    if (GetOnscreenKeyboardResult()) then
                        numero = GetOnscreenKeyboardResult()  
            		end
                end})

            RageUI.Button("Heure du Rendez-vous", nil, {RightLabel = heurerdv}, true , {
                onSelected = function()
                    DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "15h40", " ", "", "", "", 10)
                    while (UpdateOnscreenKeyboard() == 0) do
                        DisableAllControlActions(0);
                       Citizen.Wait(1)
                    end
                    if (GetOnscreenKeyboardResult()) then
                        heurerdv = GetOnscreenKeyboardResult()  
                    end
                end})
            
            RageUI.Button("Motif du Rendez-vous", nil, {RightLabel = "→→"}, true , {
                onSelected = function()
                    DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "Motif", " ", "", "", "", 120)
                    while (UpdateOnscreenKeyboard() == 0) do
                        DisableAllControlActions(0);
                       Citizen.Wait(1)
                    end
                    if (GetOnscreenKeyboardResult()) then
                        rdvmotif = GetOnscreenKeyboardResult()  
                    end
                end})

            RageUI.Button("Valider la Demande", nil, { Color = {BackgroundColor = { 230, 119, 14 , 50}} }, true, {
                onSelected = function()
                    if (nomprenom == nil or nomprenom == '') then
                        ESX.ShowNotification('~r~Vous n\'a pas rempli ton Nom/Prénom')
                    elseif (numero == nil or numero == '') then
                        ESX.ShowNotification('~r~Vous n\'a pas rempli ton Numéro')
                    elseif (heurerdv == nil or heurerdv == '') then
                        ESX.ShowNotification('~r~Vous n\'a pas rempli l\'heure de Rendez-vous')
                    elseif (rdvmotif == nil or rdvmotif == '' or rdvmotif == "Motif") then
                        ESX.ShowNotification('~r~Vous n\'a pas rempli le motif du rendez-vous')
                else
                    RageUI.CloseAll()
                    TriggerServerEvent("Rdv:kbennysMotif", nomprenom, numero, heurerdv, rdvmotif)
                    ESX.ShowNotification("Demande de Rendez-vous envoyée")
                    nomprenom = nil
                    numero = nil
                    heurerdv = nil
                    rdvmotif = nil
                end
            end}) 
          end)			
		Wait(0)
	   end
	end)
 end
end

-- [Ouverture Du Menu]
Citizen.CreateThread(function()
    while true do 
        local wait = 750
         for k in pairs(Config.Position.Accueil) do 
                local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
                local pos = Config.Position.Accueil
                local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, pos[k].x, pos[k].y, pos[k].z)
             if dist <= 2.0 then 
                    wait = 0
                    Visual.Subtitle(Config.TextAccueil, 1)
                    if IsControlJustPressed(1,51) then
                        OpenMenuAccueilkbennys()
                    end
                end
            end
    Citizen.Wait(wait)
   end
end)

-- kbennys by ! Kamion#1323