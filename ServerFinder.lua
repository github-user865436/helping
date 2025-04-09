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

local storage = game:GetService("ReplicatedStorage")

local List = script.Parent
local ServerCount = 0
local Correlations = {}

local function UpdateLayout()
	List.Layout.CellPadding = UDim2.new(0, 0, 1 / (5 * ServerCount), 0)
	List.Layout.CellSize = UDim2.new(1, 0, 1 / (1.25 * ServerCount))
end

local Updates = storage.Events.ManageServerList

Updates.OnClientEvent:Connect(function(Info, Create)
	if Create then
		local Server = script.DividerTemplate:Clone()
		
		Server.Name = "Server"..tostring(ServerCount)
		Server.Region.Text = Info.Region
		Server.Restrictions.Low = Info.Restrictions.Low
		Server.Restrictions.High = Info.Restrictions.High
		Server.Server.Value = Info.Server
		
		Correlations[Info.Server] = ServerCount
		ServerCount += 1
		UpdateLayout()
		
		Server.Parent = List
	else
		List["Server"..tostring(Correlations[Info.Server])]:Destroy()
	end
end)
