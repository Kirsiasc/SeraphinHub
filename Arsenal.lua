local success, WindUI = pcall(function()
    return loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
end)

if not success or not WindUI then
    warn("⚠️ UI failed to load!")
    return
else
    print("✓ UI loaded successfully!")
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local Window = WindUI:CreateWindow({
    Title = "Seraphin",
    Icon = "rbxassetid://120248611602330",
    Author = "KirsiaSC | Arsenal",
    Folder = "SERAPHIN_HUB",
    Size = UDim2.fromOffset(300, 370),
    Transparent = true,
    Theme = "Dark",
    SideBarWidth = 170,
    HasOutline = true
})

Window:Tag({ Title = "v0.0.0.6", Color = Color3.fromRGB(0,0,0) })

WindUI:Notify({ Title = "Seraphin Loaded", Content = "Arsenal script loaded!", Duration = 3 })

local Combat = Window:Tab({ Title = "Combat", Icon = "sword" })

_G.SilentAim = false
_G.RageMode = false
_G.AutoFire = false
_G.HitChance = 100
_G.FOV = 120
_G.RageTarget = nil

Combat:Toggle({ Title = "Silent Aim", Callback = function(v) _G.SilentAim = v end })
Combat:Toggle({ Title = "Rage Mode", Callback = function(v) _G.RageMode = v end })
Combat:Toggle({ Title = "Auto Fire", Callback = function(v) _G.AutoFire = v end })

Combat:Input({ Title = "Hit Chance %", Value = "100", Callback = function(v) local n=tonumber(v) if n then _G.HitChance=math.clamp(n,0,100) end end })
Combat:Input({ Title = "Silent FOV", Value = "120", Callback = function(v) local n=tonumber(v) if n then _G.FOV=n end end })

local Visuals = Window:Tab({ Title = "Visuals", Icon = "eye" })

_G.ESPBox = false
_G.ESPCorner = false
_G.ESPTracer = false
_G.ESPName = false
_G.ESPDistance = false
_G.ESPHighlight = false
_G.ESPSize = 1
_G.ESPThickness = 1

Visuals:Toggle({ Title = "ESP Box", Callback = function(v) _G.ESPBox=v end })
Visuals:Toggle({ Title = "ESP Corner", Callback = function(v) _G.ESPCorner=v end })
Visuals:Toggle({ Title = "ESP Tracer", Callback = function(v) _G.ESPTracer=v end })
Visuals:Toggle({ Title = "ESP Name", Callback = function(v) _G.ESPName=v end })
Visuals:Toggle({ Title = "ESP Distance", Callback = function(v) _G.ESPDistance=v end })

Visuals:Toggle({
    Title = "ESP Highlight",
    Callback = function(v)
        _G.ESPHighlight=v
        for _,p in pairs(Players:GetPlayers()) do
            if p~=LocalPlayer and p.Character then
                if v then
                    if not p.Character:FindFirstChild("SeraphinHL") then
                        local h=Instance.new("Highlight",p.Character)
                        h.Name="SeraphinHL"
                        h.FillColor=Color3.fromRGB(0,0,0)
                        h.OutlineColor=Color3.fromRGB(0,0,0)
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

Visuals:Input({ Title = "ESP Size", Value = "1", Callback = function(v) local n=tonumber(v) if n then _G.ESPSize=n end end })
Visuals:Input({ Title = "ESP Thickness", Value = "1", Callback = function(v) local n=tonumber(v) if n then _G.ESPThickness=n end end })

local espCache = {}

local function L() local l=Drawing.new("Line") l.Color=Color3.fromRGB(0,0,0) l.Thickness=_G.ESPThickness l.Visible=false return l end
local function T() local t=Drawing.new("Text") t.Color=Color3.fromRGB(0,0,0) t.Size=13 t.Center=true t.Outline=true t.Visible=false return t end

local function setup(p)
    espCache[p]={box={L(),L(),L(),L()},tr=L(),name=T(),dist=T()}
end

for _,p in pairs(Players:GetPlayers()) do if p~=LocalPlayer then setup(p) end end
Players.PlayerAdded:Connect(function(p) if p~=LocalPlayer then setup(p) end end)
Players.PlayerRemoving:Connect(function(p) if espCache[p] then for _,v in pairs(espCache[p].box) do v:Remove() end espCache[p].tr:Remove() espCache[p].name:Remove() espCache[p].dist:Remove() espCache[p]=nil end end)

RunService.RenderStepped:Connect(function()
    for p,e in pairs(espCache) do
        local c=p.Character
        if not c or not c:FindFirstChild("HumanoidRootPart") then
            for _,v in pairs(e.box) do v.Visible=false end
            e.tr.Visible=false e.name.Visible=false e.dist.Visible=false
        else
            local hrp=c.HumanoidRootPart
            local pos,on=Camera:WorldToViewportPoint(hrp.Position)
            if on then
                local s=_G.ESPSize
                local w,h=40*s,60*s
                local x,y=pos.X-w/2,pos.Y-h/2
                local b=e.box
                b[1].From=Vector2.new(x,y) b[1].To=Vector2.new(x+w,y)
                b[2].From=Vector2.new(x+w,y) b[2].To=Vector2.new(x+w,y+h)
                b[3].From=Vector2.new(x+w,y+h) b[3].To=Vector2.new(x,y+h)
                b[4].From=Vector2.new(x,y+h) b[4].To=Vector2.new(x,y)
                for _,v in pairs(b) do v.Thickness=_G.ESPThickness v.Visible=_G.ESPBox end
                e.tr.From=Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y)
                e.tr.To=Vector2.new(pos.X,pos.Y)
                e.tr.Thickness=_G.ESPThickness
                e.tr.Visible=_G.ESPTracer
                e.name.Text=p.Name e.name.Position=Vector2.new(pos.X,y-12) e.name.Visible=_G.ESPName
                e.dist.Text=math.floor((Camera.CFrame.Position-hrp.Position).Magnitude).."m"
                e.dist.Position=Vector2.new(pos.X,y+h+2) e.dist.Visible=_G.ESPDistance
            end
        end
    end
end)

local function chance() return math.random(0,100)<=_G.HitChance end

task.spawn(function()
    while task.wait() do
        if _G.RageMode then
            local c,d=nil,math.huge
            for _,p in pairs(Players:GetPlayers()) do
                if p~=LocalPlayer and p.Team~=LocalPlayer.Team and p.Character and p.Character:FindFirstChild("Head") then
                    local m=(LocalPlayer.Character.HumanoidRootPart.Position-p.Character.HumanoidRootPart.Position).Magnitude
                    if m<d then d=m c=p end
                end
            end
            _G.RageTarget=c
        else
            _G.RageTarget=nil
        end
    end
end)

local mt=getrawmetatable(game)
setreadonly(mt,false)
local old=mt.__namecall

mt.__namecall=newcclosure(function(self,...)
    local a={...}
    if getnamecallmethod()=="FindPartOnRayWithIgnoreList" and _G.SilentAim and chance() then
        local t=_G.RageTarget
        if not t then
            local c,d=nil,math.huge
            for _,p in pairs(Players:GetPlayers()) do
                if p~=LocalPlayer and p.Team~=LocalPlayer.Team and p.Character and p.Character:FindFirstChild("Head") then
                    local s,on=Camera:WorldToViewportPoint(p.Character.Head.Position)
                    if on then
                        local m=(Vector2.new(s.X,s.Y)-UserInputService:GetMouseLocation()).Magnitude
                        if m<_G.FOV and m<d then d=m c=p end
                    end
                end
            end
            t=c
        end
        if t and t.Character and t.Character:FindFirstChild("Head") then
            a[1]=Ray.new(Camera.CFrame.Position,(t.Character.Head.Position-Camera.CFrame.Position).Unit*5000)
            return old(self,unpack(a))
        end
    end
    return old(self,...)
end)

setreadonly(mt,true)

local Settings = Window:Tab({ Title = "Settings", Icon = "settings" })

_G.AntiAFK=false
_G.HideUI=false

Settings:Toggle({ Title="Anti AFK", Callback=function(v) _G.AntiAFK=v end })
Settings:Toggle({ Title="Toggle UI", Callback=function(v) _G.HideUI=v Window:SetVisible(not v) end })

Settings:Button({ Title="Save Config", Callback=function() WindUI:SaveConfig("Seraphin") end })
Settings:Button({ Title="Load Config", Callback=function() WindUI:LoadConfig("Seraphin") end })
Settings:Button({ Title="Delete Config", Callback=function() WindUI:DeleteConfig("Seraphin") end })

Settings:Button({ Title="Rejoin", Callback=function() TeleportService:Teleport(game.PlaceId,LocalPlayer) end })
Settings:Button({ Title="Infinite Yield", Callback=function() loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))() end })

RunService.Heartbeat:Connect(function()
    if _G.AntiAFK then
        VirtualUser:Button2Down(Vector2.new(),Camera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(),Camera.CFrame)
    end
    if _G.AutoFire and _G.RageMode then
        local c=LocalPlayer.Character
        if c then local t=c:FindFirstChildOfClass("Tool") if t then pcall(function() t:Activate() end) end end
    end
end)