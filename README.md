# Eazy UI

Open-source Roblox GUI library. One file, zero dependencies.

Built and maintained by [Akira Dev](https://github.com/akiradv).

## Loadstring
```lua
local EZ = loadstring(game:HttpGet("https://raw.githubusercontent.com/akiradv/eazyuilib/main/eazyui.lua"))()
```

## Quick Start
```lua
local EZ = loadstring(game:HttpGet("https://raw.githubusercontent.com/akiradv/eazyuilib/main/eazyui.lua"))()

local Window = EZ:CreateWindow({
    Name = "My Hub",
    SubTitle = "by you",
    AutoLoad = true,
    NotifyPosition = "BottomRight",
    Discord = {
        Enabled = true,
        Invite = "9VE4PXFDSg",
    },
})

local Main = Window:AddTab({ Title = "Main", Icon = "home" })

Main:AddToggle({
    Title = "My first toggle",
    Default = true,
    Flag = "MyToggle",
    Callback = print,
})

local Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
Window:BuildConfigSection(Settings)
```

## Features

- **11 themes** (Default, Pitch, Light, Ocean, Sunset, Mono, Amethyst, Rose, Aqua, Nocturne, Pumpkin) with aliases for quick switching
- **14 elements**: Toggle, Slider, Dropdown, Input, Text Area, Color Picker, Keybind, Button, Progress Bar, Label, Paragraph, Section, Divider, Banner
- **Collapsible sections** with colored accent bar and rotating chevron
- **Searchable dropdowns** - add `Searchable = true` for a filter input inside the popup
- **Color picker with hex input** - expand the panel and type `#RRGGBB` values
- **Keybinds with modifiers** - capture Ctrl, Shift, Alt combos
- **Editable sliders** - click the value label to type exact numbers, use mouse wheel or arrow keys when hovered
- **Notifications with 4 positions** - BottomRight, BottomLeft, TopRight, TopLeft with timer bar
- Persistent configs with auto-save, named files, orphan-field warnings and per-window autoload selection
- Key system with custom validator and local cache with expiry
- Discord prompt that copies the invite link to the clipboard
- Global dropdown popup that flips, clamps and closes on outside click or Escape
- Notifications with 4 styles and optional action buttons
- Loading screen, minimize hotkey, transparency 0-90%
- **Performance optimized** - repaint calls batched through task.defer
- Executor-safe: every filesystem, HTTP and hook call is capability-checked

## Documentation

Full docs with every parameter and example: [akiradv.github.io/eazyuilib](https://akiradv.github.io/eazyuilib)

## Example

Run the showcase hub straight from the repository:

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/akiradv/eazyuilib/main/example.lua"))()
```

## Showcase

- **[FTF Premium Hub](https://github.com/akiradv/scriptsroblox)** - Full hub for Flee The Facility with auto hack, ESPs, teleports and configs. The same hub used to test every library release.
- **[Muscle Legends Hub](https://github.com/akiradv/scriptsroblox)** - Automation hub for Muscle Legends with auto train, auto machines, teleport to gyms, auto kill players with whitelist, auto rebirth and a full stats panel.

## Credits

- [Akira Dev](https://github.com/akiradv) - author and maintainer
- [Lucide Icons](https://lucide.dev) via [WindUI](https://github.com/Footagesus/treehub-web) - icon set
- Roblox TweenService - animations

## License

MIT. Do whatever you want with it, just keep the credit.

## Support

Found a bug or want a feature? Open an issue or ping on [Discord](https://discord.gg/9VE4PXFDSg).