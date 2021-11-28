-- kserver.lua
ESX = nil
local playersHealing, deadPlayers = {}, {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

TriggerEvent('esx_society:registerSociety', 'bennys', 'bennys', 'society_bennys', 'society_bennys', 'society_bennys', {type = 'public'})


-- [Annonce Ouverture]
RegisterServerEvent('Ouvre:kbennys')
AddEventHandler('Ouvre:kbennys', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], "Benny's", '~o~Annonce', "Le benny's est désormais ~g~Ouvert~s~ !", 'CHAR_CARSITE3', 8)
	end
end)
-- [Annonce Fermeture]
RegisterServerEvent('Ferme:kbennys')
AddEventHandler('Ferme:kbennys', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], "Benny's", '~o~Annonce', "Le benny's est désormais ~r~Fermer~s~ !", 'CHAR_CARSITE3', 8)
	end
end)
-- [Annonce Recrutement]
RegisterServerEvent('Recru:kbennys')
AddEventHandler('Recru:kbennys', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], "Benny's", '~o~Annonce', "Le benny's ~y~recrute~w~ faites chauffés vos cv !", 'CHAR_CARSITE3', 8)
	end
end)

-- [Coffre]
ESX.RegisterServerCallback('kbennys:playerinventory', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items   = xPlayer.inventory
	local all_items = {}
	
	for k,v in pairs(items) do
		if v.count > 0 then
			table.insert(all_items, {label = v.label, item = v.name,nb = v.count})
		end
	end
  cb(all_items)
end)

ESX.RegisterServerCallback('kbennys:getStockItems', function(source, cb)
	local all_items = {}
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_bennys', function(inventory)
		for k,v in pairs(inventory.items) do
			if v.count > 0 then
				table.insert(all_items, {label = v.label,item = v.name, nb = v.count})
			end
		end
     end)
  cb(all_items)
end)

RegisterServerEvent('kbennys:putStockItems')
AddEventHandler('kbennys:putStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)
	local item_in_inventory = xPlayer.getInventoryItem(itemName).count

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_bennys', function(inventory)
		if item_in_inventory >= count and count > 0 then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
			TriggerClientEvent('esx:showNotification', xPlayer.source, " ~o~Dépot\n~s~ ~o~Item ~s~: "..itemName.."\n~s~ ~o~Quantitée ~s~: "..count.."")
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, "~r~Vous n'en avez pas assez sur vous")
		end
	end)
end)

RegisterServerEvent('kbennys:takeStockItems')
AddEventHandler('kbennys:takeStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_bennys', function(inventory)
			xPlayer.addInventoryItem(itemName, count)
			inventory.removeItem(itemName, count)
			TriggerClientEvent('esx:showNotification', xPlayer.source, " ~o~Retrait\n~s~ ~o~Item ~s~: "..itemName.."\n~s~ ~o~Quantitée ~s~: "..count.."")
	end)
end)

-- [Boss]
RegisterServerEvent('kbennys:withdrawMoney')
AddEventHandler('kbennys:withdrawMoney', function(society, amount, money_soc)
	local xPlayer = ESX.GetPlayerFromId(source)
	local src = source
  
	TriggerEvent('esx_addonaccount:getSharedAccount', society, function(account)
	  if account.money >= tonumber(amount) then
		  xPlayer.addMoney(amount)
		  account.removeMoney(amount)
		  TriggerClientEvent("esx:showNotification", src, " ~o~Retiré \n~s~ ~s~Somme : "..amount.."$")
	  else
		    TriggerClientEvent("esx:showNotification", src, " ~r~Erreur \n~s~ ~r~Pas assez d'argent")
	  end
	end)
	  
  end)

RegisterServerEvent('kbennys:depositMoney')
AddEventHandler('kbennys:depositMoney', function(society, amount)

	local xPlayer = ESX.GetPlayerFromId(source)
	local money = xPlayer.getMoney()
	local src = source
  
	TriggerEvent('esx_addonaccount:getSharedAccount', society, function(account)
	  if money >= tonumber(amount) then
		  xPlayer.removeMoney(amount)
		  account.addMoney(amount)
		  TriggerClientEvent("esx:showNotification", src, " ~o~Déposé \n~s~ ~s~Somme : "..amount.."$")
	  else
		  TriggerClientEvent("esx:showNotification", src, " ~r~Erreur \n~s~ ~r~Pas assez d'argent")
	  end
	end)
	
end)

ESX.RegisterServerCallback('kbennys:getSocietyMoney', function(source, cb, soc)
	local money = nil
		MySQL.Async.fetchAll('SELECT * FROM addon_account_data WHERE account_name = @society ', {
			['@society'] = soc,
		}, function(data)
			for _,v in pairs(data) do
				money = v.money
			end
			cb(money)
		end)
end)

-- [Prise de Service]

function sendToDiscordWithSpecialURL(name,message,color,url)
    local DiscordWebHook = url
	local embeds = {
		{
			["title"]=message,
			["type"]="rich",
			["color"] =color,
		}
	}
    if message == nil or message == '' then return FALSE end
    PerformHttpRequest(kbennysLogs, function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end

RegisterNetEvent('kbennys:prisedeservice')
AddEventHandler('kbennys:prisedeservice', function()
	local _src = source
	local xPlayer = ESX.GetPlayerFromId(_src)
	sendToDiscordWithSpecialURL("Prise de service",xPlayer.getName().." à prise son service au bennys", 9999999, kbennysLogs)
end)

RegisterNetEvent('kbennys:quitteleservice')
AddEventHandler('kbennys:quitteleservice', function()
	local _src = source
	local xPlayer = ESX.GetPlayerFromId(_src)
	sendToDiscordWithSpecialURL("Fin de service",xPlayer.getName().." à quitter son service au bennys", 9999999, kbennysLogs)
end)

-- [Accueil]
local function sendToDiscordWithSpecialURL(Color, Title, Description)
	local Content = {
	        {
	            ["color"] = Color,
	            ["title"] = Title,
	            ["description"] = Description,    
	        }
	    }
	PerformHttpRequest(kbennysLogs, function(err, text, headers) end, 'POST', json.encode({username = Name, embeds = Content}), { ['Content-Type'] = 'application/json' })
end

RegisterServerEvent("Rdv:kbennysMotif")
AddEventHandler("Rdv:kbennysMotif", function(nomprenom, numero, heurerdv, rdvmotif)
	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local ident = xPlayer.getIdentifier()
	local date = os.date('*t')
    if date.day < 10 then date.day = '' .. tostring(date.day) end
	if date.month < 10 then date.month = '' .. tostring(date.month) end
	if date.hour < 10 then date.hour = '' .. tostring(date.hour) end
	if date.min < 10 then date.min = '' .. tostring(date.min) end
	if date.sec < 10 then date.sec = '' .. tostring(date.sec) end
    if ident == 'steam:11' then
	else 
		sendToDiscordWithSpecialURL(9999999, "__**Nouveau Rendez-Vous :**__\n\n **Nom :** "..nomprenom.."\n\n**Numéro de Téléphone:** "..numero.."\n\n**Heure du Rendez Vous** : " ..heurerdv.."\n\n**Motif du Rendez-vous :** " ..rdvmotif.. "\n\n**Date :** " .. date.day .. "." .. date.month .. "." .. date.year .. " | " .. date.hour .. " h " .. date.min .. " min " .. date.sec)
	end
end)

RegisterServerEvent('Appel:kbennys')
AddEventHandler('Appel:kbennys', function()
   	local xPlayers = ESX.GetPlayers()
	for i = 1, #xPlayers, 1 do
		local thePlayer = ESX.GetPlayerFromId(xPlayers[i])
		if thePlayer.job.name == 'bennys' then
		TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'Secrétaire bennys', '~o~Accueil', 'Un employer du bennys est appelé à l\'accueil !', 'CHAR_CARSITE3', 8)
        end
    end
end)

-- kbennys by ! Kamion#1323