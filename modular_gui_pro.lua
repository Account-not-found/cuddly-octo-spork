-- modular_gui.lua (Professional Polished Version)
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer

-- Configuration
local accentColor = Color3.fromRGB(0, 170, 255)
local darkColor = Color3.fromRGB(30, 30, 30)
local textColor = Color3.new(1, 1, 1)
local modules = {
    {name = "ESP", icon = "🔍", url = "https://raw.githubusercontent.com/Account-not-found/cuddly-octo-spork/refs/heads/modules/esp.lua"},
    {name = "Fly", icon = "🚀", url = "https://raw.githubusercontent.com/Account-not-found/cuddly-octo-spork/refs/heads/modules/fly.lua"},
    {name = "Noclip", icon = "🕳️", url = "https://raw.githubusercontent.com/Account-not-found/cuddly-octo-spork/refs/heads/modules/noclip.lua"},
    {name = "Rejoin", icon = "🔄", url = "https://raw.githubusercontent.com/Account-not-found/cuddly-octo-spork/refs/heads/modules/rejoin.lua"},
    {name = "Server Hop", icon = "🚪", url = "https://raw.githubusercontent.com/Account-not-found/cuddly-octo-spork/refs/heads/modules/serverhop.lua"},
    {name = "Anti-AFK", icon = "💤", url = "https://raw.githubusercontent.com/Account-not-found/cuddly-octo-spork/refs/heads/modules/antiafk.lua"}
}

-- GUI Setup
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "ScriptHubUI"
gui.ResetOnSpawn = false

-- Toggle Button
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 40, 0, 40)
toggleButton.Position = UDim2.new(0, 10, 0.5, -20)
toggleButton.BackgroundColor3 = accentColor
toggleButton.Text = "≡"
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextSize = 20
toggleButton.Parent = gui
toggleButton.Active = true
toggleButton.Draggable = true

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 420, 0, 350)
mainFrame.Position = UDim2.new(0.5, -210, 0.5, -175)
mainFrame.BackgroundColor3 = darkColor
mainFrame.Visible = false
mainFrame.Parent = gui
mainFrame.Active = true
mainFrame.Draggable = true

-- UICorner
local corner = Instance.new("UICorner", mainFrame)
corner.CornerRadius = UDim.new(0, 6)

-- Title
local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "💻 Script Hub Pro"
title.TextColor3 = accentColor
title.Font = Enum.Font.GothamBold
title.TextSize = 22

-- Container
local container = Instance.new("ScrollingFrame", mainFrame)
container.Size = UDim2.new(1, -20, 1, -60)
container.Position = UDim2.new(0, 10, 0, 50)
container.BackgroundTransparency = 1
container.BorderSizePixel = 0
container.ScrollBarThickness = 4
container.CanvasSize = UDim2.new(0, 0, 0, 0)

-- Layout
local layout = Instance.new("UIListLayout", container)
layout.Padding = UDim.new(0, 8)
layout.SortOrder = Enum.SortOrder.LayoutOrder

-- Status Label
local status = Instance.new("TextLabel", mainFrame)
status.Size = UDim2.new(1, -20, 0, 20)
status.Position = UDim2.new(0, 10, 1, -25)
status.BackgroundTransparency = 1
status.TextColor3 = textColor
status.Font = Enum.Font.Gotham
status.TextSize = 14
status.Text = "🟢 Ready."

-- Create Buttons
for _, mod in ipairs(modules) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.Text = mod.icon .. "  " .. mod.name
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 18
    btn.TextColor3 = textColor
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.AutoButtonColor = true
    btn.Parent = container

    local uic = Instance.new("UICorner", btn)
    uic.CornerRadius = UDim.new(0, 4)

    btn.MouseButton1Click:Connect(function()
        status.Text = "⏳ Loading " .. mod.name .. "..."
        local s, err = pcall(function()
            loadstring(game:HttpGet(mod.url))()
        end)
        status.Text = s and ("✅ Loaded " .. mod.name) or ("❌ Error: " .. tostring(err))
    end)
end

-- Responsive canvas
container.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    container.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
end)

-- Toggle logic
toggleButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

-- Resize + ESC close
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.RightControl then
        mainFrame.Visible = not mainFrame.Visible
    end
end)
