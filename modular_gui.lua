-- modular_gui.lua (Advanced Version)

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

local MODULES = {
    { name = "🔍 ESP", url = "https://raw.githubusercontent.com/Account-not-found/cuddly-octo-spork/refs/heads/modules/esp.lua", key = "ESP" },
    { name = "🚀 Fly", url = "https://raw.githubusercontent.com/Account-not-found/cuddly-octo-spork/refs/heads/modules/fly.lua", key = "Fly" },
    { name = "🕳️ Noclip", url = "https://raw.githubusercontent.com/Account-not-found/cuddly-octo-spork/refs/heads/modules/noclip.lua", key = "Noclip" },
    { name = "🔄 Rejoin", url = "https://raw.githubusercontent.com/Account-not-found/cuddly-octo-spork/refs/heads/modules/rejoin.lua", key = "Rejoin" },
    { name = "🚪 Server Hop", url = "https://raw.githubusercontent.com/Account-not-found/cuddly-octo-spork/refs/heads/modules/serverhop.lua", key = "Serverhop" },
    { name = "💤 Anti-AFK", url = "https://raw.githubusercontent.com/Account-not-found/cuddly-octo-spork/refs/heads/modules/antiafk.lua", key = "AntiAFK" },
}

local Config = { Theme = "Dark", Toggles = {} }
local ConfigFile = "modular_gui_config.json"

-- Read config if available
pcall(function()
    if isfile(ConfigFile) then
        local saved = HttpService:JSONDecode(readfile(ConfigFile))
        if saved then Config = saved end
    end
end)

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
ScreenGui.Name = "ModularScriptHub"
ScreenGui.ResetOnSpawn = false

-- Toggle Button
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Size = UDim2.new(0, 140, 0, 40)
ToggleButton.Position = UDim2.new(0, 10, 0.5, -20)
ToggleButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
ToggleButton.TextColor3 = Color3.new(1, 1, 1)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 14
ToggleButton.Text = "📂 Open Script Hub"
ToggleButton.Draggable = true
ToggleButton.Active = true
ToggleButton.Parent = ScreenGui

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 460, 0, 360)
MainFrame.Position = UDim2.new(0.5, -230, 0.5, -180)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

-- Title Bar
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Title.Text = "💻 Advanced Script Hub"
Title.Font = Enum.Font.GothamBold
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextSize = 18

-- Button Container
local ButtonHolder = Instance.new("Frame", MainFrame)
ButtonHolder.Size = UDim2.new(1, -20, 1, -60)
ButtonHolder.Position = UDim2.new(0, 10, 0, 50)
ButtonHolder.BackgroundTransparency = 1

local Layout = Instance.new("UIListLayout", ButtonHolder)
Layout.Padding = UDim.new(0, 8)
Layout.SortOrder = Enum.SortOrder.LayoutOrder

-- Save config
local function saveConfig()
    pcall(function()
        writefile(ConfigFile, HttpService:JSONEncode(Config))
    end)
end

-- Create toggle buttons
for _, module in ipairs(MODULES) do
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 36)
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Font = Enum.Font.Gotham
    button.TextSize = 14
    button.Text = module.name
    button.Name = module.key
    button.AutoButtonColor = true
    button.Parent = ButtonHolder

    local function toggleModule()
        local state = not Config.Toggles[module.key]
        Config.Toggles[module.key] = state
        saveConfig()

        button.BackgroundColor3 = state and Color3.fromRGB(70, 110, 70) or Color3.fromRGB(50, 50, 50)
        if state then
            local success, err = pcall(function()
                loadstring(game:HttpGet(module.url))()
            end)
            if not success then
                warn("Error loading module " .. module.name .. ": " .. err)
            end
        end
    end

    button.MouseButton1Click:Connect(toggleModule)

    -- Restore saved toggle state
    if Config.Toggles[module.key] then
        toggleModule()
    end
end

-- Open/Close behavior
ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
    ToggleButton.Text = MainFrame.Visible and "❌ Close Script Hub" or "📂 Open Script Hub"
end)
