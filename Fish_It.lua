local success, WindUI = pcall(function()
    return loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
end)

if not success or not WindUI then
    warn("⚠️ WindUI failed to load!")
    return
else
    print("✓ WindUI loaded successfully!")
end

local Window = WindUI:CreateWindow({
    Title = "SeraphinHub",
    Icon = "monitor",
    Author = "Fish It | v0.0.0.1",
    Folder = "Seraphin_Hub",
    Size = UDim2.fromOffset(560, 400),
    Transparent = true,
    Theme = "Amethyst",
    SideBarWidth = 170,
    HasOutline = true
})

local Tab1 = Window:Tab({
    Title = "Home",
    Icon = "house",
})

local Section = Tab1:Section({ 
    Title = "Info community",
    TextXAlignment = "Left",
    TextSize = 17,
})

Tab1:Button({
    Title = "Discord",
    Desc = "click to copy link",
    Callback = function()
        if setclipboard then
            setclipboard("https://discord.gg/jdmX43t5mY")
        end
    end
})

local Tab2 = Window:Tab({
    Title = "gamepad-2",
    Icon = "Game",
})

local Tab3 = Window:Tab({
    Title = "Settings",
    Icon = "settings",
})

local Tab4 = Window:Tab({
    Title = "Misc",
    Icon = "list",
})

myConfig:Load()
