local datastoreservice = game:GetService("DataStoreService"):GetGlobalDataStore("RatingsContribution")

local players = {}

game.Players.PlayerAdded:Connect(function(player)
	local id = player.UserId
	players[id] = datastoreservice:GetAsync(id).PairingSettings
end)
