local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- esp.lua
if _G.ESPEnabled then
    _G.ESPEnabled = false
    for _, v in pairs(game.CoreGui:GetChildren()) do
        if v.Name == "ESPHighlight" then v:Destroy() end
    end
    return
end

_G.ESPEnabled = true

local function createESP(char)
    local highlight = Instance.new("Highlight")
    highlight.Name = "ESPHighlight"
    highlight.FillColor = Color3.new(1, 0, 0)
    highlight.OutlineColor = Color3.new(1, 1, 1)
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.Adornee = char
    highlight.Parent = game.CoreGui
end

for _, p in pairs(game.Players:GetPlayers()) do
    if p ~= game.Players.LocalPlayer and p.Character then
        createESP(p.Character)
    end
end

game.Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function(c)
        if _G.ESPEnabled then createESP(c) end
    end)
end)

