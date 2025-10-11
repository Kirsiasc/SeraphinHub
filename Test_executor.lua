-- Seraphin Executor (in-game) v1.2 — Ronix style, logo toggle + fade/slide animation
-- Paste ke executor (Synapse/Fluxus/KRNL/...) and run

-- ===== Services & Utilities =====
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local UserInput = game:GetService("UserInputService")

-- persistence
local saveFilename = "seraphin_explorer.json"
local function canWrite() return (type(writefile) == "function" and type(readfile) == "function") end
local function saveExplorer(tbl)
    local ok,enc = pcall(HttpService.JSONEncode, HttpService, tbl)
    if not ok then return end
    if canWrite() then
        pcall(function() writefile(saveFilename, enc) end)
    else
        getgenv().seraphin_explorer = tbl
    end
end
local function loadExplorer()
    if canWrite() then
        local ok, cont = pcall(function() return readfile(saveFilename) end)
        if ok and cont then
            local ok2, t = pcall(HttpService.JSONDecode, HttpService, cont)
            if ok2 and type(t) == "table" then return t end
        end
        return {}
    else
        return getgenv().seraphin_explorer or {}
    end
end

local function fetchUrlRaw(url)
    url = tostring(url or "")
    if url:match("^%s*$") then return nil, "URL kosong" end
    -- try multiple methods
    local ok, res = pcall(function() return (game.HttpGet and game:HttpGet(url)) end)
    if ok and res and #res > 0 then return res end
    ok, res = pcall(function() return HttpService:GetAsync(url) end)
    if ok and res and #res > 0 then return res end
    if type(syn) == "table" and type(syn.request) == "function" then
        local suc, r = pcall(function() return syn.request{Url = url, Method = "GET"} end)
        if suc and r and r.Body then return r.Body end
    end
    return nil, "Gagal fetch URL (cek URL atau izin HTTP)."
end

-- Utility: remove previous GUI
for _,v in pairs(CoreGui:GetChildren()) do
    if v.Name == "SeraphinExecutorGui_v1" or v.Name == "SeraphinExecutorToggle_v1" then
        v:Destroy()
    end
end

-- ===== Create Toggle Logo (left-top) =====
local toggleGui = Instance.new("ScreenGui")
toggleGui.Name = "SeraphinExecutorToggle_v1"
toggleGui.ResetOnSpawn = false
toggleGui.Parent = CoreGui

local logoBtn = Instance.new("ImageButton")
logoBtn.Name = "SeraphinLogo"
logoBtn.Size = UDim2.new(0,50,0,50)
logoBtn.Position = UDim2.new(0,10,0,10) -- pojok kiri atas, offset 10 px
logoBtn.AnchorPoint = Vector2.new(0,0)
logoBtn.BackgroundTransparency = 1
logoBtn.Image = "rbxassetid://135748028632686"
logoBtn.Parent = toggleGui
logoBtn.ZIndex = 5
logoBtn.AutoButtonColor = true

-- glow effect (UIStroke)
local stroke = Instance.new("UIStroke", logoBtn)
stroke.Thickness = 2
stroke.Transparency = 0.4
stroke.Color = Color3.fromRGB(72,170,255)

-- small pulsing effect (tween)
local pulseInfo = TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
local pulseTween = TweenService:Create(logoBtn, pulseInfo, {ImageTransparency = 0.1})
pulseTween:Play()

-- ===== Create Main Executor GUI (hidden initially, off-screen) =====
local screen = Instance.new("ScreenGui")
screen.Name = "SeraphinExecutorGui_v1"
screen.ResetOnSpawn = false
screen.Parent = CoreGui

local window = Instance.new("Frame", screen)
window.Name = "Window"
window.Size = UDim2.new(0,980,0,540)
window.Position = UDim2.new(-1,0,0.08,0) -- start off-screen (left) for slide-in
window.AnchorPoint = Vector2.new(0,0)
window.BackgroundColor3 = Color3.fromRGB(18,18,20)
window.BorderSizePixel = 0
window.AnchorPoint = Vector2.new(0,0)
window.Visible = true
window.ZIndex = 4
window.ClipsDescendants = true
window.BackgroundTransparency = 1 -- start invisible (we'll fade in)

-- Topbar
local topbar = Instance.new("Frame", window)
topbar.Name = "Topbar"
topbar.Size = UDim2.new(1,0,0,40)
topbar.Position = UDim2.new(0,0,0,0)
topbar.BackgroundColor3 = Color3.fromRGB(24,24,26)
topbar.BorderSizePixel = 0

local logoSmall = Instance.new("ImageLabel", topbar)
logoSmall.Size = UDim2.new(0,28,0,28)
logoSmall.Position = UDim2.new(0,8,0.5,-14)
logoSmall.Image = "rbxassetid://135748028632686"
logoSmall.BackgroundTransparency = 1

local title = Instance.new("TextLabel", topbar)
title.Size = UDim2.new(0,260,0,40)
title.Position = UDim2.new(0,44,0,0)
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansSemibold
title.TextSize = 16
title.Text = "Seraphin - Executor"
title.TextColor3 = Color3.fromRGB(210,210,215)
title.TextXAlignment = Enum.TextXAlignment.Left

-- Minimize & Close
local btnClose = Instance.new("TextButton", topbar)
btnClose.Size = UDim2.new(0,36,0,28)
btnClose.Position = UDim2.new(1,-44,0.5,-14)
btnClose.Text = "X"
btnClose.Font = Enum.Font.SourceSansBold
btnClose.TextSize = 16
btnClose.BackgroundColor3 = Color3.fromRGB(36,36,40)
btnClose.TextColor3 = Color3.fromRGB(230,230,230)
btnClose.BorderSizePixel = 0

local btnMin = Instance.new("TextButton", topbar)
btnMin.Size = UDim2.new(0,36,0,28)
btnMin.Position = UDim2.new(1,-84,0.5,-14)
btnMin.Text = "—"
btnMin.Font = Enum.Font.SourceSansBold
btnMin.TextSize = 18
btnMin.BackgroundColor3 = Color3.fromRGB(36,36,40)
btnMin.TextColor3 = Color3.fromRGB(230,230,230)
btnMin.BorderSizePixel = 0

-- Iconbar
local iconbar = Instance.new("Frame", window)
iconbar.Size = UDim2.new(1,0,0,44)
iconbar.Position = UDim2.new(0,0,0,40)
iconbar.BackgroundColor3 = Color3.fromRGB(22,22,24)
iconbar.BorderSizePixel = 0

local function makeIconBtn(parent, x, glyph, tooltip)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(0,36,0,32)
    b.Position = UDim2.new(0,8 + (x-1) * 40, 0, 6)
    b.Text = glyph
    b.Font = Enum.Font.SourceSans
    b.TextSize = 18
    b.TextColor3 = Color3.fromRGB(200,200,210)
    b.BackgroundColor3 = Color3.fromRGB(36,36,40)
    b.BorderSizePixel = 0
    b.Name = tooltip or ("Icon"..x)
    return b
end

local runIcon = makeIconBtn(iconbar, 1, "▶", "Run")
local linkIcon = makeIconBtn(iconbar, 2, "🔗", "Load URL")
local trashIcon = makeIconBtn(iconbar, 3, "🗑", "Clear")
local saveIcon = makeIconBtn(iconbar, 4, "💾", "Save Snippet")
local folderIcon = makeIconBtn(iconbar, 5, "📂", "Add from Explorer")

-- Leftbar
local leftbar = Instance.new("Frame", window)
leftbar.Size = UDim2.new(0,56,1,-84)
leftbar.Position = UDim2.new(0,0,0,84)
leftbar.BackgroundColor3 = Color3.fromRGB(20,20,22)
leftbar.BorderSizePixel = 0

local function makeLeftIcon(i, glyph)
    local btn = Instance.new("TextButton", leftbar)
    btn.Size = UDim2.new(1,0,0,56)
    btn.Position = UDim2.new(0,0,0,(i-1)*56)
    btn.Text = glyph
    btn.Font = Enum.Font.SourceSansSemibold
    btn.TextSize = 20
    btn.TextColor3 = Color3.fromRGB(140,110,220)
    btn.BackgroundColor3 = Color3.fromRGB(24,24,26)
    btn.BorderSizePixel = 0
    return btn
end

makeLeftIcon(1, "🏠")
makeLeftIcon(2, "</>")
makeLeftIcon(3, "⚙")

-- Explorer (right)
local explorer = Instance.new("Frame", window)
explorer.Size = UDim2.new(0,260,1,-84)
explorer.Position = UDim2.new(1,-260,0,84)
explorer.BackgroundColor3 = Color3.fromRGB(22,22,24)
explorer.BorderSizePixel = 0

local expTitle = Instance.new("TextLabel", explorer)
expTitle.Size = UDim2.new(1,0,0,34)
expTitle.Position = UDim2.new(0,0,0,0)
expTitle.BackgroundColor3 = Color3.fromRGB(28,28,30)
expTitle.Text = "Script Explorer"
expTitle.Font = Enum.Font.SourceSansSemibold
expTitle.TextSize = 14
expTitle.TextColor3 = Color3.fromRGB(190,190,200)
expTitle.BorderSizePixel = 0

local tabListLabel = Instance.new("TextLabel", explorer)
tabListLabel.Size = UDim2.new(1,-12,0,20)
tabListLabel.Position = UDim2.new(0,8,0,40)
tabListLabel.BackgroundTransparency = 1
tabListLabel.Text = "Tabs"
tabListLabel.Font = Enum.Font.SourceSans
tabListLabel.TextSize = 12
tabListLabel.TextColor3 = Color3.fromRGB(160,160,170)
tabListLabel.TextXAlignment = Enum.TextXAlignment.Left

local expScroll = Instance.new("ScrollingFrame", explorer)
expScroll.Size = UDim2.new(1,-12,1,-70)
expScroll.Position = UDim2.new(0,6,0,64)
expScroll.CanvasSize = UDim2.new(0,0,0,0)
expScroll.ScrollBarThickness = 6
expScroll.BackgroundTransparency = 1

-- Editor area
local editorArea = Instance.new("Frame", window)
editorArea.Size = UDim2.new(1, - (56 + 260), 1, - 84)
editorArea.Position = UDim2.new(0,56,0,84)
editorArea.BackgroundColor3 = Color3.fromRGB(14,14,16)
editorArea.BorderSizePixel = 0

local lineNumbers = Instance.new("ScrollingFrame", editorArea)
lineNumbers.Size = UDim2.new(0,36,1, - 46)
lineNumbers.Position = UDim2.new(0,6,0,6)
lineNumbers.BackgroundTransparency = 1
lineNumbers.ScrollBarThickness = 0

local editorBox = Instance.new("TextBox", editorArea)
editorBox.Size = UDim2.new(1, - 60, 1, - 46)
editorBox.Position = UDim2.new(0,48,0,6)
editorBox.MultiLine = true
editorBox.ClearTextOnFocus = false
editorBox.TextWrapped = false
editorBox.Font = Enum.Font.Code
editorBox.TextSize = 14
editorBox.TextColor3 = Color3.fromRGB(224,224,230)
editorBox.BackgroundColor3 = Color3.fromRGB(12,12,14)
editorBox.Text = "-- Tulis script di sini\n"

-- Line numbers update
local function updateLineNumbers()
    local t = editorBox.Text or ""
    local lines = 0
    for _ in string.gmatch(t, "\n") do lines = lines + 1 end
    lines = lines + 1
    for _,c in pairs(lineNumbers:GetChildren()) do if c:IsA("TextLabel") then c:Destroy() end end
    for i = 1, lines do
        local lbl = Instance.new("TextLabel", lineNumbers)
        lbl.Size = UDim2.new(1,0,0,18)
        lbl.Position = UDim2.new(0,0,0,(i-1)*18)
        lbl.BackgroundTransparency = 1
        lbl.Text = tostring(i)
        lbl.TextColor3 = Color3.fromRGB(120,120,130)
        lbl.Font = Enum.Font.Code
        lbl.TextSize = 12
        lbl.TextXAlignment = Enum.TextXAlignment.Right
    end
    lineNumbers.CanvasSize = UDim2.new(0,0,0, lines * 18)
end
editorBox:GetPropertyChangedSignal("Text"):Connect(updateLineNumbers)
updateLineNumbers()

-- Autocomplete (basic)
local acFrame = Instance.new("Frame", editorArea)
acFrame.Size = UDim2.new(0,300,0,200)
acFrame.Position = UDim2.new(0,60,0,50)
acFrame.BackgroundColor3 = Color3.fromRGB(22,22,26)
acFrame.BorderSizePixel = 0
acFrame.Visible = false

local acScroll = Instance.new("ScrollingFrame", acFrame)
acScroll.Size = UDim2.new(1,0,1,0)
acScroll.CanvasSize = UDim2.new(0,0,0,0)
acScroll.ScrollBarThickness = 6
acScroll.BackgroundTransparency = 1

local keywords = {
    "pairs()", "pcall()", "print()", "Instance.new", "workspace", "game", "Vector3.new", "CFrame.new",
    "game:GetService", "wait()", "task.wait()", "loadstring()", "require()", "spawn()", "task.spawn()"
}

local function clearAc()
    for _,v in pairs(acScroll:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    acScroll.CanvasSize = UDim2.new(0,0,0,0)
end

local function showAc(suggestions)
    clearAc()
    if #suggestions == 0 then acFrame.Visible = false return end
    for i,k in ipairs(suggestions) do
        local btn = Instance.new("TextButton", acScroll)
        btn.Size = UDim2.new(1,-8,0,28)
        btn.Position = UDim2.new(0,4,0,(i-1)*32 + 4)
        btn.BackgroundColor3 = Color3.fromRGB(30,30,34)
        btn.BorderSizePixel = 0
        btn.Text = k
        btn.Font = Enum.Font.Code
        btn.TextSize = 14
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.TextColor3 = Color3.fromRGB(220,220,230)
        btn.MouseButton1Click:Connect(function()
            local text = editorBox.Text or ""
            local cursor = editorBox.CursorPosition or (#text + 1)
            if cursor < 1 then cursor = 1 end
            local pre = string.sub(text, 1, cursor - 1)
            local post = string.sub(text, cursor)
            pre = pre:gsub("[%w_%.%:]+$", "")
            editorBox.Text = pre .. k .. post
            acFrame.Visible = false
            editorBox:CaptureFocus()
        end)
    end
    acScroll.CanvasSize = UDim2.new(0,0,0,#suggestions * 36)
    acFrame.Visible = true
end

editorBox:GetPropertyChangedSignal("Text"):Connect(function()
    local txt = editorBox.Text or ""
    local cursor = editorBox.CursorPosition or #txt + 1
    if cursor < 1 then cursor = 1 end
    local pre = string.sub(txt, 1, cursor - 1)
    local prefix = pre:match("([%w_%.:]+)$") or ""
    if prefix == "" then acFrame.Visible = false return end
    local matches = {}
    for _,k in pairs(keywords) do
        if k:lower():find("^"..prefix:lower()) then table.insert(matches, k) end
    end
    showAc(matches)
end)
editorBox.FocusLost:Connect(function() acFrame.Visible = false end)

-- Status bar & buttons
local statusBar = Instance.new("Frame", window)
statusBar.Size = UDim2.new(1, - 260, 0, 40)
statusBar.Position = UDim2.new(0,56,1,-40)
statusBar.BackgroundColor3 = Color3.fromRGB(22,22,24)

local statusLabel = Instance.new("TextLabel", statusBar)
statusLabel.Size = UDim2.new(1,-320,1,0)
statusLabel.Position = UDim2.new(0,8,0,0)
statusLabel.BackgroundTransparency = 1
statusLabel.Font = Enum.Font.SourceSansItalic
statusLabel.TextSize = 13
statusLabel.TextColor3 = Color3.fromRGB(150,150,160)
statusLabel.Text = "Ready."

local execBtn = Instance.new("TextButton", statusBar)
execBtn.Size = UDim2.new(0,100,0,28)
execBtn.Position = UDim2.new(1,-110,0,6)
execBtn.Text = "Execute"
execBtn.Font = Enum.Font.SourceSansSemibold
execBtn.TextSize = 14
execBtn.BackgroundColor3 = Color3.fromRGB(6,150,110)
execBtn.TextColor3 = Color3.fromRGB(230,230,230)

local insertServerBtn = Instance.new("TextButton", statusBar)
insertServerBtn.Size = UDim2.new(0,160,0,28)
insertServerBtn.Position = UDim2.new(1,-280,0,6)
insertServerBtn.Text = "Insert as ServerScript"
insertServerBtn.Font = Enum.Font.SourceSans
insertServerBtn.TextSize = 13
insertServerBtn.BackgroundColor3 = Color3.fromRGB(36,36,40)
insertServerBtn.TextColor3 = Color3.fromRGB(220,220,220)

local insertLocalBtn = Instance.new("TextButton", statusBar)
insertLocalBtn.Size = UDim2.new(0,160,0,28)
insertLocalBtn.Position = UDim2.new(1,-460,0,6)
insertLocalBtn.Text = "Insert as LocalScript"
insertLocalBtn.Font = Enum.Font.SourceSans
insertLocalBtn.TextSize = 13
insertLocalBtn.BackgroundColor3 = Color3.fromRGB(36,36,40)
insertLocalBtn.TextColor3 = Color3.fromRGB(220,220,220)

-- ===== Explorer data & UI builder =====
local explorerData = loadExplorer()

local function rebuildExplorerUI()
    for _,c in pairs(expScroll:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
    local count = 0
    for name,content in pairs(explorerData) do
        count = count + 1
        local btn = Instance.new("TextButton", expScroll)
        btn.Size = UDim2.new(1,-12,0,36)
        btn.Position = UDim2.new(0,6,0,(count-1)*42 + 6)
        btn.BackgroundColor3 = Color3.fromRGB(28,28,30)
        btn.BorderSizePixel = 0
        btn.Text = name
        btn.Font = Enum.Font.SourceSans
        btn.TextSize = 13
        btn.TextColor3 = Color3.fromRGB(220,220,230)
        local sVal = Instance.new("StringValue", btn)
        sVal.Name = "ScriptContent"
        sVal.Value = content or ""
        btn.MouseButton1Click:Connect(function()
            editorBox.Text = sVal.Value
            statusLabel.Text = "Opened: "..name
            updateLineNumbers()
        end)
        btn.MouseButton2Click:Connect(function()
            local ok, err = pcall(function()
                local ss = game:GetService("ServerScriptService")
                if ss then
                    local s = Instance.new("Script")
                    s.Name = name:gsub("%W","_")
                    s.Source = sVal.Value
                    s.Parent = ss
                end
            end)
            if ok then statusLabel.Text = "Inserted to ServerScriptService as "..name
            else statusLabel.Text = "Insert failed: "..tostring(err) end
        end)
    end
    expScroll.CanvasSize = UDim2.new(0,0,0, (count) * 48)
end

-- default placeholders
if next(explorerData) == nil then
    explorerData["Infinite Yield.lua"] = "-- Infinite Yield placeholder\nprint('Hello from Infinite Yield')\n"
    explorerData["Kaitun Lime.lua"] = "-- Kaitun Lime placeholder\nprint('Hello from Kaitun Lime')\n"
    saveExplorer(explorerData)
end
rebuildExplorerUI()

local function addExplorerItem(name, content)
    local safeName = tostring(name or ("Script_"..math.random(1000,9999)))
    explorerData[safeName] = tostring(content or "")
    saveExplorer(explorerData)
    rebuildExplorerUI()
    statusLabel.Text = "Added to Explorer: "..safeName
end

-- ===== Execution core =====
local function safeExecute(code)
    if not code or tostring(code):match("^%s*$") then statusLabel.Text = "Editor kosong." return end
    statusLabel.Text = "Executing..."
    local ok, err = pcall(function()
        local fn, loadErr = loadstring(code)
        if not fn then error(loadErr) end
        fn()
    end)
    if ok then statusLabel.Text = "Execution finished."
    else statusLabel.Text = "Error: "..tostring(err) end
end

-- ===== Button Behaviors =====
runIcon.MouseButton1Click:Connect(function() safeExecute(editorBox.Text) end)
execBtn.MouseButton1Click:Connect(function() safeExecute(editorBox.Text) end)
trashIcon.MouseButton1Click:Connect(function() editorBox.Text = ""; updateLineNumbers(); statusLabel.Text = "Editor cleared." end)
folderIcon.MouseButton1Click:Connect(function() addExplorerItem("Script_"..math.random(1000,9999)..".lua", editorBox.Text or "") end)

saveIcon.MouseButton1Click:Connect(function()
    local nameBox = Instance.new("TextBox", screen)
    nameBox.Size = UDim2.new(0,360,0,28)
    nameBox.Position = UDim2.new(0.5,-180,0.5,-14)
    nameBox.Text = "Snippet name..."
    nameBox.ClearTextOnFocus = false
    nameBox.Font = Enum.Font.SourceSans
    nameBox.TextSize = 14
    nameBox.BackgroundColor3 = Color3.fromRGB(30,30,32)
    local ok = Instance.new("TextButton", screen)
    ok.Size = UDim2.new(0,80,0,28)
    ok.Position = UDim2.new(0.5,192,0.5,-14)
    ok.Text = "Save"
    ok.Font = Enum.Font.SourceSansBold
    ok.TextSize = 14
    ok.BackgroundColor3 = Color3.fromRGB(8,140,100)
    ok.MouseButton1Click:Connect(function()
        local n = tostring(nameBox.Text or "Snippet_"..math.random(1000,9999))
        addExplorerItem(n, editorBox.Text or "")
        nameBox:Destroy(); ok:Destroy()
    end)
    task.delay(10, function() if nameBox and nameBox.Parent then nameBox:Destroy(); if ok then ok:Destroy() end end)
end)

linkIcon.MouseButton1Click:Connect(function()
    local dlg = Instance.new("TextBox", screen)
    dlg.Size = UDim2.new(0,520,0,24)
    dlg.Position = UDim2.new(0.5,-260,0.5,-12)
    dlg.ClearTextOnFocus = false
    dlg.Text = "Paste raw url here (raw.githubusercontent / pastebin raw)..."
    dlg.Font = Enum.Font.SourceSans
    dlg.TextSize = 12
    dlg.BackgroundColor3 = Color3.fromRGB(30,30,32)
    local ok = Instance.new("TextButton", screen)
    ok.Size = UDim2.new(0,60,0,24)
    ok.Position = UDim2.new(0.5,264,0.5,-12)
    ok.Text = "Load"
    ok.Font = Enum.Font.SourceSansBold
    ok.TextSize = 12
    ok.BackgroundColor3 = Color3.fromRGB(8,140,100)
    ok.MouseButton1Click:Connect(function()
        local url = tostring(dlg.Text or "")
        if url == "" then statusLabel.Text = "URL kosong." dlg:Destroy(); ok:Destroy(); return end
        statusLabel.Text = "Fetching..."
        local res, ferr = fetchUrlRaw(url)
        if res then editorBox.Text = res; statusLabel.Text = "Loaded content from URL."; updateLineNumbers()
        else statusLabel.Text = "Gagal load URL: "..tostring(ferr) end
        dlg:Destroy(); ok:Destroy()
    end)
end)

insertServerBtn.MouseButton1Click:Connect(function()
    local code = editorBox.Text or ""
    if code == "" then statusLabel.Text = "Editor kosong." return end
    local ok, err = pcall(function()
        local ss = game:GetService("ServerScriptService")
        if not ss then error("ServerScriptService not found") end
        local name = "InsertedScript_"..math.random(1000,9999)
        local s = Instance.new("Script")
        s.Name = name
        s.Source = code
        s.Parent = ss
    end)
    if ok then statusLabel.Text = "Inserted as Server Script."
    else statusLabel.Text = "Insert failed: "..tostring(err) end
end)

insertLocalBtn.MouseButton1Click:Connect(function()
    local code = editorBox.Text or ""
    if code == "" then statusLabel.Text = "Editor kosong." return end
    local ok, err = pcall(function()
        local sp = game:GetService("StarterPlayer")
        local starter = sp:FindFirstChild("StarterPlayerScripts")
        if not starter then
            starter = Instance.new("Folder", sp)
            starter.Name = "StarterPlayerScripts"
        end
        local name = "InsertedLocal_"..math.random(1000,9999)
        local ls = Instance.new("LocalScript")
        ls.Name = name
        ls.Source = code
        ls.Parent = starter
    end)
    if ok then statusLabel.Text = "Inserted as LocalScript (StarterPlayerScripts)."
    else statusLabel.Text = "Insert failed: "..tostring(err) end
end)

-- Ctrl+Enter execute
UserInput.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if (input.KeyCode == Enum.KeyCode.Return or input.KeyCode == Enum.KeyCode.KeypadEnter) and (UserInput:IsKeyDown(Enum.KeyCode.LeftControl) or UserInput:IsKeyDown(Enum.KeyCode.RightControl)) then
        safeExecute(editorBox.Text)
    end
end)

statusLabel.Text = "Seraphin Executor ready."

-- ===== Dragging window logic =====
local dragging, dragInput, dragStart, startPos
local function updateDrag(input)
    local delta = input.Position - dragStart
    window.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end
topbar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = window.Position
        dragInput = input
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
topbar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
end)
UserInput.InputChanged:Connect(function(input) if dragging and input == dragInput then updateDrag(input) end end)

-- ===== Open/Close animation functions =====
local tweenInfoFast = TweenInfo.new(0.28, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local tweenInfoSlow = TweenInfo.new(0.36, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local opened = false
local openPos = UDim2.new(0.1,0,0.08,0)
local hiddenPos = UDim2.new(-1,0,0.08,0)

local function openWindow()
    if opened then return end
    opened = true
    -- slide in & fade in
    window.Visible = true
    TweenService:Create(window, tweenInfoSlow, {Position = openPos}):Play()
    TweenService:Create(window, tweenInfoFast, {BackgroundTransparency = 0}):Play()
    -- small ease for topbar transparency
    TweenService:Create(topbar, tweenInfoFast, {BackgroundTransparency = 0}):Play()
    -- focus editor after open
    task.delay(0.35, function() pcall(function() editorBox:CaptureFocus() end) end)
end

local function closeWindow()
    if not opened then return end
    opened = false
    -- slide out & fade out
    TweenService:Create(window, tweenInfoSlow, {Position = hiddenPos}):Play()
    TweenService:Create(window, tweenInfoFast, {BackgroundTransparency = 1}):Play()
    -- clear focus
    pcall(function() UserInput.KeyboardEnabled = false end)
end

-- Toggle behaviours: logo click opens/closes
logoBtn.MouseButton1Click:Connect(function()
    if opened then
        closeWindow()
    else
        openWindow()
    end
end)

-- Minimize & Close buttons
btnMin.MouseButton1Click:Connect(function()
    if window.Size.X.Offset > 350 then
        -- minimize
        TweenService:Create(window, tweenInfoFast, {Size = UDim2.new(0,320,0,40)}):Play()
    else
        -- restore
        TweenService:Create(window, tweenInfoFast, {Size = UDim2.new(0,980,0,540)}):Play()
    end
end)
btnClose.MouseButton1Click:Connect(function()
    closeWindow()
end)

-- open by default with small delay for nicer effect
task.delay(0.12, function() openWindow() end)

-- ===== Final focus =====
task.delay(0.45, function() pcall(function() editorBox:CaptureFocus() end) end)

-- End of script
