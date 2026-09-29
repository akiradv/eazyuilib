local EZ = {}
EZ.Version = "0.7.0"

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")

local function EZ_C(r, g, b) return Color3.fromRGB(r, g, b) end

local EZ_Themes = {
    Default = { Background = EZ_C(22, 22, 22), Card = EZ_C(29, 29, 29), CardHover = EZ_C(37, 37, 37), Border = EZ_C(46, 46, 46), BorderHover = EZ_C(72, 72, 72), TabActive = EZ_C(20, 40, 33), Text = EZ_C(238, 238, 238), TextDim = EZ_C(132, 132, 132), Accent = EZ_C(16, 185, 129) },
    Pitch = { Background = EZ_C(10, 10, 10), Card = EZ_C(17, 17, 17), CardHover = EZ_C(24, 24, 24), Border = EZ_C(34, 34, 34), BorderHover = EZ_C(58, 58, 58), TabActive = EZ_C(17, 34, 28), Text = EZ_C(229, 229, 229), TextDim = EZ_C(102, 102, 102), Accent = EZ_C(16, 185, 129) },
    Light = { Background = EZ_C(244, 244, 244), Card = EZ_C(252, 252, 252), CardHover = EZ_C(236, 236, 236), Border = EZ_C(214, 214, 214), BorderHover = EZ_C(180, 180, 180), TabActive = EZ_C(214, 240, 231), Text = EZ_C(24, 24, 24), TextDim = EZ_C(112, 112, 112), Accent = EZ_C(12, 150, 105) },
    Ocean = { Background = EZ_C(13, 20, 26), Card = EZ_C(18, 28, 36), CardHover = EZ_C(24, 36, 46), Border = EZ_C(34, 48, 60), BorderHover = EZ_C(52, 72, 88), TabActive = EZ_C(16, 42, 54), Text = EZ_C(225, 235, 240), TextDim = EZ_C(112, 132, 142), Accent = EZ_C(56, 152, 199) },
    Sunset = { Background = EZ_C(24, 16, 20), Card = EZ_C(32, 22, 27), CardHover = EZ_C(40, 28, 34), Border = EZ_C(52, 38, 46), BorderHover = EZ_C(78, 56, 68), TabActive = EZ_C(52, 28, 36), Text = EZ_C(240, 228, 232), TextDim = EZ_C(142, 120, 130), Accent = EZ_C(244, 114, 140) },
}

local EZ_Theme = { Radius = 6, RadiusWindow = 8, Success = EZ_C(16, 185, 129), Warning = EZ_C(245, 158, 11), Error = EZ_C(239, 68, 68), Info = EZ_C(59, 130, 246) }

local function EZ_ApplyTheme(name)
    local t = EZ_Themes[name] or EZ_Themes.Default
    EZ_Theme.Background = t.Background; EZ_Theme.Card = t.Card; EZ_Theme.CardHover = t.CardHover
    EZ_Theme.Border = t.Border; EZ_Theme.BorderHover = t.BorderHover; EZ_Theme.TabActive = t.TabActive
    EZ_Theme.Text = t.Text; EZ_Theme.TextDim = t.TextDim; EZ_Theme.Accent = t.Accent
end
EZ_ApplyTheme("Default")

function EZ:SetTheme(name) EZ_ApplyTheme(name) end
function EZ:SetAccent(color) EZ_Theme.Accent = color end

local EZ_LucideIcons = {
    home = "rbxassetid://1234567890", settings = "rbxassetid://1234567891", zap = "rbxassetid://1234567892",
    eye = "rbxassetid://1234567893", user = "rbxassetid://1234567894", star = "rbxassetid://1234567895",
    shield = "rbxassetid://1234567896", key = "rbxassetid://1234567897", bell = "rbxassetid://1234567898",
    code = "rbxassetid://1234567899",
}

local function EZ_GetIcon(icon)
    if type(icon) == "string" then return EZ_LucideIcons[icon:lower()] or nil
    elseif type(icon) == "number" then return "rbxassetid://" .. tostring(icon) end
    return nil
end

local EZ_TITLEBAR_HEIGHT = 38
local EZ_SIDEBAR_WIDTH = 160
local EZ_NOTIFY_WIDTH = 280
local EZ_ConfigFolder = "EazyUI_Configs"
local EZ_KeyFile = "eazyui_key.json"
local EZ_DiscordFile = "eazyui_discord.json"

local EZ_GlobalTransparency = 0
local EZ_AutoSave = true
local EZ_BGRegistry = {}
local EZ_BlurRef = nil

local function EZ_RegBG(inst)
    table.insert(EZ_BGRegistry, inst)
    return inst
end

local function EZ_GuiParent()
    if gethui then return gethui() end
    return CoreGui
end

local function EZ_Clamp(v, lo, hi) return math.clamp(v, lo, hi) end

local function EZ_Round(v, s)
    if s <= 0 then return v end
    return math.floor(v / s + 0.5) * s
end

if getgenv and getgenv().EazyUI then
    pcall(function() getgenv().EazyUI:Destroy() end)
end

local EZ_Gui = Instance.new("ScreenGui")
EZ_Gui.Name = "EazyUI"
EZ_Gui.ResetOnSpawn = false
EZ_Gui.IgnoreGuiInset = true
EZ_Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
EZ_Gui.Parent = EZ_GuiParent()

local EZ_NotifyGui = Instance.new("ScreenGui")
EZ_NotifyGui.Name = "EazyUI_Notify"
EZ_NotifyGui.ResetOnSpawn = false
EZ_NotifyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
EZ_NotifyGui.DisplayOrder = 100
EZ_NotifyGui.Parent = EZ_GuiParent()

local EZ_NotifyContainer = Instance.new("Frame")
EZ_NotifyContainer.AnchorPoint = Vector2.new(1, 1)
EZ_NotifyContainer.Position = UDim2.new(1, -24, 1, -24)
EZ_NotifyContainer.Size = UDim2.fromOffset(EZ_NOTIFY_WIDTH, 400)
EZ_NotifyContainer.BackgroundTransparency = 1
EZ_NotifyContainer.Parent = EZ_NotifyGui

local EZ_NotifyLayout = Instance.new("UIListLayout")
EZ_NotifyLayout.Padding = UDim.new(0, 8)
EZ_NotifyLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
EZ_NotifyLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
EZ_NotifyLayout.Parent = EZ_NotifyContainer

local function EZ_AddStroke(parent, color, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color or EZ_Theme.Border
    s.Thickness = thickness or 1
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = parent
    return s
end

local function EZ_AddRadius(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or EZ_Theme.Radius)
    c.Parent = parent
    return c
end

local function EZ_MakeDraggable(frame, handle)
    local dragging, start, startPos = false, nil, nil
    handle.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true; start = i.Position; startPos = frame.Position
        end
    end)
    handle.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local d = i.Position - start
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
end

local function EZ_NewRow(page, height)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, height)
    row.BackgroundColor3 = EZ_Theme.Card
    row.BackgroundTransparency = EZ_GlobalTransparency
    row.BorderSizePixel = 0
    row.ClipsDescendants = true
    row.Parent = page
    local st = EZ_AddStroke(row, EZ_Theme.Border)
    EZ_AddRadius(row, EZ_Theme.Radius)
    EZ_RegBG(row)
    row.MouseEnter:Connect(function()
        TweenService:Create(st, TweenInfo.new(0.12), { Color = EZ_Theme.BorderHover }):Play()
        TweenService:Create(row, TweenInfo.new(0.12), { BackgroundColor3 = EZ_Theme.CardHover }):Play()
    end)
    row.MouseLeave:Connect(function()
        TweenService:Create(st, TweenInfo.new(0.12), { Color = EZ_Theme.Border }):Play()
        TweenService:Create(row, TweenInfo.new(0.12), { BackgroundColor3 = EZ_Theme.Card }):Play()
    end)
    return row
end

local function EZ_RowTitle(row, text, desc, height)
    local h = height or 44
    local l = Instance.new("TextLabel")
    l.Position = UDim2.fromOffset(12, desc and 7 or 0)
    l.Size = UDim2.new(1, -130, 0, desc and 16 or h)
    l.BackgroundTransparency = 1
    l.Text = text
    l.Font = Enum.Font.Gotham
    l.TextSize = 13
    l.TextColor3 = EZ_Theme.Text
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.TextTruncate = Enum.TextTruncate.AtEnd
    l.Parent = row
    if desc and desc ~= "" then
        local d = Instance.new("TextLabel")
        d.Position = UDim2.fromOffset(12, 25)
        d.Size = UDim2.new(1, -130, 0, 14)
        d.BackgroundTransparency = 1
        d.Text = desc
        d.Font = Enum.Font.Gotham
        d.TextSize = 11
        d.TextColor3 = EZ_Theme.TextDim
        d.TextXAlignment = Enum.TextXAlignment.Left
        d.TextTruncate = Enum.TextTruncate.AtEnd
        d.Parent = row
    end
    return l
end

local function EZ_SaveConfig(placeId, data)
    if not writefile then return false end
    return pcall(function()
        if not isfolder(EZ_ConfigFolder) then makefolder(EZ_ConfigFolder) end
        writefile(EZ_ConfigFolder .. "/" .. tostring(placeId) .. ".json", HttpService:JSONEncode(data))
    end)
end

local function EZ_LoadConfig(placeId)
    if not readfile or not isfile then return nil end
    local ok, data = pcall(function()
        local p = EZ_ConfigFolder .. "/" .. tostring(placeId) .. ".json"
        if isfile(p) then return HttpService:JSONDecode(readfile(p)) end
        return nil
    end)
    return ok and data or nil
end

local function EZ_DeleteConfig(placeId)
    if not delfile or not isfile then return false end
    return pcall(function()
        local p = EZ_ConfigFolder .. "/" .. tostring(placeId) .. ".json"
        if isfile(p) then delfile(p) end
    end)
end

local function EZ_SaveKey(key, duration, filename)
    if not writefile then return false end
    return pcall(function()
        writefile(filename or EZ_KeyFile, HttpService:JSONEncode({ key = key, timestamp = os.time(), expiresAt = os.time() + (duration or 86400) }))
    end)
end

local function EZ_ClearKey(filename)
    if not delfile then return false end
    return pcall(function() if isfile(filename or EZ_KeyFile) then delfile(filename or EZ_KeyFile) end end)
end

local function EZ_LoadKey(filename)
    if not readfile or not isfile then return nil end
    local ok, data = pcall(function()
        if isfile(filename or EZ_KeyFile) then
            local d = HttpService:JSONDecode(readfile(filename or EZ_KeyFile))
            if d.expiresAt and os.time() > d.expiresAt then
                EZ_ClearKey(filename)
                return nil
            end
            return d.key
        end
        return nil
    end)
    return ok and data or nil
end

local EZ_ValidKeys = { "EASY-TEST-2024", "PREMIUM-USER", "AKIRA-DEV-KEY" }
local EZ_KeyDurationGlobal = 86400

local function EZ_ValidateKey(key)
    if not key or key == "" then return false end
    for _, k in ipairs(EZ_ValidKeys) do if key == k then return true end end
    return false
end

local function EZ_SaveDiscordJoined(invite)
    if not writefile then return false end
    return pcall(function()
        writefile(EZ_DiscordFile, HttpService:JSONEncode({ joined = invite, timestamp = os.time() }))
    end)
end

local function EZ_CheckDiscordJoined(invite)
    if not readfile or not isfile then return false end
    local ok, data = pcall(function()
        if isfile(EZ_DiscordFile) then
            local d = HttpService:JSONDecode(readfile(EZ_DiscordFile))
            return d.joined == invite
        end
        return false
    end)
    return ok and data or false
end

local function EZ_ShowLoadingScreen(EZ_LTitle, EZ_LSubTitle, EZ_LDuration)
    local EZ_LGui = Instance.new("ScreenGui")
    EZ_LGui.Name = "EazyUI_Loading"
    EZ_LGui.ResetOnSpawn = false
    EZ_LGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    EZ_LGui.DisplayOrder = 300
    EZ_LGui.Parent = EZ_GuiParent()
    local EZ_LCard = Instance.new("Frame")
    EZ_LCard.AnchorPoint = Vector2.new(0.5, 0.5)
    EZ_LCard.Position = UDim2.new(0.5, 0, 0.5, 0)
    EZ_LCard.Size = UDim2.fromOffset(380 * 0.92, 170 * 0.92)
    EZ_LCard.BackgroundColor3 = EZ_Theme.Background
    EZ_LCard.BorderSizePixel = 0
    EZ_LCard.Parent = EZ_LGui
    EZ_AddStroke(EZ_LCard, EZ_Theme.Border); EZ_AddRadius(EZ_LCard, EZ_Theme.RadiusWindow)
    TweenService:Create(EZ_LCard, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = UDim2.fromOffset(380, 170) }):Play()
    local EZ_LTopLine = Instance.new("Frame")
    EZ_LTopLine.Size = UDim2.new(1, 0, 0, 2)
    EZ_LTopLine.BackgroundColor3 = EZ_Theme.Accent
    EZ_LTopLine.BorderSizePixel = 0
    EZ_LTopLine.Parent = EZ_LCard
    local EZ_LDot = Instance.new("Frame")
    EZ_LDot.AnchorPoint = Vector2.new(0.5, 0)
    EZ_LDot.Size = UDim2.fromOffset(10, 10)
    EZ_LDot.Position = UDim2.new(0.5, 0, 0, 24)
    EZ_LDot.BackgroundColor3 = EZ_Theme.Accent
    EZ_LDot.BorderSizePixel = 0
    EZ_LDot.Parent = EZ_LCard
    EZ_AddRadius(EZ_LDot, 3)
    TweenService:Create(EZ_LDot, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, -1, true), { BackgroundTransparency = 0.5 }):Play()
    local EZ_LTitleLabel = Instance.new("TextLabel")
    EZ_LTitleLabel.AnchorPoint = Vector2.new(0.5, 0)
    EZ_LTitleLabel.Position = UDim2.new(0.5, 0, 0, 44)
    EZ_LTitleLabel.Size = UDim2.new(1, -60, 0, 24)
    EZ_LTitleLabel.BackgroundTransparency = 1
    EZ_LTitleLabel.Text = EZ_LTitle or "Loading"
    EZ_LTitleLabel.Font = Enum.Font.GothamMedium
    EZ_LTitleLabel.TextSize = 18
    EZ_LTitleLabel.TextColor3 = EZ_Theme.Text
    EZ_LTitleLabel.TextXAlignment = Enum.TextXAlignment.Center
    EZ_LTitleLabel.TextTruncate = Enum.TextTruncate.AtEnd
    EZ_LTitleLabel.Parent = EZ_LCard
    local EZ_LSubLabel = Instance.new("TextLabel")
    EZ_LSubLabel.AnchorPoint = Vector2.new(0.5, 0)
    EZ_LSubLabel.Position = UDim2.new(0.5, 0, 0, 72)
    EZ_LSubLabel.Size = UDim2.new(1, -60, 0, 16)
    EZ_LSubLabel.BackgroundTransparency = 1
    EZ_LSubLabel.Text = EZ_LSubTitle or "Please wait..."
    EZ_LSubLabel.Font = Enum.Font.Code
    EZ_LSubLabel.TextSize = 11
    EZ_LSubLabel.TextColor3 = EZ_Theme.TextDim
    EZ_LSubLabel.TextXAlignment = Enum.TextXAlignment.Center
    EZ_LSubLabel.TextTruncate = Enum.TextTruncate.AtEnd
    EZ_LSubLabel.Parent = EZ_LCard
    local EZ_LTrack = Instance.new("Frame")
    EZ_LTrack.Position = UDim2.fromOffset(30, 112)
    EZ_LTrack.Size = UDim2.new(1, -60, 0, 3)
    EZ_LTrack.BackgroundColor3 = EZ_Theme.BorderHover
    EZ_LTrack.BorderSizePixel = 0
    EZ_LTrack.Parent = EZ_LCard
    EZ_AddRadius(EZ_LTrack, 2)
    local EZ_LFill = Instance.new("Frame")
    EZ_LFill.Size = UDim2.fromScale(0, 1)
    EZ_LFill.BackgroundColor3 = EZ_Theme.Accent
    EZ_LFill.BorderSizePixel = 0
    EZ_LFill.Parent = EZ_LTrack
    EZ_AddRadius(EZ_LFill, 2)
    local EZ_LStateLabel = Instance.new("TextLabel")
    EZ_LStateLabel.Position = UDim2.fromOffset(30, 128)
    EZ_LStateLabel.Size = UDim2.new(0.6, 0, 0, 16)
    EZ_LStateLabel.BackgroundTransparency = 1
    EZ_LStateLabel.Text = "Loading interface..."
    EZ_LStateLabel.Font = Enum.Font.Code
    EZ_LStateLabel.TextSize = 10
    EZ_LStateLabel.TextColor3 = EZ_Theme.TextDim
    EZ_LStateLabel.TextXAlignment = Enum.TextXAlignment.Left
    EZ_LStateLabel.Parent = EZ_LCard
    local EZ_LPercent = Instance.new("TextLabel")
    EZ_LPercent.AnchorPoint = Vector2.new(1, 0)
    EZ_LPercent.Position = UDim2.new(1, -30, 0, 126)
    EZ_LPercent.Size = UDim2.fromOffset(60, 20)
    EZ_LPercent.BackgroundTransparency = 1
    EZ_LPercent.Text = "0%"
    EZ_LPercent.Font = Enum.Font.Code
    EZ_LPercent.TextSize = 13
    EZ_LPercent.TextColor3 = EZ_Theme.Accent
    EZ_LPercent.TextXAlignment = Enum.TextXAlignment.Right
    EZ_LPercent.Parent = EZ_LCard
    local EZ_LTotal = EZ_LDuration or 2
    local EZ_LElapsed = 0
    local EZ_LDone = false
    local EZ_LConn
    EZ_LConn = game:GetService("RunService").Heartbeat:Connect(function(dt)
        EZ_LElapsed = EZ_LElapsed + dt
        local EZ_LP = math.min(EZ_LElapsed / EZ_LTotal, 1)
        EZ_LFill.Size = UDim2.fromScale(EZ_LP, 1)
        EZ_LPercent.Text = math.floor(EZ_LP * 100) .. "%"
        if EZ_LP < 0.4 then EZ_LStateLabel.Text = "Loading interface..."
        elseif EZ_LP < 0.8 then EZ_LStateLabel.Text = "Preparing modules..."
        else EZ_LStateLabel.Text = "Almost ready..." end
        if EZ_LElapsed >= EZ_LTotal then
            EZ_LConn:Disconnect()
            EZ_LPercent.Text = "100%"
            EZ_LStateLabel.Text = "Done."
            task.wait(0.2)
            TweenService:Create(EZ_LCard, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { Size = UDim2.fromOffset(380 * 0.94, 170 * 0.94) }):Play()
            task.wait(0.22)
            EZ_LGui:Destroy()
            EZ_LDone = true
        end
    end)
    while not EZ_LDone do task.wait() end
end

local function EZ_ShowDiscordPrompt(invite, rememberJoins, callback)
    if rememberJoins and EZ_CheckDiscordJoined(invite) then callback(true) return end
    local gui = Instance.new("ScreenGui")
    gui.Name = "EazyUI_Discord"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.DisplayOrder = 250
    gui.Parent = EZ_GuiParent()
    local frame = Instance.new("Frame")
    frame.Size = UDim2.fromOffset(400, 220)
    frame.Position = UDim2.new(0.5, -200, 0.5, -110)
    frame.BackgroundColor3 = EZ_Theme.Background
    frame.BorderSizePixel = 0
    frame.Parent = gui
    EZ_AddStroke(frame, EZ_Theme.Border); EZ_AddRadius(frame, EZ_Theme.RadiusWindow)
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -20, 0, 30)
    title.Position = UDim2.fromOffset(10, 15)
    title.BackgroundTransparency = 1
    title.Text = "Join our Discord"
    title.Font = Enum.Font.GothamMedium
    title.TextSize = 16
    title.TextColor3 = EZ_Theme.Text
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = frame
    local sub = Instance.new("TextLabel")
    sub.Size = UDim2.new(1, -20, 0, 40)
    sub.Position = UDim2.fromOffset(10, 45)
    sub.BackgroundTransparency = 1
    sub.Text = "Join our Discord server for updates, support and exclusive content."
    sub.Font = Enum.Font.Gotham
    sub.TextSize = 12
    sub.TextColor3 = EZ_Theme.TextDim
    sub.TextXAlignment = Enum.TextXAlignment.Left
    sub.TextWrapped = true
    sub.Parent = frame
    local inviteLabel = Instance.new("TextLabel")
    inviteLabel.Size = UDim2.new(1, -20, 0, 30)
    inviteLabel.Position = UDim2.fromOffset(10, 95)
    inviteLabel.BackgroundTransparency = 1
    inviteLabel.Text = "discord.gg/" .. invite
    inviteLabel.Font = Enum.Font.Code
    inviteLabel.TextSize = 14
    inviteLabel.TextColor3 = EZ_Theme.Accent
    inviteLabel.TextXAlignment = Enum.TextXAlignment.Left
    inviteLabel.Parent = frame
    local join = Instance.new("TextButton")
    join.Size = UDim2.new(0.48, 0, 0, 36)
    join.Position = UDim2.new(0.02, 0, 0, 140)
    join.BackgroundColor3 = EZ_Theme.Accent
    join.BorderSizePixel = 0
    join.Text = "Join"
    join.Font = Enum.Font.GothamMedium
    join.TextSize = 13
    join.TextColor3 = EZ_Theme.Background
    join.AutoButtonColor = false
    join.Parent = frame
    EZ_AddRadius(join, EZ_Theme.Radius)
    local skip = Instance.new("TextButton")
    skip.Size = UDim2.new(0.48, 0, 0, 36)
    skip.Position = UDim2.new(0.52, 0, 0, 140)
    skip.BackgroundColor3 = EZ_Theme.CardHover
    skip.BorderSizePixel = 0
    skip.Text = "Skip"
    skip.Font = Enum.Font.GothamMedium
    skip.TextSize = 13
    skip.TextColor3 = EZ_Theme.TextDim
    skip.AutoButtonColor = false
    skip.Parent = frame
    local skipst = EZ_AddStroke(skip, EZ_Theme.Border); EZ_AddRadius(skip, EZ_Theme.Radius)
    skip.MouseEnter:Connect(function() TweenService:Create(skipst, TweenInfo.new(0.12), { Color = EZ_Theme.Accent }):Play() end)
    skip.MouseLeave:Connect(function() TweenService:Create(skipst, TweenInfo.new(0.12), { Color = EZ_Theme.Border }):Play() end)
    join.MouseButton1Click:Connect(function()
        if request then request({ Url = "https://discord.gg/" .. invite, Method = "GET" }) end
        if rememberJoins then EZ_SaveDiscordJoined(invite) end
        gui:Destroy()
        callback(true)
    end)
    skip.MouseButton1Click:Connect(function() gui:Destroy(); callback(false) end)
end

local function EZ_ShowKeyScreen(options, callback)
    local gui = Instance.new("ScreenGui")
    gui.Name = "EazyUI_Key"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.DisplayOrder = 200
    gui.Parent = EZ_GuiParent()
    local frame = Instance.new("Frame")
    frame.Size = UDim2.fromOffset(400, 240)
    frame.Position = UDim2.new(0.5, -200, 0.5, -120)
    frame.BackgroundColor3 = EZ_Theme.Background
    frame.BorderSizePixel = 0
    frame.Parent = gui
    EZ_AddStroke(frame, EZ_Theme.Border); EZ_AddRadius(frame, EZ_Theme.RadiusWindow)
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -20, 0, 30)
    title.Position = UDim2.fromOffset(10, 15)
    title.BackgroundTransparency = 1
    title.Text = options.Title or "Enter Key"
    title.Font = Enum.Font.GothamMedium
    title.TextSize = 16
    title.TextColor3 = EZ_Theme.Text
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = frame
    local sub = Instance.new("TextLabel")
    sub.Size = UDim2.new(1, -20, 0, 20)
    sub.Position = UDim2.fromOffset(10, 45)
    sub.BackgroundTransparency = 1
    sub.Text = options.Subtitle or "Enter your access key to continue"
    sub.Font = Enum.Font.Gotham
    sub.TextSize = 12
    sub.TextColor3 = EZ_Theme.TextDim
    sub.TextXAlignment = Enum.TextXAlignment.Left
    sub.Parent = frame
    local input = Instance.new("TextBox")
    input.Size = UDim2.new(1, -20, 0, 32)
    input.Position = UDim2.fromOffset(10, 80)
    input.BackgroundColor3 = EZ_Theme.Card
    input.BorderSizePixel = 0
    input.Text = ""
    input.PlaceholderText = "Enter key here..."
    input.Font = Enum.Font.Code
    input.TextSize = 12
    input.TextColor3 = EZ_Theme.Text
    input.PlaceholderColor3 = EZ_Theme.TextDim
    input.TextXAlignment = Enum.TextXAlignment.Left
    input.ClearTextOnFocus = false
    input.Parent = frame
    local ist = EZ_AddStroke(input, EZ_Theme.Border); EZ_AddRadius(input, EZ_Theme.Radius)
    local ip = Instance.new("UIPadding")
    ip.PaddingLeft = UDim.new(0, 10); ip.PaddingRight = UDim.new(0, 10); ip.Parent = input
    input.Focused:Connect(function() ist.Color = EZ_Theme.Accent end)
    input.FocusLost:Connect(function() ist.Color = EZ_Theme.Border end)
    local note = Instance.new("TextLabel")
    note.Size = UDim2.new(1, -20, 0, 20)
    note.Position = UDim2.fromOffset(10, 120)
    note.BackgroundTransparency = 1
    note.Text = options.Note or ""
    note.Font = Enum.Font.Gotham
    note.TextSize = 11
    note.TextColor3 = EZ_Theme.TextDim
    note.TextXAlignment = Enum.TextXAlignment.Left
    note.Parent = frame
    local submit = Instance.new("TextButton")
    submit.Size = UDim2.new(0.48, 0, 0, 36)
    submit.Position = UDim2.new(0.02, 0, 0, 155)
    submit.BackgroundColor3 = EZ_Theme.CardHover
    submit.BorderSizePixel = 0
    submit.Text = "Submit"
    submit.Font = Enum.Font.GothamMedium
    submit.TextSize = 13
    submit.TextColor3 = EZ_Theme.Text
    submit.AutoButtonColor = false
    submit.Parent = frame
    local sst = EZ_AddStroke(submit, EZ_Theme.Border); EZ_AddRadius(submit, EZ_Theme.Radius)
    submit.MouseEnter:Connect(function() TweenService:Create(sst, TweenInfo.new(0.12), { Color = EZ_Theme.Accent }):Play() end)
    submit.MouseLeave:Connect(function() TweenService:Create(sst, TweenInfo.new(0.12), { Color = EZ_Theme.Border }):Play() end)
    local cancel = Instance.new("TextButton")
    cancel.Size = UDim2.new(0.48, 0, 0, 36)
    cancel.Position = UDim2.new(0.52, 0, 0, 155)
    cancel.BackgroundColor3 = EZ_Theme.CardHover
    cancel.BorderSizePixel = 0
    cancel.Text = "Cancel"
    cancel.Font = Enum.Font.GothamMedium
    cancel.TextSize = 13
    cancel.TextColor3 = EZ_Theme.TextDim
    cancel.AutoButtonColor = false
    cancel.Parent = frame
    local cst = EZ_AddStroke(cancel, EZ_Theme.Border); EZ_AddRadius(cancel, EZ_Theme.Radius)
    cancel.MouseEnter:Connect(function() TweenService:Create(cst, TweenInfo.new(0.12), { Color = EZ_Theme.Accent }):Play() end)
    cancel.MouseLeave:Connect(function() TweenService:Create(cst, TweenInfo.new(0.12), { Color = EZ_Theme.Border }):Play() end)
    local err = Instance.new("TextLabel")
    err.Size = UDim2.new(1, -20, 0, 20)
    err.Position = UDim2.fromOffset(10, 205)
    err.BackgroundTransparency = 1
    err.Text = ""
    err.Font = Enum.Font.Gotham
    err.TextSize = 11
    err.TextColor3 = EZ_Theme.Error
    err.TextXAlignment = Enum.TextXAlignment.Left
    err.Parent = frame
    local function doSubmit()
        local key = input.Text
        if EZ_ValidateKey(key) then
            EZ_SaveKey(key, EZ_KeyDurationGlobal, options.FileName)
            gui:Destroy()
            callback(true, key)
        else
            err.Text = "Invalid key. Please try again."
            input.Text = ""
        end
    end
    submit.MouseButton1Click:Connect(doSubmit)
    input.FocusLost:Connect(function(enter) if enter then doSubmit() end end)
    cancel.MouseButton1Click:Connect(function() gui:Destroy(); callback(false, nil) end)
    input:CaptureFocus()
end

function EZ:Notify(options)
    options = options or {}
    local t = options.Title or "Eazy UI"
    local c = options.Content or ""
    local d = options.Duration or 3
    local style = (options.Style or "Info"):lower()
    local buttons = options.Buttons or {}
    local onOpen = options.OnOpen
    local onClose = options.OnClose
    local hasButtons = #buttons > 0
    local height = hasButtons and 92 or 62
    local styleColor = EZ_Theme.Info
    if style == "success" then styleColor = EZ_Theme.Success
    elseif style == "warning" then styleColor = EZ_Theme.Warning
    elseif style == "error" then styleColor = EZ_Theme.Error end
    local holder = Instance.new("Frame")
    holder.Size = UDim2.fromOffset(0, height)
    holder.BackgroundTransparency = 1
    holder.ClipsDescendants = true
    holder.Parent = EZ_NotifyContainer
    local card = Instance.new("Frame")
    card.Size = UDim2.fromOffset(EZ_NOTIFY_WIDTH, height)
    card.BackgroundColor3 = EZ_Theme.Card
    card.BackgroundTransparency = EZ_GlobalTransparency
    card.BorderSizePixel = 0
    card.Parent = holder
    EZ_AddStroke(card, EZ_Theme.Border); EZ_AddRadius(card, EZ_Theme.Radius)
    EZ_RegBG(card)
    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(0, 2, 1, 0)
    bar.BackgroundColor3 = styleColor
    bar.BorderSizePixel = 0
    bar.Parent = card
    local tl = Instance.new("TextLabel")
    tl.Position = UDim2.fromOffset(14, 9)
    tl.Size = UDim2.new(1, -24, 0, 16)
    tl.BackgroundTransparency = 1
    tl.Text = t
    tl.Font = Enum.Font.GothamMedium; tl.TextSize = 13; tl.TextColor3 = EZ_Theme.Text
    tl.TextXAlignment = Enum.TextXAlignment.Left; tl.TextTruncate = Enum.TextTruncate.AtEnd
    tl.Parent = card
    local cl = Instance.new("TextLabel")
    cl.Position = UDim2.fromOffset(14, 27)
    cl.Size = UDim2.new(1, -24, 0, 26)
    cl.BackgroundTransparency = 1
    cl.Text = c
    cl.Font = Enum.Font.Gotham; cl.TextSize = 12; cl.TextColor3 = EZ_Theme.TextDim
    cl.TextXAlignment = Enum.TextXAlignment.Left; cl.TextYAlignment = Enum.TextYAlignment.Top
    cl.TextWrapped = true
    cl.Parent = card
    if hasButtons then
        local btnRow = Instance.new("Frame")
        btnRow.Size = UDim2.new(1, -28, 0, 24)
        btnRow.Position = UDim2.fromOffset(14, 58)
        btnRow.BackgroundTransparency = 1
        btnRow.Parent = card
        local btnLayout = Instance.new("UIListLayout")
        btnLayout.FillDirection = Enum.FillDirection.Horizontal
        btnLayout.Padding = UDim.new(0, 6)
        btnLayout.Parent = btnRow
        for _, btnData in ipairs(buttons) do
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(0.5, -3, 1, 0)
            btn.BackgroundColor3 = EZ_Theme.Background
            btn.BorderSizePixel = 0
            btn.Text = btnData.Title
            btn.Font = Enum.Font.Gotham
            btn.TextSize = 11
            btn.TextColor3 = EZ_Theme.Text
            btn.AutoButtonColor = false
            btn.Parent = btnRow
            local bst = EZ_AddStroke(btn, EZ_Theme.Border); EZ_AddRadius(btn, 4)
            btn.MouseEnter:Connect(function() TweenService:Create(bst, TweenInfo.new(0.12), { Color = EZ_Theme.Accent }):Play() end)
            btn.MouseLeave:Connect(function() TweenService:Create(bst, TweenInfo.new(0.12), { Color = EZ_Theme.Border }):Play() end)
            btn.MouseButton1Click:Connect(function()
                if btnData.Callback then btnData.Callback() end
                holder:Destroy()
                if onClose then onClose("Action") end
            end)
        end
    end
    if onOpen then onOpen() end
    TweenService:Create(holder, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = UDim2.fromOffset(EZ_NOTIFY_WIDTH, height) }):Play()
    if d > 0 then
        task.delay(d, function()
            if not holder.Parent then return end
            TweenService:Create(holder, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { Size = UDim2.fromOffset(0, height) }):Play()
            task.wait(0.16)
            holder:Destroy()
            if onClose then onClose("Timeout") end
        end)
    end
end

function EZ:CreateWindow(options)
    options = options or {}
    local EZ_Name = options.Name or "Eazy UI"
    local EZ_SubTitle = options.SubTitle or ""
    local EZ_Size = options.Size or UDim2.fromOffset(560, 400)
    local EZ_MinKey = options.MinimizeKey or Enum.KeyCode.RightControl
    local EZ_ConfigId = options.ConfigId or tostring(game.PlaceId)
    EZ_KeyDurationGlobal = options.KeyDuration or 86400
    EZ_GlobalTransparency = EZ_Clamp(options.Transparency or 0, 0, 0.9)

    if options.Acrylic then
        EZ_BlurRef = Instance.new("BlurEffect")
        EZ_BlurRef.Name = "EazyUI_Blur"
        EZ_BlurRef.Size = 28
        EZ_BlurRef.Parent = Lighting
    end

    if options.LoadingTitle then
        EZ_ShowLoadingScreen(options.LoadingTitle, options.LoadingSubtitle or "", options.LoadingDuration or 2)
    end

    if options.Discord and options.Discord.Enabled then
        local resolved = false
        EZ_ShowDiscordPrompt(options.Discord.Invite, options.Discord.RememberJoins, function() resolved = true end)
        while not resolved do task.wait(0.1) end
    end

    if options.KeySystem and options.KeySystem.Enabled then
        local keyOptions = { Title = options.KeySystem.Title, Subtitle = options.KeySystem.Subtitle, Note = options.KeySystem.Note, FileName = options.KeySystem.FileName }
        local savedKey = EZ_LoadKey(options.KeySystem.FileName)
        if not (savedKey and EZ_ValidateKey(savedKey)) then
            local resolved, success = false, false
            EZ_ShowKeyScreen(keyOptions, function(s) success = s; resolved = true end)
            while not resolved do task.wait(0.1) end
            if not success then
                EZ:Notify({ Title = "Eazy UI", Content = "Access denied.", Style = "Error", Duration = 3 })
                return nil
            end
        end
    end

    local EZ_Window = {}
    EZ_Window.Minimized = false
    EZ_Window.ConfigData = {}
    EZ_Window.Elements = {}

    local function EZ_BuildWindow()
        local frame = Instance.new("Frame")
        frame.Name = "Window"
        frame.Size = UDim2.fromOffset(EZ_Size.X.Offset * 0.96, EZ_Size.Y.Offset * 0.96)
        frame.Position = UDim2.new(0.5, -(EZ_Size.X.Offset * 0.96) / 2, 0.5, -(EZ_Size.Y.Offset * 0.96) / 2)
        frame.BackgroundColor3 = EZ_Theme.Background
        frame.BackgroundTransparency = EZ_GlobalTransparency
        frame.BorderSizePixel = 0
        frame.ClipsDescendants = true
        frame.Parent = EZ_Gui
        EZ_AddStroke(frame, EZ_Theme.Border); EZ_AddRadius(frame, EZ_Theme.RadiusWindow)
        EZ_RegBG(frame)
        TweenService:Create(frame, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = EZ_Size, Position = UDim2.new(0.5, -EZ_Size.X.Offset / 2, 0.5, -EZ_Size.Y.Offset / 2)
        }):Play()

        local titlebar = Instance.new("Frame")
        titlebar.Size = UDim2.new(1, 0, 0, EZ_TITLEBAR_HEIGHT)
        titlebar.BackgroundColor3 = EZ_Theme.Card
        titlebar.BackgroundTransparency = EZ_GlobalTransparency
        titlebar.BorderSizePixel = 0
        titlebar.Parent = frame
        EZ_RegBG(titlebar)

        local tline = Instance.new("Frame")
        tline.Size = UDim2.new(1, 0, 0, 1)
        tline.Position = UDim2.new(0, 0, 1, -1)
        tline.BackgroundColor3 = EZ_Theme.Border
        tline.BorderSizePixel = 0
        tline.Parent = titlebar

        local tholder = Instance.new("Frame")
        tholder.BackgroundTransparency = 1
        tholder.Size = UDim2.new(1, -60, 1, 0)
        tholder.Position = UDim2.fromOffset(14, 0)
        tholder.Parent = titlebar
        local tlay = Instance.new("UIListLayout")
        tlay.FillDirection = Enum.FillDirection.Horizontal
        tlay.VerticalAlignment = Enum.VerticalAlignment.Center
        tlay.Padding = UDim.new(0, 8)
        tlay.Parent = tholder

        local tdot = Instance.new("Frame")
        tdot.Size = UDim2.fromOffset(8, 8)
        tdot.BackgroundColor3 = EZ_Theme.Accent
        tdot.BorderSizePixel = 0
        tdot.Parent = tholder
        EZ_AddRadius(tdot, 2)

        local tlabel = Instance.new("TextLabel")
        tlabel.BackgroundTransparency = 1
        tlabel.Size = UDim2.fromOffset(0, 20)
        tlabel.AutomaticSize = Enum.AutomaticSize.X
        tlabel.Text = EZ_Name
        tlabel.Font = Enum.Font.GothamMedium
        tlabel.TextSize = 14
        tlabel.TextColor3 = EZ_Theme.Text
        tlabel.Parent = tholder

        local slabel = Instance.new("TextLabel")
        slabel.BackgroundTransparency = 1
        slabel.Size = UDim2.fromOffset(0, 18)
        slabel.AutomaticSize = Enum.AutomaticSize.X
        slabel.Text = EZ_SubTitle
        slabel.Font = Enum.Font.Code
        slabel.TextSize = 11
        slabel.TextColor3 = EZ_Theme.TextDim
        slabel.Parent = tholder

        local minbtn = Instance.new("TextButton")
        minbtn.Size = UDim2.fromOffset(28, 28)
        minbtn.Position = UDim2.new(1, -34, 0.5, -14)
        minbtn.BackgroundColor3 = EZ_Theme.CardHover
        minbtn.BackgroundTransparency = 1
        minbtn.Text = ""
        minbtn.AutoButtonColor = false
        minbtn.Parent = titlebar
        EZ_AddRadius(minbtn, EZ_Theme.Radius)
        local minicon = Instance.new("Frame")
        minicon.Size = UDim2.fromOffset(12, 2)
        minicon.Position = UDim2.new(0.5, -6, 0.5, -1)
        minicon.BackgroundColor3 = EZ_Theme.TextDim
        minicon.BorderSizePixel = 0
        minicon.Parent = minbtn
        EZ_AddRadius(minicon, 1)

        local sidebar = Instance.new("Frame")
        sidebar.Size = UDim2.new(0, EZ_SIDEBAR_WIDTH, 1, -EZ_TITLEBAR_HEIGHT)
        sidebar.Position = UDim2.new(0, 0, 0, EZ_TITLEBAR_HEIGHT)
        sidebar.BackgroundColor3 = EZ_Theme.Card
        sidebar.BackgroundTransparency = EZ_GlobalTransparency
        sidebar.BorderSizePixel = 0
        sidebar.Parent = frame
        EZ_RegBG(sidebar)
        local slay = Instance.new("UIListLayout")
        slay.Padding = UDim.new(0, 4); slay.Parent = sidebar
        local spad = Instance.new("UIPadding")
        spad.PaddingTop = UDim.new(0, 10); spad.PaddingBottom = UDim.new(0, 10)
        spad.PaddingLeft = UDim.new(0, 8); spad.PaddingRight = UDim.new(0, 8); spad.Parent = sidebar

        local sline = Instance.new("Frame")
        sline.Size = UDim2.new(0, 1, 1, -EZ_TITLEBAR_HEIGHT)
        sline.Position = UDim2.new(0, EZ_SIDEBAR_WIDTH - 1, 0, EZ_TITLEBAR_HEIGHT)
        sline.BackgroundColor3 = EZ_Theme.Border
        sline.BorderSizePixel = 0
        sline.Parent = frame

        local content = Instance.new("Frame")
        content.Position = UDim2.new(0, EZ_SIDEBAR_WIDTH, 0, EZ_TITLEBAR_HEIGHT)
        content.Size = UDim2.new(1, -EZ_SIDEBAR_WIDTH, 1, -EZ_TITLEBAR_HEIGHT)
        content.BackgroundTransparency = 1
        content.ClipsDescendants = true
        content.Parent = frame

        local registry = {}

        local function selectTab(target)
            for _, d in ipairs(registry) do
                d.Active = (d == target)
                d.Page.Visible = d.Active
                d.Button.BackgroundColor3 = d.Active and EZ_Theme.TabActive or EZ_Theme.CardHover
                TweenService:Create(d.Button, TweenInfo.new(0.12), { BackgroundTransparency = d.Active and 0 or 1 }):Play()
                TweenService:Create(d.Label, TweenInfo.new(0.12), { TextColor3 = d.Active and EZ_Theme.Text or EZ_Theme.TextDim }):Play()
            end
        end

        local function setMinimized(state)
            if not frame.Parent then return end
            EZ_Window.Minimized = state
            frame.Visible = not state
            if EZ_BlurRef then EZ_BlurRef.Enabled = not state end
        end

        minbtn.MouseEnter:Connect(function()
            TweenService:Create(minbtn, TweenInfo.new(0.12), { BackgroundTransparency = 0 }):Play()
            TweenService:Create(minicon, TweenInfo.new(0.12), { BackgroundColor3 = EZ_Theme.Text }):Play()
        end)
        minbtn.MouseLeave:Connect(function()
            TweenService:Create(minbtn, TweenInfo.new(0.12), { BackgroundTransparency = 1 }):Play()
            TweenService:Create(minicon, TweenInfo.new(0.12), { BackgroundColor3 = EZ_Theme.TextDim }):Play()
        end)
        minbtn.MouseButton1Click:Connect(function() setMinimized(not EZ_Window.Minimized) end)

        UserInputService.InputBegan:Connect(function(input, processed)
            if processed then return end
            if input.KeyCode == EZ_MinKey then setMinimized(not EZ_Window.Minimized) end
        end)

        EZ_MakeDraggable(frame, titlebar)

        function EZ_Window:AddTab(opt)
            opt = opt or {}
            local tabTitle = opt.Title or "Tab"
            local tabIcon = EZ_GetIcon(opt.Icon)
            local data = {}
            local tab = {}

            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 34)
            btn.BackgroundColor3 = EZ_Theme.CardHover
            btn.BackgroundTransparency = 1
            btn.Text = ""
            btn.AutoButtonColor = false
            btn.Parent = sidebar
            EZ_AddRadius(btn, EZ_Theme.Radius)

            local lbl = Instance.new("TextLabel")
            lbl.Position = UDim2.fromOffset(tabIcon and 36 or 14, 0)
            lbl.Size = UDim2.new(1, tabIcon and 42 or 20, 1, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = tabTitle
            lbl.Font = Enum.Font.Gotham
            lbl.TextSize = 13
            lbl.TextColor3 = EZ_Theme.TextDim
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.TextTruncate = Enum.TextTruncate.AtEnd
            lbl.Parent = btn

            if tabIcon then
                local icon = Instance.new("ImageLabel")
                icon.Size = UDim2.fromOffset(16, 16)
                icon.Position = UDim2.new(0, 14, 0.5, -8)
                icon.BackgroundTransparency = 1
                icon.Image = tabIcon
                icon.ImageColor3 = EZ_Theme.TextDim
                icon.Parent = btn
            end

            local page = Instance.new("ScrollingFrame")
            page.Size = UDim2.new(1, 0, 1, 0)
            page.BackgroundTransparency = 1
            page.BorderSizePixel = 0
            page.ScrollBarThickness = 2
            page.ScrollBarImageColor3 = EZ_Theme.Border
            page.AutomaticCanvasSize = Enum.AutomaticSize.Y
            page.ScrollingDirection = Enum.ScrollingDirection.Y
            page.Visible = false
            page.Parent = content
            local play = Instance.new("UIListLayout")
            play.Padding = UDim.new(0, 8); play.Parent = page
            local ppad = Instance.new("UIPadding")
            ppad.PaddingTop = UDim.new(0, 14); ppad.PaddingBottom = UDim.new(0, 14)
            ppad.PaddingLeft = UDim.new(0, 16); ppad.PaddingRight = UDim.new(0, 16); ppad.Parent = page

            data.Button = btn; data.Label = lbl; data.Page = page; data.Active = false
            table.insert(registry, data)

            btn.MouseEnter:Connect(function()
                if not data.Active then
                    TweenService:Create(lbl, TweenInfo.new(0.12), { TextColor3 = EZ_Theme.Text }):Play()
                    TweenService:Create(btn, TweenInfo.new(0.12), { BackgroundTransparency = 0 }):Play()
                end
            end)
            btn.MouseLeave:Connect(function()
                if not data.Active then
                    TweenService:Create(lbl, TweenInfo.new(0.12), { TextColor3 = EZ_Theme.TextDim }):Play()
                    TweenService:Create(btn, TweenInfo.new(0.12), { BackgroundTransparency = 1 }):Play()
                end
            end)
            btn.MouseButton1Click:Connect(function() selectTab(data) end)
            if #registry == 1 then selectTab(data) end

            function tab:AddSection(o)
                o = o or {}
                local row = Instance.new("Frame")
                row.Size = UDim2.new(1, 0, 0, 18)
                row.BackgroundTransparency = 1
                row.Parent = page
                local t = Instance.new("TextLabel")
                t.Size = UDim2.new(1, 0, 1, 0)
                t.BackgroundTransparency = 1
                t.Text = string.upper(o.Title or "")
                t.Font = Enum.Font.Code
                t.TextSize = 11
                t.TextColor3 = EZ_Theme.TextDim
                t.TextXAlignment = Enum.TextXAlignment.Left
                t.Parent = row
                local p = Instance.new("UIPadding")
                p.PaddingLeft = UDim.new(0, 12); p.Parent = row
                local obj = {}
                function obj:Set(x) t.Text = string.upper(x or "") end
                return obj
            end

            function tab:AddDivider()
                local div = Instance.new("Frame")
                div.Size = UDim2.new(1, 0, 0, 1)
                div.BackgroundColor3 = EZ_Theme.Border
                div.BorderSizePixel = 0
                div.Parent = page
                local obj = {}
                function obj:Set(v) div.Visible = v end
                return obj
            end

            function tab:AddParagraph(o)
                o = o or {}
                local row = Instance.new("Frame")
                row.Size = UDim2.new(1, 0, 0, 0)
                row.AutomaticSize = Enum.AutomaticSize.Y
                row.BackgroundColor3 = EZ_Theme.Card
                row.BackgroundTransparency = EZ_GlobalTransparency
                row.BorderSizePixel = 0
                row.Parent = page
                EZ_AddStroke(row, EZ_Theme.Border); EZ_AddRadius(row, EZ_Theme.Radius)
                EZ_RegBG(row)
                local lay = Instance.new("UIListLayout")
                lay.Padding = UDim.new(0, 4); lay.Parent = row
                local pad = Instance.new("UIPadding")
                pad.PaddingLeft = UDim.new(0, 12); pad.PaddingRight = UDim.new(0, 12)
                pad.PaddingTop = UDim.new(0, 10); pad.PaddingBottom = UDim.new(0, 10); pad.Parent = row
                local cl = nil
                if o.Title and o.Title ~= "" then
                    local pt = Instance.new("TextLabel")
                    pt.Size = UDim2.new(1, 0, 0, 0); pt.AutomaticSize = Enum.AutomaticSize.Y
                    pt.BackgroundTransparency = 1; pt.Text = o.Title
                    pt.Font = Enum.Font.GothamMedium; pt.TextSize = 13; pt.TextColor3 = EZ_Theme.Text
                    pt.TextXAlignment = Enum.TextXAlignment.Left; pt.TextWrapped = true; pt.Parent = row
                end
                if o.Content and o.Content ~= "" then
                    cl = Instance.new("TextLabel")
                    cl.Size = UDim2.new(1, 0, 0, 0); cl.AutomaticSize = Enum.AutomaticSize.Y
                    cl.BackgroundTransparency = 1; cl.Text = o.Content
                    cl.Font = Enum.Font.Gotham; cl.TextSize = 12; cl.TextColor3 = EZ_Theme.TextDim
                    cl.TextXAlignment = Enum.TextXAlignment.Left; cl.TextWrapped = true; cl.Parent = row
                end
                local obj = {}
                function obj:Set(x) if cl then cl.Text = x or "" end end
                return obj
            end

            function tab:AddLabel(text)
                local row = Instance.new("Frame")
                row.Size = UDim2.new(1, 0, 0, 0)
                row.AutomaticSize = Enum.AutomaticSize.Y
                row.BackgroundTransparency = 1
                row.Parent = page
                local pad = Instance.new("UIPadding")
                pad.PaddingLeft = UDim.new(0, 12); pad.PaddingRight = UDim.new(0, 12); pad.Parent = row
                local t = Instance.new("TextLabel")
                t.Size = UDim2.new(1, 0, 0, 0); t.AutomaticSize = Enum.AutomaticSize.Y
                t.BackgroundTransparency = 1; t.Text = text or ""
                t.Font = Enum.Font.Gotham; t.TextSize = 12; t.TextColor3 = EZ_Theme.TextDim
                t.TextXAlignment = Enum.TextXAlignment.Left; t.TextWrapped = true; t.Parent = row
                local obj = {}
                function obj:Set(x) t.Text = x or "" end
                return obj
            end

            function tab:AddToggle(o)
                o = o or {}
                local cb = o.Callback or function() end
                local id = o.Flag or o.Id or o.Title or "toggle_" .. os.clock()
                local obj = { Value = o.Default and true or false, Id = id, Flag = o.Flag, Type = "toggle", Default = o.Default and true or false }
                local row = EZ_NewRow(page, 44)
                EZ_RowTitle(row, o.Title or "Toggle", o.Description, 44)
                local track = Instance.new("Frame")
                track.Size = UDim2.fromOffset(40, 20)
                track.Position = UDim2.new(1, -52, 0.5, -10)
                track.BackgroundColor3 = EZ_Theme.BorderHover
                track.BorderSizePixel = 0
                track.Parent = row
                EZ_AddRadius(track, 10)
                local knob = Instance.new("Frame")
                knob.Size = UDim2.fromOffset(14, 14)
                knob.Position = UDim2.fromOffset(3, 3)
                knob.BackgroundColor3 = EZ_Theme.TextDim
                knob.BorderSizePixel = 0
                knob.Parent = track
                EZ_AddRadius(knob, 7)
                local function render()
                    local on = obj.Value
                    TweenService:Create(track, TweenInfo.new(0.12), { BackgroundColor3 = on and EZ_Theme.Accent or EZ_Theme.BorderHover }):Play()
                    TweenService:Create(knob, TweenInfo.new(0.12), { Position = UDim2.fromOffset(on and 23 or 3, 3), BackgroundColor3 = on and EZ_Theme.Background or EZ_Theme.TextDim }):Play()
                end
                function obj:Set(state, silent)
                    obj.Value = state and true or false
                    render()
                    if not silent then
                        cb(obj.Value)
                        if obj.Flag and EZ_AutoSave then
                            EZ_Window.ConfigData[id] = { type = "toggle", value = obj.Value }
                            EZ_SaveConfig(EZ_ConfigId, EZ_Window.ConfigData)
                        end
                    end
                end
                row.InputBegan:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 then obj:Set(not obj.Value) end
                end)
                render()
                if obj.Flag then table.insert(EZ_Window.Elements, obj) end
                return obj
            end

            function tab:AddButton(o)
                o = o or {}
                local cb = o.Callback or function() end
                local obj = {}
                local row = EZ_NewRow(page, 44)
                EZ_RowTitle(row, o.Title or "Button", o.Description, 44)
                local act = Instance.new("TextButton")
                act.Size = UDim2.fromOffset(96, 28)
                act.Position = UDim2.new(1, -108, 0.5, -14)
                act.BackgroundColor3 = EZ_Theme.CardHover
                act.BorderSizePixel = 0
                act.Text = "Run"
                act.Font = Enum.Font.Code
                act.TextSize = 12
                act.TextColor3 = EZ_Theme.TextDim
                act.AutoButtonColor = false
                act.Parent = row
                local ast = EZ_AddStroke(act, EZ_Theme.Border); EZ_AddRadius(act, EZ_Theme.Radius)
                act.MouseEnter:Connect(function()
                    TweenService:Create(ast, TweenInfo.new(0.12), { Color = EZ_Theme.Accent }):Play()
                    TweenService:Create(act, TweenInfo.new(0.12), { TextColor3 = EZ_Theme.Text, BackgroundColor3 = EZ_Theme.BorderHover }):Play()
                end)
                act.MouseLeave:Connect(function()
                    TweenService:Create(ast, TweenInfo.new(0.12), { Color = EZ_Theme.Border }):Play()
                    TweenService:Create(act, TweenInfo.new(0.12), { TextColor3 = EZ_Theme.TextDim, BackgroundColor3 = EZ_Theme.CardHover }):Play()
                end)
                function obj:Fire()
                    TweenService:Create(ast, TweenInfo.new(0.08), { Color = EZ_Theme.Accent }):Play()
                    task.delay(0.25, function() if act.Parent then TweenService:Create(ast, TweenInfo.new(0.2), { Color = EZ_Theme.Border }):Play() end end)
                    cb()
                end
                act.MouseButton1Click:Connect(function() obj:Fire() end)
                return obj
            end

            function tab:AddSlider(o)
                o = o or {}
                local mn, mx, st = o.Min or 0, o.Max or 100, o.Step or 1
                local cb = o.Callback or function() end
                local id = o.Flag or o.Id or o.Title or "slider_" .. os.clock()
                local obj = { Value = o.Default or mn, Id = id, Flag = o.Flag, Type = "slider", Default = o.Default or mn }
                local dragging = false
                local row = EZ_NewRow(page, 62)
                local tl = Instance.new("TextLabel")
                tl.Position = UDim2.fromOffset(12, 10)
                tl.Size = UDim2.new(1, -110, 0, 16)
                tl.BackgroundTransparency = 1
                tl.Text = o.Title or "Slider"
                tl.Font = Enum.Font.Gotham; tl.TextSize = 13; tl.TextColor3 = EZ_Theme.Text
                tl.TextXAlignment = Enum.TextXAlignment.Left; tl.TextTruncate = Enum.TextTruncate.AtEnd
                tl.Parent = row
                local vl = Instance.new("TextLabel")
                vl.AnchorPoint = Vector2.new(1, 0)
                vl.Position = UDim2.new(1, -12, 0, 10)
                vl.Size = UDim2.fromOffset(80, 16)
                vl.BackgroundTransparency = 1
                vl.Font = Enum.Font.Code; vl.TextSize = 13; vl.TextColor3 = EZ_Theme.TextDim
                vl.TextXAlignment = Enum.TextXAlignment.Right
                vl.Parent = row
                local track = Instance.new("Frame")
                track.Position = UDim2.fromOffset(12, 38)
                track.Size = UDim2.new(1, -24, 0, 6)
                track.BackgroundColor3 = EZ_Theme.BorderHover
                track.BorderSizePixel = 0
                track.Parent = row
                EZ_AddRadius(track, 3)
                local fill = Instance.new("Frame")
                fill.Size = UDim2.new(0, 0, 1, 0)
                fill.BackgroundColor3 = EZ_Theme.Accent
                fill.BorderSizePixel = 0
                fill.Parent = track
                EZ_AddRadius(fill, 3)
                local knob = Instance.new("Frame")
                knob.AnchorPoint = Vector2.new(0.5, 0.5)
                knob.Size = UDim2.fromOffset(12, 12)
                knob.Position = UDim2.new(0, 0, 0.5, 0)
                knob.BackgroundColor3 = EZ_Theme.Accent
                knob.BorderSizePixel = 0
                knob.Parent = track
                EZ_AddRadius(knob, 6)
                local cap = Instance.new("TextButton")
                cap.Position = UDim2.fromOffset(12, 26)
                cap.Size = UDim2.new(1, -24, 0, 24)
                cap.BackgroundTransparency = 1
                cap.Text = ""
                cap.AutoButtonColor = false
                cap.Parent = row
                local function fmt(n)
                    if st >= 1 then return tostring(math.floor(n + 0.5)) end
                    return string.format("%.1f", n)
                end
                local function apply(raw, silent)
                    local v = EZ_Round(EZ_Clamp(raw, mn, mx), st)
                    obj.Value = v
                    local r = (mx - mn) == 0 and 0 or (v - mn) / (mx - mn)
                    fill.Size = UDim2.new(r, 0, 1, 0)
                    TweenService:Create(knob, TweenInfo.new(0.08), { Position = UDim2.new(r, 0, 0.5, 0) }):Play()
                    vl.Text = fmt(v)
                    if not silent then
                        cb(v)
                        if obj.Flag and EZ_AutoSave then
                            EZ_Window.ConfigData[id] = { type = "slider", value = v }
                            EZ_SaveConfig(EZ_ConfigId, EZ_Window.ConfigData)
                        end
                    end
                end
                local function fromPtr(x)
                    local w = track.AbsoluteSize.X
                    if w <= 0 then return obj.Value end
                    return mn + EZ_Clamp((x - track.AbsolutePosition.X) / w, 0, 1) * (mx - mn)
                end
                cap.InputBegan:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                        dragging = true; apply(fromPtr(i.Position.X), false)
                    end
                end)
                cap.InputEnded:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = false end
                end)
                UserInputService.InputChanged:Connect(function(i)
                    if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
                        apply(fromPtr(i.Position.X), false)
                    end
                end)
                function obj:Set(n, silent) apply(tonumber(n) or mn, silent) end
                apply(obj.Value, true)
                if obj.Flag then table.insert(EZ_Window.Elements, obj) end
                return obj
            end

            function tab:AddDropdown(o)
                o = o or {}
                local values = o.Values or o.Options or {}
                local cb = o.Callback or function() end
                local id = o.Flag or o.Id or o.Title or "dropdown_" .. os.clock()
                local obj = { Value = o.Default, Id = id, Flag = o.Flag, Type = "dropdown", Default = o.Default }
                local row = EZ_NewRow(page, 44)
                EZ_RowTitle(row, o.Title or "Dropdown", o.Description, 44)
                local vl = Instance.new("TextLabel")
                vl.AnchorPoint = Vector2.new(1, 0)
                vl.Position = UDim2.new(1, -36, 0, 0)
                vl.Size = UDim2.fromOffset(120, 44)
                vl.BackgroundTransparency = 1
                vl.Text = obj.Value and tostring(obj.Value) or "none"
                vl.Font = Enum.Font.Code; vl.TextSize = 12; vl.TextColor3 = EZ_Theme.TextDim
                vl.TextXAlignment = Enum.TextXAlignment.Right; vl.TextTruncate = Enum.TextTruncate.AtEnd
                vl.Parent = row
                local sign = Instance.new("TextLabel")
                sign.AnchorPoint = Vector2.new(1, 0)
                sign.Position = UDim2.new(1, -12, 0, 0)
                sign.Size = UDim2.fromOffset(14, 44)
                sign.BackgroundTransparency = 1
                sign.Text = "+"
                sign.Font = Enum.Font.Code; sign.TextSize = 14; sign.TextColor3 = EZ_Theme.TextDim
                sign.Parent = row
                local list = Instance.new("Frame")
                list.Position = UDim2.fromOffset(1, 44)
                list.Size = UDim2.new(1, -2, 0, 0)
                list.BackgroundColor3 = EZ_Theme.Background
                list.BorderSizePixel = 0
                list.ClipsDescendants = true
                list.Parent = row
                local llay = Instance.new("UIListLayout"); llay.Parent = list
                local open = false
                local function setOpen(s)
                    open = s
                    sign.Text = s and "-" or "+"
                    local h = s and (#values * 28) or 0
                    TweenService:Create(row, TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = UDim2.new(1, 0, 0, 44 + h) }):Play()
                    TweenService:Create(list, TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = UDim2.new(1, -2, 0, h) }):Play()
                end
                function obj:Set(v, silent)
                    obj.Value = v
                    vl.Text = tostring(v)
                    if not silent then
                        cb(v)
                        if obj.Flag and EZ_AutoSave then
                            EZ_Window.ConfigData[id] = { type = "dropdown", value = v }
                            EZ_SaveConfig(EZ_ConfigId, EZ_Window.ConfigData)
                        end
                    end
                end
                for _, v in ipairs(values) do
                    local op = Instance.new("TextButton")
                    op.Size = UDim2.new(1, 0, 0, 28)
                    op.BackgroundTransparency = 1
                    op.Text = tostring(v)
                    op.Font = Enum.Font.Gotham; op.TextSize = 12; op.TextColor3 = EZ_Theme.TextDim
                    op.TextXAlignment = Enum.TextXAlignment.Left
                    op.AutoButtonColor = false
                    op.Parent = list
                    local opp = Instance.new("UIPadding"); opp.PaddingLeft = UDim.new(0, 12); opp.Parent = op
                    op.MouseEnter:Connect(function() TweenService:Create(op, TweenInfo.new(0.1), { TextColor3 = EZ_Theme.Text }):Play() end)
                    op.MouseLeave:Connect(function() TweenService:Create(op, TweenInfo.new(0.1), { TextColor3 = EZ_Theme.TextDim }):Play() end)
                    op.MouseButton1Click:Connect(function() obj:Set(v, false); setOpen(false) end)
                end
                row.InputBegan:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 then
                        if i.Position.Y < row.AbsolutePosition.Y + 44 then setOpen(not open) end
                    end
                end)
                if obj.Flag then table.insert(EZ_Window.Elements, obj) end
                return obj
            end

            function tab:AddInput(o)
                o = o or {}
                local cb = o.Callback or function() end
                local id = o.Flag or o.Id or o.Title or "input_" .. os.clock()
                local obj = { Value = o.Default or "", Id = id, Flag = o.Flag, Type = "input", Default = o.Default or "" }
                local row = EZ_NewRow(page, 44)
                EZ_RowTitle(row, o.Title or "Input", o.Description, 44)
                local box = Instance.new("TextBox")
                box.Size = UDim2.fromOffset(160, 26)
                box.Position = UDim2.new(1, -172, 0.5, -13)
                box.BackgroundColor3 = EZ_Theme.Background
                box.BorderSizePixel = 0
                box.Text = obj.Value
                box.Font = Enum.Font.Code; box.TextSize = 12; box.TextColor3 = EZ_Theme.Text
                box.PlaceholderText = o.Placeholder or "..."
                box.PlaceholderColor3 = EZ_Theme.TextDim
                box.TextXAlignment = Enum.TextXAlignment.Left
                box.ClearTextOnFocus = false
                box.Parent = row
                local bst = EZ_AddStroke(box, EZ_Theme.Border); EZ_AddRadius(box, EZ_Theme.Radius)
                local bpad = Instance.new("UIPadding")
                bpad.PaddingLeft = UDim.new(0, 8); bpad.PaddingRight = UDim.new(0, 8); bpad.Parent = box
                box.Focused:Connect(function() bst.Color = EZ_Theme.Accent end)
                box.FocusLost:Connect(function()
                    bst.Color = EZ_Theme.Border
                    obj:Set(box.Text, false)
                end)
                function obj:Set(t, silent)
                    obj.Value = t or ""
                    box.Text = obj.Value
                    if not silent then
                        cb(obj.Value)
                        if obj.Flag and EZ_AutoSave then
                            EZ_Window.ConfigData[id] = { type = "input", value = t }
                            EZ_SaveConfig(EZ_ConfigId, EZ_Window.ConfigData)
                        end
                    end
                end
                if obj.Flag then table.insert(EZ_Window.Elements, obj) end
                return obj
            end

            function tab:AddTextArea(o)
                o = o or {}
                local cb = o.Callback or function() end
                local id = o.Flag or o.Id or o.Title or "textarea_" .. os.clock()
                local obj = { Value = o.Default or "", Id = id, Flag = o.Flag, Type = "textarea", Default = o.Default or "" }
                local row = Instance.new("Frame")
                row.Size = UDim2.new(1, 0, 0, 100)
                row.BackgroundColor3 = EZ_Theme.Card
                row.BackgroundTransparency = EZ_GlobalTransparency
                row.BorderSizePixel = 0
                row.Parent = page
                EZ_AddStroke(row, EZ_Theme.Border); EZ_AddRadius(row, EZ_Theme.Radius)
                EZ_RegBG(row)
                local tl = Instance.new("TextLabel")
                tl.Position = UDim2.fromOffset(12, 8)
                tl.Size = UDim2.new(1, -24, 0, 16)
                tl.BackgroundTransparency = 1
                tl.Text = o.Title or "Text Area"
                tl.Font = Enum.Font.Gotham; tl.TextSize = 13; tl.TextColor3 = EZ_Theme.Text
                tl.TextXAlignment = Enum.TextXAlignment.Left
                tl.Parent = row
                local box = Instance.new("TextBox")
                box.Size = UDim2.new(1, -24, 0, 68)
                box.Position = UDim2.fromOffset(12, 28)
                box.BackgroundColor3 = EZ_Theme.Background
                box.BorderSizePixel = 0
                box.Text = obj.Value
                box.Font = Enum.Font.Code; box.TextSize = 12; box.TextColor3 = EZ_Theme.Text
                box.PlaceholderText = o.Placeholder or "..."
                box.PlaceholderColor3 = EZ_Theme.TextDim
                box.TextXAlignment = Enum.TextXAlignment.Left
                box.TextYAlignment = Enum.TextYAlignment.Top
                box.TextWrapped = true
                box.ClearTextOnFocus = false
                box.Parent = row
                local bst = EZ_AddStroke(box, EZ_Theme.Border); EZ_AddRadius(box, EZ_Theme.Radius)
                local bpad = Instance.new("UIPadding")
                bpad.PaddingLeft = UDim.new(0, 8); bpad.PaddingRight = UDim.new(0, 8)
                bpad.PaddingTop = UDim.new(0, 8); bpad.PaddingBottom = UDim.new(0, 8); bpad.Parent = box
                box.Focused:Connect(function() bst.Color = EZ_Theme.Accent end)
                box.FocusLost:Connect(function()
                    bst.Color = EZ_Theme.Border
                    obj:Set(box.Text, false)
                end)
                function obj:Set(t, silent)
                    obj.Value = t or ""
                    box.Text = obj.Value
                    if not silent then
                        cb(obj.Value)
                        if obj.Flag and EZ_AutoSave then
                            EZ_Window.ConfigData[id] = { type = "textarea", value = t }
                            EZ_SaveConfig(EZ_ConfigId, EZ_Window.ConfigData)
                        end
                    end
                end
                if obj.Flag then table.insert(EZ_Window.Elements, obj) end
                return obj
            end

            function tab:AddProgressBar(o)
                o = o or {}
                local obj = { Value = o.Default or 0 }
                local row = EZ_NewRow(page, 50)
                local tl = Instance.new("TextLabel")
                tl.Position = UDim2.fromOffset(12, 10)
                tl.Size = UDim2.new(1, -80, 0, 16)
                tl.BackgroundTransparency = 1
                tl.Text = o.Title or "Progress"
                tl.Font = Enum.Font.Gotham; tl.TextSize = 13; tl.TextColor3 = EZ_Theme.Text
                tl.TextXAlignment = Enum.TextXAlignment.Left
                tl.Parent = row
                local vl = Instance.new("TextLabel")
                vl.AnchorPoint = Vector2.new(1, 0)
                vl.Position = UDim2.new(1, -12, 0, 10)
                vl.Size = UDim2.fromOffset(60, 16)
                vl.BackgroundTransparency = 1
                vl.Font = Enum.Font.Code; vl.TextSize = 12; vl.TextColor3 = EZ_Theme.TextDim
                vl.TextXAlignment = Enum.TextXAlignment.Right
                vl.Text = tostring(obj.Value) .. "%"
                vl.Parent = row
                local track = Instance.new("Frame")
                track.Position = UDim2.fromOffset(12, 32)
                track.Size = UDim2.new(1, -24, 0, 6)
                track.BackgroundColor3 = EZ_Theme.BorderHover
                track.BorderSizePixel = 0
                track.Parent = row
                EZ_AddRadius(track, 3)
                local fill = Instance.new("Frame")
                fill.Size = UDim2.new(obj.Value / 100, 0, 1, 0)
                fill.BackgroundColor3 = EZ_Theme.Accent
                fill.BorderSizePixel = 0
                fill.Parent = track
                EZ_AddRadius(fill, 3)
                function obj:Set(val)
                    obj.Value = EZ_Clamp(val, 0, 100)
                    TweenService:Create(fill, TweenInfo.new(0.15), { Size = UDim2.new(obj.Value / 100, 0, 1, 0) }):Play()
                    vl.Text = tostring(obj.Value) .. "%"
                end
                return obj
            end

            function tab:AddColorPicker(o)
                o = o or {}
                local cb = o.Callback or function() end
                local id = o.Flag or o.Id or o.Title or "color_" .. os.clock()
                local def = o.Default or Color3.fromRGB(255, 255, 255)
                local obj = { Value = def, Id = id, Flag = o.Flag, Type = "color", Default = def }
                local open = false
                local r, g, b = math.floor(def.R * 255), math.floor(def.G * 255), math.floor(def.B * 255)
                local row = EZ_NewRow(page, 44)
                EZ_RowTitle(row, o.Title or "Color", o.Description, 44)
                local sw = Instance.new("Frame")
                sw.Size = UDim2.fromOffset(26, 26)
                sw.Position = UDim2.new(1, -38, 0.5, -13)
                sw.BackgroundColor3 = obj.Value
                sw.BorderSizePixel = 0
                sw.Parent = row
                EZ_AddStroke(sw, EZ_Theme.Border); EZ_AddRadius(sw, EZ_Theme.Radius)
                local sign = Instance.new("TextLabel")
                sign.AnchorPoint = Vector2.new(1, 0)
                sign.Position = UDim2.new(1, -12, 0, 0)
                sign.Size = UDim2.fromOffset(14, 44)
                sign.BackgroundTransparency = 1
                sign.Text = "+"
                sign.Font = Enum.Font.Code; sign.TextSize = 14; sign.TextColor3 = EZ_Theme.TextDim
                sign.Parent = row
                local panel = Instance.new("Frame")
                panel.Position = UDim2.fromOffset(1, 44)
                panel.Size = UDim2.new(1, -2, 0, 0)
                panel.BackgroundColor3 = EZ_Theme.Background
                panel.BorderSizePixel = 0
                panel.ClipsDescendants = true
                panel.Parent = row
                local play2 = Instance.new("UIListLayout"); play2.Padding = UDim.new(0, 8); play2.Parent = panel
                local ppad2 = Instance.new("UIPadding")
                ppad2.PaddingTop = UDim.new(0, 10); ppad2.PaddingBottom = UDim.new(0, 10)
                ppad2.PaddingLeft = UDim.new(0, 12); ppad2.PaddingRight = UDim.new(0, 12); ppad2.Parent = panel
                local function update(silent)
                    obj.Value = Color3.fromRGB(r, g, b)
                    sw.BackgroundColor3 = obj.Value
                    if not silent then
                        cb(obj.Value)
                        if obj.Flag and EZ_AutoSave then
                            EZ_Window.ConfigData[id] = { type = "color", value = { r, g, b } }
                            EZ_SaveConfig(EZ_ConfigId, EZ_Window.ConfigData)
                        end
                    end
                end
                local function channel(letter, get, set)
                    local holder = Instance.new("Frame")
                    holder.Size = UDim2.new(1, 0, 0, 24)
                    holder.BackgroundTransparency = 1
                    holder.Parent = panel
                    local lab = Instance.new("TextLabel")
                    lab.Size = UDim2.fromOffset(14, 24)
                    lab.BackgroundTransparency = 1
                    lab.Text = letter
                    lab.Font = Enum.Font.Code; lab.TextSize = 12; lab.TextColor3 = EZ_Theme.TextDim
                    lab.TextXAlignment = Enum.TextXAlignment.Left
                    lab.Parent = holder
                    local track = Instance.new("Frame")
                    track.Position = UDim2.fromOffset(24, 10)
                    track.Size = UDim2.new(1, -70, 0, 4)
                    track.BackgroundColor3 = EZ_Theme.BorderHover
                    track.BorderSizePixel = 0
                    track.Parent = holder
                    EZ_AddRadius(track, 2)
                    local fill = Instance.new("Frame")
                    fill.Size = UDim2.new(get() / 255, 0, 1, 0)
                    fill.BackgroundColor3 = EZ_Theme.Accent
                    fill.BorderSizePixel = 0
                    fill.Parent = track
                    EZ_AddRadius(fill, 2)
                    local cvl = Instance.new("TextLabel")
                    cvl.AnchorPoint = Vector2.new(1, 0)
                    cvl.Position = UDim2.new(1, 0, 0, 4)
                    cvl.Size = UDim2.fromOffset(36, 16)
                    cvl.BackgroundTransparency = 1
                    cvl.Font = Enum.Font.Code; cvl.TextSize = 12; cvl.TextColor3 = EZ_Theme.TextDim
                    cvl.TextXAlignment = Enum.TextXAlignment.Right
                    cvl.Text = tostring(get())
                    cvl.Parent = holder
                    local cap = Instance.new("TextButton")
                    cap.Position = UDim2.fromOffset(24, 0)
                    cap.Size = UDim2.new(1, -70, 0, 24)
                    cap.BackgroundTransparency = 1
                    cap.Text = ""
                    cap.AutoButtonColor = false
                    cap.Parent = holder
                    local drag = false
                    local function apply(x)
                        local w = track.AbsoluteSize.X
                        if w <= 0 then return end
                        local v = math.floor(EZ_Clamp((x - track.AbsolutePosition.X) / w, 0, 1) * 255)
                        set(v)
                        fill.Size = UDim2.new(v / 255, 0, 1, 0)
                        cvl.Text = tostring(v)
                        update(false)
                    end
                    cap.InputBegan:Connect(function(i)
                        if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = true; apply(i.Position.X) end
                    end)
                    cap.InputEnded:Connect(function(i)
                        if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end
                    end)
                    UserInputService.InputChanged:Connect(function(i)
                        if drag and i.UserInputType == Enum.UserInputType.MouseMovement then apply(i.Position.X) end
                    end)
                end
                channel("R", function() return r end, function(v) r = v end)
                channel("G", function() return g end, function(v) g = v end)
                channel("B", function() return b end, function(v) b = v end)
                local function setOpen(s)
                    open = s
                    sign.Text = s and "-" or "+"
                    local h = s and 100 or 0
                    TweenService:Create(row, TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = UDim2.new(1, 0, 0, 44 + h) }):Play()
                    TweenService:Create(panel, TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = UDim2.new(1, -2, 0, h) }):Play()
                end
                row.InputBegan:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 then
                        if i.Position.Y < row.AbsolutePosition.Y + 44 then setOpen(not open) end
                    end
                end)
                function obj:Set(color, silent)
                    r = math.floor(color.R * 255); g = math.floor(color.G * 255); b = math.floor(color.B * 255)
                    update(silent)
                end
                if obj.Flag then table.insert(EZ_Window.Elements, obj) end
                return obj
            end

            function tab:AddKeybind(o)
                o = o or {}
                local cb = o.Callback or function() end
                local obj = { Value = o.Default, Id = o.Flag or o.Title }
                local listening = false
                local row = EZ_NewRow(page, 44)
                EZ_RowTitle(row, o.Title or "Keybind", o.Description, 44)
                local kl = Instance.new("TextLabel")
                kl.Position = UDim2.new(1, -72, 0.5, -12)
                kl.Size = UDim2.fromOffset(60, 24)
                kl.BackgroundColor3 = EZ_Theme.Background
                kl.BorderSizePixel = 0
                kl.Text = obj.Value and obj.Value.Name or "None"
                kl.Font = Enum.Font.Code
                kl.TextSize = 12
                kl.TextColor3 = EZ_Theme.TextDim
                kl.TextXAlignment = Enum.TextXAlignment.Center
                kl.Parent = row
                local klst = EZ_AddStroke(kl, EZ_Theme.Border)
                EZ_AddRadius(kl, EZ_Theme.Radius)
                UserInputService.InputBegan:Connect(function(input, processed)
                    if listening then
                        if input.UserInputType == Enum.UserInputType.Keyboard then
                            if input.KeyCode == Enum.KeyCode.Escape then
                                listening = false
                                kl.Text = obj.Value and obj.Value.Name or "None"
                                klst.Color = EZ_Theme.Border
                            else
                                obj.Value = input.KeyCode
                                listening = false
                                kl.Text = input.KeyCode.Name
                                klst.Color = EZ_Theme.Border
                                cb(input.KeyCode)
                            end
                        end
                        return
                    end
                    if obj.Value and input.KeyCode == obj.Value and not processed then
                        if not UserInputService:GetFocusedTextBox() then cb() end
                    end
                end)
                row.MouseEnter:Connect(function() if not listening then klst.Color = EZ_Theme.BorderHover end end)
                row.MouseLeave:Connect(function() if not listening then klst.Color = EZ_Theme.Border end end)
                row.InputBegan:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 then
                        listening = true
                        kl.Text = "..."
                        klst.Color = EZ_Theme.Accent
                    end
                end)
                function obj:Set(key)
                    obj.Value = key
                    kl.Text = key and key.Name or "None"
                end
                return obj
            end

            tab.CreateSection = tab.AddSection
            tab.CreateDivider = tab.AddDivider
            tab.CreateParagraph = tab.AddParagraph
            tab.CreateLabel = tab.AddLabel
            tab.CreateToggle = tab.AddToggle
            tab.CreateButton = tab.AddButton
            tab.CreateSlider = tab.AddSlider
            tab.CreateDropdown = tab.AddDropdown
            tab.CreateInput = tab.AddInput
            tab.CreateTextArea = tab.AddTextArea
            tab.CreateProgressBar = tab.AddProgressBar
            tab.CreateColorPicker = tab.AddColorPicker
            tab.CreateKeybind = tab.AddKeybind

            return tab
        end

        EZ_Window.CreateTab = EZ_Window.AddTab

        function EZ_Window:SetTransparency(t)
            EZ_GlobalTransparency = EZ_Clamp(t, 0, 0.9)
            for _, inst in ipairs(EZ_BGRegistry) do
                if inst.Parent then
                    inst.BackgroundTransparency = EZ_GlobalTransparency
                end
            end
        end

        function EZ_Window:SaveConfig()
            local data = {}
            for _, el in ipairs(EZ_Window.Elements) do
                if el.Flag then
                    if el.Type == "color" then
                        data[el.Id] = { type = "color", value = { math.floor(el.Value.R * 255), math.floor(el.Value.G * 255), math.floor(el.Value.B * 255) } }
                    else
                        data[el.Id] = { type = el.Type, value = el.Value }
                    end
                end
            end
            EZ_Window.ConfigData = data
            return EZ_SaveConfig(EZ_ConfigId, data)
        end

        function EZ_Window:LoadConfig()
            local data = EZ_LoadConfig(EZ_ConfigId)
            if not data then return false end
            for _, el in ipairs(EZ_Window.Elements) do
                local d = data[el.Id]
                if d then
                    if d.type == "color" then
                        el:Set(Color3.fromRGB(d.value[1], d.value[2], d.value[3]), true)
                    else
                        el:Set(d.value, true)
                    end
                end
            end
            return true
        end

        function EZ_Window:ResetConfig()
            EZ_DeleteConfig(EZ_ConfigId)
            EZ_Window.ConfigData = {}
            for _, el in ipairs(EZ_Window.Elements) do
                if el.Default ~= nil then
                    el:Set(el.Default, true)
                end
            end
            return true
        end

        function EZ_Window:BuildConfigSection(tab)
            tab:AddSection({ Title = "configuration" })
            tab:AddLabel("Config file: " .. EZ_ConfigId .. ".json")
            tab:AddToggle({
                Title = "Auto-Save",
                Description = "Save settings automatically when changed",
                Default = true,
                Callback = function(s) EZ_AutoSave = s end
            })
            tab:AddButton({
                Title = "Save Config Now",
                Description = "Force save current settings",
                Callback = function()
                    EZ_Window:SaveConfig()
                    EZ:Notify({ Title = "Config", Content = "Config saved.", Style = "Success", Duration = 2 })
                end
            })
            tab:AddButton({
                Title = "Reload Config",
                Description = "Load saved settings from file",
                Callback = function()
                    local ok = EZ_Window:LoadConfig()
                    EZ:Notify({ Title = "Config", Content = ok and "Config loaded." or "No config file found.", Style = ok and "Success" or "Warning", Duration = 2 })
                end
            })
            tab:AddButton({
                Title = "Reset Config",
                Description = "Delete file and restore defaults",
                Callback = function()
                    EZ_Window:ResetConfig()
                    EZ:Notify({ Title = "Config", Content = "Config reset to defaults.", Style = "Warning", Duration = 2 })
                end
            })
        end

        EZ_Window.Frame = frame
        EZ_Window.Titlebar = titlebar
        EZ_Window.Sidebar = sidebar
        EZ_Window.Content = content
        EZ_Window.SetMinimized = setMinimized

        local saved = EZ_LoadConfig(EZ_ConfigId)
        if saved then
            EZ_Window.ConfigData = saved
            for _, el in ipairs(EZ_Window.Elements) do
                local d = saved[el.Id]
                if d then
                    if d.type == "color" then
                        el:Set(Color3.fromRGB(d.value[1], d.value[2], d.value[3]), true)
                    else
                        el:Set(d.value, true)
                    end
                end
            end
        end

        return EZ_Window
    end

    return EZ_BuildWindow()
end

function EZ:Destroy()
    EZ_Gui:Destroy()
    EZ_NotifyGui:Destroy()
    if EZ_BlurRef then
        EZ_BlurRef:Destroy()
        EZ_BlurRef = nil
    end
    if getgenv then getgenv().EazyUI = nil end
end

function EZ:Logout()
    EZ_ClearKey()
    EZ:Notify({ Title = "Eazy UI", Content = "Logged out. Restart to re-enter key.", Style = "Info", Duration = 3 })
end

if getgenv then getgenv().EazyUI = EZ end

return EZ