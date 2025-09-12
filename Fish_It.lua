local success, WindUI = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/main.lua"))()
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
    Theme = "Default",
    SideBarWidth = 170,
    HasOutline = true
})

local Tab1 = Window:Tab({
    Title = "Home",
    Icon = "house",
})

Tab1:Button({
    Title = "Hello",
    Desc = "Test button",
    Callback = function()
        print("Button clicked!")
    end
})
