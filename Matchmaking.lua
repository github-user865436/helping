--[[
Add server region selector: more servers, precise player location, better latency.
Add warning for a bit less locational privacy especially for all under 13.
Add play button on servers with the region.
--
Add the division difference between the player and the player who started the server.
Allow players 50 elo delta to be allowed as long as their recent (10 game) win rate is not above 50%.
Put ELO to division charting sideways here, with player division in bold and progress to the right.
----
Change the requirement to be selected to be on sides.
]]--

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

local function reserveServer()
	local Server = teleport:ReserveServer(game.PlaceId)
	local Region = messaging:SubscribeAsync(Server)
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
end)
storage.Events.InitiateParty.OnServerEvent:Connect(InitiateParty)

local StartPairing = function(player)
	local pairing = {player}
	local party = playerdata.Parties[player]
	if party then
		table.insert(pairing, table.unpack(party)
	end
	globalDS:SetAsync(-)
end)
storage.Events.StartPairing.OnServerEvent:Connect(StartPairing)

local ChangeRequirements = function(player, division, latency)
	local id = player.UserId
	playerdata.Requirements[id] = {Division = division, Latency = latency}
end)
storage.Events.ChangeRequirements.OnServerEvent:Connect(ChangeRequirements)
