local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

for _, v in pairs(Players:GetPlayers()) do
    if v ~= Players.LocalPlayer and not v.Character:FindFirstChild("Highlight") then
        local hl = Instance.new("Highlight", v.Character)
        hl.FillColor = Color3.new(1, 0, 0)
        hl.OutlineColor = Color3.new(1, 1, 1)
    end
end

Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function(char)
        local hl = Instance.new("Highlight", char)
        hl.FillColor = Color3.new(1, 0, 0)
        hl.OutlineColor = Color3.new(1, 1, 1)
    end)
end)
