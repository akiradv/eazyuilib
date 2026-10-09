--[[
    Eazy UI v0.9.36
    Open-source Roblox GUI library with minimal dependencies.
    Join our discord!: https://discord.gg/9VE4PXFDSg
]]

local EZ = {}
EZ.Version = "0.9.36"

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

local EZ_Locale = {
    Search = "Search...",
    Loading = "Loading",
    PleaseWait = "Please wait...",
    JoinDiscord = "Join our Discord",
    DiscordSubtitle = "Get updates, support and exclusive features.\nCopy the invite link below to join.",
    EnterKey = "Enter Key",
    EnterKeySubtitle = "Enter your access key to continue",
    EnterKeyPlaceholder = "Enter key here...",
    Submit = "Submit",
    Cancel = "Cancel",
    Validating = "Validating...",
    InvalidKey = "Invalid key. Please try again.",
    AccessDenied = "Access denied.",
    Copied = "Copied!",
    CopyLink = "Copy Link",
    Skip = "Skip",
    None = "None",
}

function EZ:SetLocale(key, value)
    if type(key) == "table" then
        for k, v in pairs(key) do EZ_Locale[k] = v end
    elseif key and value then
        EZ_Locale[key] = value
    end
end

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
        Radius = 8,
        RadiusWindow = 12,
    },
    Pitch = {
        Background = EZ_C(5, 5, 6), Card = EZ_C(12, 12, 14), CardHover = EZ_C(20, 20, 23),
        Border = EZ_C(28, 28, 32), BorderHover = EZ_C(48, 48, 54), TabActive = EZ_C(30, 12, 16),
        Text = EZ_C(235, 235, 238), TextDim = EZ_C(105, 105, 112),
        Accent = EZ_C(244, 63, 94), AccentDim = EZ_C(190, 40, 70),
        Radius = 6, RadiusWindow = 10,
    },
    Light = {
        Background = EZ_C(246, 247, 249), Card = EZ_C(255, 255, 255), CardHover = EZ_C(240, 242, 245),
        Border = EZ_C(220, 224, 230), BorderHover = EZ_C(190, 196, 205), TabActive = EZ_C(224, 234, 252),
        Text = EZ_C(25, 28, 35), TextDim = EZ_C(115, 122, 132),
        Accent = EZ_C(37, 99, 235), AccentDim = EZ_C(28, 74, 176),
        Radius = 8, RadiusWindow = 12,
    },
    Ocean = {
        Background = EZ_C(6, 14, 26), Card = EZ_C(10, 20, 36), CardHover = EZ_C(15, 27, 46),
        Border = EZ_C(24, 40, 62), BorderHover = EZ_C(38, 60, 90), TabActive = EZ_C(10, 32, 56),
        Text = EZ_C(222, 234, 246), TextDim = EZ_C(108, 128, 148),
        Accent = EZ_C(56, 189, 248), AccentDim = EZ_C(37, 140, 190),
        Radius = 8, RadiusWindow = 12,
    },
    Sunset = {
        Background = EZ_C(32, 15, 22), Card = EZ_C(42, 20, 29), CardHover = EZ_C(52, 26, 36),
        Border = EZ_C(70, 34, 46), BorderHover = EZ_C(100, 50, 64), TabActive = EZ_C(58, 32, 20),
        Text = EZ_C(246, 232, 226), TextDim = EZ_C(158, 124, 118),
        Accent = EZ_C(250, 204, 21), AccentDim = EZ_C(196, 158, 12),
        Radius = 10, RadiusWindow = 14,
    },
    Mono = {
        Background = EZ_C(18, 18, 18), Card = EZ_C(26, 26, 26), CardHover = EZ_C(34, 34, 34),
        Border = EZ_C(48, 48, 48), BorderHover = EZ_C(72, 72, 72), TabActive = EZ_C(40, 40, 40),
        Text = EZ_C(238, 238, 238), TextDim = EZ_C(132, 132, 132),
        Accent = EZ_C(238, 238, 238), AccentDim = EZ_C(179, 179, 179),
        Radius = 4, RadiusWindow = 8,
    },
    Amethyst = {
        Background = EZ_C(22, 17, 32), Card = EZ_C(29, 23, 42), CardHover = EZ_C(37, 30, 53),
        Border = EZ_C(50, 42, 72), BorderHover = EZ_C(74, 62, 104), TabActive = EZ_C(40, 28, 62),
        Text = EZ_C(238, 232, 248), TextDim = EZ_C(138, 128, 158),
        Accent = EZ_C(192, 132, 252), AccentDim = EZ_C(147, 98, 196),
        Radius = 8, RadiusWindow = 12,
    },
    Rose = {
        Background = EZ_C(26, 14, 20), Card = EZ_C(35, 19, 27), CardHover = EZ_C(44, 25, 34),
        Border = EZ_C(62, 34, 48), BorderHover = EZ_C(92, 50, 70), TabActive = EZ_C(52, 22, 38),
        Text = EZ_C(248, 232, 238), TextDim = EZ_C(158, 128, 140),
        Accent = EZ_C(244, 114, 182), AccentDim = EZ_C(190, 80, 138),
        Radius = 8, RadiusWindow = 12,
    },
    Aqua = {
        Background = EZ_C(8, 20, 20), Card = EZ_C(12, 27, 27), CardHover = EZ_C(17, 35, 35),
        Border = EZ_C(28, 52, 50), BorderHover = EZ_C(42, 76, 73), TabActive = EZ_C(14, 42, 40),
        Text = EZ_C(226, 242, 240), TextDim = EZ_C(116, 140, 138),
        Accent = EZ_C(45, 212, 191), AccentDim = EZ_C(30, 160, 144),
        Radius = 8, RadiusWindow = 12,
    },
    Nocturne = {
        Background = EZ_C(9, 11, 22), Card = EZ_C(14, 17, 30), CardHover = EZ_C(20, 24, 40),
        Border = EZ_C(30, 36, 58), BorderHover = EZ_C(46, 54, 86), TabActive = EZ_C(20, 24, 50),
        Text = EZ_C(228, 232, 246), TextDim = EZ_C(122, 130, 156),
        Accent = EZ_C(129, 140, 248), AccentDim = EZ_C(96, 105, 196),
        Radius = 6, RadiusWindow = 10,
    },
    Pumpkin = {
        Background = EZ_C(24, 17, 12), Card = EZ_C(32, 23, 16), CardHover = EZ_C(41, 29, 20),
        Border = EZ_C(58, 42, 28), BorderHover = EZ_C(87, 63, 42), TabActive = EZ_C(52, 36, 20),
        Text = EZ_C(244, 236, 228), TextDim = EZ_C(156, 140, 124),
        Accent = EZ_C(249, 115, 22), AccentDim = EZ_C(194, 87, 14),
        Radius = 10, RadiusWindow = 14,
    },
}

local EZ_Theme = {}
for k, v in pairs(EZ_Themes.Default) do EZ_Theme[k] = v end

local EZ_ThemeAliases = {
    default = "Default", padrao = "Default",
    pitch = "Pitch", escuro = "Pitch", dark = "Pitch",
    light = "Light", claro = "Light",
    ocean = "Ocean", oceano = "Ocean",
    sunset = "Sunset",
    mono = "Mono",
    amethyst = "Amethyst", ametista = "Amethyst",
    rose = "Rose", rosa = "Rose",
    aqua = "Aqua", agua = "Aqua",
    nocturne = "Nocturne", noite = "Nocturne",
    pumpkin = "Pumpkin", abobora = "Pumpkin",
}

local EZ_CurrentThemeName = "Default"
local EZ_Painters = {}
local EZ_PaintersByElement = {}
local EZ_TransSurf = {}
local EZ_TransFactors = {}
local EZ_StrokeSurf = {}
local EZ_Connections = {}
local EZ_ThemeListeners = {}
local EZ_GlobalTransparency = 0
local EZ_LogoAsset = nil
local EZ_CurrentWindow = nil
local EZ_Ease = {
    Fast = TweenInfo.new(0.12, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    Med = TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    Slow = TweenInfo.new(0.28, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
    Pop = TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
}
local EZ_NotifyPosition = "BottomRight"
local EZ_NotifyQueue = {}
local EZ_NotifyVisible = {}
local EZ_NotifyMax = 6
local EZ_SaveQueued = false

local function EZ_Paint(fn, element)
    local entry = { fn = fn, element = element }
    table.insert(EZ_Painters, entry)
    if element then
        if not EZ_PaintersByElement[element] then
            EZ_PaintersByElement[element] = {}
        end
        table.insert(EZ_PaintersByElement[element], entry)
    end
    return entry
end

local function EZ_ClearPaintersFor(element)
    local list = EZ_PaintersByElement[element]
    if not list then return end
    for _, entry in ipairs(list) do
        for i = #EZ_Painters, 1, -1 do
            if EZ_Painters[i] == entry then
                table.remove(EZ_Painters, i)
                break
            end
        end
    end
    EZ_PaintersByElement[element] = nil
end

local function EZ_Connect(element, signal, fn)
    local conn = signal:Connect(fn)
    if not EZ_Connections[element] then EZ_Connections[element] = {} end
    table.insert(EZ_Connections[element], conn)
    return conn
end

local function EZ_DisconnectAll(element)
    local list = EZ_Connections[element]
    if not list then return end
    for _, conn in ipairs(list) do
        if conn.Connected then conn:Disconnect() end
    end
    EZ_Connections[element] = nil
    EZ_ClearPaintersFor(element)
end

local function EZ_RegTrans(inst, factor)
    local f = factor or 0.55
    table.insert(EZ_TransSurf, inst)
    EZ_TransFactors[inst] = f
    inst.BackgroundTransparency = EZ_GlobalTransparency * f
    return inst
end

local function EZ_OnThemeChange(fn)
    table.insert(EZ_ThemeListeners, fn)
    return fn
end

local EZ_RepaintQueued = false
local function EZ_Repaint()
    if EZ_RepaintQueued then return end
    EZ_RepaintQueued = true
    task.defer(function()
        EZ_RepaintQueued = false
        for i = #EZ_Painters, 1, -1 do
            local entry = EZ_Painters[i]
            local ok = pcall(entry.fn)
            if not ok then table.remove(EZ_Painters, i) end
        end
    end)
end

local function EZ_ApplyThemeAndRepaint(name)
    local clean = tostring(name):lower():gsub("^%s+", ""):gsub("%s+$", "")
    local resolved = EZ_ThemeAliases[clean] or name
    local t = EZ_Themes[resolved] or EZ_Themes.Default
    EZ_CurrentThemeName = resolved
    for k, v in pairs(t) do EZ_Theme[k] = v end
    if not EZ_Theme.Radius then EZ_Theme.Radius = 8 end
    if not EZ_Theme.RadiusWindow then EZ_Theme.RadiusWindow = 12 end
    EZ_Repaint()
    for _, fn in ipairs(EZ_ThemeListeners) do
        pcall(fn, EZ_CurrentThemeName)
    end
end

function EZ:SetTheme(name)
    EZ_ApplyThemeAndRepaint(name)
end

function EZ:SetAccent(color)
    if EZ_CurrentWindow then
        EZ_CurrentWindow:SetAccent(color)
    else
        EZ_Theme.Accent = color
        local r, g, b = color.R * 255, color.G * 255, color.B * 255
        EZ_Theme.AccentDim = EZ_C(math.floor(r * 0.75), math.floor(g * 0.75), math.floor(b * 0.75))
        EZ_Repaint()
    end
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

local EZ_LogoUrl = "https://raw.githubusercontent.com/akiradv/eazyuilib/main/assets/logo.png"

local function EZ_LoadLogo()
    if EZ_LogoAsset then return EZ_LogoAsset end
    pcall(function()
        if not (writefile and isfile and getcustomasset) then return end
        local fname = "eazyui_logo_" .. EZ.Version:gsub("%.", "") .. ".png"
        if isfile(fname) then
            EZ_LogoAsset = getcustomasset(fname)
            pcall(function()
                if listfiles then
                    local files = listfiles("")
                    for _, f in ipairs(files or {}) do
                        local n = f:match("([^/\\]+)$") or f
                        if n:find("eazyui_logo_", 1, true) == 1 and n ~= fname then
                            pcall(function() delfile(n) end)
                        end
                    end
                end
            end)
            return
        end
        local data = game:HttpGet(EZ_LogoUrl)
        if data and #data > 0 then
            writefile(fname, data)
            EZ_LogoAsset = getcustomasset(fname)
        end
    end)
    return EZ_LogoAsset
end

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
        if icon:match("^rbxassetid://%d+$") then return icon end
        local set, name = icon:match("^(%w+):(.+)$")
        if set and name then
            local iconSet = EZ_IconSets[set:lower()]
            if iconSet and iconSet[name:lower()] then return iconSet[name:lower()] end
            return nil
        end
        local lucide = EZ_IconSets.lucide
        local lower = icon:lower()
        if lucide[lower] then return lucide[lower] end
        local withHyphens = lower:gsub(" ", "-")
        if lucide[withHyphens] then return lucide[withHyphens] end
        return nil
    elseif type(icon) == "number" then
        return "rbxassetid://" .. tostring(icon)
    end
    return nil
end

local function EZ_CreateIcon(parent, icon, size)
    local asset = EZ_ResolveIcon(icon)
    local img = Instance.new("ImageLabel")
    img.BackgroundTransparency = 1
    img.Size = UDim2.fromOffset(size or 16, size or 16)
    img.ScaleType = Enum.ScaleType.Fit
    img.Parent = parent
    if asset then
        img.Image = asset
    else
        img.Image = ""
        img.BackgroundColor3 = EZ_Theme.TextDim
        img.BackgroundTransparency = 0.7
        local pc = Instance.new("UICorner")
        pc.CornerRadius = UDim.new(0, 3)
        pc.Parent = img
    end
    return img
end

local EZ_TITLEBAR_HEIGHT = 44
local EZ_SIDEBAR_WIDTH = 180
local EZ_NOTIFY_WIDTH = 300
local EZ_ConfigFolder = "EazyUI_Configs"
local EZ_AutoSave = true

local function EZ_KeyFilePath(configId)
    local safeId = tostring(configId or "global"):gsub("[^%w%-_]", "_")
    return "eazyui_key_" .. safeId .. ".json"
end

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
EZ_NotifyContainer.Size = UDim2.fromOffset(EZ_NOTIFY_WIDTH, 600)
EZ_NotifyContainer.BackgroundTransparency = 1
EZ_NotifyContainer.Parent = EZ_NotifyGui

local EZ_NotifyLayout = Instance.new("UIListLayout")
EZ_NotifyLayout.Padding = UDim.new(0, 8)
EZ_NotifyLayout.Parent = EZ_NotifyContainer

local function EZ_UpdateNotifyPosition()
    local pos = EZ_NotifyPosition
    if pos == "BottomRight" then
        EZ_NotifyContainer.AnchorPoint = Vector2.new(1, 1)
        EZ_NotifyContainer.Position = UDim2.new(1, -24, 1, -24)
        EZ_NotifyLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
        EZ_NotifyLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    elseif pos == "BottomLeft" then
        EZ_NotifyContainer.AnchorPoint = Vector2.new(0, 1)
        EZ_NotifyContainer.Position = UDim2.new(0, 24, 1, -24)
        EZ_NotifyLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
        EZ_NotifyLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    elseif pos == "TopRight" then
        EZ_NotifyContainer.AnchorPoint = Vector2.new(1, 0)
        EZ_NotifyContainer.Position = UDim2.new(1, -24, 0, 24)
        EZ_NotifyLayout.VerticalAlignment = Enum.VerticalAlignment.Top
        EZ_NotifyLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    elseif pos == "TopLeft" then
        EZ_NotifyContainer.AnchorPoint = Vector2.new(0, 0)
        EZ_NotifyContainer.Position = UDim2.new(0, 24, 0, 24)
        EZ_NotifyLayout.VerticalAlignment = Enum.VerticalAlignment.Top
        EZ_NotifyLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    end
end
EZ_UpdateNotifyPosition()

local function EZ_AddStroke(parent, color, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color or EZ_Theme.Border
    s.Thickness = thickness or 1
    local isTextObj = parent:IsA("TextBox") or parent:IsA("TextLabel") or parent:IsA("TextButton")
    s.ApplyStrokeMode = isTextObj and Enum.ApplyStrokeMode.Border or Enum.ApplyStrokeMode.Contextual
    s.Parent = parent
    table.insert(EZ_StrokeSurf, s)
    s.Transparency = EZ_Clamp(EZ_GlobalTransparency * 2, 0, 1)
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

local function EZ_ApplyTransparency(t)
    EZ_GlobalTransparency = EZ_Clamp(t, 0, 0.9)
    for _, inst in ipairs(EZ_TransSurf) do
        if inst.Parent then
            inst.BackgroundTransparency = EZ_GlobalTransparency * (EZ_TransFactors[inst] or 0.55)
        end
    end
    for _, s in ipairs(EZ_StrokeSurf) do
        if s.Parent then
            s.Transparency = EZ_Clamp(EZ_GlobalTransparency * 2, 0, 1)
        end
    end
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

local EZ_DropdownList = Instance.new("ScrollingFrame")
EZ_DropdownList.Size = UDim2.new(1, 0, 1, 0)
EZ_DropdownList.BackgroundTransparency = 1
EZ_DropdownList.ClipsDescendants = true
EZ_DropdownList.ZIndex = 61
EZ_DropdownList.ScrollBarThickness = 3
EZ_DropdownList.ScrollBarImageColor3 = EZ_Theme.BorderHover
EZ_DropdownList.AutomaticCanvasSize = Enum.AutomaticSize.Y
EZ_DropdownList.CanvasSize = UDim2.new(0, 0, 0, 0)
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
        TweenService:Create(prev.sign, EZ_Ease.Med, { Rotation = 0 }):Play()
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
        TweenService:Create(EZ_DropdownCurrent.sign, EZ_Ease.Med, { Rotation = 0 }):Play()
    end
    EZ_DropdownCurrent = entry
    for _, child in ipairs(EZ_DropdownList:GetChildren()) do
        if child:IsA("TextButton") or child:IsA("TextBox") then child:Destroy() end
    end
    local optionButtons = {}
    if entry.searchable then
        local search = Instance.new("TextBox")
        search.Size = UDim2.new(1, 0, 0, 30)
        search.BackgroundColor3 = EZ_Theme.Card
        search.BorderSizePixel = 0
        search.Text = ""
        search.PlaceholderText = EZ_Locale.Search
        search.Font = EZ_Brand.FontBody
        search.TextSize = 12
        search.TextColor3 = EZ_Theme.Text
        search.PlaceholderColor3 = EZ_Theme.TextDim
        search.TextXAlignment = Enum.TextXAlignment.Left
        search.ClearTextOnFocus = false
        search.ZIndex = 61
        search.Parent = EZ_DropdownList
        local sp = Instance.new("UIPadding")
        sp.PaddingLeft = UDim.new(0, 12)
        sp.Parent = search
        search:GetPropertyChangedSignal("Text"):Connect(function()
            local q = search.Text:lower()
            for _, data in ipairs(optionButtons) do
                data.btn.Visible = q == "" or data.name:lower():find(q, 1, true) ~= nil
            end
        end)
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
        table.insert(optionButtons, { btn = op, name = tostring(v) })
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
    local popH = math.min(#values * 30 + (entry.searchable and 38 or 8), 220)
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
    EZ_DropdownList.CanvasPosition = Vector2.new(0, 0)
    EZ_DropdownPopup.Position = UDim2.fromOffset(x, y)
    EZ_DropdownPopup.Visible = true
    EZ_DropdownPopup.Size = UDim2.fromOffset(popW, 0)
    if entry.sign then
        TweenService:Create(entry.sign, EZ_Ease.Med, { Rotation = 180 }):Play()
    end
    TweenService:Create(EZ_DropdownPopup, EZ_Ease.Med, { Size = UDim2.fromOffset(popW, popH) }):Play()
end

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if EZ_DropdownCurrent and input.KeyCode == Enum.KeyCode.Escape then
        EZ_CloseDropdown()
        return
    end
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

local function EZ_ClampToViewport(frame)
    local vp = EZ_Gui.AbsoluteSize
    local pos = frame.Position
    local size = frame.AbsoluteSize
    local x = pos.X.Offset
    local y = pos.Y.Offset
    local maxX = vp.X - size.X - 4
    local maxY = vp.Y - size.Y - 4
    x = EZ_Clamp(x, 4, math.max(4, maxX))
    y = EZ_Clamp(y, 4, math.max(4, maxY))
    if x ~= pos.X.Offset or y ~= pos.Y.Offset then
        frame.Position = UDim2.new(pos.X.Scale, x, pos.Y.Scale, y)
    end
end

local function EZ_MakeDraggable(frame, handle)
    local dragging, start, startPos = false, nil, nil
    handle.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            start = i.Position
            startPos = frame.Position
            EZ_CloseDropdown()
        end
    end)
    handle.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = false
            EZ_ClampToViewport(frame)
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local d = i.Position - start
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
end

local function EZ_NewRow(page, height, element)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, height)
    row.BackgroundColor3 = EZ_Theme.Card
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
    end, element)
    EZ_Connect(row, row.MouseEnter, function()
        hovering = true
        TweenService:Create(st, EZ_Ease.Fast, { Color = EZ_Theme.BorderHover }):Play()
        TweenService:Create(row, EZ_Ease.Fast, { BackgroundColor3 = EZ_Theme.CardHover }):Play()
    end)
    EZ_Connect(row, row.MouseLeave, function()
        hovering = false
        TweenService:Create(st, EZ_Ease.Fast, { Color = EZ_Theme.Border }):Play()
        TweenService:Create(row, EZ_Ease.Fast, { BackgroundColor3 = EZ_Theme.Card }):Play()
    end)
    return row
end

local function EZ_RowTitle(row, text, desc, height, rightPad, element)
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
    EZ_Paint(function() l.TextColor3 = EZ_Theme.Text end, element)
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
        EZ_Paint(function() d.TextColor3 = EZ_Theme.TextDim end, element)
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
            local cfgName = name:sub(#base + 1, #name - 5)
            if cfgName ~= "_autoload" then
                table.insert(configs, cfgName)
            end
        end
    end
    return configs
end

local function EZ_AutoloadPath(configId)
    return EZ_ConfigFolder .. "/" .. tostring(configId) .. "__autoload.json"
end

local function EZ_GetAutoloadName(configId)
    if not readfile or not isfile then return nil end
    local ok, name = pcall(function()
        local p = EZ_AutoloadPath(configId)
        if isfile(p) then
            local d = HttpService:JSONDecode(readfile(p))
            return d and d.name or nil
        end
        return nil
    end)
    return ok and name or nil
end

local function EZ_SetAutoloadName(configId, name)
    if not writefile then return false end
    return pcall(function()
        if not isfolder(EZ_ConfigFolder) then makefolder(EZ_ConfigFolder) end
        writefile(EZ_AutoloadPath(configId), HttpService:JSONEncode({ name = name }))
    end)
end

local function EZ_SaveKey(key, duration, filename)
    if not writefile then return false end
    return pcall(function()
        writefile(filename, HttpService:JSONEncode({ key = key, timestamp = os.time(), expiresAt = os.time() + (duration or 86400) }))
    end)
end

local function EZ_ClearKey(filename)
    if not delfile then return false end
    return pcall(function() if isfile(filename) then delfile(filename) end end)
end

local function EZ_LoadKey(filename)
    if not readfile or not isfile then return nil end
    local ok, data = pcall(function()
        if isfile(filename) then
            local d = HttpService:JSONDecode(readfile(filename))
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
    local card = Instance.new("Frame")
    card.AnchorPoint = Vector2.new(0.5, 0.5)
    card.Position = UDim2.new(0.5, 0, 0.5, 0)
    card.Size = UDim2.fromOffset(460, 170)
    card.BackgroundColor3 = EZ_Theme.Background
    card.BorderSizePixel = 0
    card.Parent = gui
    EZ_AddRadius(card, EZ_Theme.RadiusWindow)
    local cardStroke = EZ_AddStroke(card, EZ_Theme.Border)
    local holder = Instance.new("Frame")
    holder.Size = UDim2.new(1, 0, 1, 0)
    holder.BackgroundTransparency = 1
    holder.Parent = card
    local lay = Instance.new("UIListLayout")
    lay.FillDirection = Enum.FillDirection.Vertical
    lay.HorizontalAlignment = Enum.HorizontalAlignment.Center
    lay.VerticalAlignment = Enum.VerticalAlignment.Center
    lay.Padding = UDim.new(0, 10)
    lay.Parent = holder
    local letter, fadeProp
    if EZ_LogoAsset then
        letter = Instance.new("ImageLabel")
        letter.Size = UDim2.fromOffset(56, 56)
        letter.BackgroundTransparency = 1
        letter.Image = EZ_LogoAsset
        letter.ScaleType = Enum.ScaleType.Fit
        letter.ImageTransparency = 1
        letter.Parent = holder
        fadeProp = "ImageTransparency"
    else
        letter = Instance.new("TextLabel")
        letter.Size = UDim2.fromOffset(60, 60)
        letter.BackgroundTransparency = 1
        letter.Text = "E"
        letter.Font = EZ_Brand.Font
        letter.TextSize = 44
        letter.TextColor3 = EZ_Theme.Accent
        letter.TextTransparency = 1
        letter.Parent = holder
        fadeProp = "TextTransparency"
        EZ_Paint(function() letter.TextColor3 = EZ_Theme.Accent end)
    end
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.fromOffset(420, 24)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title or EZ_Locale.Loading
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
    subLabel.Text = subtitle or EZ_Locale.PleaseWait
    subLabel.Font = EZ_Brand.FontBody
    subLabel.TextSize = 12
    subLabel.TextColor3 = EZ_Theme.TextDim
    subLabel.TextXAlignment = Enum.TextXAlignment.Center
    subLabel.TextTruncate = Enum.TextTruncate.AtEnd
    subLabel.TextTransparency = 1
    subLabel.Parent = holder
    EZ_Paint(function() subLabel.TextColor3 = EZ_Theme.TextDim end)
    local fadeInfo = TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    TweenService:Create(letter, fadeInfo, { [fadeProp] = 0 }):Play()
    TweenService:Create(titleLabel, fadeInfo, { TextTransparency = 0 }):Play()
    TweenService:Create(subLabel, fadeInfo, { TextTransparency = 0 }):Play()
    task.wait(duration or 2)
    local outInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
    TweenService:Create(letter, outInfo, { [fadeProp] = 1 }):Play()
    TweenService:Create(titleLabel, outInfo, { TextTransparency = 1 }):Play()
    TweenService:Create(subLabel, outInfo, { TextTransparency = 1 }):Play()
    TweenService:Create(card, outInfo, { BackgroundTransparency = 1 }):Play()
    TweenService:Create(cardStroke, outInfo, { Transparency = 1 }):Play()
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
    local iconLetter
    if EZ_LogoAsset then
        iconLetter = Instance.new("ImageLabel")
        iconLetter.Size = UDim2.new(1, -8, 1, -8)
        iconLetter.Position = UDim2.fromOffset(4, 4)
        iconLetter.BackgroundTransparency = 1
        iconLetter.Image = EZ_LogoAsset
        iconLetter.ScaleType = Enum.ScaleType.Fit
        iconLetter.Parent = iconFrame
    else
        iconLetter = Instance.new("TextLabel")
        iconLetter.Size = UDim2.new(1, 0, 1, 0)
        iconLetter.BackgroundTransparency = 1
        iconLetter.Text = "D"
        iconLetter.Font = EZ_Brand.Font
        iconLetter.TextSize = 28
        iconLetter.TextColor3 = EZ_Theme.Background
        iconLetter.Parent = iconFrame
        EZ_Paint(function() iconLetter.TextColor3 = EZ_Theme.Background end)
    end
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -40, 0, 24)
    title.Position = UDim2.new(0.5, 0, 0, 80)
    title.AnchorPoint = Vector2.new(0.5, 0)
    title.BackgroundTransparency = 1
    title.Text = EZ_Locale.JoinDiscord
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
    sub.Text = EZ_Locale.DiscordSubtitle
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
    copyBtn.Size = UDim2.new(0.5, -19, 0, 42)
    copyBtn.Position = UDim2.new(0, 14, 0, 216)
    copyBtn.BackgroundColor3 = EZ_Theme.Accent
    copyBtn.BorderSizePixel = 0
    copyBtn.Text = EZ_Locale.CopyLink
    copyBtn.Font = EZ_Brand.FontBody
    copyBtn.TextSize = 14
    copyBtn.TextColor3 = EZ_Theme.Background
    copyBtn.AutoButtonColor = false
    copyBtn.Parent = frame
    EZ_AddRadius(copyBtn, EZ_Theme.Radius)
    EZ_Paint(function() copyBtn.BackgroundColor3 = EZ_Theme.Accent; copyBtn.TextColor3 = EZ_Theme.Background end)
    local skipBtn = Instance.new("TextButton")
    skipBtn.Size = UDim2.new(0.5, -19, 0, 42)
    skipBtn.Position = UDim2.new(0.5, 5, 0, 216)
    skipBtn.BackgroundColor3 = EZ_Theme.CardHover
    skipBtn.BorderSizePixel = 0
    skipBtn.Text = EZ_Locale.Skip
    skipBtn.Font = EZ_Brand.FontBody
    skipBtn.TextSize = 14
    skipBtn.TextColor3 = EZ_Theme.TextDim
    skipBtn.AutoButtonColor = false
    skipBtn.Parent = frame
    local skipSt = EZ_AddStroke(skipBtn, EZ_Theme.Border)
    EZ_AddRadius(skipBtn, EZ_Theme.Radius)
    EZ_Paint(function() skipBtn.BackgroundColor3 = EZ_Theme.CardHover; skipBtn.TextColor3 = EZ_Theme.TextDim end)
    skipBtn.MouseEnter:Connect(function() TweenService:Create(skipSt, EZ_Ease.Fast, { Color = EZ_Theme.Accent }):Play() end)
    skipBtn.MouseLeave:Connect(function() TweenService:Create(skipSt, EZ_Ease.Fast, { Color = EZ_Theme.Border }):Play() end)
    copyBtn.MouseButton1Click:Connect(function()
        local link = "https://discord.gg/" .. invite
        local copied = false
        if setclipboard then setclipboard(link); copied = true
        elseif toclipboard then toclipboard(link); copied = true end
        if copied then
            copyBtn.Text = EZ_Locale.Copied
            task.delay(1.5, function()
                if copyBtn.Parent then copyBtn.Text = EZ_Locale.CopyLink end
            end)
        else
            copyBtn.Text = link
            task.delay(3, function()
                if copyBtn.Parent then copyBtn.Text = EZ_Locale.CopyLink end
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
    title.Text = options.Title or EZ_Locale.EnterKey
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
    sub.Text = options.Subtitle or EZ_Locale.EnterKeySubtitle
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
    input.PlaceholderText = EZ_Locale.EnterKeyPlaceholder
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
    submit.Size = UDim2.new(0.5, -19, 0, 38)
    submit.Position = UDim2.new(0, 14, 0, 155)
    submit.BackgroundColor3 = EZ_Theme.Accent
    submit.BorderSizePixel = 0
    submit.Text = EZ_Locale.Submit
    submit.Font = EZ_Brand.FontBody
    submit.TextSize = 13
    submit.TextColor3 = EZ_Theme.Background
    submit.AutoButtonColor = false
    submit.Parent = frame
    EZ_AddRadius(submit, EZ_Theme.Radius)
    EZ_Paint(function() submit.BackgroundColor3 = EZ_Theme.Accent; submit.TextColor3 = EZ_Theme.Background end)
    local cancel = Instance.new("TextButton")
    cancel.Size = UDim2.new(0.5, -19, 0, 38)
    cancel.Position = UDim2.new(0.5, 5, 0, 155)
    cancel.BackgroundColor3 = EZ_Theme.CardHover
    cancel.BorderSizePixel = 0
    cancel.Text = EZ_Locale.Cancel
    cancel.Font = EZ_Brand.FontBody
    cancel.TextSize = 13
    cancel.TextColor3 = EZ_Theme.TextDim
    cancel.AutoButtonColor = false
    cancel.Parent = frame
    local cst = EZ_AddStroke(cancel, EZ_Theme.Border)
    EZ_AddRadius(cancel, EZ_Theme.Radius)
    EZ_Paint(function() cancel.BackgroundColor3 = EZ_Theme.CardHover; cancel.TextColor3 = EZ_Theme.TextDim end)
    cancel.MouseEnter:Connect(function() TweenService:Create(cst, EZ_Ease.Fast, { Color = EZ_Theme.Accent }):Play() end)
    cancel.MouseLeave:Connect(function() TweenService:Create(cst, EZ_Ease.Fast, { Color = EZ_Theme.Border }):Play() end)
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
        err.Text = EZ_Locale.Validating
        err.TextColor3 = EZ_Theme.TextDim
        task.spawn(function()
            local resolved = false
            local result = false
            task.spawn(function()
                result = EZ_ValidateKey(key, validator)
                resolved = true
            end)
            local start = tick()
            while not resolved and tick() - start < 5 do task.wait(0.05) end
            if not resolved then
                err.Text = "Timeout validating key."
                err.TextColor3 = EZ_Theme.Error
                return
            end
            if result then
                EZ_SaveKey(key, EZ_KeyDurationGlobal, options.FileName)
                gui:Destroy()
                callback(true, key)
            else
                err.Text = EZ_Locale.InvalidKey
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

local function EZ_FlushNotifyQueue()
    while #EZ_NotifyVisible >= EZ_NotifyMax and #EZ_NotifyQueue > 0 do
        local oldest = EZ_NotifyVisible[1]
        if oldest and oldest.destroy then oldest.destroy() end
    end
    while #EZ_NotifyQueue > 0 and #EZ_NotifyVisible < EZ_NotifyMax do
        local data = table.remove(EZ_NotifyQueue, 1)
        data.render()
    end
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
    local inputCallback = options.InputCallback
    local hasInput = options.Input == true
    local hasButtons = #buttons > 0 or hasInput
    local height = hasInput and 110 or (hasButtons and 92 or 66)
    local styleColor = EZ_Theme.Info
    if style == "success" then styleColor = EZ_Theme.Success
    elseif style == "warning" then styleColor = EZ_Theme.Warning
    elseif style == "error" then styleColor = EZ_Theme.Error end

    local function render()
        local holder = Instance.new("Frame")
        holder.Size = UDim2.fromOffset(0, height)
        holder.BackgroundTransparency = 1
        holder.ClipsDescendants = true
        holder.Parent = EZ_NotifyContainer
        local card = Instance.new("Frame")
        card.Size = UDim2.fromOffset(EZ_NOTIFY_WIDTH, height)
        card.BackgroundColor3 = EZ_Theme.Card
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
        
        local inputBox = nil
        if hasInput then
            inputBox = Instance.new("TextBox")
            inputBox.Size = UDim2.new(1, -36, 0, 26)
            inputBox.Position = UDim2.fromOffset(18, 58)
            inputBox.BackgroundColor3 = EZ_Theme.Background
            inputBox.BorderSizePixel = 0
            inputBox.Text = ""
            inputBox.PlaceholderText = options.InputPlaceholder or "Type here..."
            inputBox.Font = EZ_Brand.FontMono
            inputBox.TextSize = 12
            inputBox.TextColor3 = EZ_Theme.Text
            inputBox.PlaceholderColor3 = EZ_Theme.TextDim
            inputBox.TextXAlignment = Enum.TextXAlignment.Left
            inputBox.ClearTextOnFocus = false
            inputBox.Parent = card
            local ibst = EZ_AddStroke(inputBox, EZ_Theme.Border)
            EZ_AddRadius(inputBox, 4)
            local ibpad = Instance.new("UIPadding")
            ibpad.PaddingLeft = UDim.new(0, 8); ibpad.PaddingRight = UDim.new(0, 8); ibpad.Parent = inputBox
            inputBox.Focused:Connect(function() ibst.Color = EZ_Theme.Accent end)
            inputBox.FocusLost:Connect(function(enter)
                ibst.Color = EZ_Theme.Border
                if enter and inputCallback then
                    inputCallback(inputBox.Text)
                end
            end)
        end
        
        if hasButtons and not hasInput then
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
                btn.MouseEnter:Connect(function() TweenService:Create(bst, EZ_Ease.Fast, { Color = EZ_Theme.Accent }):Play() end)
                btn.MouseLeave:Connect(function() TweenService:Create(bst, EZ_Ease.Fast, { Color = EZ_Theme.Border }):Play() end)
                btn.MouseButton1Click:Connect(function()
                    if btnData.Callback then btnData.Callback() end
                    destroyNotify()
                    if onClose then onClose("Action") end
                end)
            end
        end
        
        local timer = nil
        if d > 0 and not hasInput then
            timer = Instance.new("Frame")
            timer.Size = UDim2.new(1, -16, 0, 2)
            timer.Position = UDim2.fromOffset(8, height - 6)
            timer.BackgroundColor3 = styleColor
            timer.BackgroundTransparency = 0.5
            timer.BorderSizePixel = 0
            timer.Parent = card
            EZ_AddRadius(timer, 1)
        end
        if onOpen then onOpen() end
        local entry = { holder = holder }
        table.insert(EZ_NotifyVisible, entry)
        function entry.destroy()
            for i, e in ipairs(EZ_NotifyVisible) do
                if e == entry then table.remove(EZ_NotifyVisible, i); break end
            end
            if holder.Parent then
                TweenService:Create(holder, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.In), { Size = UDim2.fromOffset(0, height) }):Play()
                task.delay(0.22, function()
                    holder:Destroy()
                    EZ_FlushNotifyQueue()
                end)
            end
        end
        TweenService:Create(holder, TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { Size = UDim2.fromOffset(EZ_NOTIFY_WIDTH, height) }):Play()
        if timer then
            TweenService:Create(timer, TweenInfo.new(d, Enum.EasingStyle.Linear), { Size = UDim2.new(0, 0, 0, 2) }):Play()
        end
        if d > 0 and not hasInput then
            task.delay(d, function()
                if holder.Parent then
                    entry.destroy()
                    if onClose then onClose("Timeout") end
                end
            end)
        end
    end

    table.insert(EZ_NotifyQueue, { render = render })
    EZ_FlushNotifyQueue()
end

function EZ:CreateWindow(options)
    options = options or {}
    local EZ_Name = options.Name or "Eazy UI"
    local EZ_SubTitle = options.SubTitle or ""
    local EZ_Size = options.Size or UDim2.fromOffset(620, 440)
    local EZ_MinKey = options.MinimizeKey or Enum.KeyCode.RightControl
    local EZ_ConfigId = options.ConfigId or tostring(game.PlaceId)
    local EZ_KeyFile = EZ_KeyFilePath(EZ_ConfigId)
    EZ_KeyDurationGlobal = options.KeyDuration or 86400
    EZ_GlobalTransparency = EZ_Clamp(options.Transparency or 0, 0, 0.9)
    local EZ_AutoLoad = options.AutoLoad ~= false
    if options.NotifyPosition then
        EZ_NotifyPosition = options.NotifyPosition
        EZ_UpdateNotifyPosition()
    end
    EZ_LoadLogo()

    if options.LoadingTitle then
        EZ_ShowLoadingScreen(options.LoadingTitle, options.LoadingSubtitle or "", options.LoadingDuration or 2)
    end
    if options.Discord and options.Discord.Enabled then
        local resolved = false
        EZ_ShowDiscordPrompt(options.Discord.Invite, function() resolved = true end)
        local start = tick()
        while not resolved and tick() - start < 30 do task.wait(0.1) end
    end
    if options.KeySystem and options.KeySystem.Enabled then
        local keyOptions = { Title = options.KeySystem.Title, Subtitle = options.KeySystem.Subtitle, Note = options.KeySystem.Note, FileName = EZ_KeyFile }
        local savedKey = EZ_LoadKey(EZ_KeyFile)
        if not (savedKey and EZ_ValidateKey(savedKey, options.KeySystem.validator)) then
            local resolved, success = false, false
            EZ_ShowKeyScreen(keyOptions, options.KeySystem.validator, function(s) success = s; resolved = true end)
            local start = tick()
            while not resolved and tick() - start < 30 do task.wait(0.1) end
            if not success then
                EZ:Notify({ Title = "Eazy UI", Content = EZ_Locale.AccessDenied, Style = "Error", Duration = 3 })
                return nil
            end
        end
    end

    local EZ_Window = {}
    EZ_Window.Minimized = false
    EZ_Window.ConfigData = {}
    EZ_Window.Elements = {}
    EZ_Window.CurrentConfig = "default"
    EZ_Window._pendingConfigSync = nil
    EZ_CurrentWindow = EZ_Window

    function EZ_Window:SetAccent(color)
        EZ_Theme.Accent = color
        local r, g, b = color.R * 255, color.G * 255, color.B * 255
        EZ_Theme.AccentDim = EZ_C(math.floor(r * 0.75), math.floor(g * 0.75), math.floor(b * 0.75))
        EZ_Repaint()
    end

    local function EZ_SyncConfigDropdown(name)
        if not EZ_Window._configDropdown then
            EZ_Window._pendingConfigSync = name
            return
        end
        local currentValues = {}
        local getter = EZ_Window._configDropdown.getValues
        if getter then
            for _, v in ipairs(getter()) do table.insert(currentValues, v) end
        end
        local found = false
        for _, v in ipairs(currentValues) do if v == name then found = true break end end
        if not found then
            table.insert(currentValues, name)
            EZ_Window._configDropdown:SetValues(currentValues)
        end
        EZ_Window._configDropdown:Set(name, true)
    end

    local function EZ_ApplyConfigData(data, isAutoLoad)
        if not data then return false end
        local ignored = 0
        if not isAutoLoad then
            for key, _ in pairs(data) do
                if key ~= "_meta" then
                    local found = false
                    for _, el in ipairs(EZ_Window.Elements) do
                        if el.Id == key then found = true break end
                    end
                    if not found then ignored = ignored + 1 end
                end
            end
        end
        if data._meta then
            if data._meta.theme then EZ_ApplyThemeAndRepaint(data._meta.theme) end
            if data._meta.transparency then EZ_Window:SetTransparency(data._meta.transparency) end
            if data._meta.autoSave ~= nil then EZ_AutoSave = data._meta.autoSave end
        end
        if EZ_Window._themeDropdown then
            EZ_Window._themeDropdown:Set(EZ_CurrentThemeName, true)
        end
        if data._minimize_key and data._minimize_key.value then
            local key = Enum.KeyCode[data._minimize_key.value]
            if key then EZ_MinKey = key end
        end
        for _, el in ipairs(EZ_Window.Elements) do
            local d = data[el.Id]
            if d then
                if d.type == "color" then
                    el:Set(Color3.fromRGB(d.value[1], d.value[2], d.value[3]), false)
                elseif d.type == "keybind" then
                    local key = d.value and Enum.KeyCode[d.value] or nil
                    el:Set(key, true)
                    if el.Id == "_minimize_key" and key then EZ_MinKey = key end
                elseif d.type == "multi" then
                    el:Set(d.value, false)
                elseif d.type == "range" then
                    el:Set(d.value, false)
                else
                    el:Set(d.value, false)
                end
            end
        end
        if ignored > 0 and not isAutoLoad then
            task.spawn(function()
                EZ:Notify({ Title = "Config", Content = ignored .. " saved field(s) no longer exist and were skipped.", Style = "Warning", Duration = 3 })
            end)
        end
        return true
    end

    local function EZ_BuildWindow()
        local frame = Instance.new("Frame")
        frame.Name = "Window"
        frame.Size = UDim2.fromOffset(EZ_Size.X.Offset * 0.96, EZ_Size.Y.Offset * 0.96)
        frame.AnchorPoint = Vector2.new(0.5, 0.5)
        frame.Position = UDim2.fromScale(0.5, 0.5)
        frame.BackgroundColor3 = EZ_Theme.Background
        frame.BorderSizePixel = 0
        frame.ClipsDescendants = true
        frame.Parent = EZ_Gui
        EZ_AddStroke(frame, EZ_Theme.Border)
        EZ_AddRadius(frame, EZ_Theme.RadiusWindow)
        EZ_RegTrans(frame, 1)
        EZ_Paint(function() frame.BackgroundColor3 = EZ_Theme.Background end)

TweenService:Create(frame,TweenInfo.new(0.3,Enum.EasingStyle.Quint,Enum.EasingDirection.Out), {
    Size = EZ_Size
}):Play()

        local titlebar = Instance.new("Frame")
        titlebar.Size = UDim2.new(1, 0, 0, EZ_TITLEBAR_HEIGHT)
        titlebar.BackgroundColor3 = EZ_Theme.Card
        titlebar.BorderSizePixel = 0
        titlebar.Parent = frame
        EZ_AddRadius(titlebar, EZ_Theme.RadiusWindow)
        EZ_RegTrans(titlebar, 1)
        EZ_Paint(function() titlebar.BackgroundColor3 = EZ_Theme.Card end)

        local tbFill = Instance.new("Frame")
        tbFill.Size = UDim2.new(1, 0, 0, EZ_Theme.RadiusWindow)
        tbFill.Position = UDim2.new(0, 0, 1, -EZ_Theme.RadiusWindow)
        tbFill.BackgroundColor3 = EZ_Theme.Card
        tbFill.BorderSizePixel = 0
        tbFill.Parent = titlebar
        EZ_RegTrans(tbFill, 1)
        EZ_Paint(function() tbFill.BackgroundColor3 = EZ_Theme.Card end)

        local tline = Instance.new("Frame")
        tline.Size = UDim2.new(1, 0, 0, 1)
        tline.Position = UDim2.new(0, 0, 1, -1)
        tline.BackgroundColor3 = EZ_Theme.Border
        tline.BorderSizePixel = 0
        tline.Parent = titlebar
        EZ_RegTrans(tline, 1)
        EZ_Paint(function() tline.BackgroundColor3 = EZ_Theme.Border end)

        local logoLetter
        if EZ_LogoAsset then
            logoLetter = Instance.new("ImageLabel")
            logoLetter.Size = UDim2.fromOffset(24, 24)
            logoLetter.Position = UDim2.new(0, 14, 0.5, -12)
            logoLetter.BackgroundTransparency = 1
            logoLetter.Image = EZ_LogoAsset
            logoLetter.ScaleType = Enum.ScaleType.Fit
            logoLetter.Parent = titlebar
        else
            logoLetter = Instance.new("TextLabel")
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
        end

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
        sidebar.BorderSizePixel = 0
        sidebar.ClipsDescendants = true
        sidebar.Parent = frame
        EZ_AddRadius(sidebar, EZ_Theme.RadiusWindow)
        EZ_RegTrans(sidebar, 1)
        EZ_Paint(function() sidebar.BackgroundColor3 = EZ_Theme.Card end)

        local sbFillTop = Instance.new("Frame")
        sbFillTop.Size = UDim2.new(1, 0, 0, EZ_Theme.RadiusWindow)
        sbFillTop.Position = UDim2.new(0, 0, 0, 0)
        sbFillTop.BackgroundColor3 = EZ_Theme.Card
        sbFillTop.BorderSizePixel = 0
        sbFillTop.ZIndex = 10
        sbFillTop.Parent = sidebar
        EZ_RegTrans(sbFillTop, 1)
        EZ_Paint(function() sbFillTop.BackgroundColor3 = EZ_Theme.Card end)

        local sbFillRight = Instance.new("Frame")
        sbFillRight.Size = UDim2.new(0, EZ_Theme.RadiusWindow, 1, 0)
        sbFillRight.Position = UDim2.new(1, -EZ_Theme.RadiusWindow, 0, 0)
        sbFillRight.BackgroundColor3 = EZ_Theme.Card
        sbFillRight.BorderSizePixel = 0
        sbFillRight.ZIndex = 10
        sbFillRight.Parent = sidebar
        EZ_RegTrans(sbFillRight, 1)
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
        EZ_RegTrans(sline, 1)
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
                    BackgroundTransparency = d.Active and (EZ_GlobalTransparency * 0.55) or 1
                }):Play()
                TweenService:Create(d.Label, EZ_Ease.Fast, {
                    TextColor3 = d.Active and EZ_Theme.Text or EZ_Theme.TextDim
                }):Play()
                if d.Icon then
                    TweenService:Create(d.Icon, EZ_Ease.Fast, {
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
            TweenService:Create(minbtn, EZ_Ease.Fast, { BackgroundTransparency = 0 }):Play()
            TweenService:Create(minicon, EZ_Ease.Fast, { BackgroundColor3 = EZ_Theme.Text }):Play()
        end)
        minbtn.MouseLeave:Connect(function()
            TweenService:Create(minbtn, EZ_Ease.Fast, { BackgroundTransparency = 1 }):Play()
            TweenService:Create(minicon, EZ_Ease.Fast, { BackgroundColor3 = EZ_Theme.TextDim }):Play()
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
                    if iconLbl and iconLbl:IsA("ImageLabel") then iconLbl.ImageColor3 = EZ_Theme.Accent end
                else
                    lbl.TextColor3 = EZ_Theme.TextDim
                    if iconLbl and iconLbl:IsA("ImageLabel") then iconLbl.ImageColor3 = EZ_Theme.TextDim end
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
                    TweenService:Create(lbl, EZ_Ease.Fast, { TextColor3 = EZ_Theme.Text }):Play()
                    if iconLbl and iconLbl:IsA("ImageLabel") then
                        TweenService:Create(iconLbl, EZ_Ease.Fast, { ImageColor3 = EZ_Theme.Text }):Play()
                    end
                end
            end)
            btn.MouseLeave:Connect(function()
                if not data.Active then
                    TweenService:Create(lbl, EZ_Ease.Fast, { TextColor3 = EZ_Theme.TextDim }):Play()
                    if iconLbl and iconLbl:IsA("ImageLabel") then
                        TweenService:Create(iconLbl, EZ_Ease.Fast, { ImageColor3 = EZ_Theme.TextDim }):Play()
                    end
                end
            end)
            btn.MouseButton1Click:Connect(function() selectTab(data) end)
            if #registry == 1 then selectTab(data) end

            function tab:AddSection(o)
                o = o or {}
                local holder = Instance.new("Frame")
                holder:SetAttribute("EZ_Section", true)
                holder.Size = UDim2.new(1, 0, 0, 24)
                holder.BackgroundTransparency = 1
                holder.Parent = page
                local bar = Instance.new("Frame")
                bar.Size = UDim2.fromOffset(3, 12)
                bar.Position = UDim2.new(0, 2, 0.5, -6)
                bar.BackgroundColor3 = EZ_Theme.Accent
                bar.BorderSizePixel = 0
                bar.Parent = holder
                EZ_RegTrans(bar, 1)
                EZ_AddRadius(bar, 2)
                EZ_Paint(function() bar.BackgroundColor3 = EZ_Theme.Accent end)
                local t = Instance.new("TextLabel")
                t.Size = UDim2.new(1, -40, 1, 0)
                t.Position = UDim2.new(0, 11, 0, 0)
                t.BackgroundTransparency = 1
                t.Text = string.upper(o.Title or "")
                t.Font = EZ_Brand.FontBody
                t.TextSize = 11
                t.TextColor3 = EZ_Theme.TextDim
                t.TextXAlignment = Enum.TextXAlignment.Left
                t.Parent = holder
                EZ_Paint(function() t.TextColor3 = EZ_Theme.TextDim end)
                local chev = EZ_CreateIcon(holder, "chevron-down", 12)
                if chev then
                    chev.AnchorPoint = Vector2.new(1, 0.5)
                    chev.Position = UDim2.new(1, -2, 0.5, 0)
                    chev.ImageColor3 = EZ_Theme.TextDim
                end
                local collapsed = false
                local click = Instance.new("TextButton")
                click.Size = UDim2.new(1, 0, 1, 0)
                click.BackgroundTransparency = 1
                click.Text = ""
                click.AutoButtonColor = false
                click.Parent = holder
                click.MouseButton1Click:Connect(function()
                    collapsed = not collapsed
                    if chev then
                        TweenService:Create(chev, EZ_Ease.Med, { Rotation = collapsed and -90 or 0 }):Play()
                    end
                    local active = false
                    for _, child in ipairs(page:GetChildren()) do
                        if child == holder then
                            active = true
                        elseif child:GetAttribute("EZ_Section") then
                            active = false
                        elseif active then
                            child.Visible = not collapsed
                        end
                    end
                end)
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
                EZ_RegTrans(div, 1)
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
                local rightCb = o.RightClick or function() end
                local middleCb = o.MiddleClick or function() end
                local id = o.Flag or o.Id or o.Title or "toggle_" .. os.clock()
                local obj = { Value = o.Default and true or false, Id = id, Flag = o.Flag, Type = "toggle", Default = o.Default and true or false }
                local row = EZ_NewRow(page, 44, obj)
                EZ_RowTitle(row, o.Title or "Toggle", o.Description, 44, nil, obj)
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
                local function renderTween()
                    local on = obj.Value
                    TweenService:Create(track, TweenInfo.new(0.15), { BackgroundColor3 = on and EZ_Theme.Accent or EZ_Theme.BorderHover }):Play()
                    TweenService:Create(knob, TweenInfo.new(0.18, Enum.EasingStyle.Quint), {
                        Position = UDim2.fromOffset(on and 21 or 3, 3),
                        BackgroundColor3 = on and EZ_Theme.Background or EZ_Theme.TextDim
                    }):Play()
                end
                EZ_Paint(renderTween, obj)
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
                EZ_Connect(row, row.InputBegan, function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 then obj:Set(not obj.Value)
                    elseif i.UserInputType == Enum.UserInputType.MouseButton2 then rightCb(obj)
                    elseif i.UserInputType == Enum.UserInputType.MouseButton3 then middleCb(obj) end
                end)
                renderTween()
                if obj.Flag then table.insert(EZ_Window.Elements, obj) end
                obj._row = row
                return obj
            end

            function tab:AddButton(a, b)
                local o = EZ_Normalize(a, b)
                local cb = o.Callback or function() end
                local rightCb = o.RightClick or function() end
                local middleCb = o.MiddleClick or function() end
                local obj = {}
                local row = EZ_NewRow(page, 44, obj)
                EZ_RowTitle(row, o.Title or "Button", o.Description, 44, nil, obj)
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
                EZ_Paint(function() act.BackgroundColor3 = EZ_Theme.Accent; act.TextColor3 = EZ_Theme.Background end, obj)
                act.MouseEnter:Connect(function()
                    TweenService:Create(act, EZ_Ease.Fast, { BackgroundColor3 = EZ_Theme.AccentDim }):Play()
                end)
                act.MouseLeave:Connect(function()
                    TweenService:Create(act, EZ_Ease.Fast, { BackgroundColor3 = EZ_Theme.Accent }):Play()
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
                act.MouseButton2Click:Connect(function() rightCb(obj) end)
                EZ_Connect(act, act.InputBegan, function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton3 then middleCb(obj) end
                end)
                function obj:SetTitle(t) act.Text = t or "" end
                obj._row = row
                return obj
            end

            function tab:AddSlider(a, b)
                local o = EZ_Normalize(a, b)
                local mn, mx, st = o.Min or 0, o.Max or 100, o.Step or 1
                local cb = o.Callback or function() end
                local id = o.Flag or o.Id or o.Title or "slider_" .. os.clock()
                local obj = { Value = o.Default or mn, Id = id, Flag = o.Flag, Type = "slider", Default = o.Default or mn }
                local dragging = false
                local lastCallbackValue = obj.Value
                local row = EZ_NewRow(page, 62, obj)
                local tl = Instance.new("TextLabel")
                tl.Position = UDim2.fromOffset(12, 10)
                tl.Size = UDim2.new(1, -110, 0, 16)
                tl.BackgroundTransparency = 1
                tl.Text = o.Title or "Slider"
                tl.Font = EZ_Brand.FontBody; tl.TextSize = 13; tl.TextColor3 = EZ_Theme.Text
                tl.TextXAlignment = Enum.TextXAlignment.Left; tl.TextTruncate = Enum.TextTruncate.AtEnd
                tl.Parent = row
                EZ_Paint(function() tl.TextColor3 = EZ_Theme.Text end, obj)
                local vl = Instance.new("TextLabel")
                vl.AnchorPoint = Vector2.new(1, 0)
                vl.Position = UDim2.new(1, -12, 0, 10)
                vl.Size = UDim2.fromOffset(80, 16)
                vl.BackgroundTransparency = 1
                vl.Font = EZ_Brand.FontMono; vl.TextSize = 13; vl.TextColor3 = EZ_Theme.Accent
                vl.TextXAlignment = Enum.TextXAlignment.Right
                vl.Parent = row
                EZ_Paint(function() vl.TextColor3 = EZ_Theme.Accent end, obj)
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
                end, obj)
                local function applyVisual(raw)
                    local v = EZ_Round(EZ_Clamp(raw, mn, mx), st)
                    obj.Value = v
                    refreshVisual()
                end
                local function applyFinal(silent)
                    if not silent then
                        if obj.Value ~= lastCallbackValue then
                            lastCallbackValue = obj.Value
                            cb(obj.Value)
                            if obj.Flag and EZ_AutoSave then
                                EZ_Window.ConfigData[id] = { type = "slider", value = obj.Value }
                                EZ_Window:SaveConfig(EZ_Window.CurrentConfig)
                            end
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
                        dragging = true; applyVisual(fromPtr(i.Position.X))
                    end
                end)
                cap.InputEnded:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                        dragging = false
                        applyFinal(false)
                    end
                end)
                UserInputService.InputChanged:Connect(function(i)
                    if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
                        applyVisual(fromPtr(i.Position.X))
                    end
                end)
                local hovering = false
                row.MouseEnter:Connect(function() hovering = true end)
                row.MouseLeave:Connect(function() hovering = false end)
                UserInputService.InputChanged:Connect(function(i)
                    if hovering and i.UserInputType == Enum.UserInputType.MouseWheel then
                        applyVisual(obj.Value + (i.Position.Z > 0 and st or -st))
                        applyFinal(false)
                    end
                end)
                UserInputService.InputBegan:Connect(function(i, p)
                    if hovering and not p and not UserInputService:GetFocusedTextBox() then
                        if i.KeyCode == Enum.KeyCode.Left then applyVisual(obj.Value - st); applyFinal(false)
                        elseif i.KeyCode == Enum.KeyCode.Right then applyVisual(obj.Value + st); applyFinal(false) end
                    end
                end)
                local editBtn = Instance.new("TextButton")
                editBtn.AnchorPoint = Vector2.new(1, 0)
                editBtn.Position = UDim2.new(1, -12, 0, 10)
                editBtn.Size = UDim2.fromOffset(80, 16)
                editBtn.BackgroundTransparency = 1
                editBtn.Text = ""
                editBtn.AutoButtonColor = false
                editBtn.Parent = row
                editBtn.MouseButton1Click:Connect(function()
                    local box = Instance.new("TextBox")
                    box.AnchorPoint = Vector2.new(1, 0)
                    box.Position = UDim2.new(1, -12, 0, 8)
                    box.Size = UDim2.fromOffset(80, 20)
                    box.BackgroundColor3 = EZ_Theme.Card
                    box.BorderSizePixel = 0
                    box.Text = fmt(obj.Value)
                    box.Font = EZ_Brand.FontMono
                    box.TextSize = 13
                    box.TextColor3 = EZ_Theme.Accent
                    box.TextXAlignment = Enum.TextXAlignment.Right
                    box.Parent = row
                    EZ_AddRadius(box, 4)
                    vl.Visible = false
                    box:CaptureFocus()
                    box.FocusLost:Connect(function(enter)
                        if enter then
                            local n = tonumber(box.Text)
                            if n then applyVisual(n); applyFinal(false) end
                        end
                        box:Destroy()
                        vl.Visible = true
                    end)
                end)
                function obj:Set(n, silent)
                    applyVisual(tonumber(n) or mn)
                    applyFinal(silent)
                end
                applyVisual(obj.Value)
                if obj.Flag then table.insert(EZ_Window.Elements, obj) end
                obj._row = row
                return obj
            end

            function tab:AddRangeSlider(a, b)
                local o = EZ_Normalize(a, b)
                local mn, mx, st = o.Min or 0, o.Max or 100, o.Step or 1
                local cb = o.Callback or function() end
                local id = o.Flag or o.Id or o.Title or "range_" .. os.clock()
                local obj = { 
                    MinValue = (type(o.Default) == "table" and o.Default[1]) or mn,
                    MaxValue = (type(o.Default) == "table" and o.Default[2]) or mx,
                    Id = id, Flag = o.Flag, Type = "range",
                    Default = { (type(o.Default) == "table" and o.Default[1]) or mn, (type(o.Default) == "table" and o.Default[2]) or mx }
                }
                local draggingMin = false
                local draggingMax = false
                local lastCallbackMin = obj.MinValue
                local lastCallbackMax = obj.MaxValue
                local row = EZ_NewRow(page, 62, obj)
                local tl = Instance.new("TextLabel")
                tl.Position = UDim2.fromOffset(12, 10)
                tl.Size = UDim2.new(1, -180, 0, 16)
                tl.BackgroundTransparency = 1
                tl.Text = o.Title or "Range"
                tl.Font = EZ_Brand.FontBody; tl.TextSize = 13; tl.TextColor3 = EZ_Theme.Text
                tl.TextXAlignment = Enum.TextXAlignment.Left; tl.TextTruncate = Enum.TextTruncate.AtEnd
                tl.Parent = row
                EZ_Paint(function() tl.TextColor3 = EZ_Theme.Text end, obj)
                local vl = Instance.new("TextLabel")
                vl.AnchorPoint = Vector2.new(1, 0)
                vl.Position = UDim2.new(1, -12, 0, 10)
                vl.Size = UDim2.fromOffset(150, 16)
                vl.BackgroundTransparency = 1
                vl.Font = EZ_Brand.FontMono; vl.TextSize = 13; vl.TextColor3 = EZ_Theme.Accent
                vl.TextXAlignment = Enum.TextXAlignment.Right
                vl.Parent = row
                EZ_Paint(function() vl.TextColor3 = EZ_Theme.Accent end, obj)
                local track = Instance.new("Frame")
                track.Position = UDim2.fromOffset(12, 38)
                track.Size = UDim2.new(1, -24, 0, 6)
                track.BackgroundColor3 = EZ_Theme.BorderHover
                track.BorderSizePixel = 0
                track.Parent = row
                EZ_AddRadius(track, 3)
                local fill = Instance.new("Frame")
                fill.BackgroundColor3 = EZ_Theme.Accent
                fill.BorderSizePixel = 0
                fill.Parent = track
                EZ_AddRadius(fill, 3)
                local knobMin = Instance.new("Frame")
                knobMin.AnchorPoint = Vector2.new(0.5, 0.5)
                knobMin.Size = UDim2.fromOffset(14, 14)
                knobMin.BackgroundColor3 = EZ_Theme.Accent
                knobMin.BorderSizePixel = 0
                knobMin.ZIndex = 2
                knobMin.Parent = track
                EZ_AddRadius(knobMin, 7)
                local knobMax = Instance.new("Frame")
                knobMax.AnchorPoint = Vector2.new(0.5, 0.5)
                knobMax.Size = UDim2.fromOffset(14, 14)
                knobMax.BackgroundColor3 = EZ_Theme.Accent
                knobMax.BorderSizePixel = 0
                knobMax.ZIndex = 2
                knobMax.Parent = track
                EZ_AddRadius(knobMax, 7)
                local capMin = Instance.new("TextButton")
                capMin.Position = UDim2.fromOffset(12, 26)
                capMin.Size = UDim2.new(0.5, -12, 0, 24)
                capMin.BackgroundTransparency = 1
                capMin.Text = ""
                capMin.AutoButtonColor = false
                capMin.ZIndex = 3
                capMin.Parent = row
                local capMax = Instance.new("TextButton")
                capMax.Position = UDim2.new(0.5, 0, 0, 26)
                capMax.Size = UDim2.new(0.5, -12, 0, 24)
                capMax.BackgroundTransparency = 1
                capMax.Text = ""
                capMax.AutoButtonColor = false
                capMax.ZIndex = 3
                capMax.Parent = row
                local function fmt(n)
                    if st >= 1 then return tostring(math.floor(n + 0.5)) end
                    return string.format("%.1f", n)
                end
                local function refreshVisual()
                    local rMin = (mx - mn) == 0 and 0 or (obj.MinValue - mn) / (mx - mn)
                    local rMax = (mx - mn) == 0 and 0 or (obj.MaxValue - mn) / (mx - mn)
                    fill.Position = UDim2.new(rMin, 0, 0, 0)
                    fill.Size = UDim2.new(rMax - rMin, 0, 1, 0)
                    knobMin.Position = UDim2.new(rMin, 0, 0.5, 0)
                    knobMax.Position = UDim2.new(rMax, 0, 0.5, 0)
                    vl.Text = fmt(obj.MinValue) .. " - " .. fmt(obj.MaxValue)
                end
                EZ_Paint(function()
                    track.BackgroundColor3 = EZ_Theme.BorderHover
                    fill.BackgroundColor3 = EZ_Theme.Accent
                    knobMin.BackgroundColor3 = EZ_Theme.Accent
                    knobMax.BackgroundColor3 = EZ_Theme.Accent
                    refreshVisual()
                end, obj)
                local function applyVisualMin(raw)
                    local v = EZ_Round(EZ_Clamp(raw, mn, obj.MaxValue - st), st)
                    obj.MinValue = v
                    refreshVisual()
                end
                local function applyVisualMax(raw)
                    local v = EZ_Round(EZ_Clamp(raw, obj.MinValue + st, mx), st)
                    obj.MaxValue = v
                    refreshVisual()
                end
                local function applyFinal(silent)
                    if not silent then
                        if obj.MinValue ~= lastCallbackMin or obj.MaxValue ~= lastCallbackMax then
                            lastCallbackMin = obj.MinValue
                            lastCallbackMax = obj.MaxValue
                            cb({ obj.MinValue, obj.MaxValue })
                            if obj.Flag and EZ_AutoSave then
                                EZ_Window.ConfigData[id] = { type = "range", value = { obj.MinValue, obj.MaxValue } }
                                EZ_Window:SaveConfig(EZ_Window.CurrentConfig)
                            end
                        end
                    end
                end
                local function fromPtr(x)
                    local w = track.AbsoluteSize.X
                    if w <= 0 then return 0 end
                    return mn + EZ_Clamp((x - track.AbsolutePosition.X) / w, 0, 1) * (mx - mn)
                end
                capMin.InputBegan:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 then
                        draggingMin = true; applyVisualMin(fromPtr(i.Position.X))
                    end
                end)
                capMin.InputEnded:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 then
                        draggingMin = false; applyFinal(false)
                    end
                end)
                capMax.InputBegan:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 then
                        draggingMax = true; applyVisualMax(fromPtr(i.Position.X))
                    end
                end)
                capMax.InputEnded:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 then
                        draggingMax = false; applyFinal(false)
                    end
                end)
                UserInputService.InputChanged:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseMovement then
                        if draggingMin then applyVisualMin(fromPtr(i.Position.X)) end
                        if draggingMax then applyVisualMax(fromPtr(i.Position.X)) end
                    end
                end)
                function obj:Set(values, silent)
                    if type(values) == "table" then
                        obj.MinValue = EZ_Clamp(values[1] or mn, mn, obj.MaxValue - st)
                        obj.MaxValue = EZ_Clamp(values[2] or mx, obj.MinValue + st, mx)
                    end
                    refreshVisual()
                    if not silent then
                        cb({ obj.MinValue, obj.MaxValue })
                        if obj.Flag and EZ_AutoSave then
                            EZ_Window.ConfigData[id] = { type = "range", value = { obj.MinValue, obj.MaxValue } }
                            EZ_Window:SaveConfig(EZ_Window.CurrentConfig)
                        end
                    end
                end
                refreshVisual()
                if obj.Flag then table.insert(EZ_Window.Elements, obj) end
                obj._row = row
                return obj
            end

            function tab:AddBanner(o)
                o = o or {}
                local holder = Instance.new("Frame")
                holder.Size = UDim2.new(1, 0, 0, o.Height or 90)
                holder.BackgroundColor3 = EZ_Theme.Card
                holder.BorderSizePixel = 0
                holder.ClipsDescendants = true
                holder.Parent = page
                EZ_AddRadius(holder, EZ_Theme.Radius)
                EZ_RegTrans(holder)
                EZ_Paint(function() holder.BackgroundColor3 = EZ_Theme.Card end)
                if o.Image then
                    local img = Instance.new("ImageLabel")
                    img.Size = UDim2.new(1, 0, 1, 0)
                    img.BackgroundTransparency = 1
                    img.Image = o.Image
                    img.ScaleType = Enum.ScaleType.Crop
                    img.Parent = holder
                    EZ_AddRadius(img, EZ_Theme.Radius)
                end
                local titleLbl, subLbl
                if o.Title then
                    titleLbl = Instance.new("TextLabel")
                    titleLbl.Size = UDim2.new(1, -20, 0, 22)
                    titleLbl.Position = UDim2.new(0, 14, 0, 12)
                    titleLbl.BackgroundTransparency = 1
                    titleLbl.Text = o.Title
                    titleLbl.Font = EZ_Brand.Font
                    titleLbl.TextSize = 16
                    titleLbl.TextColor3 = o.TextColor or EZ_Theme.Text
                    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
                    titleLbl.Parent = holder
                    EZ_Paint(function() titleLbl.TextColor3 = o.TextColor or EZ_Theme.Text end)
                end
                if o.SubTitle then
                    subLbl = Instance.new("TextLabel")
                    subLbl.Size = UDim2.new(1, -20, 0, 16)
                    subLbl.Position = UDim2.new(0, 14, 0, 36)
                    subLbl.BackgroundTransparency = 1
                    subLbl.Text = o.SubTitle
                    subLbl.Font = EZ_Brand.FontBody
                    subLbl.TextSize = 12
                    subLbl.TextColor3 = o.SubColor or EZ_Theme.TextDim
                    subLbl.TextXAlignment = Enum.TextXAlignment.Left
                    subLbl.Parent = holder
                    EZ_Paint(function() subLbl.TextColor3 = o.SubColor or EZ_Theme.TextDim end)
                end
                local obj = {}
                function obj:SetTitle(x) if titleLbl then titleLbl.Text = x or "" end end
                function obj:SetSubtitle(x) if subLbl then subLbl.Text = x or "" end end
                obj._holder = holder
                return obj
            end

            function tab:AddDropdown(a, b)
                local o = EZ_Normalize(a, b)
                local values = o.Values or o.Options or {}
                local cb = o.Callback or function() end
                local multi = o.Multi == true
                local id = o.Flag or o.Id or o.Title or "dropdown_" .. os.clock()
                local obj = { 
                    Value = multi and (type(o.Default) == "table" and o.Default or {}) or o.Default, 
                    Id = id, Flag = o.Flag, 
                    Type = multi and "multi" or "dropdown", 
                    Default = multi and (type(o.Default) == "table" and o.Default or {}) or o.Default 
                }
                local row = EZ_NewRow(page, 44, obj)
                EZ_RowTitle(row, o.Title or "Dropdown", o.Description, 44, 190, obj)
                local trigger = Instance.new("TextButton")
                trigger.Size = UDim2.fromOffset(160, 28)
                trigger.Position = UDim2.new(1, -172, 0.5, -14)
                trigger.BackgroundColor3 = EZ_Theme.CardHover
                trigger.BorderSizePixel = 0
                trigger.Text = ""
                trigger.AutoButtonColor = false
                trigger.Parent = row
                local tst = EZ_AddStroke(trigger, EZ_Theme.Border)
                EZ_AddRadius(trigger, EZ_Theme.Radius)
                EZ_RegTrans(trigger)
                local trigText = Instance.new("TextLabel")
                trigText.Size = UDim2.new(1, -30, 1, 0)
                trigText.Position = UDim2.fromOffset(10, 0)
                trigText.BackgroundTransparency = 1
                if multi then
                    trigText.Text = #obj.Value > 0 and table.concat(obj.Value, ", ") or "none"
                else
                    trigText.Text = obj.Value and tostring(obj.Value) or "none"
                end
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
                    if sign and sign:IsA("ImageLabel") then sign.ImageColor3 = EZ_Theme.TextDim end
                end, obj)
                trigger.MouseEnter:Connect(function() TweenService:Create(tst, EZ_Ease.Fast, { Color = EZ_Theme.BorderHover }):Play() end)
                trigger.MouseLeave:Connect(function() TweenService:Create(tst, EZ_Ease.Fast, { Color = EZ_Theme.Border }):Play() end)
                local entry = {
                    trigger = trigger,
                    sign = sign,
                    windowFrame = frame,
                    width = 172,
                    searchable = o.Searchable and true or false,
                    getValues = function() return values end,
                    getValue = function() return obj.Value end,
                    pick = function(v) 
                        if multi then
                            local found = false
                            for i, item in ipairs(obj.Value) do
                                if item == v then table.remove(obj.Value, i); found = true; break end
                            end
                            if not found then table.insert(obj.Value, v) end
                            trigText.Text = #obj.Value > 0 and table.concat(obj.Value, ", ") or "none"
                            cb(obj.Value)
                            if obj.Flag and EZ_AutoSave then
                                EZ_Window.ConfigData[id] = { type = "multi", value = obj.Value }
                                EZ_Window:SaveConfig(EZ_Window.CurrentConfig)
                            end
                        else
                            obj:Set(v, false)
                        end
                    end,
                }
                function obj:Set(v, silent)
                    if multi then
                        obj.Value = type(v) == "table" and v or {}
                        trigText.Text = #obj.Value > 0 and table.concat(obj.Value, ", ") or "none"
                    else
                        obj.Value = v
                        trigText.Text = tostring(v)
                    end
                    if not silent then
                        cb(obj.Value)
                        if obj.Flag and EZ_AutoSave then
                            EZ_Window.ConfigData[id] = { type = multi and "multi" or "dropdown", value = obj.Value }
                            EZ_Window:SaveConfig(EZ_Window.CurrentConfig)
                        end
                    end
                end
                function obj:SetValues(newValues)
                    values = newValues
                    if EZ_DropdownCurrent == entry then EZ_CloseDropdown() end
                end
                obj.getValues = function() return values end
                trigger.MouseButton1Click:Connect(function() EZ_OpenDropdown(entry) end)
                if obj.Flag then table.insert(EZ_Window.Elements, obj) end
                obj._row = row
                return obj
            end

            function tab:AddInput(a, b)
                local o = EZ_Normalize(a, b)
                local cb = o.Callback or function() end
                local id = o.Flag or o.Id or o.Title or "input_" .. os.clock()
                local obj = { Value = o.Default or "", Id = id, Flag = o.Flag, Type = "input", Default = o.Default or "" }
                local row = EZ_NewRow(page, 44, obj)
                EZ_RowTitle(row, o.Title or "Input", o.Description, 44, 190, obj)
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
                end, obj)
                local bpad = Instance.new("UIPadding")
                bpad.PaddingLeft = UDim.new(0, 10); bpad.PaddingRight = UDim.new(0, 10); bpad.Parent = box
                EZ_Connect(box, box.Focused, function() bst.Color = EZ_Theme.Accent end)
                EZ_Connect(box, box.FocusLost, function()
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
                obj._row = row
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
                row.BorderSizePixel = 0
                row.Parent = page
                EZ_AddStroke(row, EZ_Theme.Border)
                EZ_AddRadius(row, EZ_Theme.Radius)
                EZ_RegTrans(row)
                EZ_Paint(function() row.BackgroundColor3 = EZ_Theme.Card end, obj)
                local tl = Instance.new("TextLabel")
                tl.Position = UDim2.fromOffset(14, 10)
                tl.Size = UDim2.new(1, -24, 0, 16)
                tl.BackgroundTransparency = 1
                tl.Text = o.Title or "Text Area"
                tl.Font = EZ_Brand.FontBody; tl.TextSize = 13; tl.TextColor3 = EZ_Theme.Text
                tl.TextXAlignment = Enum.TextXAlignment.Left
                tl.Parent = row
                EZ_Paint(function() tl.TextColor3 = EZ_Theme.Text end, obj)
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
                end, obj)
                local bpad = Instance.new("UIPadding")
                bpad.PaddingLeft = UDim.new(0, 10); bpad.PaddingRight = UDim.new(0, 10)
                bpad.PaddingTop = UDim.new(0, 8); bpad.PaddingBottom = UDim.new(0, 8); bpad.Parent = box
                EZ_Connect(box, box.Focused, function() bst.Color = EZ_Theme.Accent end)
                EZ_Connect(box, box.FocusLost, function()
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
                obj._row = row
                return obj
            end

            function tab:AddProgressBar(a, b)
                local o = EZ_Normalize(a, b)
                local obj = { Value = o.Default or 0 }
                local row = EZ_NewRow(page, 50, obj)
                local tl = Instance.new("TextLabel")
                tl.Position = UDim2.fromOffset(12, 10)
                tl.Size = UDim2.new(1, -80, 0, 16)
                tl.BackgroundTransparency = 1
                tl.Text = o.Title or "Progress"
                tl.Font = EZ_Brand.FontBody; tl.TextSize = 13; tl.TextColor3 = EZ_Theme.Text
                tl.TextXAlignment = Enum.TextXAlignment.Left
                tl.Parent = row
                EZ_Paint(function() tl.TextColor3 = EZ_Theme.Text end, obj)
                local vl = Instance.new("TextLabel")
                vl.AnchorPoint = Vector2.new(1, 0)
                vl.Position = UDim2.new(1, -12, 0, 10)
                vl.Size = UDim2.fromOffset(60, 16)
                vl.BackgroundTransparency = 1
                vl.Font = EZ_Brand.FontMono; vl.TextSize = 12; vl.TextColor3 = EZ_Theme.Accent
                vl.TextXAlignment = Enum.TextXAlignment.Right
                vl.Text = tostring(obj.Value) .. "%"
                vl.Parent = row
                EZ_Paint(function() vl.TextColor3 = EZ_Theme.Accent end, obj)
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
                end, obj)
                function obj:Set(val)
                    obj.Value = EZ_Clamp(val, 0, 100)
                    TweenService:Create(fill, TweenInfo.new(0.2, Enum.EasingStyle.Quint), { Size = UDim2.new(obj.Value / 100, 0, 1, 0) }):Play()
                    vl.Text = tostring(obj.Value) .. "%"
                end
                obj._row = row
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
                local row = EZ_NewRow(page, 44, obj)
                EZ_RowTitle(row, o.Title or "Color", o.Description, 44, 90, obj)
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
                EZ_Paint(function() if sign and sign:IsA("ImageLabel") then sign.ImageColor3 = EZ_Theme.TextDim end end, obj)
                local panel = Instance.new("Frame")
                panel.Position = UDim2.fromOffset(1, 44)
                panel.Size = UDim2.new(1, -2, 0, 0)
                panel.BackgroundColor3 = EZ_Theme.Background
                panel.BorderSizePixel = 0
                panel.ClipsDescendants = true
                panel.Parent = row
                EZ_RegTrans(panel)
                EZ_Paint(function() panel.BackgroundColor3 = EZ_Theme.Background end, obj)
                local play2 = Instance.new("UIListLayout"); play2.Padding = UDim.new(0, 8); play2.Parent = panel
                local ppad2 = Instance.new("UIPadding")
                ppad2.PaddingTop = UDim.new(0, 10); ppad2.PaddingBottom = UDim.new(0, 10)
                ppad2.PaddingLeft = UDim.new(0, 14); ppad2.PaddingRight = UDim.new(0, 14); ppad2.Parent = panel
                local updateScheduled = false
                local hexBox
                local function update(silent)
                    obj.Value = Color3.fromRGB(r, g, b)
                    sw.BackgroundColor3 = obj.Value
                    if hexBox and hexBox.Parent then hexBox.Text = string.format("#%02X%02X%02X", r, g, b) end
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
                hexBox = Instance.new("TextBox")
                hexBox.Size = UDim2.new(1, 0, 0, 24)
                hexBox.BackgroundColor3 = EZ_Theme.Card
                hexBox.BorderSizePixel = 0
                hexBox.Text = string.format("#%02X%02X%02X", r, g, b)
                hexBox.Font = EZ_Brand.FontMono
                hexBox.TextSize = 12
                hexBox.TextColor3 = EZ_Theme.Text
                hexBox.TextXAlignment = Enum.TextXAlignment.Center
                hexBox.Parent = panel
                EZ_AddRadius(hexBox, 4)
                hexBox.FocusLost:Connect(function(enter)
                    if enter then
                        local hex = hexBox.Text:match("^#?(%x%x%x%x%x%x)$")
                        if hex then
                            r = tonumber(hex:sub(1, 2), 16)
                            g = tonumber(hex:sub(3, 4), 16)
                            b = tonumber(hex:sub(5, 6), 16)
                            update(false)
                        end
                    end
                end)
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
                    EZ_Paint(function() lab.TextColor3 = EZ_Theme.TextDim end, obj)
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
                    end, obj)
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
                        TweenService:Create(sign, EZ_Ease.Med, { Rotation = s and 180 or 0 }):Play()
                    end
                    local h = s and 110 or 0
                    TweenService:Create(row, EZ_Ease.Med, { Size = UDim2.new(1, 0, 0, 44 + h) }):Play()
                    TweenService:Create(panel, EZ_Ease.Med, { Size = UDim2.new(1, -2, 0, h) }):Play()
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
                obj._row = row
                return obj
            end

            function tab:AddKeybind(a, b)
                local o = EZ_Normalize(a, b)
                local cb = o.Callback or function() end
                local id = o.Flag or o.Id or o.Title or "keybind_" .. os.clock()
                local obj = { Value = o.Default, Id = id, Flag = o.Flag, Type = "keybind", Default = o.Default, Mods = "" }
                local listening = false
                local row = EZ_NewRow(page, 44, obj)
                EZ_RowTitle(row, o.Title or "Keybind", o.Description, 44, 100, obj)
                local kl = Instance.new("TextButton")
                kl.Position = UDim2.new(1, -92, 0.5, -13)
                kl.Size = UDim2.fromOffset(80, 26)
                kl.BackgroundColor3 = EZ_Theme.Background
                kl.BorderSizePixel = 0
                kl.Text = obj.Value and obj.Value.Name or EZ_Locale.None
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
                end, obj)
                local function modString()
                    local m = ""
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.RightControl) then m = m .. "Ctrl+" end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.RightShift) then m = m .. "Shift+" end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftAlt) or UserInputService:IsKeyDown(Enum.KeyCode.RightAlt) then m = m .. "Alt+" end
                    return m
                end
                local function modsHeld()
                    local ctrl = UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.RightControl)
                    local shift = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.RightShift)
                    local alt = UserInputService:IsKeyDown(Enum.KeyCode.LeftAlt) or UserInputService:IsKeyDown(Enum.KeyCode.RightAlt)
                    return ctrl, shift, alt
                end
                UserInputService.InputBegan:Connect(function(input, processed)
                    if listening then
                        if input.UserInputType == Enum.UserInputType.Keyboard then
                            if input.KeyCode == Enum.KeyCode.Escape then
                                listening = false
                                kl.Text = (obj.Value and (obj.Mods .. obj.Value.Name)) or EZ_Locale.None
                                klst.Color = EZ_Theme.Border
                            else
                                obj.Value = input.KeyCode
                                obj.Mods = modString()
                                listening = false
                                kl.Text = obj.Mods .. input.KeyCode.Name
                                klst.Color = EZ_Theme.Border
                                cb(input.KeyCode)
                                if obj.Flag and EZ_AutoSave then
                                    EZ_Window.ConfigData[id] = { type = "keybind", value = input.KeyCode.Name, mods = obj.Mods }
                                    EZ_Window:SaveConfig(EZ_Window.CurrentConfig)
                                end
                            end
                        end
                        return
                    end
                    if obj.Value and input.KeyCode == obj.Value and not processed then
                        local c, s, al = modsHeld()
                        local mc, ms, ma = obj.Mods:find("Ctrl+", 1, true) and true or false, obj.Mods:find("Shift+", 1, true) and true or false, obj.Mods:find("Alt+", 1, true) and true or false
                        if c == mc and s == ms and al == ma then
                            if not UserInputService:GetFocusedTextBox() then cb() end
                        end
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
                    kl.Text = key and (obj.Mods .. key.Name) or EZ_Locale.None
                    if not silent and obj.Flag and EZ_AutoSave then
                        EZ_Window.ConfigData[id] = { type = "keybind", value = key and key.Name or nil, mods = obj.Mods }
                        EZ_Window:SaveConfig(EZ_Window.CurrentConfig)
                    end
                end
                if obj.Flag then table.insert(EZ_Window.Elements, obj) end
                obj._row = row
                return obj
            end

            tab.CreateSection = tab.AddSection
            tab.CreateBanner = tab.AddBanner
            tab.CreateDivider = tab.AddDivider
            tab.CreateParagraph = tab.AddParagraph
            tab.CreateLabel = tab.AddLabel
            tab.CreateToggle = tab.AddToggle
            tab.CreateButton = tab.AddButton
            tab.CreateSlider = tab.AddSlider
            tab.CreateRangeSlider = tab.AddRangeSlider
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
            EZ_ApplyTransparency(t)
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
                        data[el.Id] = { type = "keybind", value = el.Value and el.Value.Name or nil, mods = el.Mods }
                    elseif el.Type == "multi" then
                        data[el.Id] = { type = "multi", value = el.Value }
                    elseif el.Type == "range" then
                        data[el.Id] = { type = "range", value = { el.MinValue, el.MaxValue } }
                    else
                        data[el.Id] = { type = el.Type, value = el.Value }
                    end
                end
            end
            EZ_Window.ConfigData = data
            EZ_Window.CurrentConfig = configName
            if EZ_SaveQueued then return true end
            EZ_SaveQueued = true
            task.delay(1, function()
                EZ_SaveQueued = false
                EZ_SaveConfig(EZ_ConfigId, configName, data)
            end)
            return true
        end

        function EZ_Window:LoadConfig(configName)
            configName = configName or EZ_Window.CurrentConfig
            local data = EZ_LoadConfig(EZ_ConfigId, configName)
            if not data then return false end
            local ok = EZ_ApplyConfigData(data, false)
            EZ_Window.CurrentConfig = configName
            EZ_SyncConfigDropdown(configName)
            return ok
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
            EZ_Window._configDropdown = savedConfigsDropdown
            if EZ_Window._pendingConfigSync then
                EZ_SyncConfigDropdown(EZ_Window._pendingConfigSync)
                EZ_Window._pendingConfigSync = nil
            end
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
                Title = "Set Autoload Config",
                Description = "Loads the selected config on startup",
                ButtonText = "Set",
                Callback = function()
                    local name = EZ_Window.CurrentConfig
                    EZ_SetAutoloadName(EZ_ConfigId, name)
                    EZ:Notify({ Title = "Config", Content = "'" .. name .. "' will load on startup.", Style = "Success", Duration = 2 })
                end
            })
            tab:AddButton({
                Title = "Clear Autoload",
                Description = "Back to loading 'default'",
                ButtonText = "Clear",
                Callback = function()
                    EZ_SetAutoloadName(EZ_ConfigId, "default")
                    EZ:Notify({ Title = "Config", Content = "Autoload back to 'default'.", Style = "Info", Duration = 2 })
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
                Values = { "Default", "Pitch", "Light", "Ocean", "Sunset", "Mono", "Amethyst", "Rose", "Aqua", "Nocturne", "Pumpkin" },
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
            EZ_Window._themeDropdown = themeDropdown
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
            local autoloadName = EZ_GetAutoloadName(EZ_ConfigId) or "default"
            local saved = EZ_LoadConfig(EZ_ConfigId, autoloadName)
            if not saved then return false end
            EZ_Window.ConfigData = saved
            EZ_Window.CurrentConfig = autoloadName
            EZ_ApplyConfigData(saved, true)
            EZ_SyncConfigDropdown(autoloadName)
            EZ_Repaint()
            EZ_ApplyTransparency(EZ_GlobalTransparency)
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
    table.clear(EZ_PaintersByElement)
    table.clear(EZ_TransSurf)
    table.clear(EZ_TransFactors)
    table.clear(EZ_StrokeSurf)
    for _, list in pairs(EZ_Connections) do
        for _, conn in ipairs(list) do
            if conn.Connected then conn:Disconnect() end
        end
    end
    table.clear(EZ_Connections)
    table.clear(EZ_ThemeListeners)
    if getgenv then getgenv().EazyUI = nil end
    EZ_CurrentWindow = nil
end

function EZ:Logout()
    if EZ_CurrentWindow then
        local configId = EZ_CurrentWindow.ConfigId or tostring(game.PlaceId)
        EZ_ClearKey(EZ_KeyFilePath(configId))
    end
    EZ:Notify({ Title = "Eazy UI", Content = "Logged out. Restart to re-enter key.", Style = "Info", Duration = 3 })
end

if getgenv then getgenv().EazyUI = EZ end

return EZ