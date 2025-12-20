local success, WindUI = pcall(function()
    return loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
end)

if not success or not WindUI then
    warn("⚠️ UI failed to load!")
    return
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Window = WindUI:CreateWindow({
    Title = "Seraphin",
    Icon = "rbxassetid://120248611602330",
    Author = "KirsiaSC | Arsenal",
    Folder = "SERAPHIN_HUB",
    Size = UDim2.fromOffset(280, 320),
    Transparent = true,
    Theme = "Dark",
    SideBarWidth = 170,
    HasOutline = true
})

Window:EditOpenButton({
    Enabled = false,
})

local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local G2L = {}

G2L["ScreenGui_1"] = Instance.new("ScreenGui")
G2L["ScreenGui_1"].Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
G2L["ScreenGui_1"].ZIndexBehavior = Enum.ZIndexBehavior.Sibling
CollectionService:AddTag(G2L["ScreenGui_1"], "main")

G2L["ButtonRezise_2"] = Instance.new("ImageButton")
G2L["ButtonRezise_2"].Parent = G2L["ScreenGui_1"]
G2L["ButtonRezise_2"].BorderSizePixel = 0
G2L["ButtonRezise_2"].Draggable = true
G2L["ButtonRezise_2"].BackgroundColor3 = Color3.fromRGB(0, 0, 0)
G2L["ButtonRezise_2"].Image = "rbxassetid://120248611602330"
G2L["ButtonRezise_2"].Size = UDim2.new(0, 45, 0, 45)
G2L["ButtonRezise_2"].Position = UDim2.new(0.13, 0, 0.03, 0)

local corner = Instance.new("UICorner", G2L["ButtonRezise_2"])
corner.CornerRadius = UDim.new(0, 8)

local neon = Instance.new("UIStroke", G2L["ButtonRezise_2"])
neon.Thickness = 2
neon.Color = Color3.fromRGB(0, 255, 0)
neon.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

G2L["ButtonRezise_2"].MouseButton1Click:Connect(function()
    G2L["ButtonRezise_2"].Visible = false
    Window:Open()
end)

Window:OnClose(function()
    G2L["ButtonRezise_2"].Visible = true
end)

Window:OnDestroy(function()
    G2L["ButtonRezise_2"].Visible = false
end)

G2L["ButtonRezise_2"].Visible = false

G2L["ButtonRezise_2"].Visible = false

Window:Tag({
    Title = "v0.0.0.5",
    Color = Color3.fromRGB(180, 0, 255)
})

WindUI:Notify({
    Title = "SeraphinHub Loaded",
    Content = "Arsenal script loaded!",
    Duration = 3,
    Icon = "bell"
})

local Info = Window:Tab({ Title = "Info", Icon = "info" })

Info:Button({
    Title = "Discord",
    Callback = function()
        if setclipboard then
            setclipboard("https://discord.gg/getseraphin")
        end
    end
})

Tab1:Divider()

Tab1:Paragraph({
    Title = "Support",
    Desc = "Every time there is a game update or someone reports something, I will fix it as soon as possible."
})

Tab1:Divider()

Tab1:Keybind({
    Title = "Close/Open UI",
    Desc = "Keybind to Close/Open UI",
    Value = "G",
    Callback = function(v)
        Window:SetToggleKey(Enum.KeyCode[v])
    end
})

local Combat = Window:Tab({ Title = "Combat", Icon = "sword" })

_G.Hitbox = false
_G.KillAura = false
_G.Aimbot = false
_G.AutoAim = false
_G.AimCircle = false
_G.NoRecoil = false
_G.NoSpread = false
_G.TeleportEnemy = false
_G.AutoKnife = false

Combat:Toggle({
    Title = "Hitbox Extender",
    Callback = function(v)
        _G.Hitbox = v
    end
})

RunService.Heartbeat:Connect(function()
    if _G.Hitbox then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Team ~= LocalPlayer.Team and p.Character and p.Character:FindFirstChild("Head") then
                p.Character.Head.Size = Vector3.new(5,5,5)
                p.Character.Head.CanCollide = false
            end
        end
    end
end)

Combat:Toggle({
    Title = "Kill Aura",
    Callback = function(v)
        _G.KillAura = v
    end
})

RunService.Heartbeat:Connect(function()
    if _G.KillAura and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Humanoid") and p.Character:FindFirstChild("HumanoidRootPart") then
                if (LocalPlayer.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude < 100 then
                    p.Character.Humanoid:TakeDamage(5)
                end
            end
        end
    end
end)

Combat:Toggle({
    Title = "Aimbot",
    Callback = function(v)
        _G.Aimbot = v
    end
})

Combat:Toggle({
    Title = "Auto Aim (Head)",
    Callback = function(v)
        _G.AutoAim = v
    end
})

local AimCircle = Drawing.new("Circle")
AimCircle.Radius = 70
AimCircle.Thickness = 1.5
AimCircle.Color = Color3.fromRGB(170,0,255)
AimCircle.Filled = false
AimCircle.Visible = false

Combat:Toggle({
    Title = "Aim Circle",
    Callback = function(v)
        _G.AimCircle = v
        AimCircle.Visible = v
    end
})

RunService.RenderStepped:Connect(function()
    if _G.AimCircle then
        local m = UserInputService:GetMouseLocation()
        AimCircle.Position = Vector2.new(m.X, m.Y + 36)
    end
end)

RunService.RenderStepped:Connect(function()
    if (_G.Aimbot or _G.AutoAim) and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local target, dist = nil, math.huge
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Team ~= LocalPlayer.Team and p.Character and p.Character:FindFirstChild("Head") then
                local d = (LocalPlayer.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                if d < dist then
                    dist = d
                    target = p
                end
            end
        end
        if target then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position)
        end
    end
end)

Combat:Toggle({
    Title = "No Recoil",
    Callback = function(v)
        _G.NoRecoil = v
    end
})

Combat:Toggle({
    Title = "No Spread",
    Callback = function(v)
        _G.NoSpread = v
    end
})

RunService.Stepped:Connect(function()
    local c = LocalPlayer.Character
    if c then
        local t = c:FindFirstChildOfClass("Tool")
        if t then
            if t:FindFirstChild("CameraRecoil") and _G.NoRecoil then
                t.CameraRecoil.Value = 0
            end
            if t:FindFirstChild("Spread") and _G.NoSpread then
                t.Spread.Value = 0
            end
        end
    end
end)

local Visuals = Window:Tab({ Title = "Visuals", Icon = "eye" })

_G.ESP = false

Visuals:Toggle({
    Title = "ESP Highlight",
    Callback = function(v)
        _G.ESP = v
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                if v then
                    if not p.Character:FindFirstChild("SeraphinHL") then
                        local h = Instance.new("Highlight", p.Character)
                        h.Name = "SeraphinHL"
                        h.FillColor = Color3.fromRGB(180,0,255)
                    end
                else
                    if p.Character:FindFirstChild("SeraphinHL") then
                        p.Character.SeraphinHL:Destroy()
                    end
                end
            end
        end
    end
})

local PlayersTab = Window:Tab({ Title = "Players", Icon = "user" })

local walkVal, jumpVal = 16, 50

PlayersTab:Input({
    Title = "WalkSpeed",
    Value = "16",
    Callback = function(v)
        walkVal = tonumber(v) or 16
        if LocalPlayer.Character then
            LocalPlayer.Character.Humanoid.WalkSpeed = walkVal
        end
    end
})

PlayersTab:Input({
    Title = "JumpPower",
    Value = "50",
    Callback = function(v)
        jumpVal = tonumber(v) or 50
        if LocalPlayer.Character then
            LocalPlayer.Character.Humanoid.JumpPower = jumpVal
        end
    end
})

PlayersTab:Toggle({
    Title = "Noclip",
    Callback = function(v)
        _G.Noclip = v
    end
})

RunService.Stepped:Connect(function()
    if _G.Noclip and LocalPlayer.Character then
        for _, p in pairs(LocalPlayer.Character:GetDescendants()) do
            if p:IsA("BasePart") then
                p.CanCollide = false
            end
        end
    end
end)

local Settings = Window:Tab({ Title = "Settings", Icon = "settings" })

Settings:Toggle({
    Title = "AntiAFK",
    Callback = function(v)
        _G.AntiAFK = v
        task.spawn(function()
            while _G.AntiAFK do
                task.wait(60)
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
            end
        end)
    end
})

Settings:Button({
    Title = "Rejoin",
    Callback = function()
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end
})

Settings:Button({
    Title = "Infinite Yield",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
    end
})