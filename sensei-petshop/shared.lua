Config = {}

Config.vetlocation = vector3(-1406.05, -431.21, 35.55) --change blip vector inside client.lua
Config.shoplocation = vector3(563.76, 2753.27, 41.88) ---change blip vector inside client.lua

Config.K9Message = "The K9 has been found something!" -- If the Police dog finds something

Config.UseNewInventory = false -- Set to true if you are using the new qb-inventory; false for the old qb-inventory

Config.SearchableItems = {

	["IllegalItems"] = {
		["weed"] = 10,
		["coke"] = 1,
		["bread"] = 1,
		["water"] = 1,
	},
}



Config.IllnessChance = 5 -- Chance to get Sick (For Pets) 

Config.HealPrice = 500

Config.FoodPrice = 500

Config.FoodItem = "petfood" 

Config.TennisBallPrice = 3500

Config.Pets = {
	{ name = "a_c_cat_01", price = 30000, label = "Cat" },
	{ name = "a_c_poodle", price = 120000, label = "Poodle" },
	{ name = "a_c_pug", price = 50000, label = "Pug" },
	{ name = "a_c_husky", price = 70000, label = "Husky" },
	{ name = "a_c_rottweiler", price = 140000, label = "Rottweiler" },
	{ name = "a_c_hen", price = 80000, label = "Huge Cock" },
	{ name = "a_c_retriever", price = 85000, label = "Retriever" },
	{ name = "a_c_westy", price = 55000, label = "Highland Terrier" },
	{ name = "a_c_shepherd", price = 80000, label = "Shepherd" },
	{ name = "a_c_rabbit_01", price = 80000, label = "Rabbit" },
	{ name = "a_c_pig", price = 80000, label = "Pig" },
	{ name = "a_c_boar", price = 80000, label = "Boar" },

	-- Add more pets here as needed
}
