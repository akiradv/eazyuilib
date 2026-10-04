--[[
    Eazy UI v0.9.18
    Open-source Roblox GUI library with minimal dependencies.
    Join our discord!: https://discord.gg/9VE4PXFDSg
]]

local EZ = {}
EZ.Version = "0.9.18"

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

local function EZ_C(r, g, b) return Color3.fromRGB(r, g, b) end

local EZ_Brand = {
    Font = Enum.Font.GothamBold,
    FontBody = Enum.Font.Gotham,
    FontMono = Enum.Font.Code,
}

local EZ_Themes = {
    Default = {
        Background = EZ_C(22, 22, 22),
        Card = EZ_C(29, 29, 29),
        CardHover = EZ_C(37, 37, 37),
        Border = EZ_C(46, 46, 46),
        BorderHover = EZ_C(72, 72, 72),
        TabActive = EZ_C(20, 40, 33),
        Text = EZ_C(238, 238, 238),
        TextDim = EZ_C(132, 132, 132),
        Accent = EZ_C(16, 185, 129),
        AccentDim = EZ_C(12, 139, 97),
        Success = EZ_C(16, 185, 129),
        Warning = EZ_C(245, 158, 11),
        Error = EZ_C(239, 68, 68),
        Info = EZ_C(59, 130, 246),
    },
    Pitch = {
        Background = EZ_C(10, 10, 10), Card = EZ_C(17, 17, 17), CardHover = EZ_C(24, 24, 24),
        Border = EZ_C(34, 34, 34), BorderHover = EZ_C(58, 58, 58), TabActive = EZ_C(17, 34, 28),
        Text = EZ_C(229, 229, 229), TextDim = EZ_C(102, 102, 102),
        Accent = EZ_C(16, 185, 129), AccentDim = EZ_C(12, 139, 97),
    },
    Light = {
        Background = EZ_C(244, 244, 244), Card = EZ_C(252, 252, 252), CardHover = EZ_C(236, 236, 236),
        Border = EZ_C(214, 214, 214), BorderHover = EZ_C(180, 180, 180), TabActive = EZ_C(214, 240, 231),
        Text = EZ_C(24, 24, 24), TextDim = EZ_C(112, 112, 112),
        Accent = EZ_C(12, 150, 105), AccentDim = EZ_C(9, 113, 79),
    },
    Ocean = {
        Background = EZ_C(13, 20, 26), Card = EZ_C(18, 28, 36), CardHover = EZ_C(24, 36, 46),
        Border = EZ_C(34, 48, 60), BorderHover = EZ_C(52, 72, 88), TabActive = EZ_C(16, 42, 54),
        Text = EZ_C(225, 235, 240), TextDim = EZ_C(112, 132, 142),
        Accent = EZ_C(56, 152, 199), AccentDim = EZ_C(42, 114, 149),
    },
    Sunset = {
        Background = EZ_C(24, 16, 20), Card = EZ_C(32, 22, 27), CardHover = EZ_C(40, 28, 34),
        Border = EZ_C(52, 38, 46), BorderHover = EZ_C(78, 56, 68), TabActive = EZ_C(52, 28, 36),
        Text = EZ_C(240, 228, 232), TextDim = EZ_C(142, 120, 130),
        Accent = EZ_C(244, 114, 140), AccentDim = EZ_C(183, 86, 105),
    },
    Mono = {
        Background = EZ_C(18, 18, 18), Card = EZ_C(26, 26, 26), CardHover = EZ_C(34, 34, 34),
        Border = EZ_C(48, 48, 48), BorderHover = EZ_C(72, 72, 72), TabActive = EZ_C(40, 40, 40),
        Text = EZ_C(238, 238, 238), TextDim = EZ_C(132, 132, 132),
        Accent = EZ_C(238, 238, 238), AccentDim = EZ_C(179, 179, 179),
    },
}

local EZ_Theme = {}
for k, v in pairs(EZ_Themes.Default) do EZ_Theme[k] = v end
EZ_Theme.Radius = 8
EZ_Theme.RadiusWindow = 12

local EZ_ThemeAliases = {
    default = "Default", padrao = "Default",
    pitch = "Pitch", escuro = "Pitch", dark = "Pitch",
    light = "Light", claro = "Light",
    ocean = "Ocean", oceano = "Ocean",
    sunset = "Sunset",
    mono = "Mono",
}

local EZ_CurrentThemeName = "Default"
local EZ_Painters = {}
local EZ_TransSurf = {}
local EZ_ThemeListeners = {}

local function EZ_Paint(fn)
    table.insert(EZ_Painters, fn)
    return fn
end

local function EZ_RegTrans(inst)
    table.insert(EZ_TransSurf, inst)
    return inst
end

local function EZ_OnThemeChange(fn)
    table.insert(EZ_ThemeListeners, fn)
    return fn
end

local function EZ_Repaint()
    for i = #EZ_Painters, 1, -1 do
        local ok = pcall(EZ_Painters[i])
        if not ok then table.remove(EZ_Painters, i) end
    end
end

local function EZ_ApplyThemeAndRepaint(name)
    local clean = tostring(name):lower():gsub("^%s+", ""):gsub("%s+$", "")
    local resolved = EZ_ThemeAliases[clean] or name
    local t = EZ_Themes[resolved] or EZ_Themes.Default
    EZ_CurrentThemeName = resolved
    for k, v in pairs(t) do EZ_Theme[k] = v end
    EZ_Theme.Radius = 8
    EZ_Theme.RadiusWindow = 12
    EZ_Repaint()
    for _, fn in ipairs(EZ_ThemeListeners) do
        pcall(fn, EZ_CurrentThemeName)
    end
end

function EZ:SetTheme(name)
    EZ_ApplyThemeAndRepaint(name)
end

function EZ:SetAccent(color)
    EZ_Theme.Accent = color
    local r, g, b = color.R * 255, color.G * 255, color.B * 255
    EZ_Theme.AccentDim = EZ_C(math.floor(r * 0.75), math.floor(g * 0.75), math.floor(b * 0.75))
    EZ_Repaint()
end

EZ.Compat = {
    files = (writefile and readfile and isfile) and true or false,
    folders = (makefolder and isfolder) and true or false,
    list = listfiles and true or false,
    hui = gethui and true or false,
    protect = protectgui and true or false,
    http = request and true or false,
    hooks = hookmetamethod and true or false,
}

-- =====================================================================
-- EZ_IconSets - WindUI-style icon system (Footagesus/Icons)
-- =====================================================================
local EZ_IconSets = {
    lucide = {
        house = "rbxassetid://98755624629571",
        star = "rbxassetid://136141469398409",
        users = "rbxassetid://115398113982385",
        user = "rbxassetid://81589895647169",
        shield = "rbxassetid://110987169760162",
        target = "rbxassetid://87563802520297",
        eye = "rbxassetid://100033680381365",
        ["eye-off"] = "rbxassetid://135928786788378",
        zap = "rbxassetid://130551565616516",
        settings = "rbxassetid://80758916183665",
        cog = "rbxassetid://116544501716299",
        key = "rbxassetid://96510194465420",
        globe = "rbxassetid://114238209622913",
        crosshair = "rbxassetid://134242818164054",
        ["chevron-down"] = "rbxassetid://134243273101015",
        ["chevron-up"] = "rbxassetid://122444883127455",
        ["chevron-right"] = "rbxassetid://92473583511724",
        ["chevron-left"] = "rbxassetid://73780377692148",
        plus = "rbxassetid://111774323017047",
        minus = "rbxassetid://118026365011536",
        x = "rbxassetid://110786993356448",
        check = "rbxassetid://93898873302694",
        heart = "rbxassetid://116559368303288",
        skull = "rbxassetid://137726256442333",
        ["biceps-flexed"] = "rbxassetid://82004462003936",
        mountain = "rbxassetid://73269957566415",
        ["tree-palm"] = "rbxassetid://103846705893963",
        ["circle-plus"] = "rbxassetid://113157136350384",
        command = "rbxassetid://93648221906330",
        palette = "rbxassetid://86350350950064",
        search = "rbxassetid://121018724060431",
        download = "rbxassetid://134814648082393",
        save = "rbxassetid://126116963775616",
        trash = "rbxassetid://106723740584310",
        edit = "rbxassetid://137986121120732",
        refresh = "rbxassetid://138133190015277",
        sliders = "rbxassetid://85538382643347",
        info = "rbxassetid://124560466474914",
        warning = "rbxassetid://125920361880643",
        error = "rbxassetid://114497774613488",
        success = "rbxassetid://103617236554419",
        power = "rbxassetid://96479131758775",
        menu = "rbxassetid://77021539815611",
        lock = "rbxassetid://134724289526879",
        unlock = "rbxassetid://93597915325122",
        bell = "rbxassetid://97392696311902",
        code = "rbxassetid://107380207681249",
        terminal = "rbxassetid://106783148545356",
        folder = "rbxassetid://80846616596607",
        bookmark = "rbxassetid://121093149326239",
        crown = "rbxassetid://127843403295538",
        trophy = "rbxassetid://131545003268773",
        gamepad = "rbxassetid://121607283959010",
        activity = "rbxassetid://94212016861936",
        box = "rbxassetid://101768155599700",
        circle = "rbxassetid://130359823580534",
        hash = "rbxassetid://82890331678520",
        layers = "rbxassetid://81973586053257",
        list = "rbxassetid://113179976918783",
        map = "rbxassetid://95107167260947",
        ["message-square"] = "rbxassetid://83881670383280",
        music = "rbxassetid://113343203848535",
        navigation = "rbxassetid://79308213542922",
        package = "rbxassetid://97261141732706",
        phone = "rbxassetid://128804946640049",
        ["chart-pie"] = "rbxassetid://113412261630136",
        printer = "rbxassetid://76080649734247",
        radio = "rbxassetid://85611589536956",
        rss = "rbxassetid://131789058984793",
        server = "rbxassetid://92188766517878",
        share = "rbxassetid://87340985053299",
        ["shopping-cart"] = "rbxassetid://128420521375441",
        signal = "rbxassetid://78424889355261",
        speaker = "rbxassetid://96227183003618",
        tablet = "rbxassetid://128403991264386",
        tag = "rbxassetid://129104970103940",
        thermometer = "rbxassetid://106546011492311",
        ["trending-up"] = "rbxassetid://81819858538839",
        truck = "rbxassetid://86662707764771",
        tv = "rbxassetid://135687724791776",
        umbrella = "rbxassetid://127502210274589",
        video = "rbxassetid://107587444636945",
        wifi = "rbxassetid://104669375183960",
        wind = "rbxassetid://114551690399915",
        wrench = "rbxassetid://112148279212860",
        ["arrow-up"] = "rbxassetid://89282378235317",
        ["arrow-down"] = "rbxassetid://98764963621439",
        ["arrow-left"] = "rbxassetid://102531941843733",
        ["arrow-right"] = "rbxassetid://113692007244654",
        ["circle-check"] = "rbxassetid://85262178816537",
        ["circle-x"] = "rbxassetid://76821953846248",
        ["circle-alert"] = "rbxassetid://83898160590116",
    },
    phosphor = {},
}

local function EZ_ResolveIcon(icon)
    if type(icon) == "string" then
        if icon:match("^rbxassetid://%d+$") then
            return icon
        end
        local set, name = icon:match("^(%w+):(.+)$")
        if set and name then
            local iconSet = EZ_IconSets[set:lower()]
            if iconSet and iconSet[name:lower()] then
                return iconSet[name:lower()]
            end
            return nil
        end
        local lucide = EZ_IconSets.lucide
        local lower = icon:lower()
        if lucide[lower] then
            return lucide[lower]
        end
        local withHyphens = lower:gsub(" ", "-")
        if lucide[withHyphens] then
            return lucide[withHyphens]
        end
        return nil
    elseif type(icon) == "number" then
        return "rbxassetid://" .. tostring(icon)
    end
    return nil
end

local function EZ_CreateIcon(parent, icon, size)
    local asset = EZ_ResolveIcon(icon)
    if not asset then
        local placeholder = Instance.new("Frame")
        placeholder.BackgroundColor3 = EZ_Theme.TextDim
        placeholder.BackgroundTransparency = 0.7
        placeholder.Size = UDim2.fromOffset(size or 16, size or 16)
        placeholder.Parent = parent
        EZ_AddRadius(placeholder, 3)
        return placeholder
    end
    
    local img = Instance.new("ImageLabel")
    img.BackgroundTransparency = 1
    img.Size = UDim2.fromOffset(size or 16, size or 16)
    img.Image = asset
    img.ScaleType = Enum.ScaleType.Fit
    img.Parent = parent
    return img
end

local EZ_TITLEBAR_HEIGHT = 44
local EZ_SIDEBAR_WIDTH = 180
local EZ_NOTIFY_WIDTH = 300
local EZ_ConfigFolder = "EazyUI_Configs"
local EZ_KeyFile = "eazyui_key.json"

local EZ_GlobalTransparency = 0
local EZ_AutoSave = true

local function EZ_RandName(base)
    return base .. "_" .. tostring(math.random(10000000, 99999999))
end

local function EZ_GuiParent()
    if gethui then return gethui() end
    return CoreGui
end

local function EZ_Hide(gui)
    if protectgui then pcall(function() protectgui(gui) end) end
end

local function EZ_Clamp(v, lo, hi) return math.clamp(v, lo, hi) end

local function EZ_Round(v, s)
    if s <= 0 then return v end
    return math.floor(v / s + 0.5) * s
end

local function EZ_Normalize(a, b)
    if type(a) == "string" then
        b = type(b) == "table" and b or {}
        b.Title = b.Title or a
        return b
    end
    return type(a) == "table" and a or {}
end

if getgenv and getgenv().EazyUI then
    pcall(function() getgenv().EazyUI:Destroy() end)
end

local EZ_Gui = Instance.new("ScreenGui")
EZ_Gui.Name = EZ_RandName("UI")
EZ_Gui.ResetOnSpawn = false
EZ_Gui.IgnoreGuiInset = true
EZ_Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
EZ_Gui.Parent = EZ_GuiParent()
EZ_Hide(EZ_Gui)

local EZ_NotifyGui = Instance.new("ScreenGui")
EZ_NotifyGui.Name = EZ_RandName("Notify")
EZ_NotifyGui.ResetOnSpawn = false
EZ_NotifyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
EZ_NotifyGui.DisplayOrder = 100
EZ_NotifyGui.Parent = EZ_GuiParent()
EZ_Hide(EZ_NotifyGui)

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
    local isTextObj = parent:IsA("TextBox") or parent:IsA("TextLabel") or parent:IsA("TextButton")
    s.ApplyStrokeMode = isTextObj and Enum.ApplyStrokeMode.Border or Enum.ApplyStrokeMode.Contextual
    s.Parent = parent
    EZ_Paint(function()
        if isTextObj and parent:IsA("TextBox") then
            if UserInputService:GetFocusedTextBox() ~= parent then
                s.Color = EZ_Theme.Border
            end
        else
            s.Color = EZ_Theme.Border
        end
    end)
    return s
end

local function EZ_AddRadius(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or EZ_Theme.Radius)
    c.Parent = parent
    return c
end

local EZ_DropdownPopup = Instance.new("Frame")
EZ_DropdownPopup.Name = "EZ_DropdownPopup"
EZ_DropdownPopup.BackgroundColor3 = EZ_Theme.Background
EZ_DropdownPopup.BorderSizePixel = 0
EZ_DropdownPopup.ClipsDescendants = true
EZ_DropdownPopup.Visible = false
EZ_DropdownPopup.ZIndex = 60
EZ_DropdownPopup.Parent = EZ_Gui
local EZ_DropdownStroke = EZ_AddStroke(EZ_DropdownPopup, EZ_Theme.Border)
EZ_AddRadius(EZ_DropdownPopup, EZ_Theme.Radius)
EZ_RegTrans(EZ_DropdownPopup)
EZ_Paint(function()
    EZ_DropdownPopup.BackgroundColor3 = EZ_Theme.Background
end)

local EZ_DropdownList = Instance.new("Frame")
EZ_DropdownList.Size = UDim2.new(1, 0, 1, 0)
EZ_DropdownList.BackgroundTransparency = 1
EZ_DropdownList.ClipsDescendants = true
EZ_DropdownList.ZIndex = 61
EZ_DropdownList.Parent = EZ_DropdownPopup

local EZ_DropdownLayout = Instance.new("UIListLayout")
EZ_DropdownLayout.Padding = UDim.new(0, 0)
EZ_DropdownLayout.Parent = EZ_DropdownList

local EZ_DropdownPad = Instance.new("UIPadding")
EZ_DropdownPad.PaddingTop = UDim.new(0, 4)
EZ_DropdownPad.PaddingBottom = UDim.new(0, 4)
EZ_DropdownPad.Parent = EZ_DropdownList

local EZ_DropdownCurrent = nil

local function EZ_CloseDropdown()
    if not EZ_DropdownCurrent then return end
    local prev = EZ_DropdownCurrent
    EZ_DropdownCurrent = nil
    if prev.sign and prev.sign.Parent then
        TweenService:Create(prev.sign, TweenInfo.new(0.2, Enum.EasingStyle.Quint), { Rotation = 0 }):Play()
    end
    local w = EZ_DropdownPopup.Size.X.Offset
    TweenService:Create(EZ_DropdownPopup, TweenInfo.new(0.15, Enum.EasingStyle.Quint), { Size = UDim2.fromOffset(w, 0) }):Play()
    task.delay(0.16, function()
        if not EZ_DropdownCurrent then EZ_DropdownPopup.Visible = false end
    end)
end

local function EZ_OpenDropdown(entry)
    if not entry or not entry.trigger or not entry.trigger.Parent then return end
    if EZ_DropdownCurrent == entry then
        EZ_CloseDropdown()
        return
    end
    if EZ_DropdownCurrent and EZ_DropdownCurrent.sign and EZ_DropdownCurrent.sign.Parent then
        TweenService:Create(EZ_DropdownCurrent.sign, TweenInfo.new(0.2, Enum.EasingStyle.Quint), { Rotation = 0 }):Play()
    end
    EZ_DropdownCurrent = entry
    for _, child in ipairs(EZ_DropdownList:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    local values = entry.getValues()
    for _, v in ipairs(values) do
        local op = Instance.new("TextButton")
        op.Size = UDim2.new(1, 0, 0, 30)
        op.BackgroundTransparency = 1
        op.Text = tostring(v)
        op.Font = EZ_Brand.FontBody
        op.TextSize = 12
        op.TextColor3 = (v == entry.getValue()) and EZ_Theme.Accent or EZ_Theme.TextDim
        op.TextXAlignment = Enum.TextXAlignment.Left
        op.AutoButtonColor = false
        op.ZIndex = 61
        op.Parent = EZ_DropdownList
        local opp = Instance.new("UIPadding")
        opp.PaddingLeft = UDim.new(0, 12)
        opp.Parent = op
        op.MouseEnter:Connect(function()
            TweenService:Create(op, TweenInfo.new(0.1), { TextColor3 = EZ_Theme.Text, BackgroundTransparency = 0, BackgroundColor3 = EZ_Theme.CardHover }):Play()
        end)
        op.MouseLeave:Connect(function()
            TweenService:Create(op, TweenInfo.new(0.1), { TextColor3 = (v == entry.getValue()) and EZ_Theme.Accent or EZ_Theme.TextDim, BackgroundTransparency = 1 }):Play()
        end)
        op.MouseButton1Click:Connect(function()
            entry.pick(v)
            EZ_CloseDropdown()
        end)
    end
    local popH = math.min(#values * 30 + 8, 220)
    local popW = entry.width or 150
    local trigPos = entry.trigger.AbsolutePosition
    local trigSize = entry.trigger.AbsoluteSize
    local guiPos = EZ_Gui.AbsolutePosition
    local winPos = entry.windowFrame.AbsolutePosition
    local winSize = entry.windowFrame.AbsoluteSize
    local winX = winPos.X - guiPos.X
    local winY = winPos.Y - guiPos.Y
    local x = trigPos.X - guiPos.X + trigSize.X - popW
    local y = trigPos.Y - guiPos.Y + trigSize.Y + 4
    if y + popH > winY + winSize.Y - 6 then
        y = trigPos.Y - guiPos.Y - popH - 4
    end
    x = EZ_Clamp(x, winX + 6, winX + winSize.X - popW - 6)
    y = EZ_Clamp(y, winY + 6, winY + winSize.Y - popH - 6)
    EZ_DropdownPopup.Position = UDim2.fromOffset(x, y)
    EZ_DropdownPopup.Visible = true
    EZ_DropdownPopup.Size = UDim2.fromOffset(popW, 0)
    if entry.sign then
        TweenService:Create(entry.sign, TweenInfo.new(0.2, Enum.EasingStyle.Quint), { Rotation = 180 }):Play()
    end
    TweenService:Create(EZ_DropdownPopup, TweenInfo.new(0.18, Enum.EasingStyle.Quint), { Size = UDim2.fromOffset(popW, popH) }):Play()
end

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if EZ_DropdownCurrent and input.UserInputType == Enum.UserInputType.MouseButton1 then
        local current = EZ_DropdownCurrent
        if not current.trigger or not current.trigger.Parent then
            EZ_DropdownCurrent = nil
            EZ_DropdownPopup.Visible = false
            return
        end
        local pos = input.Position
        local popPos = EZ_DropdownPopup.AbsolutePosition
        local popSize = EZ_DropdownPopup.AbsoluteSize
        local inPopup = pos.X >= popPos.X and pos.X <= popPos.X + popSize.X and pos.Y >= popPos.Y and pos.Y <= popPos.Y + popSize.Y
        local trigPos = current.trigger.AbsolutePosition
        local trigSize = current.trigger.AbsoluteSize
        local inTrig = pos.X >= trigPos.X and pos.X <= trigPos.X + trigSize.X and pos.Y >= trigPos.Y and pos.Y <= trigPos.Y + trigSize.Y
        if not inPopup and not inTrig then
            EZ_CloseDropdown()
        end
    end
end)

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
    EZ_RegTrans(row)
    local hovering = false
    EZ_Paint(function()
        row.BackgroundColor3 = hovering and EZ_Theme.CardHover or EZ_Theme.Card
        st.Color = hovering and EZ_Theme.BorderHover or EZ_Theme.Border
    end)
    row.MouseEnter:Connect(function()
        hovering = true
        TweenService:Create(st, TweenInfo.new(0.15), { Color = EZ_Theme.BorderHover }):Play()
        TweenService:Create(row, TweenInfo.new(0.15), { BackgroundColor3 = EZ_Theme.CardHover }):Play()
    end)
    row.MouseLeave:Connect(function()
        hovering = false
        TweenService:Create(st, TweenInfo.new(0.15), { Color = EZ_Theme.Border }):Play()
        TweenService:Create(row, TweenInfo.new(0.15), { BackgroundColor3 = EZ_Theme.Card }):Play()
    end)
    return row
end

local function EZ_RowTitle(row, text, desc, height, rightPad)
    local pad = rightPad or 130
    local l = Instance.new("TextLabel")
    l.Position = UDim2.fromOffset(12, desc and 8 or 0)
    l.Size = UDim2.new(1, -pad, 0, desc and 16 or (height or 44))
    l.BackgroundTransparency = 1
    l.Text = text
    l.Font = EZ_Brand.FontBody
    l.TextSize = 13
    l.TextColor3 = EZ_Theme.Text
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.TextTruncate = Enum.TextTruncate.AtEnd
    l.Parent = row
    EZ_Paint(function() l.TextColor3 = EZ_Theme.Text end)
    if desc and desc ~= "" then
        local d = Instance.new("TextLabel")
        d.Position = UDim2.fromOffset(12, 26)
        d.Size = UDim2.new(1, -pad, 0, 14)
        d.BackgroundTransparency = 1
        d.Text = desc
        d.Font = EZ_Brand.FontBody
        d.TextSize = 11
        d.TextColor3 = EZ_Theme.TextDim
        d.TextXAlignment = Enum.TextXAlignment.Left
        d.TextTruncate = Enum.TextTruncate.AtEnd
        d.Parent = row
        EZ_Paint(function() d.TextColor3 = EZ_Theme.TextDim end)
    end
    return l
end

local function EZ_SaveConfig(placeId, configName, data)
    if not writefile then return false end
    return pcall(function()
        if not isfolder(EZ_ConfigFolder) then makefolder(EZ_ConfigFolder) end
        writefile(EZ_ConfigFolder .. "/" .. tostring(placeId) .. "_" .. configName .. ".json", HttpService:JSONEncode(data))
    end)
end

local function EZ_LoadConfig(placeId, configName)
    if not readfile or not isfile then return nil end
    local ok, data = pcall(function()
        local p = EZ_ConfigFolder .. "/" .. tostring(placeId) .. "_" .. configName .. ".json"
        if isfile(p) then return HttpService:JSONDecode(readfile(p)) end
        return nil
    end)
    return ok and data or nil
end

local function EZ_DeleteConfig(placeId, configName)
    if not delfile or not isfile then return false end
    return pcall(function()
        local p = EZ_ConfigFolder .. "/" .. tostring(placeId) .. "_" .. configName .. ".json"
        if isfile(p) then delfile(p) end
    end)
end

local function EZ_ListConfigs(placeId)
    if not listfiles or not isfolder then return {} end
    local configs = {}
    local ok, files = pcall(function()
        if isfolder(EZ_ConfigFolder) then return listfiles(EZ_ConfigFolder) end
        return {}
    end)
    if not ok then return {} end
    local base = tostring(placeId) .. "_"
    for _, file in ipairs(files) do
        local name = file:match("([^/\\]+)$") or file
        if name:sub(1, #base) == base and name:sub(-5) == ".json" then
            table.insert(configs, name:sub(#base + 1, #name - 5))
        end
    end
    return configs
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
            if d.expiresAt and os.time() > d.expiresAt then EZ_ClearKey(filename) return nil end
            return d.key
        end
        return nil
    end)
    return ok and data or nil
end

local EZ_KeyDurationGlobal = 86400

local function EZ_ValidateKey(key, validator)
    if not key or key == "" then return false end
    if type(validator) == "function" then
        local success, result = pcall(validator, key)
        return success and result == true
    end
    return false
end

local function EZ_ShowLoadingScreen(title, subtitle, duration)
    local gui = Instance.new("ScreenGui")
    gui.Name = EZ_RandName("Loading")
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.DisplayOrder = 300
    gui.Parent = EZ_GuiParent()
    EZ_Hide(gui)
    local holder = Instance.new("Frame")
    holder.AnchorPoint = Vector2.new(0.5, 0.5)
    holder.Position = UDim2.new(0.5, 0, 0.5, 0)
    holder.Size = UDim2.fromOffset(420, 150)
    holder.BackgroundTransparency = 1
    holder.Parent = gui
    local lay = Instance.new("UIListLayout")
    lay.FillDirection = Enum.FillDirection.Vertical
    lay.HorizontalAlignment = Enum.HorizontalAlignment.Center
    lay.VerticalAlignment = Enum.VerticalAlignment.Center
    lay.Padding = UDim.new(0, 10)
    lay.Parent = holder
    local letter = Instance.new("TextLabel")
    letter.Size = UDim2.fromOffset(60, 60)
    letter.BackgroundTransparency = 1
    letter.Text = "E"
    letter.Font = EZ_Brand.Font
    letter.TextSize = 44
    letter.TextColor3 = EZ_Theme.Accent
    letter.TextTransparency = 1
    letter.Parent = holder
    EZ_Paint(function() letter.TextColor3 = EZ_Theme.Accent end)
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.fromOffset(420, 24)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title or "Loading"
    titleLabel.Font = EZ_Brand.Font
    titleLabel.TextSize = 17
    titleLabel.TextColor3 = EZ_Theme.Text
    titleLabel.TextXAlignment = Enum.TextXAlignment.Center
    titleLabel.TextTruncate = Enum.TextTruncate.AtEnd
    titleLabel.TextTransparency = 1
    titleLabel.Parent = holder
    EZ_Paint(function() titleLabel.TextColor3 = EZ_Theme.Text end)
    local subLabel = Instance.new("TextLabel")
    subLabel.Size = UDim2.fromOffset(420, 18)
    subLabel.BackgroundTransparency = 1
    subLabel.Text = subtitle or "Please wait..."
    subLabel.Font = EZ_Brand.FontBody
    subLabel.TextSize = 12
    subLabel.TextColor3 = EZ_Theme.TextDim
    subLabel.TextXAlignment = Enum.TextXAlignment.Center
    subLabel.TextTruncate = Enum.TextTruncate.AtEnd
    subLabel.TextTransparency = 1
    subLabel.Parent = holder
    EZ_Paint(function() subLabel.TextColor3 = EZ_Theme.TextDim end)
    local fadeInfo = TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    TweenService:Create(letter, fadeInfo, { TextTransparency = 0 }):Play()
    TweenService:Create(titleLabel, fadeInfo, { TextTransparency = 0 }):Play()
    TweenService:Create(subLabel, fadeInfo, { TextTransparency = 0 }):Play()
    task.wait(duration or 2)
    local outInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
    TweenService:Create(letter, outInfo, { TextTransparency = 1 }):Play()
    TweenService:Create(titleLabel, outInfo, { TextTransparency = 1 }):Play()
    TweenService:Create(subLabel, outInfo, { TextTransparency = 1 }):Play()
    task.wait(0.32)
    gui:Destroy()
end

local function EZ_ShowDiscordPrompt(invite, callback)
    local gui = Instance.new("ScreenGui")
    gui.Name = EZ_RandName("Discord")
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.DisplayOrder = 250
    gui.Parent = EZ_GuiParent()
    EZ_Hide(gui)
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.fromOffset(460, 280)
    frame.AnchorPoint = Vector2.new(0.5, 0.5)
    frame.Position = UDim2.new(0.5, 0, 0.5, 0)
    frame.BackgroundColor3 = EZ_Theme.Background
    frame.BorderSizePixel = 0
    frame.Parent = gui
    EZ_AddStroke(frame, EZ_Theme.Accent, 2)
    EZ_AddRadius(frame, EZ_Theme.RadiusWindow)
    EZ_RegTrans(frame)
    EZ_Paint(function() frame.BackgroundColor3 = EZ_Theme.Background end)
    
    local iconFrame = Instance.new("Frame")
    iconFrame.Size = UDim2.fromOffset(48, 48)
    iconFrame.Position = UDim2.new(0.5, -24, 0, 20)
    iconFrame.BackgroundColor3 = EZ_Theme.Accent
    iconFrame.BorderSizePixel = 0
    iconFrame.Parent = frame
    EZ_AddRadius(iconFrame, 12)
    EZ_Paint(function() iconFrame.BackgroundColor3 = EZ_Theme.Accent end)
    
    local iconLetter = Instance.new("TextLabel")
    iconLetter.Size = UDim2.new(1, 0, 1, 0)
    iconLetter.BackgroundTransparency = 1
    iconLetter.Text = "D"
    iconLetter.Font = EZ_Brand.Font
    iconLetter.TextSize = 28
    iconLetter.TextColor3 = EZ_Theme.Background
    iconLetter.Parent = iconFrame
    EZ_Paint(function() iconLetter.TextColor3 = EZ_Theme.Background end)
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -40, 0, 24)
    title.Position = UDim2.new(0.5, 0, 0, 80)
    title.AnchorPoint = Vector2.new(0.5, 0)
    title.BackgroundTransparency = 1
    title.Text = "Join our Discord"
    title.Font = EZ_Brand.Font
    title.TextSize = 18
    title.TextColor3 = EZ_Theme.Text
    title.TextXAlignment = Enum.TextXAlignment.Center
    title.Parent = frame
    EZ_Paint(function() title.TextColor3 = EZ_Theme.Text end)
    
    local sub = Instance.new("TextLabel")
    sub.Size = UDim2.new(1, -40, 0, 36)
    sub.Position = UDim2.new(0.5, 0, 0, 110)
    sub.AnchorPoint = Vector2.new(0.5, 0)
    sub.BackgroundTransparency = 1
    sub.Text = "Get updates, support and exclusive features.\nCopy the invite link below to join."
    sub.Font = EZ_Brand.FontBody
    sub.TextSize = 12
    sub.TextColor3 = EZ_Theme.TextDim
    sub.TextXAlignment = Enum.TextXAlignment.Center
    sub.TextWrapped = true
    sub.Parent = frame
    EZ_Paint(function() sub.TextColor3 = EZ_Theme.TextDim end)
    
    local inviteLabel = Instance.new("Frame")
    inviteLabel.Size = UDim2.new(1, -40, 0, 44)
    inviteLabel.Position = UDim2.new(0.5, 0, 0, 156)
    inviteLabel.AnchorPoint = Vector2.new(0.5, 0)
    inviteLabel.BackgroundColor3 = EZ_Theme.Card
    inviteLabel.BorderSizePixel = 0
    inviteLabel.Parent = frame
    EZ_AddStroke(inviteLabel, EZ_Theme.Border)
    EZ_AddRadius(inviteLabel, EZ_Theme.Radius)
    EZ_RegTrans(inviteLabel)
    EZ_Paint(function() inviteLabel.BackgroundColor3 = EZ_Theme.Card end)
    
    local inviteText = Instance.new("TextLabel")
    inviteText.Size = UDim2.new(1, -20, 1, 0)
    inviteText.BackgroundTransparency = 1
    inviteText.Text = "discord.gg/" .. invite
    inviteText.Font = EZ_Brand.FontMono
    inviteText.TextSize = 14
    inviteText.TextColor3 = EZ_Theme.Accent
    inviteText.TextXAlignment = Enum.TextXAlignment.Center
    inviteText.Parent = inviteLabel
    EZ_Paint(function() inviteText.TextColor3 = EZ_Theme.Accent end)
    
    local copyBtn = Instance.new("TextButton")
    copyBtn.Size = UDim2.new(0.48, 0, 0, 42)
    copyBtn.Position = UDim2.new(0.02, 0, 0, 216)
    copyBtn.BackgroundColor3 = EZ_Theme.Accent
    copyBtn.BorderSizePixel = 0
    copyBtn.Text = "Copy Link"
    copyBtn.Font = EZ_Brand.FontBody
    copyBtn.TextSize = 14
    copyBtn.TextColor3 = EZ_Theme.Background
    copyBtn.AutoButtonColor = false
    copyBtn.Parent = frame
    EZ_AddRadius(copyBtn, EZ_Theme.Radius)
    EZ_Paint(function() copyBtn.BackgroundColor3 = EZ_Theme.Accent; copyBtn.TextColor3 = EZ_Theme.Background end)
    
    local skipBtn = Instance.new("TextButton")
    skipBtn.Size = UDim2.new(0.48, 0, 0, 42)
    skipBtn.Position = UDim2.new(0.52, 0, 0, 216)
    skipBtn.BackgroundColor3 = EZ_Theme.CardHover
    skipBtn.BorderSizePixel = 0
    skipBtn.Text = "Skip"
    skipBtn.Font = EZ_Brand.FontBody
    skipBtn.TextSize = 14
    skipBtn.TextColor3 = EZ_Theme.TextDim
    skipBtn.AutoButtonColor = false
    skipBtn.Parent = frame
    local skipSt = EZ_AddStroke(skipBtn, EZ_Theme.Border)
    EZ_AddRadius(skipBtn, EZ_Theme.Radius)
    EZ_Paint(function() skipBtn.BackgroundColor3 = EZ_Theme.CardHover; skipBtn.TextColor3 = EZ_Theme.TextDim end)
    
    skipBtn.MouseEnter:Connect(function() TweenService:Create(skipSt, TweenInfo.new(0.12), { Color = EZ_Theme.Accent }):Play() end)
    skipBtn.MouseLeave:Connect(function() TweenService:Create(skipSt, TweenInfo.new(0.12), { Color = EZ_Theme.Border }):Play() end)
    
    copyBtn.MouseButton1Click:Connect(function()
        local link = "https://discord.gg/" .. invite
        local copied = false
        if setclipboard then
            setclipboard(link)
            copied = true
        elseif toclipboard then
            toclipboard(link)
            copied = true
        end
        if copied then
            copyBtn.Text = "Copied!"
            task.delay(1.5, function()
                if copyBtn.Parent then copyBtn.Text = "Copy Link" end
            end)
        else
            copyBtn.Text = link
            task.delay(3, function()
                if copyBtn.Parent then copyBtn.Text = "Copy Link" end
            end)
        end
        gui:Destroy()
        callback(true)
    end)
    
    skipBtn.MouseButton1Click:Connect(function() gui:Destroy(); callback(false) end)
end

local function EZ_ShowKeyScreen(options, validator, callback)
    local gui = Instance.new("ScreenGui")
    gui.Name = EZ_RandName("Key")
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.DisplayOrder = 200
    gui.Parent = EZ_GuiParent()
    EZ_Hide(gui)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.fromOffset(420, 270)
    frame.AnchorPoint = Vector2.new(0.5, 0.5)
    frame.Position = UDim2.new(0.5, 0, 0.5, 0)
    frame.BackgroundColor3 = EZ_Theme.Background
    frame.BorderSizePixel = 0
    frame.Parent = gui
    EZ_AddStroke(frame, EZ_Theme.Border)
    EZ_AddRadius(frame, EZ_Theme.RadiusWindow)
    EZ_RegTrans(frame)
    EZ_Paint(function() frame.BackgroundColor3 = EZ_Theme.Background end)
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -20, 0, 24)
    title.Position = UDim2.fromOffset(14, 16)
    title.BackgroundTransparency = 1
    title.Text = options.Title or "Enter Key"
    title.Font = EZ_Brand.Font
    title.TextSize = 14
    title.TextColor3 = EZ_Theme.Text
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = frame
    EZ_Paint(function() title.TextColor3 = EZ_Theme.Text end)
    local sub = Instance.new("TextLabel")
    sub.Size = UDim2.new(1, -20, 0, 16)
    sub.Position = UDim2.fromOffset(14, 44)
    sub.BackgroundTransparency = 1
    sub.Text = options.Subtitle or "Enter your access key to continue"
    sub.Font = EZ_Brand.FontBody
    sub.TextSize = 12
    sub.TextColor3 = EZ_Theme.TextDim
    sub.TextXAlignment = Enum.TextXAlignment.Left
    sub.Parent = frame
    EZ_Paint(function() sub.TextColor3 = EZ_Theme.TextDim end)
    local input = Instance.new("TextBox")
    input.Size = UDim2.new(1, -28, 0, 36)
    input.Position = UDim2.fromOffset(14, 76)
    input.BackgroundColor3 = EZ_Theme.Card
    input.BorderSizePixel = 0
    input.Text = ""
    input.PlaceholderText = "Enter key here..."
    input.Font = EZ_Brand.FontMono
    input.TextSize = 13
    input.TextColor3 = EZ_Theme.Text
    input.PlaceholderColor3 = EZ_Theme.TextDim
    input.TextXAlignment = Enum.TextXAlignment.Left
    input.ClearTextOnFocus = false
    input.Parent = frame
    local ist = EZ_AddStroke(input, EZ_Theme.Border)
    EZ_AddRadius(input, EZ_Theme.Radius)
    EZ_RegTrans(input)
    EZ_Paint(function() input.BackgroundColor3 = EZ_Theme.Card; input.TextColor3 = EZ_Theme.Text; input.PlaceholderColor3 = EZ_Theme.TextDim end)
    local ip = Instance.new("UIPadding")
    ip.PaddingLeft = UDim.new(0, 12); ip.PaddingRight = UDim.new(0, 12); ip.Parent = input
    input.Focused:Connect(function() ist.Color = EZ_Theme.Accent end)
    input.FocusLost:Connect(function() ist.Color = EZ_Theme.Border end)
    local note = Instance.new("TextLabel")
    note.Size = UDim2.new(1, -28, 0, 16)
    note.Position = UDim2.fromOffset(14, 118)
    note.BackgroundTransparency = 1
    note.Text = options.Note or ""
    note.Font = EZ_Brand.FontBody
    note.TextSize = 11
    note.TextColor3 = EZ_Theme.TextDim
    note.TextXAlignment = Enum.TextXAlignment.Left
    note.Parent = frame
    EZ_Paint(function() note.TextColor3 = EZ_Theme.TextDim end)
    local submit = Instance.new("TextButton")
    submit.Size = UDim2.new(0.48, 0, 0, 38)
    submit.Position = UDim2.new(0.03, 0, 0, 155)
    submit.BackgroundColor3 = EZ_Theme.Accent
    submit.BorderSizePixel = 0
    submit.Text = "Submit"
    submit.Font = EZ_Brand.FontBody
    submit.TextSize = 13
    submit.TextColor3 = EZ_Theme.Background
    submit.AutoButtonColor = false
    submit.Parent = frame
    EZ_AddRadius(submit, EZ_Theme.Radius)
    EZ_Paint(function() submit.BackgroundColor3 = EZ_Theme.Accent; submit.TextColor3 = EZ_Theme.Background end)
    local cancel = Instance.new("TextButton")
    cancel.Size = UDim2.new(0.48, 0, 0, 38)
    cancel.Position = UDim2.new(0.52, 0, 0, 155)
    cancel.BackgroundColor3 = EZ_Theme.CardHover
    cancel.BorderSizePixel = 0
    cancel.Text = "Cancel"
    cancel.Font = EZ_Brand.FontBody
    cancel.TextSize = 13
    cancel.TextColor3 = EZ_Theme.TextDim
    cancel.AutoButtonColor = false
    cancel.Parent = frame
    local cst = EZ_AddStroke(cancel, EZ_Theme.Border)
    EZ_AddRadius(cancel, EZ_Theme.Radius)
    EZ_Paint(function() cancel.BackgroundColor3 = EZ_Theme.CardHover; cancel.TextColor3 = EZ_Theme.TextDim end)
    cancel.MouseEnter:Connect(function() TweenService:Create(cst, TweenInfo.new(0.12), { Color = EZ_Theme.Accent }):Play() end)
    cancel.MouseLeave:Connect(function() TweenService:Create(cst, TweenInfo.new(0.12), { Color = EZ_Theme.Border }):Play() end)
    local err = Instance.new("TextLabel")
    err.Size = UDim2.new(1, -28, 0, 18)
    err.Position = UDim2.fromOffset(14, 205)
    err.BackgroundTransparency = 1
    err.Text = ""
    err.Font = EZ_Brand.FontBody
    err.TextSize = 11
    err.TextColor3 = EZ_Theme.Error
    err.TextXAlignment = Enum.TextXAlignment.Left
    err.Parent = frame
    local function doSubmit()
        local key = input.Text
        err.Text = "Validating..."
        err.TextColor3 = EZ_Theme.TextDim
        task.spawn(function()
            if EZ_ValidateKey(key, validator) then
                EZ_SaveKey(key, EZ_KeyDurationGlobal, options.FileName)
                gui:Destroy()
                callback(true, key)
            else
                err.Text = "Invalid key. Please try again."
                err.TextColor3 = EZ_Theme.Error
                input.Text = ""
            end
        end)
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
    local height = hasButtons and 92 or 66
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
    EZ_AddStroke(card, EZ_Theme.Border)
    EZ_AddRadius(card, EZ_Theme.Radius)
    EZ_RegTrans(card)
    EZ_Paint(function() card.BackgroundColor3 = EZ_Theme.Card end)
    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(0, 3, 1, -16)
    bar.Position = UDim2.fromOffset(8, 8)
    bar.BackgroundColor3 = styleColor
    bar.BorderSizePixel = 0
    bar.Parent = card
    EZ_AddRadius(bar, 2)
    local tl = Instance.new("TextLabel")
    tl.Position = UDim2.fromOffset(18, 10)
    tl.Size = UDim2.new(1, -28, 0, 16)
    tl.BackgroundTransparency = 1
    tl.Text = t
    tl.Font = EZ_Brand.FontBody
    tl.TextSize = 13
    tl.TextColor3 = EZ_Theme.Text
    tl.TextXAlignment = Enum.TextXAlignment.Left
    tl.TextTruncate = Enum.TextTruncate.AtEnd
    tl.Parent = card
    EZ_Paint(function() tl.TextColor3 = EZ_Theme.Text end)
    local cl = Instance.new("TextLabel")
    cl.Position = UDim2.fromOffset(18, 28)
    cl.Size = UDim2.new(1, -28, 0, 28)
    cl.BackgroundTransparency = 1
    cl.Text = c
    cl.Font = EZ_Brand.FontBody
    cl.TextSize = 12
    cl.TextColor3 = EZ_Theme.TextDim
    cl.TextXAlignment = Enum.TextXAlignment.Left
    cl.TextYAlignment = Enum.TextYAlignment.Top
    cl.TextWrapped = true
    cl.Parent = card
    EZ_Paint(function() cl.TextColor3 = EZ_Theme.TextDim end)
    if hasButtons then
        local btnRow = Instance.new("Frame")
        btnRow.Size = UDim2.new(1, -28, 0, 26)
        btnRow.Position = UDim2.fromOffset(18, 58)
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
            btn.Font = EZ_Brand.FontBody
            btn.TextSize = 11
            btn.TextColor3 = EZ_Theme.Text
            btn.AutoButtonColor = false
            btn.Parent = btnRow
            local bst = EZ_AddStroke(btn, EZ_Theme.Border)
            EZ_AddRadius(btn, 4)
            EZ_Paint(function() btn.BackgroundColor3 = EZ_Theme.Background; btn.TextColor3 = EZ_Theme.Text end)
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
    TweenService:Create(holder, TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { Size = UDim2.fromOffset(EZ_NOTIFY_WIDTH, height) }):Play()
    if d > 0 then
        task.delay(d, function()
            if not holder.Parent then return end
            TweenService:Create(holder, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.In), { Size = UDim2.fromOffset(0, height) }):Play()
            task.wait(0.22)
            holder:Destroy()
            if onClose then onClose("Timeout") end
        end)
    end
end

function EZ:CreateWindow(options)
    options = options or {}
    local EZ_Name = options.Name or "Eazy UI"
    local EZ_SubTitle = options.SubTitle or ""
    local EZ_Size = options.Size or UDim2.fromOffset(620, 440)
    local EZ_MinKey = options.MinimizeKey or Enum.KeyCode.RightControl
    local EZ_ConfigId = options.ConfigId or tostring(game.PlaceId)
    EZ_KeyDurationGlobal = options.KeyDuration or 86400
    EZ_GlobalTransparency = EZ_Clamp(options.Transparency or 0, 0, 0.9)
    local EZ_AutoLoad = options.AutoLoad ~= false

    if options.LoadingTitle then
        EZ_ShowLoadingScreen(options.LoadingTitle, options.LoadingSubtitle or "", options.LoadingDuration or 2)
    end
    if options.Discord and options.Discord.Enabled then
        local resolved = false
        EZ_ShowDiscordPrompt(options.Discord.Invite, function() resolved = true end)
        while not resolved do task.wait(0.1) end
    end
    if options.KeySystem and options.KeySystem.Enabled then
        local keyOptions = { Title = options.KeySystem.Title, Subtitle = options.KeySystem.Subtitle, Note = options.KeySystem.Note, FileName = options.KeySystem.FileName }
        local savedKey = EZ_LoadKey(options.KeySystem.FileName)
        if not (savedKey and EZ_ValidateKey(savedKey, options.KeySystem.validator)) then
            local resolved, success = false, false
            EZ_ShowKeyScreen(keyOptions, options.KeySystem.validator, function(s) success = s; resolved = true end)
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
    EZ_Window.CurrentConfig = "default"

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
        EZ_AddStroke(frame, EZ_Theme.Border)
        EZ_AddRadius(frame, EZ_Theme.RadiusWindow)
        EZ_RegTrans(frame)
        EZ_Paint(function() frame.BackgroundColor3 = EZ_Theme.Background end)
        TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Size = EZ_Size, Position = UDim2.new(0.5, -EZ_Size.X.Offset / 2, 0.5, -EZ_Size.Y.Offset / 2)
        }):Play()

        local titlebar = Instance.new("Frame")
        titlebar.Size = UDim2.new(1, 0, 0, EZ_TITLEBAR_HEIGHT)
        titlebar.BackgroundColor3 = EZ_Theme.Card
        titlebar.BackgroundTransparency = EZ_GlobalTransparency
        titlebar.BorderSizePixel = 0
        titlebar.Parent = frame
        EZ_AddRadius(titlebar, EZ_Theme.RadiusWindow)
        EZ_RegTrans(titlebar)
        EZ_Paint(function() titlebar.BackgroundColor3 = EZ_Theme.Card end)

        local tbFill = Instance.new("Frame")
        tbFill.Size = UDim2.new(1, 0, 0, EZ_Theme.RadiusWindow)
        tbFill.Position = UDim2.new(0, 0, 1, -EZ_Theme.RadiusWindow)
        tbFill.BackgroundColor3 = EZ_Theme.Card
        tbFill.BackgroundTransparency = EZ_GlobalTransparency
        tbFill.BorderSizePixel = 0
        tbFill.Parent = titlebar
        EZ_RegTrans(tbFill)
        EZ_Paint(function() tbFill.BackgroundColor3 = EZ_Theme.Card end)

        local tline = Instance.new("Frame")
        tline.Size = UDim2.new(1, 0, 0, 1)
        tline.Position = UDim2.new(0, 0, 1, -1)
        tline.BackgroundColor3 = EZ_Theme.Border
        tline.BorderSizePixel = 0
        tline.Parent = titlebar
        EZ_Paint(function() tline.BackgroundColor3 = EZ_Theme.Border end)

        local logoLetter = Instance.new("TextLabel")
        logoLetter.Size = UDim2.fromOffset(26, 26)
        logoLetter.Position = UDim2.new(0, 14, 0.5, -13)
        logoLetter.BackgroundTransparency = 1
        logoLetter.Text = "E"
        logoLetter.Font = EZ_Brand.Font
        logoLetter.TextSize = 15
        logoLetter.TextColor3 = EZ_Theme.Accent
        logoLetter.TextXAlignment = Enum.TextXAlignment.Center
        logoLetter.Parent = titlebar
        EZ_Paint(function() logoLetter.TextColor3 = EZ_Theme.Accent end)

        local tholder = Instance.new("Frame")
        tholder.BackgroundTransparency = 1
        tholder.Size = UDim2.new(1, -120, 1, 0)
        tholder.Position = UDim2.fromOffset(48, 0)
        tholder.Parent = titlebar
        local tlay = Instance.new("UIListLayout")
        tlay.FillDirection = Enum.FillDirection.Horizontal
        tlay.VerticalAlignment = Enum.VerticalAlignment.Center
        tlay.Padding = UDim.new(0, 6)
        tlay.Parent = tholder

        local tlabel = Instance.new("TextLabel")
        tlabel.BackgroundTransparency = 1
        tlabel.Size = UDim2.fromOffset(0, 20)
        tlabel.AutomaticSize = Enum.AutomaticSize.X
        tlabel.Text = EZ_Name
        tlabel.Font = EZ_Brand.Font
        tlabel.TextSize = 14
        tlabel.TextColor3 = EZ_Theme.Text
        tlabel.Parent = tholder
        EZ_Paint(function() tlabel.TextColor3 = EZ_Theme.Text end)

        local tdiv = Instance.new("TextLabel")
        tdiv.BackgroundTransparency = 1
        tdiv.Size = UDim2.fromOffset(8, 20)
        tdiv.Text = "·"
        tdiv.Font = EZ_Brand.FontBody
        tdiv.TextSize = 14
        tdiv.TextColor3 = EZ_Theme.TextDim
        tdiv.Parent = tholder
        EZ_Paint(function() tdiv.TextColor3 = EZ_Theme.TextDim end)

        local slabel = Instance.new("TextLabel")
        slabel.BackgroundTransparency = 1
        slabel.Size = UDim2.fromOffset(0, 18)
        slabel.AutomaticSize = Enum.AutomaticSize.X
        slabel.Text = EZ_SubTitle
        slabel.Font = EZ_Brand.FontBody
        slabel.TextSize = 12
        slabel.TextColor3 = EZ_Theme.TextDim
        slabel.Parent = tholder
        EZ_Paint(function() slabel.TextColor3 = EZ_Theme.TextDim end)

        local minbtn = Instance.new("TextButton")
        minbtn.Size = UDim2.fromOffset(28, 28)
        minbtn.Position = UDim2.new(1, -38, 0.5, -14)
        minbtn.BackgroundColor3 = EZ_Theme.CardHover
        minbtn.BackgroundTransparency = 1
        minbtn.Text = ""
        minbtn.AutoButtonColor = false
        minbtn.Parent = titlebar
        EZ_AddRadius(minbtn, 6)
        local minicon = Instance.new("Frame")
        minicon.Size = UDim2.fromOffset(12, 2)
        minicon.Position = UDim2.new(0.5, -6, 0.5, -1)
        minicon.BackgroundColor3 = EZ_Theme.TextDim
        minicon.BorderSizePixel = 0
        minicon.Parent = minbtn
        EZ_AddRadius(minicon, 1)
        EZ_Paint(function() minicon.BackgroundColor3 = EZ_Theme.TextDim end)

        local sidebar = Instance.new("Frame")
        sidebar.Size = UDim2.new(0, EZ_SIDEBAR_WIDTH, 1, -EZ_TITLEBAR_HEIGHT)
        sidebar.Position = UDim2.new(0, 0, 0, EZ_TITLEBAR_HEIGHT)
        sidebar.BackgroundColor3 = EZ_Theme.Card
        sidebar.BackgroundTransparency = EZ_GlobalTransparency
        sidebar.BorderSizePixel = 0
        sidebar.ClipsDescendants = true
        sidebar.Parent = frame
        EZ_AddRadius(sidebar, EZ_Theme.RadiusWindow)
        EZ_RegTrans(sidebar)
        EZ_Paint(function() sidebar.BackgroundColor3 = EZ_Theme.Card end)

        local sbFillTop = Instance.new("Frame")
        sbFillTop.Size = UDim2.new(1, 0, 0, EZ_Theme.RadiusWindow)
        sbFillTop.Position = UDim2.new(0, 0, 0, 0)
        sbFillTop.BackgroundColor3 = EZ_Theme.Card
        sbFillTop.BackgroundTransparency = EZ_GlobalTransparency
        sbFillTop.BorderSizePixel = 0
        sbFillTop.ZIndex = 10
        sbFillTop.Parent = sidebar
        EZ_RegTrans(sbFillTop)
        EZ_Paint(function() sbFillTop.BackgroundColor3 = EZ_Theme.Card end)

        local sbFillRight = Instance.new("Frame")
        sbFillRight.Size = UDim2.new(0, EZ_Theme.RadiusWindow, 1, 0)
        sbFillRight.Position = UDim2.new(1, -EZ_Theme.RadiusWindow, 0, 0)
        sbFillRight.BackgroundColor3 = EZ_Theme.Card
        sbFillRight.BackgroundTransparency = EZ_GlobalTransparency
        sbFillRight.BorderSizePixel = 0
        sbFillRight.ZIndex = 10
        sbFillRight.Parent = sidebar
        EZ_RegTrans(sbFillRight)
        EZ_Paint(function() sbFillRight.BackgroundColor3 = EZ_Theme.Card end)

        local tabsContainer = Instance.new("Frame")
        tabsContainer.Size = UDim2.new(1, -EZ_Theme.RadiusWindow, 1, 0)
        tabsContainer.Position = UDim2.new(0, 0, 0, 0)
        tabsContainer.BackgroundTransparency = 1
        tabsContainer.ClipsDescendants = true
        tabsContainer.Parent = sidebar

        local slay = Instance.new("UIListLayout")
        slay.Padding = UDim.new(0, 2)
        slay.Parent = tabsContainer

        local spad = Instance.new("UIPadding")
        spad.PaddingTop = UDim.new(0, 10)
        spad.PaddingBottom = UDim.new(0, 10)
        spad.PaddingLeft = UDim.new(0, 8)
        spad.PaddingRight = UDim.new(0, 8)
        spad.Parent = tabsContainer

        local sline = Instance.new("Frame")
        sline.Size = UDim2.new(0, 1, 1, -EZ_TITLEBAR_HEIGHT)
        sline.Position = UDim2.new(0, EZ_SIDEBAR_WIDTH - 1, 0, EZ_TITLEBAR_HEIGHT)
        sline.BackgroundColor3 = EZ_Theme.Border
        sline.BorderSizePixel = 0
        sline.Parent = frame
        EZ_Paint(function() sline.BackgroundColor3 = EZ_Theme.Border end)

        local content = Instance.new("Frame")
        content.Position = UDim2.new(0, EZ_SIDEBAR_WIDTH, 0, EZ_TITLEBAR_HEIGHT)
        content.Size = UDim2.new(1, -EZ_SIDEBAR_WIDTH, 1, -EZ_TITLEBAR_HEIGHT)
        content.BackgroundTransparency = 1
        content.ClipsDescendants = true
        content.Parent = frame

        local wm = Instance.new("TextLabel")
        wm.AnchorPoint = Vector2.new(1, 1)
        wm.Position = UDim2.new(1, -10, 1, -8)
        wm.Size = UDim2.fromOffset(160, 14)
        wm.BackgroundTransparency = 1
        wm.Text = "eazy ui · v" .. EZ.Version
        wm.Font = EZ_Brand.FontMono
        wm.TextSize = 10
        wm.TextColor3 = EZ_Theme.TextDim
        wm.TextXAlignment = Enum.TextXAlignment.Right
        wm.Parent = frame
        EZ_Paint(function() wm.TextColor3 = EZ_Theme.TextDim end)

        local registry = {}
        local activeData = nil

        local function selectTab(target)
            EZ_CloseDropdown()
            activeData = target
            for _, d in ipairs(registry) do
                d.Active = (d == target)
                d.Page.Visible = d.Active
                TweenService:Create(d.Button, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                    BackgroundTransparency = d.Active and 0 or 1
                }):Play()
                TweenService:Create(d.Label, TweenInfo.new(0.15), {
                    TextColor3 = d.Active and EZ_Theme.Text or EZ_Theme.TextDim
                }):Play()
                if d.Icon then
                    TweenService:Create(d.Icon, TweenInfo.new(0.15), {
                        ImageColor3 = d.Active and EZ_Theme.Accent or EZ_Theme.TextDim
                    }):Play()
                end
                TweenService:Create(d.Indicator, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                    Size = d.Active and UDim2.new(0, 3, 0, 20) or UDim2.new(0, 0, 0, 0)
                }):Play()
            end
        end

        local function setMinimized(state)
            if not frame.Parent then return end
            EZ_CloseDropdown()
            if state then
                local focused = UserInputService:GetFocusedTextBox()
                if focused then focused:ReleaseFocus() end
            end
            EZ_Window.Minimized = state
            frame.Visible = not state
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
            local tabIcon = opt.Icon
            local data = {}
            local tab = {}

            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 36)
            btn.BackgroundColor3 = EZ_Theme.TabActive
            btn.BackgroundTransparency = 1
            btn.Text = ""
            btn.AutoButtonColor = false
            btn.Parent = tabsContainer
            EZ_AddRadius(btn, 6)

            local indicator = Instance.new("Frame")
            indicator.Position = UDim2.fromOffset(4, 8)
            indicator.Size = UDim2.new(0, 0, 0, 0)
            indicator.BackgroundColor3 = EZ_Theme.Accent
            indicator.BorderSizePixel = 0
            indicator.Parent = btn
            EZ_AddRadius(indicator, 2)

            local iconLbl = nil
            local iconOffset = 14
            if tabIcon then
                iconLbl = EZ_CreateIcon(btn, tabIcon, 16)
                if iconLbl then
                    iconLbl.Position = UDim2.new(0, 18, 0.5, -8)
                    iconLbl.ImageColor3 = EZ_Theme.TextDim
                    iconOffset = 42
                end
            end

            local lbl = Instance.new("TextLabel")
            lbl.Position = UDim2.fromOffset(iconOffset, 0)
            lbl.Size = UDim2.new(1, -(iconOffset + 6), 1, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = tabTitle
            lbl.Font = EZ_Brand.FontBody
            lbl.TextSize = 13
            lbl.TextColor3 = EZ_Theme.TextDim
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.TextTruncate = Enum.TextTruncate.AtEnd
            lbl.Parent = btn

            data.Button = btn; data.Label = lbl; data.Page = nil; data.Icon = iconLbl
            data.Indicator = indicator; data.Active = false

            EZ_Paint(function()
                btn.BackgroundColor3 = EZ_Theme.TabActive
                indicator.BackgroundColor3 = EZ_Theme.Accent
                if data.Active then
                    lbl.TextColor3 = EZ_Theme.Text
                    if iconLbl then iconLbl.ImageColor3 = EZ_Theme.Accent end
                else
                    lbl.TextColor3 = EZ_Theme.TextDim
                    if iconLbl then iconLbl.ImageColor3 = EZ_Theme.TextDim end
                end
            end)

            local page = Instance.new("ScrollingFrame")
            page.Size = UDim2.new(1, 0, 1, 0)
            page.BackgroundTransparency = 1
            page.BorderSizePixel = 0
            page.ScrollBarThickness = 3
            page.ScrollBarImageColor3 = EZ_Theme.BorderHover
            EZ_Paint(function() page.ScrollBarImageColor3 = EZ_Theme.BorderHover end)
            page.CanvasSize = UDim2.new(0, 0, 0, 0)
            page.AutomaticCanvasSize = Enum.AutomaticSize.Y
            page.ScrollingDirection = Enum.ScrollingDirection.Y
            page.Visible = false
            page.Parent = content
            data.Page = page
            local play = Instance.new("UIListLayout")
            play.Padding = UDim.new(0, 10); play.Parent = page
            local ppad = Instance.new("UIPadding")
            ppad.PaddingTop = UDim.new(0, 16); ppad.PaddingBottom = UDim.new(0, 16)
            ppad.PaddingLeft = UDim.new(0, 18); ppad.PaddingRight = UDim.new(0, 18); ppad.Parent = page

            table.insert(registry, data)

            btn.MouseEnter:Connect(function()
                if not data.Active then
                    TweenService:Create(lbl, TweenInfo.new(0.12), { TextColor3 = EZ_Theme.Text }):Play()
                    if iconLbl then
                        TweenService:Create(iconLbl, TweenInfo.new(0.12), { ImageColor3 = EZ_Theme.Text }):Play()
                    end
                end
            end)
            btn.MouseLeave:Connect(function()
                if not data.Active then
                    TweenService:Create(lbl, TweenInfo.new(0.12), { TextColor3 = EZ_Theme.TextDim }):Play()
                    if iconLbl then
                        TweenService:Create(iconLbl, TweenInfo.new(0.12), { ImageColor3 = EZ_Theme.TextDim }):Play()
                    end
                end
            end)
            btn.MouseButton1Click:Connect(function() selectTab(data) end)
            if #registry == 1 then selectTab(data) end

            function tab:AddSection(o)
                o = o or {}
                local holder = Instance.new("Frame")
                holder.Size = UDim2.new(1, 0, 0, 32)
                holder.BackgroundTransparency = 1
                holder.Parent = page
                local line1 = Instance.new("Frame")
                line1.Size = UDim2.new(0.35, 0, 0, 1)
                line1.Position = UDim2.new(0, 0, 0.5, 0)
                line1.BackgroundColor3 = EZ_Theme.Border
                line1.BorderSizePixel = 0
                line1.Parent = holder
                EZ_Paint(function() line1.BackgroundColor3 = EZ_Theme.Border end)
                local line2 = Instance.new("Frame")
                line2.Size = UDim2.new(0.35, 0, 0, 1)
                line2.Position = UDim2.new(0.65, 0, 0.5, 0)
                line2.BackgroundColor3 = EZ_Theme.Border
                line2.BorderSizePixel = 0
                line2.Parent = holder
                EZ_Paint(function() line2.BackgroundColor3 = EZ_Theme.Border end)
                local t = Instance.new("TextLabel")
                t.Size = UDim2.new(0.3, 0, 1, 0)
                t.Position = UDim2.new(0.35, 0, 0, 0)
                t.BackgroundTransparency = 1
                t.Text = string.upper(o.Title or "")
                t.Font = EZ_Brand.FontMono
                t.TextSize = 11
                t.TextColor3 = EZ_Theme.TextDim
                t.TextXAlignment = Enum.TextXAlignment.Center
                t.Parent = holder
                EZ_Paint(function() t.TextColor3 = EZ_Theme.TextDim end)
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
                EZ_Paint(function() div.BackgroundColor3 = EZ_Theme.Border end)
                local obj = {}
                function obj:Set(v) div.Visible = v end
                return obj
            end

            function tab:AddParagraph(a, b)
                local o = EZ_Normalize(a, b)
                local row = Instance.new("Frame")
                row.Size = UDim2.new(1, 0, 0, 0)
                row.AutomaticSize = Enum.AutomaticSize.Y
                row.BackgroundColor3 = EZ_Theme.Card
                row.BackgroundTransparency = EZ_GlobalTransparency
                row.BorderSizePixel = 0
                row.Parent = page
                EZ_AddStroke(row, EZ_Theme.Border)
                EZ_AddRadius(row, EZ_Theme.Radius)
                EZ_RegTrans(row)
                EZ_Paint(function() row.BackgroundColor3 = EZ_Theme.Card end)
                local lay = Instance.new("UIListLayout")
                lay.Padding = UDim.new(0, 4); lay.Parent = row
                local pad = Instance.new("UIPadding")
                pad.PaddingLeft = UDim.new(0, 14); pad.PaddingRight = UDim.new(0, 14)
                pad.PaddingTop = UDim.new(0, 12); pad.PaddingBottom = UDim.new(0, 12); pad.Parent = row
                local cl = nil
                if o.Title and o.Title ~= "" then
                    local pt = Instance.new("TextLabel")
                    pt.Size = UDim2.new(1, 0, 0, 0); pt.AutomaticSize = Enum.AutomaticSize.Y
                    pt.BackgroundTransparency = 1; pt.Text = o.Title
                    pt.Font = EZ_Brand.FontBody; pt.TextSize = 13; pt.TextColor3 = EZ_Theme.Text
                    pt.TextXAlignment = Enum.TextXAlignment.Left; pt.TextWrapped = true; pt.Parent = row
                    EZ_Paint(function() pt.TextColor3 = EZ_Theme.Text end)
                end
                if o.Content and o.Content ~= "" then
                    cl = Instance.new("TextLabel")
                    cl.Size = UDim2.new(1, 0, 0, 0); cl.AutomaticSize = Enum.AutomaticSize.Y
                    cl.BackgroundTransparency = 1; cl.Text = o.Content
                    cl.Font = EZ_Brand.FontBody; cl.TextSize = 12; cl.TextColor3 = EZ_Theme.TextDim
                    cl.TextXAlignment = Enum.TextXAlignment.Left; cl.TextWrapped = true; cl.Parent = row
                    EZ_Paint(function() cl.TextColor3 = EZ_Theme.TextDim end)
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
                t.Font = EZ_Brand.FontBody; t.TextSize = 12; t.TextColor3 = EZ_Theme.TextDim
                t.TextXAlignment = Enum.TextXAlignment.Left; t.TextWrapped = true; t.Parent = row
                EZ_Paint(function() t.TextColor3 = EZ_Theme.TextDim end)
                local obj = {}
                function obj:Set(x) t.Text = x or "" end
                return obj
            end

            function tab:AddToggle(a, b)
                local o = EZ_Normalize(a, b)
                local cb = o.Callback or function() end
                local id = o.Flag or o.Id or o.Title or "toggle_" .. os.clock()
                local obj = { Value = o.Default and true or false, Id = id, Flag = o.Flag, Type = "toggle", Default = o.Default and true or false }
                local row = EZ_NewRow(page, 44)
                EZ_RowTitle(row, o.Title or "Toggle", o.Description, 44)
                local track = Instance.new("Frame")
                track.Size = UDim2.fromOffset(40, 22)
                track.Position = UDim2.new(1, -54, 0.5, -11)
                track.BackgroundColor3 = EZ_Theme.BorderHover
                track.BorderSizePixel = 0
                track.Parent = row
                EZ_AddRadius(track, 11)
                local knob = Instance.new("Frame")
                knob.Size = UDim2.fromOffset(16, 16)
                knob.Position = UDim2.fromOffset(3, 3)
                knob.BackgroundColor3 = EZ_Theme.TextDim
                knob.BorderSizePixel = 0
                knob.Parent = track
                EZ_AddRadius(knob, 8)
                local function paintToggle()
                    local on = obj.Value
                    track.BackgroundColor3 = on and EZ_Theme.Accent or EZ_Theme.BorderHover
                    knob.Position = UDim2.fromOffset(on and 21 or 3, 3)
                    knob.BackgroundColor3 = on and EZ_Theme.Background or EZ_Theme.TextDim
                end
                EZ_Paint(paintToggle)
                local function renderTween()
                    local on = obj.Value
                    TweenService:Create(track, TweenInfo.new(0.15), { BackgroundColor3 = on and EZ_Theme.Accent or EZ_Theme.BorderHover }):Play()
                    TweenService:Create(knob, TweenInfo.new(0.18, Enum.EasingStyle.Quint), {
                        Position = UDim2.fromOffset(on and 21 or 3, 3),
                        BackgroundColor3 = on and EZ_Theme.Background or EZ_Theme.TextDim
                    }):Play()
                end
                function obj:Set(state, silent)
                    obj.Value = state and true or false
                    renderTween()
                    if not silent then
                        cb(obj.Value)
                        if obj.Flag and EZ_AutoSave then
                            EZ_Window.ConfigData[id] = { type = "toggle", value = obj.Value }
                            EZ_Window:SaveConfig(EZ_Window.CurrentConfig)
                        end
                    end
                end
                row.InputBegan:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 then obj:Set(not obj.Value) end
                end)
                paintToggle()
                if obj.Flag then table.insert(EZ_Window.Elements, obj) end
                return obj
            end

            function tab:AddButton(a, b)
                local o = EZ_Normalize(a, b)
                local cb = o.Callback or function() end
                local obj = {}
                local row = EZ_NewRow(page, 44)
                EZ_RowTitle(row, o.Title or "Button", o.Description, 44)
                local act = Instance.new("TextButton")
                act.Size = UDim2.fromOffset(96, 28)
                act.Position = UDim2.new(1, -108, 0.5, -14)
                act.BackgroundColor3 = EZ_Theme.Accent
                act.BorderSizePixel = 0
                act.Text = o.ButtonText or "Run"
                act.Font = EZ_Brand.FontBody
                act.TextSize = 12
                act.TextColor3 = EZ_Theme.Background
                act.AutoButtonColor = false
                act.Parent = row
                EZ_AddRadius(act, EZ_Theme.Radius)
                EZ_Paint(function() act.BackgroundColor3 = EZ_Theme.Accent; act.TextColor3 = EZ_Theme.Background end)
                act.MouseEnter:Connect(function()
                    TweenService:Create(act, TweenInfo.new(0.12), { BackgroundColor3 = EZ_Theme.AccentDim }):Play()
                end)
                act.MouseLeave:Connect(function()
                    TweenService:Create(act, TweenInfo.new(0.12), { BackgroundColor3 = EZ_Theme.Accent }):Play()
                end)
                function obj:Fire()
                    TweenService:Create(act, TweenInfo.new(0.08), { Size = UDim2.fromOffset(90, 26) }):Play()
                    task.delay(0.08, function()
                        if act.Parent then
                            TweenService:Create(act, TweenInfo.new(0.12, Enum.EasingStyle.Back), { Size = UDim2.fromOffset(96, 28) }):Play()
                        end
                    end)
                    cb()
                end
                act.MouseButton1Click:Connect(function() obj:Fire() end)
                function obj:SetTitle(t) act.Text = t or "" end
                return obj
            end

            function tab:AddSlider(a, b)
                local o = EZ_Normalize(a, b)
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
                tl.Font = EZ_Brand.FontBody; tl.TextSize = 13; tl.TextColor3 = EZ_Theme.Text
                tl.TextXAlignment = Enum.TextXAlignment.Left; tl.TextTruncate = Enum.TextTruncate.AtEnd
                tl.Parent = row
                EZ_Paint(function() tl.TextColor3 = EZ_Theme.Text end)
                local vl = Instance.new("TextLabel")
                vl.AnchorPoint = Vector2.new(1, 0)
                vl.Position = UDim2.new(1, -12, 0, 10)
                vl.Size = UDim2.fromOffset(80, 16)
                vl.BackgroundTransparency = 1
                vl.Font = EZ_Brand.FontMono; vl.TextSize = 13; vl.TextColor3 = EZ_Theme.Accent
                vl.TextXAlignment = Enum.TextXAlignment.Right
                vl.Parent = row
                EZ_Paint(function() vl.TextColor3 = EZ_Theme.Accent end)
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
                knob.Size = UDim2.fromOffset(14, 14)
                knob.Position = UDim2.new(0, 0, 0.5, 0)
                knob.BackgroundColor3 = EZ_Theme.Accent
                knob.BorderSizePixel = 0
                knob.Parent = track
                EZ_AddRadius(knob, 7)
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
                local function refreshVisual()
                    local r = (mx - mn) == 0 and 0 or (obj.Value - mn) / (mx - mn)
                    fill.Size = UDim2.new(r, 0, 1, 0)
                    knob.Position = UDim2.new(r, 0, 0.5, 0)
                    vl.Text = fmt(obj.Value)
                end
                EZ_Paint(function()
                    track.BackgroundColor3 = EZ_Theme.BorderHover
                    fill.BackgroundColor3 = EZ_Theme.Accent
                    knob.BackgroundColor3 = EZ_Theme.Accent
                    refreshVisual()
                end)
                local function apply(raw, silent)
                    local v = EZ_Round(EZ_Clamp(raw, mn, mx), st)
                    obj.Value = v
                    refreshVisual()
                    if not silent then
                        cb(v)
                        if obj.Flag and EZ_AutoSave then
                            EZ_Window.ConfigData[id] = { type = "slider", value = v }
                            EZ_Window:SaveConfig(EZ_Window.CurrentConfig)
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

            function tab:AddDropdown(a, b)
                local o = EZ_Normalize(a, b)
                local values = o.Values or o.Options or {}
                local cb = o.Callback or function() end
                local id = o.Flag or o.Id or o.Title or "dropdown_" .. os.clock()
                local obj = { Value = o.Default, Id = id, Flag = o.Flag, Type = "dropdown", Default = o.Default }
                local row = EZ_NewRow(page, 44)
                EZ_RowTitle(row, o.Title or "Dropdown", o.Description, 44, 190)
                local trigger = Instance.new("TextButton")
                trigger.Size = UDim2.fromOffset(160, 28)
                trigger.Position = UDim2.new(1, -172, 0.5, -14)
                trigger.BackgroundColor3 = EZ_Theme.CardHover
                trigger.BorderSizePixel = 0
                trigger.Text = ""
                trigger.AutoButtonColor = false
                trigger.Parent = row
                EZ_AddStroke(trigger, EZ_Theme.Border)
                EZ_AddRadius(trigger, EZ_Theme.Radius)
                local trigText = Instance.new("TextLabel")
                trigText.Size = UDim2.new(1, -30, 1, 0)
                trigText.Position = UDim2.fromOffset(10, 0)
                trigText.BackgroundTransparency = 1
                trigText.Text = obj.Value and tostring(obj.Value) or "none"
                trigText.Font = EZ_Brand.FontBody
                trigText.TextSize = 12
                trigText.TextColor3 = EZ_Theme.Text
                trigText.TextXAlignment = Enum.TextXAlignment.Left
                trigText.TextTruncate = Enum.TextTruncate.AtEnd
                trigText.Parent = trigger
                local sign = EZ_CreateIcon(trigger, "chevron-down", 14)
                if sign then
                    sign.AnchorPoint = Vector2.new(1, 0.5)
                    sign.Position = UDim2.new(1, -8, 0.5, 0)
                    sign.ImageColor3 = EZ_Theme.TextDim
                end
                EZ_Paint(function()
                    trigger.BackgroundColor3 = EZ_Theme.CardHover
                    trigText.TextColor3 = EZ_Theme.Text
                    if sign then sign.ImageColor3 = EZ_Theme.TextDim end
                end)
                local entry = {
                    trigger = trigger,
                    sign = sign,
                    windowFrame = frame,
                    width = 172,
                    getValues = function() return values end,
                    getValue = function() return obj.Value end,
                    pick = function(v) obj:Set(v, false) end,
                }
                function obj:Set(v, silent)
                    obj.Value = v
                    trigText.Text = tostring(v)
                    if not silent then
                        cb(v)
                        if obj.Flag and EZ_AutoSave then
                            EZ_Window.ConfigData[id] = { type = "dropdown", value = v }
                            EZ_Window:SaveConfig(EZ_Window.CurrentConfig)
                        end
                    end
                end
                function obj:SetValues(newValues)
                    values = newValues
                    if EZ_DropdownCurrent == entry then
                        EZ_CloseDropdown()
                    end
                end
                trigger.MouseButton1Click:Connect(function()
                    EZ_OpenDropdown(entry)
                end)
                if obj.Flag then table.insert(EZ_Window.Elements, obj) end
                return obj
            end

            function tab:AddInput(a, b)
                local o = EZ_Normalize(a, b)
                local cb = o.Callback or function() end
                local id = o.Flag or o.Id or o.Title or "input_" .. os.clock()
                local obj = { Value = o.Default or "", Id = id, Flag = o.Flag, Type = "input", Default = o.Default or "" }
                local row = EZ_NewRow(page, 44)
                EZ_RowTitle(row, o.Title or "Input", o.Description, 44, 190)
                local box = Instance.new("TextBox")
                box.Size = UDim2.fromOffset(160, 28)
                box.Position = UDim2.new(1, -172, 0.5, -14)
                box.BackgroundColor3 = EZ_Theme.Background
                box.BorderSizePixel = 0
                box.Text = obj.Value
                box.Font = EZ_Brand.FontMono
                box.TextSize = 12
                box.TextColor3 = EZ_Theme.Text
                box.PlaceholderText = o.Placeholder or "..."
                box.PlaceholderColor3 = EZ_Theme.TextDim
                box.TextXAlignment = Enum.TextXAlignment.Left
                box.ClearTextOnFocus = false
                box.Parent = row
                local bst = EZ_AddStroke(box, EZ_Theme.Border)
                EZ_AddRadius(box, EZ_Theme.Radius)
                EZ_RegTrans(box)
                EZ_Paint(function()
                    box.BackgroundColor3 = EZ_Theme.Background
                    box.TextColor3 = EZ_Theme.Text
                    box.PlaceholderColor3 = EZ_Theme.TextDim
                end)
                local bpad = Instance.new("UIPadding")
                bpad.PaddingLeft = UDim.new(0, 10); bpad.PaddingRight = UDim.new(0, 10); bpad.Parent = box
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
                            EZ_Window:SaveConfig(EZ_Window.CurrentConfig)
                        end
                    end
                end
                if obj.Flag then table.insert(EZ_Window.Elements, obj) end
                return obj
            end

            function tab:AddTextArea(a, b)
                local o = EZ_Normalize(a, b)
                local cb = o.Callback or function() end
                local id = o.Flag or o.Id or o.Title or "textarea_" .. os.clock()
                local obj = { Value = o.Default or "", Id = id, Flag = o.Flag, Type = "textarea", Default = o.Default or "" }
                local row = Instance.new("Frame")
                row.Size = UDim2.new(1, 0, 0, 110)
                row.BackgroundColor3 = EZ_Theme.Card
                row.BackgroundTransparency = EZ_GlobalTransparency
                row.BorderSizePixel = 0
                row.Parent = page
                EZ_AddStroke(row, EZ_Theme.Border)
                EZ_AddRadius(row, EZ_Theme.Radius)
                EZ_RegTrans(row)
                EZ_Paint(function() row.BackgroundColor3 = EZ_Theme.Card end)
                local tl = Instance.new("TextLabel")
                tl.Position = UDim2.fromOffset(14, 10)
                tl.Size = UDim2.new(1, -24, 0, 16)
                tl.BackgroundTransparency = 1
                tl.Text = o.Title or "Text Area"
                tl.Font = EZ_Brand.FontBody; tl.TextSize = 13; tl.TextColor3 = EZ_Theme.Text
                tl.TextXAlignment = Enum.TextXAlignment.Left
                tl.Parent = row
                EZ_Paint(function() tl.TextColor3 = EZ_Theme.Text end)
                local box = Instance.new("TextBox")
                box.Size = UDim2.new(1, -28, 0, 74)
                box.Position = UDim2.fromOffset(14, 32)
                box.BackgroundColor3 = EZ_Theme.Background
                box.BorderSizePixel = 0
                box.Text = obj.Value
                box.Font = EZ_Brand.FontMono; box.TextSize = 12; box.TextColor3 = EZ_Theme.Text
                box.PlaceholderText = o.Placeholder or "..."
                box.PlaceholderColor3 = EZ_Theme.TextDim
                box.TextXAlignment = Enum.TextXAlignment.Left
                box.TextYAlignment = Enum.TextYAlignment.Top
                box.TextWrapped = true
                box.ClearTextOnFocus = false
                box.MultiLine = true
                box.Parent = row
                local bst = EZ_AddStroke(box, EZ_Theme.Border)
                EZ_AddRadius(box, EZ_Theme.Radius)
                EZ_RegTrans(box)
                EZ_Paint(function()
                    box.BackgroundColor3 = EZ_Theme.Background
                    box.TextColor3 = EZ_Theme.Text
                    box.PlaceholderColor3 = EZ_Theme.TextDim
                end)
                local bpad = Instance.new("UIPadding")
                bpad.PaddingLeft = UDim.new(0, 10); bpad.PaddingRight = UDim.new(0, 10)
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
                            EZ_Window:SaveConfig(EZ_Window.CurrentConfig)
                        end
                    end
                end
                if obj.Flag then table.insert(EZ_Window.Elements, obj) end
                return obj
            end

            function tab:AddProgressBar(a, b)
                local o = EZ_Normalize(a, b)
                local obj = { Value = o.Default or 0 }
                local row = EZ_NewRow(page, 50)
                local tl = Instance.new("TextLabel")
                tl.Position = UDim2.fromOffset(12, 10)
                tl.Size = UDim2.new(1, -80, 0, 16)
                tl.BackgroundTransparency = 1
                tl.Text = o.Title or "Progress"
                tl.Font = EZ_Brand.FontBody; tl.TextSize = 13; tl.TextColor3 = EZ_Theme.Text
                tl.TextXAlignment = Enum.TextXAlignment.Left
                tl.Parent = row
                EZ_Paint(function() tl.TextColor3 = EZ_Theme.Text end)
                local vl = Instance.new("TextLabel")
                vl.AnchorPoint = Vector2.new(1, 0)
                vl.Position = UDim2.new(1, -12, 0, 10)
                vl.Size = UDim2.fromOffset(60, 16)
                vl.BackgroundTransparency = 1
                vl.Font = EZ_Brand.FontMono; vl.TextSize = 12; vl.TextColor3 = EZ_Theme.Accent
                vl.TextXAlignment = Enum.TextXAlignment.Right
                vl.Text = tostring(obj.Value) .. "%"
                vl.Parent = row
                EZ_Paint(function() vl.TextColor3 = EZ_Theme.Accent end)
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
                EZ_Paint(function()
                    track.BackgroundColor3 = EZ_Theme.BorderHover
                    fill.BackgroundColor3 = EZ_Theme.Accent
                end)
                function obj:Set(val)
                    obj.Value = EZ_Clamp(val, 0, 100)
                    TweenService:Create(fill, TweenInfo.new(0.2, Enum.EasingStyle.Quint), { Size = UDim2.new(obj.Value / 100, 0, 1, 0) }):Play()
                    vl.Text = tostring(obj.Value) .. "%"
                end
                return obj
            end

            function tab:AddColorPicker(a, b)
                local o = EZ_Normalize(a, b)
                local cb = o.Callback or function() end
                local id = o.Flag or o.Id or o.Title or "color_" .. os.clock()
                local def = o.Default or Color3.fromRGB(255, 255, 255)
                local obj = { Value = def, Id = id, Flag = o.Flag, Type = "color", Default = def }
                local open = false
                local r, g, b = math.floor(def.R * 255), math.floor(def.G * 255), math.floor(def.B * 255)
                local row = EZ_NewRow(page, 44)
                EZ_RowTitle(row, o.Title or "Color", o.Description, 44, 90)
                local sw = Instance.new("Frame")
                sw.Size = UDim2.fromOffset(28, 28)
                sw.Position = UDim2.new(1, -50, 0.5, -14)
                sw.BackgroundColor3 = obj.Value
                sw.BorderSizePixel = 0
                sw.Parent = row
                EZ_AddStroke(sw, EZ_Theme.Border)
                EZ_AddRadius(sw, EZ_Theme.Radius)
                local sign = EZ_CreateIcon(row, "chevron-down", 14)
                if sign then
                    sign.AnchorPoint = Vector2.new(1, 0)
                    sign.Position = UDim2.new(1, -14, 0, 0)
                    sign.ImageColor3 = EZ_Theme.TextDim
                end
                EZ_Paint(function() if sign then sign.ImageColor3 = EZ_Theme.TextDim end end)
                local panel = Instance.new("Frame")
                panel.Position = UDim2.fromOffset(1, 44)
                panel.Size = UDim2.new(1, -2, 0, 0)
                panel.BackgroundColor3 = EZ_Theme.Background
                panel.BorderSizePixel = 0
                panel.ClipsDescendants = true
                panel.Parent = row
                EZ_RegTrans(panel)
                EZ_Paint(function() panel.BackgroundColor3 = EZ_Theme.Background end)
                local play2 = Instance.new("UIListLayout"); play2.Padding = UDim.new(0, 8); play2.Parent = panel
                local ppad2 = Instance.new("UIPadding")
                ppad2.PaddingTop = UDim.new(0, 10); ppad2.PaddingBottom = UDim.new(0, 10)
                ppad2.PaddingLeft = UDim.new(0, 14); ppad2.PaddingRight = UDim.new(0, 14); ppad2.Parent = panel
                local updateScheduled = false
                local function update(silent)
                    obj.Value = Color3.fromRGB(r, g, b)
                    sw.BackgroundColor3 = obj.Value
                    if silent then return end
                    if updateScheduled then return end
                    updateScheduled = true
                    task.delay(0.08, function()
                        updateScheduled = false
                        cb(obj.Value)
                        if obj.Flag and EZ_AutoSave then
                            EZ_Window.ConfigData[id] = { type = "color", value = { math.floor(obj.Value.R * 255), math.floor(obj.Value.G * 255), math.floor(obj.Value.B * 255) } }
                            EZ_Window:SaveConfig(EZ_Window.CurrentConfig)
                        end
                    end)
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
                    lab.Font = EZ_Brand.FontMono; lab.TextSize = 12; lab.TextColor3 = EZ_Theme.TextDim
                    lab.TextXAlignment = Enum.TextXAlignment.Left
                    lab.Parent = holder
                    EZ_Paint(function() lab.TextColor3 = EZ_Theme.TextDim end)
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
                    cvl.Font = EZ_Brand.FontMono; cvl.TextSize = 12; cvl.TextColor3 = EZ_Theme.TextDim
                    cvl.TextXAlignment = Enum.TextXAlignment.Right
                    cvl.Text = tostring(get())
                    cvl.Parent = holder
                    EZ_Paint(function()
                        track.BackgroundColor3 = EZ_Theme.BorderHover
                        fill.BackgroundColor3 = EZ_Theme.Accent
                        cvl.TextColor3 = EZ_Theme.TextDim
                    end)
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
                    if sign then
                        TweenService:Create(sign, TweenInfo.new(0.2, Enum.EasingStyle.Quint), { Rotation = s and 180 or 0 }):Play()
                    end
                    local h = s and 110 or 0
                    TweenService:Create(row, TweenInfo.new(0.18, Enum.EasingStyle.Quint), { Size = UDim2.new(1, 0, 0, 44 + h) }):Play()
                    TweenService:Create(panel, TweenInfo.new(0.18, Enum.EasingStyle.Quint), { Size = UDim2.new(1, -2, 0, h) }):Play()
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

            function tab:AddKeybind(a, b)
                local o = EZ_Normalize(a, b)
                local cb = o.Callback or function() end
                local id = o.Flag or o.Id or o.Title or "keybind_" .. os.clock()
                local obj = { Value = o.Default, Id = id, Flag = o.Flag, Type = "keybind", Default = o.Default }
                local listening = false
                local row = EZ_NewRow(page, 44)
                EZ_RowTitle(row, o.Title or "Keybind", o.Description, 44, 100)
                local kl = Instance.new("TextButton")
                kl.Position = UDim2.new(1, -82, 0.5, -13)
                kl.Size = UDim2.fromOffset(70, 26)
                kl.BackgroundColor3 = EZ_Theme.Background
                kl.BorderSizePixel = 0
                kl.Text = obj.Value and obj.Value.Name or "None"
                kl.Font = EZ_Brand.FontBody
                kl.TextSize = 12
                kl.TextColor3 = EZ_Theme.Text
                kl.TextXAlignment = Enum.TextXAlignment.Center
                kl.AutoButtonColor = false
                kl.Parent = row
                local klst = EZ_AddStroke(kl, EZ_Theme.Border)
                EZ_AddRadius(kl, EZ_Theme.Radius)
                EZ_RegTrans(kl)
                EZ_Paint(function()
                    kl.BackgroundColor3 = EZ_Theme.Background
                    kl.TextColor3 = EZ_Theme.Text
                    if not listening then klst.Color = EZ_Theme.Border end
                end)
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
                                if obj.Flag and EZ_AutoSave then
                                    EZ_Window.ConfigData[id] = { type = "keybind", value = input.KeyCode.Name }
                                    EZ_Window:SaveConfig(EZ_Window.CurrentConfig)
                                end
                            end
                        end
                        return
                    end
                    if obj.Value and input.KeyCode == obj.Value and not processed then
                        if not UserInputService:GetFocusedTextBox() then cb() end
                    end
                end)
                kl.MouseEnter:Connect(function() if not listening then klst.Color = EZ_Theme.Accent end end)
                kl.MouseLeave:Connect(function() if not listening then klst.Color = EZ_Theme.Border end end)
                kl.MouseButton1Click:Connect(function()
                    listening = true
                    kl.Text = "..."
                    klst.Color = EZ_Theme.Accent
                end)
                function obj:Set(key, silent)
                    obj.Value = key
                    kl.Text = key and key.Name or "None"
                    if not silent and obj.Flag and EZ_AutoSave then
                        EZ_Window.ConfigData[id] = { type = "keybind", value = key and key.Name or nil }
                        EZ_Window:SaveConfig(EZ_Window.CurrentConfig)
                    end
                end
                if obj.Flag then table.insert(EZ_Window.Elements, obj) end
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
            for _, inst in ipairs(EZ_TransSurf) do
                if inst.Parent then
                    inst.BackgroundTransparency = EZ_GlobalTransparency
                end
            end
        end

        function EZ_Window:SetMinimizeKey(key)
            EZ_MinKey = key
        end

        function EZ_Window:SaveConfig(configName)
            configName = configName or EZ_Window.CurrentConfig
            local data = { _meta = { theme = EZ_CurrentThemeName, transparency = EZ_GlobalTransparency, autoSave = EZ_AutoSave } }
            for _, el in ipairs(EZ_Window.Elements) do
                if el.Flag then
                    if el.Type == "color" then
                        data[el.Id] = { type = "color", value = { math.floor(el.Value.R * 255), math.floor(el.Value.G * 255), math.floor(el.Value.B * 255) } }
                    elseif el.Type == "keybind" then
                        data[el.Id] = { type = "keybind", value = el.Value and el.Value.Name or nil }
                    else
                        data[el.Id] = { type = el.Type, value = el.Value }
                    end
                end
            end
            EZ_Window.ConfigData = data
            EZ_Window.CurrentConfig = configName
            return EZ_SaveConfig(EZ_ConfigId, configName, data)
        end

        function EZ_Window:LoadConfig(configName)
            configName = configName or EZ_Window.CurrentConfig
            local data = EZ_LoadConfig(EZ_ConfigId, configName)
            if not data then return false end
            local ignored = 0
            for key, _ in pairs(data) do
                if key ~= "_meta" then
                    local found = false
                    for _, el in ipairs(EZ_Window.Elements) do
                        if el.Id == key then found = true break end
                    end
                    if not found then ignored = ignored + 1 end
                end
            end
            if data._meta then
                if data._meta.theme then
                    EZ_ApplyThemeAndRepaint(data._meta.theme)
                end
                if data._meta.transparency then EZ_Window:SetTransparency(data._meta.transparency) end
                if data._meta.autoSave ~= nil then EZ_AutoSave = data._meta.autoSave end
            end
            
            if data._minimize_key and data._minimize_key.value then
                local key = Enum.KeyCode[data._minimize_key.value]
                if key then
                    EZ_MinKey = key
                end
            end
            
            for _, el in ipairs(EZ_Window.Elements) do
                local d = data[el.Id]
                if d then
                    if d.type == "color" then
                        el:Set(Color3.fromRGB(d.value[1], d.value[2], d.value[3]), true)
                    elseif d.type == "keybind" then
                        local key = d.value and Enum.KeyCode[d.value] or nil
                        el:Set(key, true)
                        if el.Id == "_minimize_key" and key then
                            EZ_MinKey = key
                        end
                    else
                        el:Set(d.value, true)
                    end
                end
            end
            EZ_Window.CurrentConfig = configName
            if ignored > 0 then
                task.spawn(function()
                    EZ:Notify({ Title = "Config", Content = ignored .. " saved field(s) no longer exist and were skipped.", Style = "Warning", Duration = 3 })
                end)
            end
            return true
        end

        function EZ_Window:ResetConfig(configName)
            configName = configName or EZ_Window.CurrentConfig
            EZ_DeleteConfig(EZ_ConfigId, configName)
            EZ_Window.ConfigData = {}
            for _, el in ipairs(EZ_Window.Elements) do
                if el.Default ~= nil then el:Set(el.Default, true) end
            end
            return true
        end

        function EZ_Window:ListConfigs()
            return EZ_ListConfigs(EZ_ConfigId)
        end

        function EZ_Window:BuildConfigSection(tab)
            if tab._ezConfigBuilt then return end
            tab._ezConfigBuilt = true
            local savedConfigsDropdown = nil
            local themeDropdown = nil
            local function persistAppearance()
                if EZ_AutoSave then
                    EZ_Window:SaveConfig(EZ_Window.CurrentConfig)
                end
            end
            tab:AddSection({ Title = "configuration" })
            tab:AddToggle({
                Title = "Auto-Save",
                Description = "Save settings automatically when changed",
                Default = EZ_AutoSave,
                Callback = function(s)
                    EZ_AutoSave = s
                    persistAppearance()
                end
            })
            local configNameInput = tab:AddInput({
                Title = "Config Name",
                Description = "Name used when saving a new config",
                Placeholder = "default",
                Default = "",
                Callback = function() end
            })
            tab:AddButton({
                Title = "Save Config",
                Description = "Save current settings, theme and binds",
                ButtonText = "Save",
                Callback = function()
                    local name = (configNameInput.Value ~= "" and configNameInput.Value) or EZ_Window.CurrentConfig
                    EZ_Window:SaveConfig(name)
                    if savedConfigsDropdown then
                        savedConfigsDropdown:SetValues(EZ_Window:ListConfigs())
                    end
                    EZ:Notify({ Title = "Config", Content = "Config '" .. name .. "' saved.", Style = "Success", Duration = 2 })
                end
            })
            savedConfigsDropdown = tab:AddDropdown({
                Title = "Saved Configs",
                Description = "Pick a saved config to load or delete",
                Values = EZ_Window:ListConfigs(),
                Default = nil,
                Callback = function(name)
                    EZ_Window.CurrentConfig = name
                end
            })
            tab:AddButton({
                Title = "Load Config",
                Description = "Load the config selected above",
                ButtonText = "Load",
                Callback = function()
                    local name = EZ_Window.CurrentConfig
                    local ok = EZ_Window:LoadConfig(name)
                    EZ:Notify({ Title = "Config", Content = ok and ("Config '" .. name .. "' loaded.") or ("No config named '" .. name .. "'."), Style = ok and "Success" or "Warning", Duration = 2 })
                end
            })
            tab:AddButton({
                Title = "Delete Config",
                Description = "Delete the config selected above",
                ButtonText = "Delete",
                Callback = function()
                    local name = EZ_Window.CurrentConfig
                    EZ_DeleteConfig(EZ_ConfigId, name)
                    if savedConfigsDropdown then
                        savedConfigsDropdown:SetValues(EZ_Window:ListConfigs())
                    end
                    EZ:Notify({ Title = "Config", Content = "Config '" .. name .. "' deleted.", Style = "Warning", Duration = 2 })
                end
            })
            tab:AddButton({
                Title = "Reset to Defaults",
                Description = "Reset all settings to their default values",
                ButtonText = "Reset",
                Callback = function()
                    for _, el in ipairs(EZ_Window.Elements) do
                        if el.Default ~= nil then el:Set(el.Default, true) end
                    end
                    EZ:Notify({ Title = "Config", Content = "All settings reset to defaults.", Style = "Warning", Duration = 2 })
                end
            })
            tab:AddSection({ Title = "appearance" })
            tab:AddKeybind({
                Title = "Minimize Key",
                Description = "Key to hide/show the hub",
                Flag = "_minimize_key",
                Default = EZ_MinKey,
                Callback = function(key)
                    if key then
                        EZ_MinKey = key
                        persistAppearance()
                        EZ:Notify({ Title = "Key Changed", Content = "Minimize key set to " .. key.Name, Style = "Success", Duration = 2 })
                    end
                end
            })
            tab:AddSlider({
                Title = "Window Transparency",
                Description = "Adjust UI transparency (0-90%)",
                Min = 0, Max = 90, Default = math.floor(EZ_GlobalTransparency * 100), Step = 5,
                Callback = function(v)
                    EZ_Window:SetTransparency(v / 100)
                    persistAppearance()
                end
            })
            themeDropdown = tab:AddDropdown({
                Title = "Theme",
                Description = "Change the UI theme (applies instantly)",
                Values = { "Default", "Pitch", "Light", "Ocean", "Sunset", "Mono" },
                Default = EZ_CurrentThemeName,
                Callback = function(theme)
                    EZ:SetTheme(theme)
                    persistAppearance()
                    EZ:Notify({ Title = "Theme Changed", Content = "Switched to " .. theme .. " theme", Style = "Success", Duration = 2 })
                end
            })
            EZ_OnThemeChange(function(name)
                if themeDropdown and themeDropdown.Value ~= name then
                    themeDropdown:Set(name, true)
                end
            end)
        end

        EZ_Window.Frame = frame
        EZ_Window.Titlebar = titlebar
        EZ_Window.Sidebar = sidebar
        EZ_Window.Content = content
        EZ_Window.SetMinimized = setMinimized

        function EZ_Window:LoadAutoConfig()
            if not EZ_AutoLoad then return false end
            if EZ_Window._autoLoaded then return false end
            EZ_Window._autoLoaded = true
            local saved = EZ_LoadConfig(EZ_ConfigId, "default")
            if not saved then return false end
            
            EZ_Window.ConfigData = saved
            EZ_Window.CurrentConfig = "default"
            
            if saved._meta then
                if saved._meta.theme then
                    EZ_ApplyThemeAndRepaint(saved._meta.theme)
                end
                if saved._meta.transparency then 
                    EZ_Window:SetTransparency(saved._meta.transparency) 
                end
                if saved._meta.autoSave ~= nil then 
                    EZ_AutoSave = saved._meta.autoSave 
                end
            end
            
            if saved._minimize_key and saved._minimize_key.value then
                local key = Enum.KeyCode[saved._minimize_key.value]
                if key then
                    EZ_MinKey = key
                end
            end
            
            for _, el in ipairs(EZ_Window.Elements) do
                local d = saved[el.Id]
                if d then
                    if d.type == "color" then
                        el:Set(Color3.fromRGB(d.value[1], d.value[2], d.value[3]), true)
                    elseif d.type == "keybind" then
                        local key = d.value and Enum.KeyCode[d.value] or nil
                        el:Set(key, true)
                        if el.Id == "_minimize_key" and key then
                            EZ_MinKey = key
                        end
                    else
                        el:Set(d.value, true)
                    end
                end
            end
            
            EZ_Repaint()
            for _, inst in ipairs(EZ_TransSurf) do
                if inst.Parent then 
                    inst.BackgroundTransparency = EZ_GlobalTransparency 
                end
            end
            
            return true
        end

        if EZ_AutoLoad then
            task.delay(2, function()
                if not EZ_Window._autoLoaded then
                    EZ_Window:LoadAutoConfig()
                end
            end)
        end

        return EZ_Window
    end

    return EZ_BuildWindow()
end

function EZ:Destroy()
    EZ_CloseDropdown()
    EZ_Gui:Destroy()
    EZ_NotifyGui:Destroy()
    table.clear(EZ_Painters)
    table.clear(EZ_TransSurf)
    table.clear(EZ_ThemeListeners)
    if getgenv then getgenv().EazyUI = nil end
end

function EZ:Logout()
    EZ_ClearKey()
    EZ:Notify({ Title = "Eazy UI", Content = "Logged out. Restart to re-enter key.", Style = "Info", Duration = 3 })
end

if getgenv then getgenv().EazyUI = EZ end

return EZ