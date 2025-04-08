local globalDS = game:GetService("DataStoreService"):GetGlobalDataStore("RatingsContribution")
local replicatedstorage = game:GetService("ReplicatedStorage")

local players = {}

local events = replicatedstorage.Events
local assets = replicatedstorage.Assets

local rankings = require(assets.Ranks)
local data = globalDS:GetAsync(id).

events.StartPairing.OnServerEvent:Connect(function(player)
	
end)

game.Players.PlayerAdded:Connect(function(player)
	local id = player.UserId
	players[id] = globalDS:GetAsync(id).PairingSettings
end)
