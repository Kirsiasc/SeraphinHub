local success, WindUI = pcall(function()
    return loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
end)

if not success or not WindUI then
    warn("⚠️ UI failed to load!")
    return
else
    print("✓ UI loaded successfully!")
end

local Window = WindUI:CreateWindow({
    Title = "Seraphin",
    Icon = "rbxassetid://120248611602330",
    Author = "KirsiaSC | Arsenal",
    Folder = "SERAPHIN_HUB",
    Size = UDim2.fromOffset(270, 300),
    Transparent = true,
    Theme = "Dark",
    SideBarWidth = 170,
    HasOutline = true
})

Window:Tag({
    Title = "v0.0.1",
    Color = Color3.fromHex("#9b4dff")
})

WindUI:Notify({
    Title = "SeraphinHub Loaded",
    Content = "UI loaded successfully!",
    Duration = 3,
    Icon = "bell",
})

local Tab1 = Window:Tab({ Title = "Home", Icon = "house" })
Tab1:Button({
    Title = "Discord",
    Desc = "Click To Copy Link Discord",
    Callback = function()
        if setclipboard then
            setclipboard("https://discord.gg/getseraphin")
        end
    end
})

local Tab2 = Window:Tab({ Title = "Combat", Icon = "sword" })

Tab2:Toggle({
    Title = "Silent Aim",
    Desc = "Auto lock target",
    Default = false,
    Callback = function(state)
        _G.SilentAim = state
    end
})

Tab2:Toggle({
    Title = "No Recoil",
    Desc = "Remove gun recoil",
    Default = false,
    Callback = function(state)
        _G.NoRecoil = state
    end
})

Tab2:Toggle({
    Title = "No Spread",
    Desc = "Remove bullet spread",
    Default = false,
    Callback = function(state)
        _G.NoSpread = state
    end
})

Tab2:Toggle({
    Title = "Auto Aim",
    Desc = "Lock camera to nearest enemy",
    Default = false,
    Callback = function(state)
        _G.AutoAim = state
        task.spawn(function()
            while _G.AutoAim do
                task.wait()
                local players = game:GetService("Players")
                local lp = players.LocalPlayer
                local cam = workspace.CurrentCamera
                local nearest, dist = nil, math.huge
                for _,plr in pairs(players:GetPlayers()) do
                    if plr ~= lp and plr.Team ~= lp.Team and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                        local pos, vis = cam:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position)
                        if vis then
                            local mag = (Vector2.new(pos.X,pos.Y)-Vector2.new(cam.ViewportSize.X/2,cam.ViewportSize.Y/2)).Magnitude
                            if mag < dist then
                                dist = mag
                                nearest = plr
                            end
                        end
                    end
                end
                if nearest then
                    cam.CFrame = CFrame.new(cam.CFrame.Position, nearest.Character.HumanoidRootPart.Position)
                end
            end
        end)
    end
})

Tab2:Toggle({
    Title = "Auto TP Enemy",
    Desc = "Teleport enemy in front of you",
    Default = false,
    Callback = function(state)
        _G.AutoTP = state
        task.spawn(function()
            while _G.AutoTP do
                task.wait(1)
                local players = game:GetService("Players")
                local lp = players.LocalPlayer
                local char = lp.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    for _,plr in pairs(players:GetPlayers()) do
                        if plr ~= lp and plr.Team ~= lp.Team and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                            plr.Character.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame * CFrame.new(0,0,-5)
                        end
                    end
                end
            end
        end)
    end
})

local Tab3 = Window:Tab({ Title = "Visuals", Icon = "eye" })

Tab3:Toggle({
    Title = "ESP",
    Desc = "Show enemy through walls",
    Default = false,
    Callback = function(state)
        _G.ESPEnabled = state
        if state then
            for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
                if player ~= game:GetService("Players").LocalPlayer then
                    local highlight = Instance.new("Highlight")
                    highlight.Name = "SeraphinESP"
                    highlight.FillColor = Color3.fromRGB(0,255,0)
                    highlight.OutlineColor = Color3.fromRGB(255,255,255)
                    highlight.Parent = player.Character or player.CharacterAdded:Wait()
                end
            end
        else
            for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
                if player.Character and player.Character:FindFirstChild("SeraphinESP") then
                    player.Character.SeraphinESP:Destroy()
                end
            end
        end
    end
})

game:GetService("Players").PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function(char)
        if _G.ESPEnabled then
            local highlight = Instance.new("Highlight")
            highlight.Name = "SeraphinESP"
            highlight.FillColor = Color3.fromRGB(0,255,0)
            highlight.OutlineColor = Color3.fromRGB(255,255,255)
            highlight.Parent = char
        end
    end)
end)

local Tab4 = Window:Tab({ Title = "Movement", Icon = "move" })
local Player = game:GetService("Players").LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

Tab4:Input({
    Title = "WalkSpeed",
    Value = "16",
    Callback = function(input)
        local speed = tonumber(input)
        if speed and speed >= 16 then
            Humanoid.WalkSpeed = speed
        else
            Humanoid.WalkSpeed = 16
        end
    end
})

Tab4:Input({
    Title = "JumpPower",
    Value = "50",
    Callback = function(input)
        local value = tonumber(input)
        if value then
            Humanoid.UseJumpPower = true
            Humanoid.JumpPower = value
            _G.CustomJumpPower = value
        end
    end
})

Tab4:Toggle({
    Title = "Infinite Jump",
    Default = false,
    Callback = function(state)
        _G.InfiniteJump = state
    end
})

game:GetService("UserInputService").JumpRequest:Connect(function()
    if _G.InfiniteJump then
        local char = Player.Character or Player.CharacterAdded:Wait()
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

Tab4:Toggle({
    Title = "Fly",
    Default = false,
    Callback = function(state)
        _G.Fly = state
        local hum = Humanoid
        if state then
            task.spawn(function()
                while _G.Fly do
                    task.wait()
                    hum:ChangeState(Enum.HumanoidStateType.Physics)
                    hum.Parent:FindFirstChild("HumanoidRootPart").Velocity = hum.Parent:FindFirstChild("HumanoidRootPart").CFrame.LookVector * 50
                end
            end)
        end
    end
})

local Tab5 = Window:Tab({ Title = "Settings", Icon = "settings" })

Tab5:Toggle({
    Title = "AntiAFK",
    Default = false,
    Callback = function(state)
        _G.AntiAFK = state
        local VirtualUser = game:GetService("VirtualUser")
        task.spawn(function()
            while _G.AntiAFK do
                task.wait(60)
                pcall(function()
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton2(Vector2.new())
                end)
            end
        end)
    end
})

Tab5:Toggle({
    Title = "Auto Reconnect",
    Default = false,
    Callback = function(state)
        _G.AutoReconnect = state
        if state then
            task.spawn(function()
                while _G.AutoReconnect do
                    task.wait(2)
                    local reconnectUI = game:GetService("CoreGui"):FindFirstChild("RobloxPromptGui")
                    if reconnectUI then
                        local prompt = reconnectUI:FindFirstChild("promptOverlay")
                        if prompt then
                            local button = prompt:FindFirstChild("ButtonPrimary")
                            if button and button.Visible then
                                firesignal(button.MouseButton1Click)
                            end
                        end
                    end
                end
            end)
        end
    end
})

Tab5:Colorpicker({
    Title = "UI Color",
    Default = Color3.fromRGB(0,255,0),
    Transparency = 0,
    Callback = function(color)
        print("Background color: "..tostring(color))
    end
})
