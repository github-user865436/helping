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
local players = game:GetService("Players")

local gId = game.PlaceId

local playerdata = {
	Divisions = {},
	Parties = {},
	Requirements = {},
	Pairing = {},
}

local events = storage.Events
local assets = storage.Assets

local rankings = require(assets.Ranks)
local globalDS = datastore:GetGlobalDataStore("RatingsContribution")

local function reserveServer()
	local Server = teleport:ReserveServer(gId)
	local Region = messaging:SubscribeAsync(Server)
	return {Region, Server}
end

local function teleportPlayers(Server, Players)
	teleport:TeleportToPrivateServer(gId, Server, Players)
end

local function getPlayerRequirements(player)
	
end

local function findParty()

end

local InitiateParty = function(player, players)
	playerdata.Parties[player] = players --excluding the party owner
end)
events.InitiateParty.OnServerEvent:Connect(InitiateParty)

local StartPairing = function(player)
	local pairing = {player}
	local party = playerdata.Parties[player]
	if party then
		table.insert(pairing, table.unpack(party)
	end
	table.insert(playerdata.Pairing, pairing)
end)
events.StartPairing.OnServerEvent:Connect(StartPairing)

local ChangeRequirements = function(player, division, latency)
	local id = player.UserId
	playerdata.Requirements[id] = {Division = division, Latency = latency}
end)
events.ChangeRequirements.OnServerEvent:Connect(ChangeRequirements)

players.PlayerAdded:Connect(function(player)

end)
