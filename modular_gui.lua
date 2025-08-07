-- modular_gui.lua
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

if PlayerGui:FindFirstChild("ModularGUI") then
    PlayerGui:FindFirstChild("ModularGUI"):Destroy()
end

local gui = Instance.new("ScreenGui", PlayerGui)
gui.Name = "ModularGUI"
gui.ResetOnSpawn = false

-- Toggle Button
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 100, 0, 35)
toggleButton.Position = UDim2.new(0, 10, 0.5, -17)
toggleButton.Text = "☰ Hub"
toggleButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.TextSize = 18
toggleButton.Parent = gui
toggleButton.ZIndex = 2

-- Main Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 400, 0, 300)
frame.Position = UDim2.new(0.5, -200, 0.5, -150)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Visible = true
frame.Active = true
frame.Draggable = true
frame.Parent = gui

-- Title
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "🧠 Script Hub"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextSize = 22
title.Font = Enum.Font.SourceSansBold
title.BackgroundTransparency = 1

-- Button Container
local container = Instance.new("Frame", frame)
container.Size = UDim2.new(1, -20, 1, -50)
container.Position = UDim2.new(0, 10, 0, 45)
container.BackgroundTransparency = 1

local layout = Instance.new("UIListLayout", container)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 6)

-- Toggle handler
toggleButton.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)

-- Module URLs
local modules = {
    {name = "🔍 ESP", url = "https://raw.githubusercontent.com/Account-not-found/cuddly-octo-spork/refs/heads/modules/esp.lua"},
    {name = "🚀 Fly", url = "https://raw.githubusercontent.com/Account-not-found/cuddly-octo-spork/refs/heads/modules/fly.lua"},
    {name = "🕳️ Noclip", url = "https://raw.githubusercontent.com/Account-not-found/cuddly-octo-spork/refs/heads/modules/noclip.lua"},
    {name = "🔄 Rejoin", url = "https://raw.githubusercontent.com/Account-not-found/cuddly-octo-spork/refs/heads/modules/rejoin.lua"},
    {name = "🚪 Server Hop", url = "https://raw.githubusercontent.com/Account-not-found/cuddly-octo-spork/refs/heads/modules/serverhop.lua"},
    {name = "💤 Anti-AFK", url = "https://raw.githubusercontent.com/Account-not-found/cuddly-octo-spork/refs/heads/modules/antiafk.lua"},
}

local loaded = {}

for _, mod in ipairs(modules) do
    local button = Instance.new("TextButton", container)
    button.Size = UDim2.new(1, 0, 0, 30)
    button.Text = mod.name
    button.TextSize = 18
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Font = Enum.Font.SourceSans
    button.BackgroundColor3 = Color3.fromRGB(55, 55, 55)

    button.MouseButton1Click:Connect(function()
        if loaded[mod.name] then
            loaded[mod.name] = false
            if _G.ModuleFlags then _G.ModuleFlags[mod.name] = false end
            button.Text = mod.name
            return
        end

        local success, err = pcall(function()
            loadstring(game:HttpGet(mod.url))()
        end)

        if success then
            loaded[mod.name] = true
            if not _G.ModuleFlags then _G.ModuleFlags = {} end
            _G.ModuleFlags[mod.name] = true
            button.Text = "✅ " .. mod.name
        else
            warn("Failed to load " .. mod.name .. ": " .. tostring(err))
        end
    end)
end
