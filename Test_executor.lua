local toolbar = plugin:CreateToolbar("Seraphin")
local toggleBtn = toolbar:CreateButton("Seraphin Editor", "Open Seraphin Editor", "rbxassetid://6023426915")
toggleBtn.ClickableWhenViewportHidden = true

local widgetInfo = DockWidgetPluginGuiInfo.new(
    Enum.InitialDockState.Float,
    true,
    false,
    980,
    540,
    560,
    300
)

local widget = plugin:CreateDockWidgetPluginGui("SeraphinEditorWidget", widgetInfo)
widget.Title = "Seraphin - Windows"

local root = Instance.new("Frame")
root.Size = UDim2.new(1,0,1,0)
root.BackgroundColor3 = Color3.fromRGB(18,18,20)
root.BorderSizePixel = 0
root.Parent = widget

local topbar = Instance.new("Frame", root)
topbar.Size = UDim2.new(1,0,0,40)
topbar.BackgroundColor3 = Color3.fromRGB(24,24,26)
topbar.Position = UDim2.new(0,0,0,0)
topbar.BorderSizePixel = 0

local logo = Instance.new("ImageLabel", topbar)
logo.Size = UDim2.new(0,28,0,28)
logo.Position = UDim2.new(0,8,0.5,-14)
logo.Image = "rbxassetid://6023426915"
logo.BackgroundTransparency = 1

local title = Instance.new("TextLabel", topbar)
title.Size = UDim2.new(0,220,0,40)
title.Position = UDim2.new(0,44,0,0)
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansSemibold
title.TextSize = 16
title.Text = "Seraphin - Windows"
title.TextColor3 = Color3.fromRGB(210,210,215)
title.TextXAlignment = Enum.TextXAlignment.Left

local iconbar = Instance.new("Frame", root)
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
    b.AutoButtonColor = true
    b.Name = tooltip or ("Icon"..x)
    return b
end

local runIcon = makeIconBtn(iconbar, 1, "▶", "Run")
local linkIcon = makeIconBtn(iconbar, 2, "🔗", "Load URL")
local trashIcon = makeIconBtn(iconbar, 3, "🗑", "Clear")
local saveIcon = makeIconBtn(iconbar, 4, "💾", "Save Snippet")
local folderIcon = makeIconBtn(iconbar, 5, "📂", "Add from Explorer")

local leftbar = Instance.new("Frame", root)
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

local explorer = Instance.new("Frame", root)
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

local editorArea = Instance.new("Frame", root)
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

local function updateLineNumbers()
    local t = editorBox.Text or ""
    local lines = 0
    for _ in string.gmatch(t, "\n") do lines = lines + 1 end
    lines = lines + 1
    lineNumbers:ClearAllChildren()
    local y = 0
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

local statusBar = Instance.new("Frame", root)
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
acScroll.BackgroundTransparency = 

local keywords = {
    "pairs()", "pcall()", "plugin", "print()", "printidentity()", "PathWaypoint",
    "PhysicalProperties", "RaycastParams", "DockWidgetPluginGuiInfo", "CatalogSearchParams",
    "Instance.new", "workspace", "game", "game:GetService", "Vector3.new", "CFrame.new"
}

local function clearAc()
    for _,v in pairs(acScroll:GetChildren()) do
        if v:IsA("TextButton") then v:Destroy() end
    end
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
        if k:lower():find("^"..prefix:lower()) then
            table.insert(matches, k)
        end
    end
    showAc(matches)
end)

editorBox.FocusLost:Connect(function()
    acFrame.Visible = false
end)

local function addExplorerItem(name, content)
    local count = 0
    for _,v in pairs(expScroll:GetChildren()) do
        if v:IsA("TextButton") then count = count + 1 end
    end
    local btn = Instance.new("TextButton", expScroll)
    btn.Size = UDim2.new(1,-12,0,36)
    btn.Position = UDim2.new(0,6,0,(count)*42 + 6)
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
    end)
    btn.MouseButton2Click:Connect(function()
        local ss = game:GetService("ServerScriptService")
        local s = ss:FindFirstChild(name) or Instance.new("Script", ss)
        s.Name = name
        s.Source = sVal.Value
        statusLabel.Text = "Inserted to ServerScriptService as "..name
    end)
    expScroll.CanvasSize = UDim2.new(0,0,0,(count+1) * 48)
end

addExplorerItem("Infinite Yield.lua", "-- Infinite Yield placeholder\nprint('Hello from Infinite Yield')\n")
addExplorerItem("Kaitun Lime.lua", "-- Kaitun Lime placeholder\nprint('Hello from Kaitun Lime')\n")

runIcon.MouseButton1Click:Connect(function()
    local code = editorBox.Text or ""
    if code == "" then statusLabel.Text = "Editor kosong." return end
    local ss = game:GetService("ServerScriptService")
    local existing = ss:FindFirstChild("TempRunner")
    if existing and existing:IsA("Script") then
        existing.Source = code
    else
        if existing then existing:Destroy() end
        local s = Instance.new("Script")
        s.Name = "TempRunner"
        s.Source = code
        s.Parent = ss
    end
    statusLabel.Text = "TempRunner updated (ServerScriptService). Tekan Play untuk menjalankan."
end)

linkIcon.MouseButton1Click:Connect(function()
    local dlg = Instance.new("TextBox", widget)
    dlg.Size = UDim2.new(0,520,0,24)
    dlg.Position = UDim2.new(0.5,-260,0.5,-12)
    dlg.ClearTextOnFocus = false
    dlg.Text = "Paste raw url here (raw.githubusercontent / pastebin raw)..."
    dlg.Font = Enum.Font.SourceSans
    dlg.TextSize = 12
    dlg.BackgroundColor3 = Color3.fromRGB(30,30,32)
    local ok = Instance.new("TextButton", widget)
    ok.Size = UDim2.new(0,60,0,24)
    ok.Position = UDim2.new(0.5,264,0.5,-12)
    ok.Text = "Load"
    ok.Font = Enum.Font.SourceSansBold
    ok.TextSize = 12
    ok.BackgroundColor3 = Color3.fromRGB(8,140,100)
    ok.MouseButton1Click:Connect(function()
        local url = tostring(dlg.Text or "")
        if url == "" then
            statusLabel.Text = "URL kosong."
            dlg:Destroy(); ok:Destroy(); return
        end
        statusLabel.Text = "Fetching..."
        local HttpService = game:GetService("HttpService")
        local success, res = pcall(function() return HttpService:GetAsync(url) end)
        if success and res then
            editorBox.Text = res
            statusLabel.Text = "Loaded content from URL."
        else
            statusLabel.Text = "Gagal load URL: "..tostring(res)
        end
        dlg:Destroy(); ok:Destroy()
    end)
end)

trashIcon.MouseButton1Click:Connect(function()
    editorBox.Text = ""
    statusLabel.Text = "Editor cleared."
end)

saveIcon.MouseButton1Click:Connect(function()
    plugin:SetSetting("seraphin_last_snippet", editorBox.Text or "")
    statusLabel.Text = "Snippet saved to plugin settings."
end)

folderIcon.MouseButton1Click:Connect(function()
    local name = "Script_"..math.random(1000,9999)..".lua"
    addExplorerItem(name, editorBox.Text or "")
    statusLabel.Text = "Added to Explorer: "..name
end)

execBtn.MouseButton1Click:Connect(function()
    local code = editorBox.Text or ""
    if code == "" then statusLabel.Text = "Editor kosong." return end
    local ss = game:GetService("ServerScriptService")
    local existing = ss:FindFirstChild("TempRunner")
    if existing and existing:IsA("Script") then
        existing.Source = code
    else
        if existing then existing:Destroy() end
        local s = Instance.new("Script")
        s.Name = "TempRunner"
        s.Source = code
        s.Parent = ss
    end
    statusLabel.Text = "TempRunner updated. Press Play to run it (Play Solo)."
end)

insertServerBtn.MouseButton1Click:Connect(function()
    local code = editorBox.Text or ""
    if code == "" then statusLabel.Text = "Editor kosong." return end
    local ss = game:GetService("ServerScriptService")
    local name = "InsertedScript_"..math.random(1000,9999)
    local s = Instance.new("Script")
    s.Name = name
    s.Source = code
    s.Parent = ss
    statusLabel.Text = "Inserted as Server Script: "..name
end)

insertLocalBtn.MouseButton1Click:Connect(function()
    local code = editorBox.Text or ""
    if code == "" then statusLabel.Text = "Editor kosong." return end
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
    statusLabel.Text = "Inserted as LocalScript: "..name.." (under StarterPlayer)"
end)

local last = plugin:GetSetting("seraphin_last_snippet")
if last then editorBox.Text = last; updateLineNumbers() end

toggleBtn.Click:Connect(function()
    widget.Enabled = not widget.Enabled
end)

statusLabel.Text = "Seraphin Editor ready — safe Studio plugin. Use only on your own projects."
