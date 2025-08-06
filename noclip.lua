local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- noclip.lua
if _G.NoclipConn then
    _G.NoclipConn:Disconnect()
    _G.NoclipConn = nil
    return
end

_G.NoclipConn = game:GetService("RunService").Stepped:Connect(function()
    for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
        if part:IsA("BasePart") and part.CanCollide == true then
            part.CanCollide = false
        end
    end
end)
