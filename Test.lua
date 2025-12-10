local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()successfully!")

local Window = WindUI:CreateWindow({
    Title = "Seraphin",
    Icon = "rbxassetid://120248611602330",
    Author = "",
    Folder = "SERAPHIN_HUB",
    Size = UDim2.fromOffset(280, 320),
    Transparent = true,
    Theme = "Dark",
    SideBarWidth = 170,
    HasOutline = true
})

local Window = Fluent:CreateWindow({
    Title = "Seraphin"
    SubTitle = "v0.0.0.1",
    Icon = "rbxassetid://120248611602330",
    TabWidth = 160,
    Size = UDim2.new(280, 320),
    Acrylic = true,
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.LeftControl
})

Fluent:Notify({
        Title = "SeraphinHub Loaded",
        Content = "Rivals script loaded!",
        Duration = 3
})

local Tabs = {
    Info = Window:AddTab({ Title = "| Info", Icon = "Info" }),
    Main = Window:AddTab({ Title = "| Main", Icon = "house" }),
    Settings = Window:AddTab({ Title = "| Settings", Icon = "settings" })
}

local Section = TabInfo:AddSection("Support Community")

Info:Button({
    Title = "Discord",
    Desc = "Click to copy Discord link",
    Callback = function()
        if setclipboard then
            setclipboard("https://discord.gg/getseraphin")
        end
    end
})

Info:AddParagraph({
    Title = "Every time there is a game update or someone reports something, I will fix it as soon as possible."
})


local Section = TabMain:AddSection("Automatic")
