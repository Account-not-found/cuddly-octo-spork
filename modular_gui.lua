-- modular_gui.lua
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer

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

-- Create GUI
local ScreenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
ScreenGui.Name = "ModularGUI"
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 400, 0, 300)
Frame.Position = UDim2.new(0.5, -200, 0.5, -150)
Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true -- mobile compatibility

-- Title
local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "✅ Script Hub"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 22

-- Container
local ButtonContainer = Instance.new("Frame", Frame)
ButtonContainer.Size = UDim2.new(1, 0, 1, -50)
ButtonContainer.Position = UDim2.new(0, 0, 0, 45)
ButtonContainer.BackgroundTransparency = 1

-- Layout
local Layout = Instance.new("UIListLayout", ButtonContainer)
Layout.Padding = UDim.new(0, 6)
Layout.SortOrder = Enum.SortOrder.LayoutOrder

-- Modules
local Modules = {
    {name = "🔍 Toggle ESP", url = "https://raw.githubusercontent.com/Account-not-found/cuddly-octo-spork/refs/heads/modules/esp.lua"},
    {name = "🚀 Toggle Fly", url = "https://raw.githubusercontent.com/Account-not-found/cuddly-octo-spork/refs/heads/modules/fly.lua"},
    {name = "🕳️ Toggle Noclip", url = "https://raw.githubusercontent.com/Account-not-found/cuddly-octo-spork/refs/heads/modules/noclip.lua"},
    {name = "🔄 Rejoin", url = "https://raw.githubusercontent.com/Account-not-found/cuddly-octo-spork/refs/heads/modules/rejoin.lua"},
    {name = "🚪 Server Hop", url = "https://raw.githubusercontent.com/Account-not-found/cuddly-octo-spork/refs/heads/modules/serverhop.lua"},
    {name = "💤 Anti-AFK", url = "https://raw.githubusercontent.com/Account-not-found/cuddly-octo-spork/refs/heads/modules/antiafk.lua"},
}

local activeModules = {}

-- Create buttons
for _, mod in ipairs(Modules) do
    createButton(ButtonContainer, mod.name, function()
        if not activeModules[mod.name] then
            local success, moduleOrError = pcall(function()
                return loadstring(game:HttpGet(mod.url))()
            end)
            if success and typeof(moduleOrError) == "table" and moduleOrError.Enable then
                moduleOrError.Enable()
                activeModules[mod.name] = moduleOrError
            elseif not success then
                warn("Failed to load " .. mod.name .. ": " .. tostring(moduleOrError))
            end
        else
            if activeModules[mod.name].Disable then
                activeModules[mod.name].Disable()
                activeModules[mod.name] = nil
            end
        end
    end)
end
