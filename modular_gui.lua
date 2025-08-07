-- modular_gui.lua
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

-- Blurred loader UI
local blur = Instance.new("BlurEffect", game:GetService("Lighting"))
blur.Size = 0

-- Create loader GUI
local loaderGui = Instance.new("ScreenGui", PlayerGui)
loaderGui.Name = "LoaderUI"
loaderGui.IgnoreGuiInset = true
loaderGui.ResetOnSpawn = false

local loaderFrame = Instance.new("Frame", loaderGui)
loaderFrame.Size = UDim2.new(0, 400, 0, 200)
loaderFrame.Position = UDim2.new(0.5, -200, 0.5, -100)
loaderFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
loaderFrame.BorderSizePixel = 0
loaderFrame.BackgroundTransparency = 1
loaderFrame.AnchorPoint = Vector2.new(0.5, 0.5)

local UICorner = Instance.new("UICorner", loaderFrame)
UICorner.CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel", loaderFrame)
title.Size = UDim2.new(1, 0, 0, 50)
title.Position = UDim2.new(0, 0, 0, 20)
title.Text = "☄️ Welcome to the Script Hub"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 24
title.BackgroundTransparency = 1

local loadingText = Instance.new("TextLabel", loaderFrame)
loadingText.Size = UDim2.new(1, 0, 0, 30)
loadingText.Position = UDim2.new(0, 0, 0, 90)
loadingText.Text = "Loading modules..."
loadingText.TextColor3 = Color3.new(1, 1, 1)
loadingText.Font = Enum.Font.Gotham
loadingText.TextSize = 20
loadingText.BackgroundTransparency = 1

-- Animate blur
TweenService:Create(blur, TweenInfo.new(1), {Size = 15}):Play()
TweenService:Create(loaderFrame, TweenInfo.new(1), {BackgroundTransparency = 0}):Play()

wait(2) -- Fake loading delay

-- Clean up loader
TweenService:Create(loaderFrame, TweenInfo.new(1), {BackgroundTransparency = 1}):Play()
TweenService:Create(blur, TweenInfo.new(1), {Size = 0}):Play()
wait(1)
loaderGui:Destroy()
blur:Destroy()

-- ✅ SCRIPT HUB STARTS HERE

local UIS = game:GetService("UserInputService")

local function createButton(parent, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, 0)
    btn.Text = text
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 18
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = true
    btn.Parent = parent

    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- Main GUI
local ScreenGui = Instance.new("ScreenGui", PlayerGui)
ScreenGui.Name = "ModularGUI"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 400, 0, 300)
Frame.Position = UDim2.new(0.5, -200, 0.5, -150)
Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true

local UICornerMain = Instance.new("UICorner", Frame)
UICornerMain.CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "✅ Script Hub"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 22

local ButtonContainer = Instance.new("Frame", Frame)
ButtonContainer.Size = UDim2.new(1, 0, 1, -50)
ButtonContainer.Position = UDim2.new(0, 0, 0, 45)
ButtonContainer.BackgroundTransparency = 1

local Layout = Instance.new("UIListLayout", ButtonContainer)
Layout.Padding = UDim.new(0, 6)
Layout.SortOrder = Enum.SortOrder.LayoutOrder

-- Modules
local Modules = {
    {name = "🔍 Enable ESP", url = "https://raw.githubusercontent.com/Account-not-found/cuddly-octo-spork/refs/heads/modules/esp.lua"},
    {name = "🚀 Enable Fly", url = "https://raw.githubusercontent.com/Account-not-found/cuddly-octo-spork/refs/heads/modules/fly.lua"},
    {name = "🕳️ Enable Noclip", url = "https://raw.githubusercontent.com/Account-not-found/cuddly-octo-spork/refs/heads/modules/noclip.lua"},
    {name = "🔄 Rejoin", url = "https://raw.githubusercontent.com/Account-not-found/cuddly-octo-spork/refs/heads/modules/rejoin.lua"},
    {name = "🚪 Server Hop", url = "https://raw.githubusercontent.com/Account-not-found/cuddly-octo-spork/refs/heads/modules/serverhop.lua"},
    {name = "💤 Anti-AFK", url = "https://raw.githubusercontent.com/Account-not-found/cuddly-octo-spork/refs/heads/modules/antiafk.lua"},
}

for _, mod in ipairs(Modules) do
    createButton(ButtonContainer, mod.name, function()
        local s, err = pcall(function()
            loadstring(game:HttpGet(mod.url))()
        end)
        if not s then
            warn("Error loading " .. mod.name .. ": " .. tostring(err))
        end
    end)
end
