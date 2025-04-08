local players = {}
local updated = false

local replicatedstorage = game:GetService("ReplicatedStorage")
local datastoreservice = game:GetService("DataStoreService")

local datastorage = datastoreservice:GetDataStore("RatingsContribution") --Do not change the name of this after implementing

local events = replicatedstorage.Events
local assets = replicatedstorage.Assets
local module = replicatedstorage.RatingSystems  --Subject to change based on module location

events.SetRating.Event:Connect(function(player, games)
	local id = player.UserId
	local data = players[id]
	local live = data[#data]
	local name = "GLICKO-2"
	
	local input = {
		Constant = 0.5, --Do not change unless you know what you are doing
		Base = table.clone(live),
		Games = games
	}
	
	table.insert(players[id].RankedGames, require(module[name])(input))
	updated = true
end)

local PlayerAdded = function(player)
	--[[
	Move to assets named DefaultData
	return {
		RankedGames = {
			{
				Rating = 1500,
				RatingDeviation = 200,
				Volatility = 0.06
			},
		},
		PairingSettings = {
			Matchmaking = false,
			DivisionDiffHigh = 1,
			ClientLatencyHigh = 180,
		},
	}
	]]

	local defaultData = require(assets.DefaultData)
	local id = player.UserId
	local savestate = datastorage:GetAsync(id)
	if savestate == nil then
		players[id] = defaultData
	else
		players[id] = saveState
	end
end)
game.Players.PlayerAdded:Connect(PlayerAdded)

local PlayerRemoving = function(player)
	local id = player.UserId
	if updated then --Checks if the data set is necessary
		print(players[id])
		datastorage:SetAsync(id, players[id])
	end
	players[id] = nil --Clears up space
end)
game.Players.PlayerRemoving:Connect(PlayerRemoving)
