-- modular_gui.lua
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer

local function createButton(parent, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, 0)
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 18
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = true
    btn.Parent = parent

    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
ScreenGui.Name = "ModularScriptHub"

-- Toggle Button
local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 100, 0, 35)
ToggleButton.Position = UDim2.new(0, 20, 0.5, -17)
ToggleButton.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
ToggleButton.Text = "📂 Script Hub"
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 14
ToggleButton.TextColor3 = Color3.new(1,1,1)
ToggleButton.Draggable = true
ToggleButton.Active = true
ToggleButton.Parent = ScreenGui

-- Main Frame
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 420, 0, 330)
Frame.Position = UDim2.new(0.5, -210, 0.5, -165)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
Frame.BorderSizePixel = 0
Frame.Visible = false
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

-- Title
local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0, 45)
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
Title.Text = "📜 Script Hub - Pro Tier"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20

-- Container for buttons
local ButtonContainer = Instance.new("ScrollingFrame", Frame)
ButtonContainer.Size = UDim2.new(1, -20, 1, -60)
ButtonContainer.Position = UDim2.new(0, 10, 0, 50)
ButtonContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
ButtonContainer.ScrollBarThickness = 6
ButtonContainer.BackgroundTransparency = 1

-- Layout
local Layout = Instance.new("UIListLayout", ButtonContainer)
Layout.Padding = UDim.new(0, 6)
Layout.SortOrder = Enum.SortOrder.LayoutOrder

-- Toggle GUI visibility
ToggleButton.MouseButton1Click:Connect(function()
    Frame.Visible = not Frame.Visible
end)

-- Module URLs
local Modules = {
    {name = "🔍 Enable ESP", url = "https://raw.githubusercontent.com/Account-not-found/cuddly-octo-spork/refs/heads/modules/esp.lua"},
    {name = "🚀 Enable Fly", url = "https://raw.githubusercontent.com/Account-not-found/cuddly-octo-spork/refs/heads/modules/fly.lua"},
    {name = "🕳️ Enable Noclip", url = "https://raw.githubusercontent.com/Account-not-found/cuddly-octo-spork/refs/heads/modules/noclip.lua"},
    {name = "🔄 Rejoin", url = "https://raw.githubusercontent.com/Account-not-found/cuddly-octo-spork/refs/heads/modules/rejoin.lua"},
    {name = "🚪 Server Hop", url = "https://raw.githubusercontent.com/Account-not-found/cuddly-octo-spork/refs/heads/modules/serverhop.lua"},
    {name = "💤 Anti-AFK", url = "https://raw.githubusercontent.com/Account-not-found/cuddly-octo-spork/refs/heads/modules/antiafk.lua"},
}

-- Add buttons
for _, mod in ipairs(Modules) do
    createButton(ButtonContainer, mod.name, function()
        local success, err = pcall(function()
            loadstring(game:HttpGet(mod.url))()
        end)
        if not success then
            warn("Error loading " .. mod.name .. ": " .. tostring(err))
        end
    end)
end

-- Auto-resize canvas
ButtonContainer.ChildAdded:Connect(function()
    task.wait()
    ButtonContainer.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 10)
end)
