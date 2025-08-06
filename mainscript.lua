-- Main script hub
loadstring(game:HttpGet("https://raw.githubusercontent.com/Account-not-found/cuddly-octo-spork/refs/heads/main/ui/rayfield.lua"))()

-- Load modules dynamically
local modules = {
    "fly",
    "noclip",
    "esp",
    "antiafk"
}

for _, mod in ipairs(modules) do
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Account-not-found/cuddly-octo-spork/refs/heads/main/modules/" .. mod .. ".lua"))()
end
