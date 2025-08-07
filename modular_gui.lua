-- modular_gui.lua (Upgraded UI)
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

-- GUI Creation
local ScreenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
ScreenGui.Name = "ModularGUI"
ScreenGui.ResetOnSpawn = false

local ToggleButton = Instance.new("TextButton", ScreenGui)
ToggleButton.Size = UDim2.new(0, 100, 0, 40)
ToggleButton.Position = UDim2.new(0, 10, 0.5, -20)
ToggleButton.Text = "☰ Menu"
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 18
ToggleButton.TextColor3 = Color3.new(1, 1, 1)
ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ToggleButton.BorderSizePixel = 0
ToggleButton.ZIndex = 2

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 400, 0, 350)
Frame.Position = UDim2.new(0.5, -200, 0.5, -175)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BorderSizePixel = 0
Frame.Visible = true
Frame.Active = true
Frame.Draggable = true

local Accent = Instance.new("Frame", Frame)
Accent.Size = UDim2.new(1, 0, 0, 4)
Accent.Position = UDim2.new(0, 0, 0, 0)
Accent.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
Accent.BorderSizePixel = 0

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Position = UDim2.new(0, 0, 0, 4)
Title.BackgroundTransparency = 1
Title.Text = "🔧 Script Hub"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 22

local SearchBar = Instance.new("TextBox", Frame)
SearchBar.PlaceholderText = "🔍 Search modules..."
SearchBar.Size = UDim2.new(1, -20, 0, 30)
SearchBar.Position = UDim2.new(0, 10, 0, 50)
SearchBar.Text = ""
SearchBar.Font = Enum.Font.SourceSans
SearchBar.TextSize = 16
SearchBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
SearchBar.TextColor3 = Color3.new(1, 1, 1)
SearchBar.BorderSizePixel = 0

local ButtonContainer = Instance.new("ScrollingFrame", Frame)
ButtonContainer.Size = UDim2.new(1, -20, 1, -100)
ButtonContainer.Position = UDim2.new(0, 10, 0, 90)
ButtonContainer.BackgroundTransparency = 1
ButtonContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
ButtonContainer.ScrollBarThickness = 6

local Layout = Instance.new("UIListLayout", ButtonContainer)
Layout.Padding = UDim.new(0, 6)
Layout.SortOrder = Enum.SortOrder.LayoutOrder

-- Click sound
local Sound = Instance.new("Sound", ScreenGui)
Sound.SoundId = "rbxassetid://9118823101"
Sound.Volume = 1

local function playSound()
    if Sound.IsLoaded then Sound:Play() end
end

-- Create button
local function createButton(mod)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 36)
    btn.Text = mod.name
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 16
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = true
    btn.Parent = ButtonContainer

    btn.MouseButton1Click:Connect(function()
        playSound()
        local s, err = pcall(function()
            loadstring(game:HttpGet(mod.url))()
        end)
        if not s then
            warn("Error loading " .. mod.name .. ": " .. tostring(err))
        end
    end)
end

-- Modules
local Modules = {
    {name = "🔍 ESP", url = "https://raw.githubusercontent.com/Account-not-found/cuddly-octo-spork/refs/heads/modules/esp.lua"},
    {name = "🚀 Fly", url = "https://raw.githubusercontent.com/Account-not-found/cuddly-octo-spork/refs/heads/modules/fly.lua"},
    {name = "🕳️ Noclip", url = "https://raw.githubusercontent.com/Account-not-found/cuddly-octo-spork/refs/heads/modules/noclip.lua"},
    {name = "🔄 Rejoin", url = "https://raw.githubusercontent.com/Account-not-found/cuddly-octo-spork/refs/heads/modules/rejoin.lua"},
    {name = "🚪 Server Hop", url = "https://raw.githubusercontent.com/Account-not-found/cuddly-octo-spork/refs/heads/modules/serverhop.lua"},
    {name = "💤 Anti-AFK", url = "https://raw.githubusercontent.com/Account-not-found/cuddly-octo-spork/refs/heads/modules/antiafk.lua"},
}

-- Button filtering
local function refreshButtons(filter)
    for _, child in ipairs(ButtonContainer:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    for _, mod in ipairs(Modules) do
        if filter == "" or string.find(mod.name:lower(), filter:lower()) then
            createButton(mod)
        end
    end
    task.wait()
    ButtonContainer.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 10)
end

SearchBar:GetPropertyChangedSignal("Text"):Connect(function()
    refreshButtons(SearchBar.Text)
end)

-- Toggle open/close
local visible = true
ToggleButton.MouseButton1Click:Connect(function()
    visible = not visible
    Frame.Visible = visible
    playSound()
end)

-- Initialize
refreshButtons("")
