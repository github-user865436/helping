local storage = game:GetService("ReplicatedStorage")
local datastore = game:GetService("DataStoreService")

local datastorage = datastore:GetDataStore("RatingsContribution") --Do not change the name of this after implementing

local players = {}
local updated = false

local SetRating = function(player, games)
	local id = player.UserId
	
	local data = players[id]
	local live = data[#data]

	local module = storage.RatingSystems  --Subject to change based on module location
	
	local name = "GLICKO-2"
	local input = {
		Constant = 0.5, --Do not change unless you know what you are doing
		Base = table.clone(live),
		Games = games
	}
	
	table.insert(players[id].RankedGames, require(module[name])(input))
	updated = true
end)
storage.Events.SetRating.Event:Connect(SetRating)

local PlayerAdded = function(player)
	players[player.UserId] = (datastore:GetAsync(player.UserId) or require(storage.Assets.DefaultData))
end)
game.Players.PlayerAdded:Connect(PlayerAdded)

local PlayerRemoving = function(player)
	local id = player.UserId
	if updated then --Checks if the data set is necessary
		--print(players[id])
		datastorage:SetAsync(id, players[id])
	end
	players[id] = nil --Clears up space
end)
game.Players.PlayerRemoving:Connect(PlayerRemoving)
