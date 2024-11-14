local QBCore = exports["qb-core"]:GetCoreObject()

RegisterServerEvent("sensei-petshop:buyPet")
AddEventHandler("sensei-petshop:buyPet", function(petType, price)
	local src = source
	local xPlayer = QBCore.Functions.GetPlayer(src)

	exports.oxmysql:execute("SELECT * FROM pets WHERE owner = ?", {
		xPlayer.PlayerData.citizenid,
	}, function(result)
		local ifOwner = table.unpack(result)
		if ifOwner ~= nil then
			TriggerClientEvent("QBCore:Notify", src, "You already own a Pet!", "error")
		else
			if xPlayer.PlayerData.money.bank > price then
				TriggerClientEvent("QBCore:Notify", src, "You purchased a Pet!", "success")
				xPlayer.Functions.RemoveMoney("bank", price)
				exports.oxmysql:execute("INSERT INTO pets (owner, modelname) VALUES (?, ?)", {
					xPlayer.PlayerData.citizenid,
					petType,
				}, function(rowsChanged) end)
			else
				TriggerClientEvent("QBCore:Notify", src, "You cannot afford this pet", "error")
			end
		end
	end)
end)

RegisterServerEvent("sensei-petshop:buyFood")
AddEventHandler("sensei-petshop:buyFood", function(price)
	local xPlayer = QBCore.Functions.GetPlayer(source)
	if xPlayer.PlayerData.money.bank >= price then
		xPlayer.Functions.RemoveMoney("bank", price)
		if Config.UseNewInventory then
			exports["qb-inventory"]:AddItem(source, Config.FoodItem, 1) -- New qb-inventory export
			TriggerClientEvent("qb-inventory:client:ItemBox", source, QBCore.Shared.Items[Config.FoodItem], "add")
		else
			xPlayer.Functions.AddItem(Config.FoodItem, 1) -- Old inventory method
		end
		TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items[Config.FoodItem], "add")
	else
		TriggerClientEvent("QBCore:Notify", source, "You cannot afford this pet food", "error")
	end
end)

RegisterServerEvent("sensei-petshop:buyTennisBall")
AddEventHandler("sensei-petshop:buyTennisBall", function(price)
	local xPlayer = QBCore.Functions.GetPlayer(source)
	if xPlayer.PlayerData.money.bank >= price then
		xPlayer.Functions.RemoveMoney("bank", price)
		if Config.UseNewInventory then
			exports["qb-inventory"]:AddItem(source, "tennisball", 1) -- New qb-inventory export
			TriggerClientEvent("qb-inventory:client:ItemBox", source, QBCore.Shared.Items["tennisball"], "add")
		else
			xPlayer.Functions.AddItem("tennisball", 1) -- Old inventory method
		end
		TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items["tennisball"], "add")
	else
		TriggerClientEvent("QBCore:Notify", source, "You cannot afford this Tennisball", "error")
	end
end)

RegisterServerEvent("sensei-petshop:getOwnedPet")
AddEventHandler("sensei-petshop:getOwnedPet", function()
	local xPlayer = QBCore.Functions.GetPlayer(source)

	exports.oxmysql:execute("SELECT * FROM pets WHERE owner = ?", {
		xPlayer.PlayerData.citizenid,
	}, function(result)
		TriggerClientEvent("sensei-petshop:spawnPet", modelname, health, illness)
	end)
end)

RegisterServerEvent("sensei-petshop:chargeABitch")
AddEventHandler("sensei-petshop:chargeABitch", function(fee)
	local xPlayer = QBCore.Functions.GetPlayer(source)
	if xPlayer.PlayerData.money.bank >= (Config.HealPrice + fee) then
		xPlayer.Functions.RemoveMoney("bank", (Config.HealPrice + fee))
	end
end)

RegisterServerEvent("sensei-petshop:returnBall")
AddEventHandler("sensei-petshop:returnBall", function()
	local xPlayer = QBCore.Functions.GetPlayer(source)
	if Config.UseNewInventory then
		exports["qb-inventory"]:AddItem(source, "tennisball", 1) -- New qb-inventory export
		TriggerClientEvent("qb-inventory:client:ItemBox", source, QBCore.Shared.Items["tennisball"], "add")
	else
		xPlayer.Functions.AddItem("tennisball", 1) -- Old inventory method
	end
	TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items["tennisball"], "add")
end)

RegisterServerEvent("sensei-petshop:removeBall")
AddEventHandler("sensei-petshop:removeBall", function()
	local xPlayer = QBCore.Functions.GetPlayer(source)
	if Config.UseNewInventory then
		exports["qb-inventory"]:RemoveItem(source, "tennisball", 1) -- New qb-inventory export
		TriggerClientEvent("qb-inventory:client:ItemBox", source, QBCore.Shared.Items["tennisball"], "remove")
	else
		xPlayer.Functions.RemoveItem("tennisball", 1) -- Old inventory method
	end
	TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items["tennisball"], "remove")
end)

QBCore.Functions.CreateUseableItem("tennisball", function(source)
	local xPlayer = QBCore.Functions.GetPlayer(source)
	TriggerClientEvent("sensei-petshop:useTennisBall", source)
	if Config.UseNewInventory then
		exports["qb-inventory"]:RemoveItem(source, "tennisball", 1) -- New qb-inventory export
		TriggerClientEvent("qb-inventory:client:ItemBox", source, QBCore.Shared.Items["tennisball"], "remove")
	else
		xPlayer.Functions.RemoveItem("tennisball", 1) -- Old inventory method
	end
	TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items["tennisball"], "remove")
end)

function getPet(citizenid)
	exports.oxmysql:execute("SELECT * FROM pets WHERE owner = ?", {
		citizenid,
	}, function(result)
		id = result[1].id
		owner = result[1].owner
		modelname = result[1].modelname
		health = result[1].health
		illnesses = result[1].illnesses
		cb(id, owner, modelname, health, illnesses)
	end)
end

QBCore.Functions.CreateCallback("sensei-petshop:getPetSQL", function(source, cb)
	local xPlayer = QBCore.Functions.GetPlayer(source)
	exports.oxmysql:execute("SELECT * FROM pets WHERE owner = ?", {
		xPlayer.PlayerData.citizenid,
	}, function(result)
		cb(result)
	end)
end)

QBCore.Functions.CreateCallback("sensei-petshop:feedPetCallback", function(source, cb)
	local Player = QBCore.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(Config.FoodItem, 1) then
		TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items[Config.FoodItem], "remove")
		cb(true)
	else
		cb(false)
	end
end)

RegisterServerEvent("sensei-petshop:updatePet")
AddEventHandler("sensei-petshop:updatePet", function(health, illness)
	local xPlayer = QBCore.Functions.GetPlayer(source)

	exports.oxmysql:execute("UPDATE pets SET health = ?, illnesses = ? WHERE owner = ?", {
		health,
		illness,
		xPlayer.PlayerData.citizenid,
	}, function(rowsChanged) end)
end)

RegisterServerEvent("sensei-petshop:updatePetName")
AddEventHandler("sensei-petshop:updatePetName", function(name)
	local xPlayer = QBCore.Functions.GetPlayer(source)

	exports.oxmysql:execute("UPDATE pets SET name = ? WHERE owner = ?", {
		name,
		xPlayer.PlayerData.citizenid,
	}, function(rowsChanged) end)
end)

RegisterServerEvent("sensei-petshop:removePet")
AddEventHandler("sensei-petshop:removePet", function()
	local xPlayer = QBCore.Functions.GetPlayer(source)
	exports.oxmysql:execute("DELETE FROM pets WHERE owner = ?", {
		xPlayer.PlayerData.citizenid,
	})
end)

RegisterNetEvent("sensei-petshop:k9Search")
AddEventHandler("sensei-petshop:k9Search", function(ID, targetID)
	local itemFound = false
	local source = source
	local targetPlayer = QBCore.Functions.GetPlayer(targetID)
	for k, v in pairs(Config.SearchableItems.IllegalItems) do
		if targetPlayer.Functions.GetItemByName(k).count >= v then
			itemFound = true
		end
	end

	TriggerClientEvent("sensei-petshop:k9ItemCheck", source, itemFound)
end)
