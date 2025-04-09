--[[
To reserved server
local teleport = game:GetService("TeleportService")
local players = game:GetService("Players")

local place = game.PlaceId

local subject = players:FindFirstChild("steamyfinger")
local server = teleport:ReserveServer(place)
teleport:TeleportToPrivateServer(place, server, {subject})
----
Get server location
local http = game:GetService("HttpService")
local url = "http://ip-api.com/json/"
local regionapi = http:JSONDecode(http:GetAsync(url))
print(regionapi)
]]
