local EZ = loadstring(game:HttpGet("https://raw.githubusercontent.com/akiradv/eazyuilib/main/eazyui.lua"))()

local Window = EZ:CreateWindow({
    Name = "Eazy Showcase",
    SubTitle = "example.lua",
    Size = UDim2.fromOffset(620, 480),
    ConfigId = "EazyShowcase",
    MinimizeKey = Enum.KeyCode.RightShift,
    AutoLoad = true,
    NotifyPosition = "BottomRight",
    LoadingTitle = "Eazy Showcase",
    LoadingSubtitle = "Building interface...",
    LoadingDuration = 1.5,
})

local Main = Window:AddTab({ Title = "Main", Icon = "home" })

Main:AddBanner({
    Height = 90,
    Title = "Welcome back",
    SubTitle = "Every element of Eazy UI, live in one tab.",
})

Main:AddSection({ Title = "general" })

Main:AddParagraph({
    Title = "Welcome",
    Content = "Click around and see what saves.",
})

Main:AddLabel("Status: ready")

Main:AddDivider()

Main:AddToggle({
    Title = "Master Switch",
    Description = "Gate for everything below",
    Default = true,
    Flag = "EX_Master",
    Callback = print,
})

Main:AddSlider({
    Title = "Walk Speed",
    Min = 16, Max = 200, Default = 16, Step = 2,
    Flag = "EX_Speed",
    Callback = print,
})

Main:AddDropdown({
    Title = "Server Region",
    Description = "Pick one (has search box)",
    Values = { "Auto", "NA", "EU", "BR", "Asia", "OCE" },
    Default = "Auto",
    Searchable = true,
    Flag = "EX_Region",
    Callback = print,
})

Main:AddInput({
    Title = "Username",
    Placeholder = "guest",
    Flag = "EX_Name",
    Callback = print,
})

Main:AddButton({
    Title = "Ping Server",
    ButtonText = "Ping",
    Callback = function()
        EZ:Notify({ Title = "Network", Content = "42ms", Style = "Success", Duration = 2 })
    end,
})

local Visual = Window:AddTab({ Title = "Visual", Icon = "eye" })

Visual:AddSection({ Title = "world" })

Visual:AddToggle({
    Title = "Fullbright",
    Flag = "EX_Fullbright",
    Callback = print,
})

Visual:AddColorPicker({
    Title = "Ambient Color",
    Description = "Click the swatch to expand",
    Default = Color3.fromRGB(16, 185, 129),
    Flag = "EX_Ambient",
    Callback = print,
})

Visual:AddProgressBar({ Title = "Shader Warmup", Default = 35 })

Visual:AddTextArea({
    Title = "Custom Shader",
    Placeholder = "paste code here",
    Flag = "EX_Shader",
})

local Combat = Window:AddTab({ Title = "Combat", Icon = "crosshair" })

Combat:AddSection({ Title = "aim" })

Combat:AddToggle({
    Title = "Silent Aim",
    Flag = "EX_Aim",
    Callback = print,
})

Combat:AddSlider({
    Title = "Hit Chance",
    Min = 0, Max = 100, Default = 85, Step = 5,
    Flag = "EX_Chance",
})

Combat:AddKeybind({
    Title = "Panic Key",
    Description = "Hold Ctrl/Shift/Alt for combos",
    Default = Enum.KeyCode.K,
    Flag = "EX_Panic",
    Callback = function() Window:SetMinimized(true) end,
})

local Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
Window:BuildConfigSection(Settings)

EZ:Notify({
    Title = "Eazy UI",
    Content = "Showcase loaded. Check every tab.",
    Style = "Info",
    Duration = 4,
})