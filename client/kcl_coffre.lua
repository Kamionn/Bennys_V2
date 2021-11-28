-- kcl_coffre.lua
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- [Menu RageUi V2]
local kbennyscoffre = RageUI.CreateMenu("Coffre", "benny's",0,100,nil,nil)
local kbennyscoffre2 = RageUI.CreateSubMenu(kbennyscoffre, nil, "bennys")
local kbennyscoffre3 = RageUI.CreateSubMenu(kbennyscoffre, nil, "bennys")

local open = false

kbennyscoffre:DisplayGlare(false)
kbennyscoffre.Closed = function()
    open = false
end

-- [Fonction du Menu]
all_items = {}
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

function Chestkbennys() 
    if open then 
		open = false
		RageUI.Visible(kbennyscoffre, false)
		return
	else
		open = true 
		RageUI.Visible(kbennyscoffre, true)
		    CreateThread(function()
		    while open do 
       
        RageUI.IsVisible(kbennyscoffre, function()
            RageUI.Button("Prendre un objet", nil, {RightLabel = "→"}, true, {onSelected = function()
                getStock()
            end},kbennyscoffre3);

            RageUI.Button("Déposer un objet", nil, {RightLabel = "→"}, true, {onSelected = function()
                getInventory()
            end},kbennyscoffre2);
         end)

        RageUI.IsVisible(kbennyscoffre3, function()
           for k,v in pairs(all_items) do
                RageUI.Button(v.label, nil, {RightLabel = "~o~x"..v.nb}, true, {onSelected = function()
                    local count = KeyboardInput("Combien voulez vous en déposer",nil,10)
                    count = tonumber(count)
                    if count <= v.nb then
                        TriggerServerEvent("kbennys:takeStockItems",v.item, count)
                    else
                        ESX.ShowNotification("~r~Vous n'en avez pas assez sur vous")
                    end
                    getStock()
                end});
             end
         end)

        RageUI.IsVisible(kbennyscoffre2, function()
            for k,v in pairs(all_items) do
                RageUI.Button(v.label, nil, {RightLabel = "~o~x"..v.nb}, true, {onSelected = function()
                    local count = KeyboardInput("Combien voulez vous en déposer",nil,10)
                    count = tonumber(count)
                    TriggerServerEvent("kbennys:putStockItems",v.item, count)
                    getInventory()
                end});
               end
             end)
         Wait(0)
       end
     end)
   end
 end

function getInventory()
    ESX.TriggerServerCallback('kbennys:playerinventory', function(inventory)                          
        all_items = inventory
     end)
  end

function getStock()
    ESX.TriggerServerCallback('kbennys:getStockItems', function(inventory)                         
        all_items = inventory  
    end)
  end

-- [Ouverture du Menu]
Citizen.CreateThread(function()
    while true do
		local wait = 750
			if ESX.PlayerData.job and ESX.PlayerData.job.name == 'bennys' then
				for k in pairs(Config.Position.Coffre) do
				local plyCoords = GetEntityCoords(PlayerPedId() , false)
				local pos = Config.Position.Coffre
				local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, pos[k].x, pos[k].y, pos[k].z)
				if dist <= 2.0 then
					wait = 0
					Visual.Subtitle(Config.TextCoffre, 1)
					if IsControlJustPressed(1,51) then
						Chestkbennys()
					end
				end
			end
		end
    Citizen.Wait(wait)
   end
end)

--kbennys by ! Kamion#1323