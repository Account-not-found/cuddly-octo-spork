-- modular_gui.lua (Integrated with AlixJaffar's Roblox UI Library)
-- Make sure this runs after key system (if used)

-- Load the UI Library
local UILibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/alixjaffar/Roblox-UI-Library/refs/heads/main/main.lua"))()

-- Main Window
local Window = UILibrary:CreateWindow({
    Title = "🔧 Script Hub",
    Theme = "Dark",
    Center = true,
    AutoShow = true,
    Size = UDim2.new(0, 500, 0, 400),
})

-- Tabs
local MainTab = Window:AddTab("Modules")
local UtilityTab = Window:AddTab("Utilities")
local SettingsTab = Window:AddTab("Settings")

-- Toggle States
local ModuleStates = {
    ESP = false,
    Fly = false,
    Noclip = false,
    AntiAFK = false,
}

-- Load Module Helper
local function toggleModule(name, url, key)
    if ModuleStates[key] then
        ModuleStates[key] = false
        _G[key .. "_ENABLED"] = false
        warn(name .. " disabled.")
    else
        ModuleStates[key] = true
        _G[key .. "_ENABLED"] = true
        loadstring(game:HttpGet(url))()
        warn(name .. " enabled.")
    end
end

-- Module Buttons
MainTab:AddToggle("ESP", {Text = "🔍 ESP"}, function(state)
    toggleModule("ESP", "https://raw.githubusercontent.com/Account-not-found/cuddly-octo-spork/refs/heads/modules/esp.lua", "ESP")
end)

MainTab:AddToggle("Fly", {Text = "🚀 Fly"}, function(state)
    toggleModule("Fly", "https://raw.githubusercontent.com/Account-not-found/cuddly-octo-spork/refs/heads/modules/fly.lua", "Fly")
end)

MainTab:AddToggle("Noclip", {Text = "🕳️ Noclip"}, function(state)
    toggleModule("Noclip", "https://raw.githubusercontent.com/Account-not-found/cuddly-octo-spork/refs/heads/modules/noclip.lua", "Noclip")
end)

MainTab:AddButton("🔄 Rejoin", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Account-not-found/cuddly-octo-spork/refs/heads/modules/rejoin.lua"))()
end)

MainTab:AddButton("🚪 Server Hop", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Account-not-found/cuddly-octo-spork/refs/heads/modules/serverhop.lua"))()
end)

MainTab:AddToggle("Anti-AFK", {Text = "💤 Anti-AFK"}, function(state)
    toggleModule("Anti-AFK", "https://raw.githubusercontent.com/Account-not-found/cuddly-octo-spork/refs/heads/modules/antiafk.lua", "AntiAFK")
end)

-- Utilities
UtilityTab:AddButton("🧹 FPS Booster", function()
    -- Add custom fps boost module here if needed
    print("FPS Booster placeholder")
end)

UtilityTab:AddButton("🧾 Execution Log", function()
    print("Execution log opened")
end)

-- Settings
SettingsTab:AddDropdown("Theme", {
    Values = {"Dark", "Light"},
    Default = 1,
    Multi = false
}, function(value)
    UILibrary:SetTheme(value)
end)

-- Toggle Button UI
local ToggleGui = Instance.new("ScreenGui", game.Players.LocalPlayer:WaitForChild("PlayerGui"))
ToggleGui.Name = "ToggleButtonGUI"

local OpenBtn = Instance.new("TextButton")
OpenBtn.Size = UDim2.new(0, 120, 0, 35)
OpenBtn.Position = UDim2.new(0, 10, 0.5, -20)
OpenBtn.Text = "📂 Script Hub"
OpenBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
OpenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenBtn.Font = Enum.Font.SourceSansBold
OpenBtn.TextSize = 16
OpenBtn.Draggable = true
OpenBtn.Active = true
OpenBtn.Parent = ToggleGui

local visible = true
OpenBtn.MouseButton1Click:Connect(function()
    visible = not visible
    Window:SetVisible(visible)
end)
