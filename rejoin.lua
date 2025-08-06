-- rejoin.lua
local ts = game:GetService("TeleportService")
local plr = game:GetService("Players").LocalPlayer

ts:Teleport(game.PlaceId, plr)
