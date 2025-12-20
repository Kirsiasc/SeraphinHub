if not game:IsLoaded() then game.Loaded:Wait() end


if game.GameId ~= 6035872082 then
    warn("Seraphin Hub: Not Rivals")
    return
end


local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Seraphin | Rivals",
    TabWidth = 160,
    Size = UDim2.fromOffset(560, 360),
    Acrylic = true,
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.LeftControl
})

Fluent:Notify({
    Title = "Seraphin Hub",
    Content = "Rivals loaded successfully",
    Duration = 3
})


local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()


local Tabs = {
    Info = Window:AddTab({ Title = "| Info", Icon = "info" }),
    Combat = Window:AddTab({ Title = "| Combat", Icon = "crosshair" }),
    Visual = Window:AddTab({ Title = "| Visual", Icon = "eye" }),
    Settings = Window:AddTab({ Title = "| Settings", Icon = "settings" })
}


Tabs.Info:AddSection("Community")

Tabs.Info:AddButton({
    Title = "Copy Discord",
    Description = "Seraphin Discord",
    Callback = function()
        if setclipboard then
            setclipboard("https://discord.gg/getseraphin")
        end
    end
})

Tabs.Info:AddParagraph({
    Title = "About",
    Content = "Seraphin Hub is optimized specifically for Rivals.\nSmooth, simple, and effective."
})


local AimAssist = false
local SilentAim = false
local ESPEnabled = false
local ShowFOV = false

local AimSmooth = 0.18
local FOVRadius = 150


local function IsEnemy(plr)
    if not plr.Team or not LocalPlayer.Team then
        return true
    end
    return plr.Team ~= LocalPlayer.Team
end

local function IsAlive(plr)
    return plr.Character
    and plr.Character:FindFirstChild("Humanoid")
    and plr.Character.Humanoid.Health > 0
end


local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 2
FOVCircle.Filled = false
FOVCircle.Color = Color3.fromRGB(0, 255, 0)
FOVCircle.Visible = false

RunService.RenderStepped:Connect(function()
    FOVCircle.Position = Vector2.new(Mouse.X, Mouse.Y + 36)
    FOVCircle.Radius = FOVRadius
    FOVCircle.Visible = ShowFOV
end)


local function GetClosestEnemy()
    local closest, shortest = nil, math.huge

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer
        and IsEnemy(plr)
        and IsAlive(plr)
        and plr.Character:FindFirstChild("Head") then

            local pos, visible = Camera:WorldToViewportPoint(plr.Character.Head.Position)
            if visible then
                local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                if dist < shortest and dist <= FOVRadius then
                    shortest = dist
                    closest = plr
                end
            end
        end
    end
    return closest
end


RunService.RenderStepped:Connect(function()
    if not AimAssist then return end
    local target = GetClosestEnemy()
    if target and target.Character and target.Character:FindFirstChild("Head") then
        local cf = CFrame.new(
            Camera.CFrame.Position,
            target.Character.Head.Position
        )
        Camera.CFrame = Camera.CFrame:Lerp(cf, AimSmooth)
    end
end)


local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    if SilentAim
    and tostring(method) == "FireServer"
    and args[1]
    and typeof(args[1]) == "Vector3" then

        local target = GetClosestEnemy()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            args[1] = target.Character.Head.Position
            return old(self, unpack(args))
        end
    end
    return old(self, ...)
end)

setreadonly(mt, true)


local ESPObjects = {}

local function ClearESP()
    for _, v in pairs(ESPObjects) do
        if v then v:Remove() end
    end
    table.clear(ESPObjects)
end

RunService.RenderStepped:Connect(function()
    ClearESP()
    if not ESPEnabled then return end

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and IsEnemy(plr) and IsAlive(plr) then
            local char = plr.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local pos, vis = Camera:WorldToViewportPoint(hrp.Position)
                if vis then
                    local text = Drawing.new("Text")
                    text.Text = plr.Name
                    text.Size = 14
                    text.Center = true
                    text.Color = Color3.fromRGB(255, 80, 80)
                    text.Position = Vector2.new(pos.X, pos.Y)
                    text.Visible = true
                    table.insert(ESPObjects, text)
                end
            end
        end
    end
end)


Tabs.Combat:AddToggle("AutoAim", {
    Title = "Auto Aim",
    Default = false,
    Callback = function(v) AimAssist = v end
})

Tabs.Combat:AddToggle("SilentAim", {
    Title = "Silent Aim",
    Default = false,
    Callback = function(v) SilentAim = v end
})

Tabs.Combat:AddSlider("Smooth", {
    Title = "Aim Smooth",
    Min = 0.05,
    Max = 0.4,
    Default = AimSmooth,
    Callback = function(v) AimSmooth = v end
})


Tabs.Visual:AddToggle("FOV", {
    Title = "Show FOV",
    Default = false,
    Callback = function(v) ShowFOV = v end
})

Tabs.Visual:AddSlider("FOVSize", {
    Title = "FOV Radius",
    Min = 50,
    Max = 400,
    Default = FOVRadius,
    Callback = function(v) FOVRadius = v end
})

Tabs.Visual:AddToggle("ESP", {
    Title = "ESP Name",
    Default = false,
    Callback = function(v) ESPEnabled = v end
})


Tabs.Settings:AddButton({
    Title = "Unload UI",
    Callback = function()
        Window:Destroy()
        FOVCircle:Remove()
        ClearESP()
    end
})