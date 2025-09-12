local success, WindUI = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/main.lua"))()
end)

if not success or not WindUI then
    warn("⚠️ WindUI failed to load!")
    return
end

print("✓ WindUI loaded successfully!")

local Window = WindUI:CreateWindow({
    Title = "Test Window",
    Icon = "monitor",
    Author = "Test",
    Folder = "TestHub",
    Size = UDim2.fromOffset(500, 300),
    SideBarWidth = 160,
    HasOutline = true,
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
