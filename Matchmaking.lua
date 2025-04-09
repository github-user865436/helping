local datastore = game:GetService("DataStoreService")
local storage = game:GetService("ReplicatedStorage")
local teleport = game:GetService("TeleportService")
local messaging = game:GetService("MessagingService")

local playerdata = {
	Divisions = {},
	Parties = {},
	Pairing = {},
}

local rankings = require(storage.Assets.Ranks)
local globalDS = datastore:GetGlobalDataStore("RatingsContribution")

local function reserveServer(destroy)
	local Server = teleport:ReserveServer(game.PlaceId)
	local Region = messaging:SubscribeAsync(Server)
	storage.Events.ManageServerList:FireAllClients()
	messaging:PublishAsync(Server)
	return {Region, Server}
end

local function teleportPlayers(Server, Players)
	teleport:TeleportToPrivateServer(game.PlaceId, Server, Players)
end

local function getPlayerRequirements(player)
	return playerdata.Requirements[player.UserId]
end

local InitiateParty = function(player, players)
	playerdata.Parties[player] = players --excluding the party owner
end
storage.Events.InitiateParty.OnServerEvent:Connect(InitiateParty)

local StartPairing = function(player)
	local pairing = {player}
	local party = playerdata.Parties[player]
	if party then
		table.insert(pairing, table.unpack(party))
	end
	globalDS:SetAsync()
end
storage.Events.StartPairing.OnServerEvent:Connect(StartPairing)

local ChangeRequirements = function(player, division, latency)
	local id = player.UserId
	playerdata.Requirements[id] = {Division = division, Latency = latency}
end
storage.Events.ChangeRequirements.OnServerEvent:Connect(ChangeRequirements)
