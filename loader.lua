-- Key system (basic)
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Simulated key check (replace with real HTTP check)
local function validateKey(key)
    return key == "abc123"
end

-- UI to enter key
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 300, 0, 150)
Frame.Position = UDim2.new(0.5, -150, 0.5, -75)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

local TextBox = Instance.new("TextBox", Frame)
TextBox.Size = UDim2.new(1, -20, 0, 40)
TextBox.Position = UDim2.new(0, 10, 0, 20)
TextBox.PlaceholderText = "Enter Key Here"
TextBox.Text = ""

local Button = Instance.new("TextButton", Frame)
Button.Size = UDim2.new(1, -20, 0, 40)
Button.Position = UDim2.new(0, 10, 0, 80)
Button.Text = "Submit"

Button.MouseButton1Click:Connect(function()
    if validateKey(TextBox.Text) then
        ScreenGui:Destroy()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Account-not-found/cuddly-octo-spork/refs/heads/main/mainscript.lua"))()
    else
        Button.Text = "❌ Invalid Key"
    end
end)
