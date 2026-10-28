--[[
    Eazy UI v0.9.55
    Open-source Roblox GUI library with minimal dependencies.
    Join our discord!: https://discord.gg/9VE4PXFDSg
]]

local EZ = {}
EZ.Version = "0.9.55"
local EZ_Destroyed = false

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local GuiService = game:GetService("GuiService")
local TextService = game:GetService("TextService")

local function EZ_C(r, g, b) return Color3.fromRGB(r, g, b) end

local EZ_Brand = {
    Font = Enum.Font.GothamBold,
    FontBody = Enum.Font.Gotham,
    FontMono = Enum.Font.Code,
}

local EZ_Locale = {
    Search = "Search...", SearchTab = "Search this tab...", SearchEmpty = "No results found.",
    Language = "Language", LanguageDesc = "Change the language of Eazy UI",
    InputPlaceholder = "Type here...", LogoutMessage = "Logged out. Restart to re-enter key.",
    ConfigUnregistered = "%d saved field(s) were not registered and were kept.",
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
    Configuration = "Configuration", Appearance = "Appearance",
    AutoSave = "Auto-Save", AutoSaveDesc = "Save settings automatically when changed",
    ConfigName = "Config Name", ConfigNameDesc = "Name used when saving a new config",
    SaveConfig = "Save Config", SaveConfigDesc = "Save current settings, theme and binds",
    SavedConfigs = "Saved Configs", SavedConfigsDesc = "Pick a saved config to load or delete",
    LoadConfig = "Load Config", LoadConfigDesc = "Load the selected config",
    SetAutoload = "Set Autoload Config", SetAutoloadDesc = "Loads the selected config on startup",
    ClearAutoload = "Clear Autoload", ClearAutoloadDesc = "Back to loading default",
    DeleteConfig = "Delete Config", DeleteConfigDesc = "Delete the selected config",
    ResetDefaults = "Reset to Defaults", ResetDefaultsDesc = "Reset and save the default settings",
    MinimizeKey = "Minimize Key", MinimizeKeyDesc = "Key to hide/show the hub",
    MinimizeMode = "Minimize Mode", MinimizeModeDesc = "How the window hides when minimized",
    Transparency = "Window Transparency", TransparencyDesc = "Adjust UI transparency (0-90%)",
    Theme = "Theme", ThemeDesc = "Change the UI theme",
    Save = "Save", Load = "Load", Set = "Set", Clear = "Clear", Delete = "Delete", Reset = "Reset",
    ConfigSaved = "Config '%s' saved.", ConfigLoaded = "Config '%s' loaded.",
    ConfigDeleted = "Config '%s' deleted.", ConfigReset = "Defaults restored and saved.",
    ConfigFailed = "Config operation failed: %s", AutoloadSet = "Autoload set to '%s'.",
    ConfigSavedAutoloadFailed = "Config '%s' was saved, but autoload failed: %s",
    ConfigDeletedAutoloadFailed = "Config deleted, but autoload could not be reset: %s",
    LegacyConfigManual = "Legacy file must be removed manually: %s",
    KeyChanged = "Minimize key set to %s", ThemeChanged = "Switched to %s theme",
    KeyTimeout = "Timeout validating key.",
}

local EZ_DefaultLocale = table.clone(EZ_Locale)
local EZ_LocaleListeners = {}
local EZ_CurrentLanguage = "en"
local EZ_Languages = {
    en = {},
    ["pt-BR"] = {
        Search = "Buscar...", SearchTab = "Buscar nesta aba...", SearchEmpty = "Nenhum resultado encontrado.",
        Language = "Idioma", LanguageDesc = "Mudar o idioma da Eazy UI", InputPlaceholder = "Digite aqui...",
        LogoutMessage = "Sessão encerrada. Reinicie para inserir a chave novamente.",
        ConfigUnregistered = "%d campo(s) salvo(s) ainda não foram registrados e foram mantidos.",
        Loading = "Carregando", PleaseWait = "Aguarde...", JoinDiscord = "Entre no nosso Discord",
        DiscordSubtitle = "Receba novidades, suporte e recursos exclusivos.\nCopie o link abaixo para entrar.",
        EnterKey = "Digite a chave", EnterKeySubtitle = "Digite sua chave de acesso para continuar",
        EnterKeyPlaceholder = "Digite a chave aqui...", Submit = "Enviar", Cancel = "Cancelar",
        Validating = "Validando...", InvalidKey = "Chave inválida. Tente novamente.", AccessDenied = "Acesso negado.",
        Copied = "Copiado!", CopyLink = "Copiar link", Skip = "Pular", None = "Nenhum",
        Configuration = "Configurações", Appearance = "Aparência",
        AutoSave = "Salvamento automático", AutoSaveDesc = "Salvar configurações automaticamente ao alterar",
        ConfigName = "Nome da configuração", ConfigNameDesc = "Nome usado ao salvar uma configuração",
        SaveConfig = "Salvar configuração", SaveConfigDesc = "Salvar opções, tema e atalhos",
        SavedConfigs = "Configurações salvas", SavedConfigsDesc = "Escolha uma configuração para carregar ou excluir",
        LoadConfig = "Carregar configuração", LoadConfigDesc = "Carregar a configuração selecionada",
        SetAutoload = "Definir carregamento automático", SetAutoloadDesc = "Carregar a configuração selecionada ao iniciar",
        ClearAutoload = "Limpar carregamento automático", ClearAutoloadDesc = "Voltar a carregar a configuração padrão",
        DeleteConfig = "Excluir configuração", DeleteConfigDesc = "Excluir a configuração selecionada",
        ResetDefaults = "Restaurar padrões", ResetDefaultsDesc = "Restaurar e salvar as configurações padrão",
        MinimizeKey = "Tecla para minimizar", MinimizeKeyDesc = "Tecla para ocultar ou mostrar a interface",
        MinimizeMode = "Modo de minimizar", MinimizeModeDesc = "Como a janela fica ao minimizar",
        Transparency = "Transparência da janela", TransparencyDesc = "Ajustar transparência da interface (0-90%)",
        Theme = "Tema", ThemeDesc = "Mudar o tema da interface",
        Save = "Salvar", Load = "Carregar", Set = "Definir", Clear = "Limpar", Delete = "Excluir", Reset = "Restaurar",
        ConfigSaved = "Configuração '%s' salva.", ConfigLoaded = "Configuração '%s' carregada.",
        ConfigDeleted = "Configuração '%s' excluída.", ConfigReset = "Padrões restaurados e salvos.",
        ConfigFailed = "Falha na configuração: %s", AutoloadSet = "Carregamento automático definido para '%s'.",
        ConfigSavedAutoloadFailed = "Configuração '%s' salva, mas houve falha no carregamento automático: %s",
        ConfigDeletedAutoloadFailed = "Configuração excluída, mas não foi possível redefinir o carregamento automático: %s",
        LegacyConfigManual = "O arquivo antigo deve ser removido manualmente: %s",
        KeyChanged = "Tecla para minimizar definida como %s", ThemeChanged = "Tema alterado para %s",
        KeyTimeout = "Tempo esgotado ao validar a chave.",
    },
    es = {
        Search = "Buscar...", SearchTab = "Buscar en esta pestaña...", SearchEmpty = "No se encontraron resultados.",
        Language = "Idioma", LanguageDesc = "Cambiar el idioma de Eazy UI", InputPlaceholder = "Escribe aquí...",
        LogoutMessage = "Sesión cerrada. Reinicia para introducir la clave de nuevo.",
        ConfigUnregistered = "%d campo(s) guardado(s) no estaban registrados y se conservaron.",
        Loading = "Cargando", PleaseWait = "Espera...", JoinDiscord = "Únete a nuestro Discord",
        DiscordSubtitle = "Recibe novedades, soporte y funciones exclusivas.\nCopia el enlace para unirte.",
        EnterKey = "Introduce la clave", EnterKeySubtitle = "Introduce tu clave de acceso para continuar",
        EnterKeyPlaceholder = "Escribe la clave aquí...", Submit = "Enviar", Cancel = "Cancelar",
        Validating = "Validando...", InvalidKey = "Clave inválida. Inténtalo de nuevo.", AccessDenied = "Acceso denegado.",
        Copied = "¡Copiado!", CopyLink = "Copiar enlace", Skip = "Omitir", None = "Ninguno",
        Configuration = "Configuración", Appearance = "Apariencia",
        AutoSave = "Guardado automático", AutoSaveDesc = "Guardar ajustes automáticamente al cambiarlos",
        ConfigName = "Nombre de configuración", ConfigNameDesc = "Nombre para guardar una configuración",
        SaveConfig = "Guardar configuración", SaveConfigDesc = "Guardar ajustes, tema y atajos",
        SavedConfigs = "Configuraciones guardadas", SavedConfigsDesc = "Elige una configuración para cargar o eliminar",
        LoadConfig = "Cargar configuración", LoadConfigDesc = "Cargar la configuración seleccionada",
        SetAutoload = "Definir carga automática", SetAutoloadDesc = "Cargar la configuración seleccionada al iniciar",
        ClearAutoload = "Limpiar carga automática", ClearAutoloadDesc = "Volver a cargar la configuración predeterminada",
        DeleteConfig = "Eliminar configuración", DeleteConfigDesc = "Eliminar la configuración seleccionada",
        ResetDefaults = "Restaurar valores", ResetDefaultsDesc = "Restaurar y guardar los valores predeterminados",
        MinimizeKey = "Tecla para minimizar", MinimizeKeyDesc = "Tecla para ocultar o mostrar la interfaz",
        MinimizeMode = "Modo de minimizar", MinimizeModeDesc = "Cómo se oculta la ventana al minimizar",
        Transparency = "Transparencia de ventana", TransparencyDesc = "Ajustar la transparencia (0-90%)",
        Theme = "Tema", ThemeDesc = "Cambiar el tema de la interfaz",
        Save = "Guardar", Load = "Cargar", Set = "Definir", Clear = "Limpiar", Delete = "Eliminar", Reset = "Restaurar",
        ConfigSaved = "Configuración '%s' guardada.", ConfigLoaded = "Configuración '%s' cargada.",
        ConfigDeleted = "Configuración '%s' eliminada.", ConfigReset = "Valores restaurados y guardados.",
        ConfigFailed = "Error de configuración: %s", AutoloadSet = "Carga automática definida para '%s'.",
        ConfigSavedAutoloadFailed = "Configuración '%s' guardada, pero falló la carga automática: %s",
        ConfigDeletedAutoloadFailed = "Configuración eliminada, pero no se pudo restablecer la carga automática: %s",
        LegacyConfigManual = "El archivo antiguo debe eliminarse manualmente: %s",
        KeyChanged = "Tecla para minimizar: %s", ThemeChanged = "Tema cambiado a %s",
        KeyTimeout = "Se agotó el tiempo para validar la clave.",
    },
}
local EZ_LanguageNames = { en = "English", ["pt-BR"] = "Português (Brasil)", es = "Español" }
local EZ_LanguageCodes = { ["English"] = "en", ["Português (Brasil)"] = "pt-BR", ["Español"] = "es" }
local EZ_TextPresets = {
    en = {},
    ["pt-BR"] = {
        ["Tab"] = "Aba", ["Button"] = "Botão", ["Run"] = "Executar", ["Toggle"] = "Alternar",
        ["Slider"] = "Controle", ["Range"] = "Intervalo", ["Dropdown"] = "Lista", ["Input"] = "Entrada",
        ["Text Area"] = "Área de texto", ["Progress"] = "Progresso", ["Color"] = "Cor", ["Keybind"] = "Atalho",
        ["Fade"] = "Desvanecer", ["Shrink"] = "Encolher", ["Default"] = "Padrão", ["None"] = "Nenhum",
        ["Main"] = "Principal", ["Settings"] = "Configurações", ["General"] = "Geral", ["Home"] = "Início",
        ["About"] = "Sobre", ["Information"] = "Informações", ["Community"] = "Comunidade", ["Objective"] = "Objetivo",
        ["Local & Security"] = "Local e segurança", ["Version Info"] = "Informações da versão",
        ["Join Discord"] = "Entrar no Discord", ["Copy Link"] = "Copiar link", ["Copy link"] = "Copiar link",
        ["Player"] = "Jogador", ["Movement"] = "Movimentação", ["Combat"] = "Combate", ["Misc"] = "Diversos",
        ["Auto Farm"] = "Coleta automática", ["Config"] = "Configuração", ["Status"] = "Estado",
        ["Invalid config name"] = "Nome de configuração inválido", ["Filesystem is unavailable"] = "Sistema de arquivos indisponível",
        ["Config not found"] = "Configuração não encontrada", ["Config not found or invalid"] = "Configuração não encontrada ou inválida",
        ["Window is applying a config or destroyed"] = "A janela está aplicando uma configuração ou foi destruída", ["unknown error"] = "erro desconhecido",
    },
    es = {
        ["Tab"] = "Pestaña", ["Button"] = "Botón", ["Run"] = "Ejecutar", ["Toggle"] = "Interruptor",
        ["Slider"] = "Control", ["Range"] = "Intervalo", ["Dropdown"] = "Lista", ["Input"] = "Entrada",
        ["Text Area"] = "Área de texto", ["Progress"] = "Progreso", ["Color"] = "Color", ["Keybind"] = "Atajo",
        ["Fade"] = "Desvanecer", ["Shrink"] = "Reducir", ["Default"] = "Predeterminado", ["None"] = "Ninguno",
        ["Main"] = "Principal", ["Settings"] = "Configuración", ["General"] = "General", ["Home"] = "Inicio",
        ["About"] = "Acerca de", ["Information"] = "Información", ["Community"] = "Comunidad", ["Objective"] = "Objetivo",
        ["Local & Security"] = "Local y seguridad", ["Version Info"] = "Información de la versión",
        ["Join Discord"] = "Unirse a Discord", ["Copy Link"] = "Copiar enlace", ["Copy link"] = "Copiar enlace",
        ["Player"] = "Jugador", ["Movement"] = "Movimiento", ["Combat"] = "Combate", ["Misc"] = "Varios",
        ["Auto Farm"] = "Recolección automática", ["Config"] = "Configuración", ["Status"] = "Estado",
        ["Invalid config name"] = "Nombre de configuración inválido", ["Filesystem is unavailable"] = "Sistema de archivos no disponible",
        ["Config not found"] = "Configuración no encontrada", ["Config not found or invalid"] = "Configuración no encontrada o inválida",
        ["Window is applying a config or destroyed"] = "La ventana está aplicando una configuración o fue destruida", ["unknown error"] = "error desconocido",
    },
}
local EZ_CustomTexts = { en = {}, ["pt-BR"] = {}, es = {} }
local EZ_TextBindings = {}
local EZ_TextBindingsByOwner = {}
local EZ_TextOwnerConnections = {}
local EZ_ClearTextBindings

local function EZ_ResolveLanguage(language)
    if type(language) ~= "string" then return nil end
    local code = language:lower():gsub("_", "-"):gsub("^%s+", ""):gsub("%s+$", "")
    return ({ en = "en", ["en-us"] = "en", ["en-gb"] = "en", pt = "pt-BR", ["pt-br"] = "pt-BR", es = "es", ["es-es"] = "es", ["es-mx"] = "es" })[code]
end

local function EZ_TranslateText(value)
    if type(value) ~= "string" then return tostring(value or "") end
    local key = value:match("^loc:(.+)$")
    local lookup = key or value
    local custom = EZ_CustomTexts[EZ_CurrentLanguage]
    local preset = EZ_TextPresets[EZ_CurrentLanguage]
    local translated = (custom and custom[lookup]) or (preset and preset[lookup])
    if translated ~= nil then return translated end
    if key then return EZ_CustomTexts.en[key] or EZ_TextPresets.en[key] or ("[" .. key .. "]") end
    return value
end

local function EZ_TranslateError(value)
    local message = tostring(value or "")
    local legacyPath = message:match("Legacy file must be removed manually: (.+)$")
    if legacyPath then return string.format(EZ_Locale.LegacyConfigManual, legacyPath) end
    if message:match("Config not found$") then return EZ_TranslateText("Config not found") end
    return EZ_TranslateText(message)
end

local function EZ_SearchOriginal(value)
    local source = tostring(value or "")
    local key = source:match("^loc:(.+)$")
    if key then
        local english = EZ_CustomTexts.en[key] or EZ_TextPresets.en[key]
        if english then return source .. " " .. english end
    end
    return source
end

local function EZ_ApplyTextBinding(binding)
    local target = binding.target
    if not target or not target.Parent then return end
    if binding.apply then
        binding.apply()
        return
    end
    local text = EZ_TranslateText(binding.source)
    if binding.transform then text = binding.transform(text) end
    target[binding.property] = text
    if binding.onChange then binding.onChange(text) end
end

local function EZ_TrackTextBinding(binding, owner)
    owner = owner or binding.target
    binding.owner = owner
    EZ_TextBindings[binding] = true
    if not EZ_TextBindingsByOwner[owner] then
        EZ_TextBindingsByOwner[owner] = {}
        local ok, connection = pcall(function()
            return owner.Destroying:Connect(function() EZ_ClearTextBindings(owner) end)
        end)
        if ok then EZ_TextOwnerConnections[owner] = connection end
    end
    EZ_TextBindingsByOwner[owner][binding] = true
    EZ_ApplyTextBinding(binding)
    return binding
end

local function EZ_BindText(target, property, source, owner, onChange, transform)
    return EZ_TrackTextBinding({ target = target, property = property, source = source, onChange = onChange, transform = transform }, owner)
end

local function EZ_BindLocaleRefresh(owner, callback)
    return EZ_TrackTextBinding({ target = owner, apply = callback }, owner)
end

local function EZ_SetTextSource(binding, source)
    binding.source = source
    EZ_ApplyTextBinding(binding)
end

EZ_ClearTextBindings = function(owner)
    local list = EZ_TextBindingsByOwner[owner]
    if list then
        for binding in pairs(list) do EZ_TextBindings[binding] = nil end
        EZ_TextBindingsByOwner[owner] = nil
    end
    local connection = EZ_TextOwnerConnections[owner]
    if connection then
        if connection.Connected then connection:Disconnect() end
        EZ_TextOwnerConnections[owner] = nil
    end
end

local function EZ_OnLocaleChange(fn)
    table.insert(EZ_LocaleListeners, fn)
    return fn
end

local function EZ_RefreshLocale()
    for binding in pairs(EZ_TextBindings) do
        local ok, err = pcall(EZ_ApplyTextBinding, binding)
        if not ok then warn("[Eazy UI] Could not update localized text: " .. tostring(err)) end
    end
    for _, fn in ipairs(EZ_LocaleListeners) do pcall(fn) end
end

function EZ:SetLocale(key, value)
    if EZ_Destroyed then return false, "Library was destroyed" end
    if type(key) == "table" then
        for k, v in pairs(key) do EZ_Locale[k] = v end
    elseif key and value then
        EZ_Locale[key] = value
    else
        return
    end
    EZ_RefreshLocale()
end

function EZ:SetLanguage(language)
    if EZ_Destroyed then return false, "Library was destroyed" end
    local resolved = EZ_ResolveLanguage(language)
    if not resolved then return false, "Unknown language: " .. tostring(language) end
    for k, v in pairs(EZ_DefaultLocale) do EZ_Locale[k] = v end
    for k, v in pairs(EZ_Languages[resolved]) do EZ_Locale[k] = v end
    EZ_CurrentLanguage = resolved
    EZ_RefreshLocale()
    return true
end

function EZ:GetLanguage()
    return EZ_CurrentLanguage
end

function EZ:ListLanguages()
    return { "en", "pt-BR", "es" }
end

function EZ:Translate(text)
    return EZ_TranslateText(text)
end

function EZ:RegisterTranslations(language, translations)
    if EZ_Destroyed then return false, "Library was destroyed" end
    local incoming
    if type(language) == "table" and translations == nil then
        incoming = language
    elseif type(language) == "string" and type(translations) == "table" then
        incoming = { [language] = translations }
    else
        return false, "Expected a language and a translation table"
    end
    local pending = {}
    for name, values in pairs(incoming) do
        local resolved = EZ_ResolveLanguage(name)
        if not resolved or type(values) ~= "table" then return false, "Invalid translation language: " .. tostring(name) end
        pending[resolved] = pending[resolved] or {}
        for key, value in pairs(values) do
            if type(key) ~= "string" or key == "" or type(value) ~= "string" then return false, "Translations must map non-empty strings to strings" end
            pending[resolved][key] = value
        end
    end
    for name, values in pairs(pending) do
        for key, value in pairs(values) do EZ_CustomTexts[name][key] = value end
    end
    EZ_RefreshLocale()
    return true
end

local EZ_Themes = {
    Default = {
        Background = EZ_C(14, 22, 18),
        Card = EZ_C(20, 32, 26),
        CardHover = EZ_C(28, 44, 36),
        Border = EZ_C(38, 56, 46),
        BorderHover = EZ_C(56, 80, 66),
        TabActive = EZ_C(24, 40, 32),
        Text = EZ_C(228, 240, 232),
        TextDim = EZ_C(120, 142, 128),
        Accent = EZ_C(95, 200, 140),
        AccentDim = EZ_C(68, 150, 105),
        Success = EZ_C(115, 200, 150),
        Warning = EZ_C(240, 180, 90),
        Error = EZ_C(230, 95, 95),
        Info = EZ_C(95, 200, 140),
        Radius = 6,
        RadiusWindow = 10,
    },
    Pitch = {
        Background = EZ_C(5, 5, 6), Card = EZ_C(12, 12, 14), CardHover = EZ_C(20, 20, 23),
        Border = EZ_C(28, 28, 32), BorderHover = EZ_C(48, 48, 54), TabActive = EZ_C(30, 12, 16),
        Text = EZ_C(235, 235, 238), TextDim = EZ_C(145, 145, 152),
        Accent = EZ_C(244, 63, 94), AccentDim = EZ_C(190, 40, 70),
        Success = EZ_C(115, 200, 150), Warning = EZ_C(240, 180, 90), Error = EZ_C(230, 95, 95), Info = EZ_C(244, 63, 94),
        Radius = 6, RadiusWindow = 10,
    },
    Light = {
        Background = EZ_C(246, 247, 249), Card = EZ_C(255, 255, 255), CardHover = EZ_C(240, 242, 245),
        Border = EZ_C(220, 224, 230), BorderHover = EZ_C(190, 196, 205), TabActive = EZ_C(224, 234, 252),
        Text = EZ_C(25, 28, 35), TextDim = EZ_C(100, 107, 117),
        Accent = EZ_C(37, 99, 235), AccentDim = EZ_C(28, 74, 176),
        Success = EZ_C(22, 163, 74), Warning = EZ_C(217, 119, 6), Error = EZ_C(220, 38, 38), Info = EZ_C(37, 99, 235),
        Radius = 8, RadiusWindow = 12,
    },
    Ocean = {
        Background = EZ_C(6, 14, 26), Card = EZ_C(10, 20, 36), CardHover = EZ_C(15, 27, 46),
        Border = EZ_C(24, 40, 62), BorderHover = EZ_C(38, 60, 90), TabActive = EZ_C(10, 32, 56),
        Text = EZ_C(222, 234, 246), TextDim = EZ_C(108, 128, 148),
        Accent = EZ_C(56, 189, 248), AccentDim = EZ_C(37, 140, 190),
        Success = EZ_C(115, 200, 150), Warning = EZ_C(240, 180, 90), Error = EZ_C(230, 95, 95), Info = EZ_C(56, 189, 248),
        Radius = 8, RadiusWindow = 12,
    },
    Sunset = {
        Background = EZ_C(32, 15, 22), Card = EZ_C(42, 20, 29), CardHover = EZ_C(52, 26, 36),
        Border = EZ_C(70, 34, 46), BorderHover = EZ_C(100, 50, 64), TabActive = EZ_C(58, 32, 20),
        Text = EZ_C(246, 232, 226), TextDim = EZ_C(158, 124, 118),
        Accent = EZ_C(250, 204, 21), AccentDim = EZ_C(196, 158, 12),
        Success = EZ_C(115, 200, 150), Warning = EZ_C(240, 180, 90), Error = EZ_C(230, 95, 95), Info = EZ_C(250, 204, 21),
        Radius = 10, RadiusWindow = 14,
    },
    Mono = {
        Background = EZ_C(18, 18, 18), Card = EZ_C(26, 26, 26), CardHover = EZ_C(34, 34, 34),
        Border = EZ_C(48, 48, 48), BorderHover = EZ_C(72, 72, 72), TabActive = EZ_C(40, 40, 40),
        Text = EZ_C(238, 238, 238), TextDim = EZ_C(132, 132, 132),
        Accent = EZ_C(238, 238, 238), AccentDim = EZ_C(179, 179, 179),
        Success = EZ_C(238, 238, 238), Warning = EZ_C(240, 180, 90), Error = EZ_C(230, 95, 95), Info = EZ_C(238, 238, 238),
        Radius = 4, RadiusWindow = 8,
    },
    Amethyst = {
        Background = EZ_C(22, 17, 32), Card = EZ_C(29, 23, 42), CardHover = EZ_C(37, 30, 53),
        Border = EZ_C(50, 42, 72), BorderHover = EZ_C(74, 62, 104), TabActive = EZ_C(40, 28, 62),
        Text = EZ_C(238, 232, 248), TextDim = EZ_C(138, 128, 158),
        Accent = EZ_C(192, 132, 252), AccentDim = EZ_C(147, 98, 196),
        Success = EZ_C(115, 200, 150), Warning = EZ_C(240, 180, 90), Error = EZ_C(230, 95, 95), Info = EZ_C(192, 132, 252),
        Radius = 8, RadiusWindow = 12,
    },
    Rose = {
        Background = EZ_C(26, 14, 20), Card = EZ_C(35, 19, 27), CardHover = EZ_C(44, 25, 34),
        Border = EZ_C(62, 34, 48), BorderHover = EZ_C(92, 50, 70), TabActive = EZ_C(52, 22, 38),
        Text = EZ_C(248, 232, 238), TextDim = EZ_C(158, 128, 140),
        Accent = EZ_C(244, 114, 182), AccentDim = EZ_C(190, 80, 138),
        Success = EZ_C(115, 200, 150), Warning = EZ_C(240, 180, 90), Error = EZ_C(230, 95, 95), Info = EZ_C(244, 114, 182),
        Radius = 8, RadiusWindow = 12,
    },
    Aqua = {
        Background = EZ_C(8, 20, 20), Card = EZ_C(12, 27, 27), CardHover = EZ_C(17, 35, 35),
        Border = EZ_C(28, 52, 50), BorderHover = EZ_C(42, 76, 73), TabActive = EZ_C(14, 42, 40),
        Text = EZ_C(226, 242, 240), TextDim = EZ_C(116, 140, 138),
        Accent = EZ_C(45, 212, 191), AccentDim = EZ_C(30, 160, 144),
        Success = EZ_C(45, 212, 191), Warning = EZ_C(240, 180, 90), Error = EZ_C(230, 95, 95), Info = EZ_C(45, 212, 191),
        Radius = 8, RadiusWindow = 12,
    },
    Nocturne = {
        Background = EZ_C(9, 11, 22), Card = EZ_C(14, 17, 30), CardHover = EZ_C(20, 24, 40),
        Border = EZ_C(30, 36, 58), BorderHover = EZ_C(46, 54, 86), TabActive = EZ_C(20, 24, 50),
        Text = EZ_C(228, 232, 246), TextDim = EZ_C(122, 130, 156),
        Accent = EZ_C(129, 140, 248), AccentDim = EZ_C(96, 105, 196),
        Success = EZ_C(115, 200, 150), Warning = EZ_C(240, 180, 90), Error = EZ_C(230, 95, 95), Info = EZ_C(129, 140, 248),
        Radius = 6, RadiusWindow = 10,
    },
    Pumpkin = {
        Background = EZ_C(24, 17, 12), Card = EZ_C(32, 23, 16), CardHover = EZ_C(41, 29, 20),
        Border = EZ_C(58, 42, 28), BorderHover = EZ_C(87, 63, 42), TabActive = EZ_C(52, 36, 20),
        Text = EZ_C(244, 236, 228), TextDim = EZ_C(156, 140, 124),
        Accent = EZ_C(249, 115, 22), AccentDim = EZ_C(194, 87, 14),
        Success = EZ_C(115, 200, 150), Warning = EZ_C(240, 180, 90), Error = EZ_C(230, 95, 95), Info = EZ_C(249, 115, 22),
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
local EZ_ThemeNames = { "Default", "Pitch", "Light", "Ocean", "Sunset", "Mono", "Amethyst", "Rose", "Aqua", "Nocturne", "Pumpkin" }
local EZ_CustomThemes = {}
local EZ_ThemeListListeners = {}
local EZ_Painters = {}
local EZ_PaintersByElement = {}
local EZ_TransSurf = {}
local EZ_TransFactors = {}
local EZ_StrokeSurf = {}
local EZ_Connections = {}
local EZ_ThemeListeners = {}
local EZ_GlobalTransparency = 0
local EZ_LogoAsset = nil
local EZ_LogoLoading = false
local EZ_LogoRequest = 0
local EZ_LogoWatchers = {}
local EZ_CurrentWindow = nil
local EZ_ScaleConns = {}
local EZ_MIN_SIZE = Vector2.new(420, 300)
local EZ_STROKE_BASE = 0.7
local EZ_Destroying = false
local EZ_Windows = {}
local EZ_ServiceConnections = {}
local EZ_TransientGuis = {}
EZ._Windows = EZ_Windows

local function EZ_ConnectGlobal(signal, callback)
    local connection = signal:Connect(function(...)
        if not EZ_Destroyed then callback(...) end
    end)
    EZ_ServiceConnections[connection] = true
    return connection
end

local function EZ_SafeCall(callback, ...)
    if type(callback) ~= "function" then return true end
    local ok, result = pcall(callback, ...)
    if not ok then warn("[Eazy UI] Callback failed: " .. tostring(result)) end
    return ok, result
end

local function EZ_Copy(value)
    if type(value) ~= "table" then return value end
    local copy = {}
    for k, v in pairs(value) do copy[k] = EZ_Copy(v) end
    return copy
end

local EZ_Ease = {
    Fast = TweenInfo.new(0.14, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    Med = TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    Slow = TweenInfo.new(0.32, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
    Pop = TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
}

local EZ_NotifyPosition = "BottomRight"
local EZ_NotifyQueue = {}
local EZ_NotifyVisible = {}
local EZ_NotifyMax = 6

local EZ_HoveredSlider = nil
local EZ_Pointer = { input = nil, move = nil, finish = nil, ready = false }
local function EZ_StartPointer(input, move, finish)
    if EZ_Pointer.finish then EZ_SafeCall(EZ_Pointer.finish) end
    EZ_Pointer.input, EZ_Pointer.move, EZ_Pointer.finish = input, move, finish
    if EZ_Pointer.ready then return end
    EZ_Pointer.ready = true
    EZ_ConnectGlobal(UserInputService.InputChanged, function(event)
        local active = EZ_Pointer.input
        if not active or not EZ_Pointer.move then return end
        if (active.UserInputType == Enum.UserInputType.Touch and event == active) or
           (active.UserInputType == Enum.UserInputType.MouseButton1 and event.UserInputType == Enum.UserInputType.MouseMovement) then
            EZ_SafeCall(EZ_Pointer.move, event)
        end
    end)
    EZ_ConnectGlobal(UserInputService.InputEnded, function(event)
        local active = EZ_Pointer.input
        if active and (event == active or (active.UserInputType == Enum.UserInputType.MouseButton1 and event.UserInputType == Enum.UserInputType.MouseButton1)) then
            local done = EZ_Pointer.finish
            EZ_Pointer.input, EZ_Pointer.move, EZ_Pointer.finish = nil, nil, nil
            EZ_SafeCall(done)
        end
    end)
end
local EZ_CapturingKeybind = nil
local EZ_LastCaptureInput = nil
local EZ_KeybindHandlers, EZ_KeybindDispatcherReady = {}, false
local function EZ_RegisterKeybind(callback)
    table.insert(EZ_KeybindHandlers, callback)
    if EZ_KeybindDispatcherReady then return end
    EZ_KeybindDispatcherReady = true
    EZ_ConnectGlobal(UserInputService.InputBegan, function(input, processed)
        for _, handler in ipairs(EZ_KeybindHandlers) do EZ_SafeCall(handler, input, processed) end
    end)
end
local function EZ_CurrentModifiers(excluded)
    local function down(key) return key ~= excluded and UserInputService:IsKeyDown(key) end
    local result = ""
    if down(Enum.KeyCode.LeftControl) or down(Enum.KeyCode.RightControl) then result = result .. "Ctrl+" end
    if down(Enum.KeyCode.LeftShift) or down(Enum.KeyCode.RightShift) then result = result .. "Shift+" end
    if down(Enum.KeyCode.LeftAlt) or down(Enum.KeyCode.RightAlt) then result = result .. "Alt+" end
    return result
end
local EZ_SliderDispatcherReady = false
local function EZ_EnsureSliderDispatcher()
    if EZ_SliderDispatcherReady then return end
    EZ_SliderDispatcherReady = true
    EZ_ConnectGlobal(UserInputService.InputBegan, function(i, p)
        if p or EZ_CapturingKeybind then return end
        if not EZ_HoveredSlider then return end
        if UserInputService:GetFocusedTextBox() then return end
        if i.KeyCode == Enum.KeyCode.Left or i.KeyCode == Enum.KeyCode.DPadLeft then
            EZ_HoveredSlider.dec()
        elseif i.KeyCode == Enum.KeyCode.Right or i.KeyCode == Enum.KeyCode.DPadRight then
            EZ_HoveredSlider.inc()
        end
    end)
    EZ_ConnectGlobal(UserInputService.InputChanged, function(i)
        if i.UserInputType ~= Enum.UserInputType.MouseWheel then return end
        if not EZ_HoveredSlider then return end
        EZ_HoveredSlider.wheel(i.Position.Z > 0)
    end)
end

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
    local conn = signal:Connect(function(...)
        if not EZ_Destroyed then fn(...) end
    end)
    if not EZ_Connections[element] then EZ_Connections[element] = {} end
    table.insert(EZ_Connections[element], conn)
    return conn
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

EZ_OnLocaleChange(function() EZ_Repaint() end)

local function EZ_ApplyThemeAndRepaint(name)
    local clean = tostring(name):lower():gsub("^%s+", ""):gsub("%s+$", "")
    local resolved = EZ_ThemeAliases[clean] or name
    local t = EZ_Themes[resolved] or EZ_Themes.Default
    EZ_CurrentThemeName = resolved
    for k, v in pairs(t) do EZ_Theme[k] = v end
    if not EZ_Theme.Radius then EZ_Theme.Radius = 6 end
    if not EZ_Theme.RadiusWindow then EZ_Theme.RadiusWindow = 10 end
    EZ_Repaint()
    for _, fn in ipairs(EZ_ThemeListeners) do
        pcall(fn, EZ_CurrentThemeName)
    end
end

function EZ:SetTheme(name)
    if EZ_Destroyed then return false, "Library was destroyed" end
    EZ_ApplyThemeAndRepaint(name)
end

function EZ:GetTheme()
    return EZ_CurrentThemeName
end

function EZ:ListThemes()
    return table.clone(EZ_ThemeNames)
end

function EZ:RegisterTheme(name, colors, base)
    if EZ_Destroyed then return false, "Library was destroyed" end
    if type(name) ~= "string" or type(colors) ~= "table" then return false, "Expected a theme name and a table of colors" end
    name = name:gsub("^%s+", ""):gsub("%s+$", "")
    if name == "" or #name > 80 then return false, "Invalid theme name" end
    local key = name:lower()
    local existing = EZ_ThemeAliases[key]
    if existing and not EZ_CustomThemes[existing] then return false, "A built-in theme or alias already uses this name" end
    if existing then name = existing end
    local baseName = type(base) == "string" and (EZ_ThemeAliases[base:lower()] or base) or "Default"
    local parent = EZ_Themes[baseName]
    if not parent then return false, "Unknown base theme" end
    local result = {}
    for k, v in pairs(parent) do result[k] = v end
    for k, v in pairs(colors) do
        if EZ_Themes.Default[k] == nil then return false, "Unknown theme field: " .. tostring(k) end
        if typeof(v) ~= typeof(EZ_Themes.Default[k]) then return false, "Invalid value for theme field: " .. tostring(k) end
        if type(v) == "number" and (v ~= v or v < 0 or v > 100) then return false, "Invalid radius: " .. tostring(k) end
        result[k] = v
    end
    if colors.Accent and colors.AccentDim == nil then
        result.AccentDim = Color3.new(colors.Accent.R * 0.75, colors.Accent.G * 0.75, colors.Accent.B * 0.75)
    end
    if not EZ_CustomThemes[name] then table.insert(EZ_ThemeNames, name) end
    EZ_CustomThemes[name] = true
    EZ_Themes[name] = result
    EZ_ThemeAliases[key] = name
    for _, fn in ipairs(EZ_ThemeListListeners) do pcall(fn, table.clone(EZ_ThemeNames)) end
    if EZ_CurrentThemeName == name then EZ_ApplyThemeAndRepaint(name) end
    return true
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

local EZ_DefaultLogoUrl = "https://raw.githubusercontent.com/akiradv/eazyuilib/3bc2a6f72ddd57e9a603dacf0501e7171b29e296/assets/logonobg.png"
local EZ_DefaultLogoData = "iVBORw0KGgoAAAANSUhEUgAAAQsAAAE6CAYAAAABc3daAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAOdEVYdFNvZnR3YXJlAEZpZ21hnrGWYwAABWpJREFUeAHt3NFRI0cUQNGWi3/IYJWBCWlDWWdiZ+AUnIGdgTORh7XGKyiJvawRmpHOqepqSRR/cKv7IbTZTQbAd/w0AAKxABKxABKxABKxABKxABKxABKxABKxABKxABKxABKxABKxABKxABKxABKxABKxABKxABKxABKxABKxABKxABKxABKxABKxABKxABKxABKxABKxABKxABKxABKxABKxABKxABKxABKxABKxABKxABKxABKxABKxABKxABKxABKxABKxABKxABKxABKxABKxABKxABKxABKxABKxABKxABKxABKxABKxABKxABKxABKxABKxABKxABKxABKxABKxABKxABKxABKxABKxABKxABKxABKxAJK7waV92Ww2vwxYOCcLIBELIBELIBELIBELIBELIBELIBELIBELIBELIBELIBELIBELIBELIBELIBELIBELIBELIBELIBELIBELIBELIBELIBELIBELIBELIBELIBELIBELIBELIBELIBELIBELIBELIBELIBELIBELIBELIBELIBELIBELIBELIBELIBELIBELIBELIBELIBELIBELIBELIBELIBELIBELIBELIBELILkbwFXZ7XbbaXuY1rx/Ong87182m81v4w3EAlbgSADux/MAzI8fxpmIBVzIFID5l3u7X/fjeRAO94sTC3hnr1wDnjyObyeAs50CzkEsIDhxCtiOD7wGXJpYcLPWdg24NLHg6py4BrwMw1WfAs5BLFiN/UlgO/699x9eAx72r43hFHA2YsFinIjB/NxJ4MLEgg9zcD0QgxUSC97NkRg8HjwXg5UTCzIxuG1iwX9exODw/wnEALG4Jd+JwXbAK8TiiuxjMC8x4F2JxYqciMHhgrMRiwURA5ZMLC7v8xSJz0MMWDixuLztgBXwGZxAIhZAIhZAIhZAIhZAIhZAIhZAIhZAIhZAIhZAIhZAIhZAIhZAIhZAIhZAIhZAIhZAIhZAIhZAIhZAIhZAIhZAIhZAIhZAIhZAIhZAIhZAIhZAIhZAIhZAIhZAIhZAIhZAIhZAIhZAIhZAIhZAIhZAIhZAIhZAIhZAcje4tF/3Cz7SX+ONxOLy/t5sNn8MWDjXECARCyARCyARCyARCyARCyARCyARCyARCyARCyARCyARCyARCyARCyARCyARCyARCyARCyARCyARCyARCyARCyARCyARCyARCyARCyARCyARCyARCyARCyARCyARCyARCyARCyARCyARCyARCyARCyARCyARCyARCyC5GwAHdrvddtoepvU4rftpfX0uFnBDphA8RWC7X5/2++Fr21PfKxZwJfYhmE8ET/scg3nNX/8hYgEr8EoIDl/74RAUYgELsJ8TzOt+PD8RPK2zhqAQCzizUwPD8e1EsB0rIBbwPxyE4Gk/djXYjishFnDCuQeGayMW3KQlDAzXRiy4Si8GhsfeTyAEbyQWrM61DAzXRixYlFsaGK6NWPBhXrzV+NjAcDtYLLHgXRgYXj+xIHllYCgEN0IsODUwnJc5AV+JxZXzlwPei1is2JGB4c8jfjYBvJVYLJSBIUuzmX4od4NL+n1afw4hYOHEAkh8ujeQiAWQiAWQiAWQiAWQiAWQiAWQiAWQiAWQiAWQiAWQiAWQiAWQiAWQiAWQiAWQiAWQiAWQiAWQiAWQiAWQiAWQiAWQiAWQiAWQiAWQiAWQiAWQiAWQiAWQiAWQiAWQiAWQiAWQiAWQiAWQiAWQiAWQiAWQiAWQiAWQiAWQiAWQiAWQiAWQiAWQiAWQiAWQiAWQiAWQiAWQiAWQiAWQiAWQiAWQiAWQiAWQiAWQiAWQiAWQiAWQ/APUH6mCV+sc5wAAAABJRU5ErkJggg=="

local function EZ_DecodeLogo(value)
    local alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    local bytes, accumulator, bits = {}, 0, 0
    for i = 1, #value do
        local character = value:sub(i, i)
        if character == "=" then break end
        local index = alphabet:find(character, 1, true)
        if not index then return nil end
        accumulator = accumulator * 64 + index - 1
        bits = bits + 6
        if bits >= 8 then
            bits = bits - 8
            local divisor = 2 ^ bits
            table.insert(bytes, string.char(math.floor(accumulator / divisor)))
            accumulator = accumulator % divisor
        end
    end
    return table.concat(bytes)
end

local function EZ_SetLogoAsset(asset)
    if type(asset) ~= "string" or asset == "" then return false end
    EZ_LogoAsset = asset
    for owner, callback in pairs(EZ_LogoWatchers) do
        if owner.Parent then EZ_SafeCall(callback, asset) end
    end
    table.clear(EZ_LogoWatchers)
    return true
end

local function EZ_LoadLogo(options)
    local supplied = options.LogoAsset
    if type(supplied) == "number" then supplied = "rbxassetid://" .. tostring(supplied) end
    if type(supplied) == "string" and supplied ~= "" then
        EZ_LogoRequest = EZ_LogoRequest + 1
        EZ_LogoLoading = false
        EZ_SetLogoAsset(supplied)
        return
    end
    if options.LoadLogo == false or EZ_LogoAsset or EZ_LogoLoading then return end
    local customAsset = type(getcustomasset) == "function" and getcustomasset or
        (type(getsynasset) == "function" and getsynasset or nil)
    if not customAsset or type(isfile) ~= "function" then return end
    local customUrl = type(options.LogoUrl) == "string" and options.LogoUrl ~= "" and options.LogoUrl or nil
    local url = customUrl or EZ_DefaultLogoUrl
    local maxBytes = math.clamp(tonumber(options.LogoMaxBytes) or 4 * 1024 * 1024, 1024, 16 * 1024 * 1024)
    local hash = 0
    for i = 1, #url do hash = (hash * 131 + string.byte(url, i)) % 2147483647 end
    local filename = type(options.LogoCacheFile) == "string" and options.LogoCacheFile ~= "" and options.LogoCacheFile or
        ("eazyui_logo_" .. tostring(hash) .. ".png")
    local cached, existing = pcall(function()
        if isfile(filename) then return customAsset(filename) end
    end)
    if cached and type(existing) == "string" and existing ~= "" then
        EZ_SetLogoAsset(existing)
        return
    end
    if type(writefile) ~= "function" then return end
    EZ_LogoRequest = EZ_LogoRequest + 1
    local requestId = EZ_LogoRequest
    EZ_LogoLoading = true
    task.spawn(function()
        if EZ_Destroyed or requestId ~= EZ_LogoRequest then return end
        local ok, result = pcall(function()
            local data
            if customUrl then data = game:HttpGet(customUrl) else data = EZ_DecodeLogo(EZ_DefaultLogoData) end
            if type(data) ~= "string" or data:sub(1, 8) ~= string.char(137, 80, 78, 71, 13, 10, 26, 10) then
                error("The logo response is not a PNG image")
            end
            if #data > maxBytes then error("The logo exceeds the configured size limit") end
            if EZ_Destroyed or requestId ~= EZ_LogoRequest then return nil end
            writefile(filename, data)
            return customAsset(filename)
        end)
        if EZ_Destroyed or requestId ~= EZ_LogoRequest then return end
        EZ_LogoLoading = false
        if ok and EZ_SetLogoAsset(result) then return end
        table.clear(EZ_LogoWatchers)
        warn("[Eazy UI] Logo could not be loaded; using the built-in mark: " .. tostring(result))
    end)
end

local function EZ_CreateLogo(parent, size, color)
    local root = Instance.new("Frame")
    root.Name = "EZ_Logo"
    root.Size = UDim2.fromOffset(size, size)
    root.BackgroundTransparency = 1
    root.Parent = parent
    local mark = Instance.new("Frame")
    mark.Name = "EZ_LogoFallback"
    mark.AnchorPoint = Vector2.new(0.5, 0.5)
    mark.Position = UDim2.fromScale(0.5, 0.5)
    mark.Size = UDim2.fromScale(0.85, 1)
    mark.BackgroundTransparency = 1
    mark.Parent = root
    local bars = {}
    local function bar(x, y, w, h)
        local part = Instance.new("Frame")
        part.Position = UDim2.fromScale(x, y)
        part.Size = UDim2.fromScale(w, h)
        part.BorderSizePixel = 0
        part.Parent = mark
        table.insert(bars, part)
    end
    bar(0, 0, 0.36, 1)
    bar(0, 0, 1, 0.233)
    bar(0, 0.425, 0.95, 0.22)
    bar(0, 0.77, 1, 0.23)
    local image = Instance.new("ImageLabel")
    image.Name = "EZ_LogoImage"
    image.Size = UDim2.fromScale(1, 1)
    image.BackgroundTransparency = 1
    image.ScaleType = Enum.ScaleType.Fit
    image.Active = false
    image.Image = ""
    image.Parent = root
    local function repaint()
        local shade = color()
        image.ImageColor3 = shade
        for _, part in ipairs(bars) do part.BackgroundColor3 = shade end
    end
    repaint()
    EZ_Paint(repaint, root)
    local function sync()
        if image.Parent then mark.Visible = not image.IsLoaded end
    end
    image:GetPropertyChangedSignal("IsLoaded"):Connect(sync)
    local function setImage(asset)
        if not image.Parent then return end
        image.Image = asset
        sync()
    end
    if EZ_LogoAsset then
        setImage(EZ_LogoAsset)
    elseif EZ_LogoLoading then
        EZ_LogoWatchers[root] = setImage
    end
    root.Destroying:Connect(function()
        EZ_LogoWatchers[root] = nil
        EZ_ClearPaintersFor(root)
    end)
    return root
end

local EZ_IconSets = {
    lucide = {
        house = "rbxassetid://98755624629571",
        home = "rbxassetid://98755624629571",
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

local EZ_TITLEBAR_HEIGHT = 46
local EZ_SIDEBAR_WIDTH = 178
local EZ_NOTIFY_WIDTH = 320
local EZ_ConfigFolder = "EazyUI_Configs"

local function EZ_KeyFilePath(configId)
    local safeId = tostring(configId or "global"):gsub("[^%w%-_]", "_")
    return "eazyui_key_" .. safeId .. ".json"
end

local function EZ_RandName(base)
    return base .. "_" .. tostring(math.random(10000000, 99999999))
end

local function EZ_GuiParent()
    if type(gethui) == "function" then
        local ok, parent = pcall(gethui)
        if ok and parent then return parent end
    end
    local playerGui
    pcall(function()
        local player = game:GetService("Players").LocalPlayer
        if player then playerGui = player:FindFirstChildOfClass("PlayerGui") or player:WaitForChild("PlayerGui") end
    end)
    return playerGui or CoreGui
end

local function EZ_Hide(gui)
    if protectgui then pcall(function() protectgui(gui) end) end
end

local function EZ_Clamp(v, lo, hi) return math.clamp(v, lo, hi) end
local function EZ_ResponsiveMinimum(base, available)
    return math.min(base, available, math.max(1, available - 96))
end

local function EZ_Snap(v, minimum, maximum, step)
    v = EZ_Clamp(tonumber(v) or minimum, minimum, maximum)
    if step <= 0 then return v end
    local snapped = minimum + math.floor((v - minimum) / step + 0.5) * step
    return EZ_Clamp(snapped, minimum, maximum)
end

local function EZ_FormatStep(value, step)
    local decimals, scaled = 0, step
    while decimals < 6 and math.abs(scaled - math.floor(scaled + 0.5)) > 0.000001 do
        decimals = decimals + 1
        scaled = scaled * 10
    end
    return string.format("%." .. decimals .. "f", value)
end

local EZ_SearchParents = {}
local EZ_SearchRefresh = {}
local EZ_SearchAccents = {
    ["á"] = "a", ["à"] = "a", ["â"] = "a", ["ã"] = "a", ["ä"] = "a", ["Á"] = "a", ["À"] = "a", ["Â"] = "a", ["Ã"] = "a", ["Ä"] = "a",
    ["é"] = "e", ["è"] = "e", ["ê"] = "e", ["ë"] = "e", ["É"] = "e", ["È"] = "e", ["Ê"] = "e", ["Ë"] = "e",
    ["í"] = "i", ["ì"] = "i", ["î"] = "i", ["ï"] = "i", ["Í"] = "i", ["Ì"] = "i", ["Î"] = "i", ["Ï"] = "i",
    ["ó"] = "o", ["ò"] = "o", ["ô"] = "o", ["õ"] = "o", ["ö"] = "o", ["Ó"] = "o", ["Ò"] = "o", ["Ô"] = "o", ["Õ"] = "o", ["Ö"] = "o",
    ["ú"] = "u", ["ù"] = "u", ["û"] = "u", ["ü"] = "u", ["Ú"] = "u", ["Ù"] = "u", ["Û"] = "u", ["Ü"] = "u",
    ["ç"] = "c", ["Ç"] = "c", ["ñ"] = "n", ["Ñ"] = "n",
}
local function EZ_SearchText(value)
    local text = tostring(value or ""):lower()
    return (text:gsub("[\194-\244][\128-\191]*", function(c) return EZ_SearchAccents[c] or c end))
end
local EZ_UpperAccents = {
    ["á"] = "Á", ["à"] = "À", ["â"] = "Â", ["ã"] = "Ã", ["ä"] = "Ä", ["ç"] = "Ç",
    ["é"] = "É", ["è"] = "È", ["ê"] = "Ê", ["ë"] = "Ë", ["í"] = "Í", ["ì"] = "Ì", ["î"] = "Î", ["ï"] = "Ï",
    ["ó"] = "Ó", ["ò"] = "Ò", ["ô"] = "Ô", ["õ"] = "Õ", ["ö"] = "Ö", ["ñ"] = "Ñ",
    ["ú"] = "Ú", ["ù"] = "Ù", ["û"] = "Û", ["ü"] = "Ü",
}
local function EZ_Upper(value)
    return (tostring(value or ""):upper():gsub("[\194-\244][\128-\191]*", function(c) return EZ_UpperAccents[c] or c end))
end
local function EZ_SetSearchText(row, title, description, originalTitle, originalDescription)
    if not row then return end
    local text = tostring(title or "") .. " " .. tostring(description or "") .. " " .. EZ_SearchOriginal(originalTitle) .. " " .. EZ_SearchOriginal(originalDescription)
    if row:GetAttribute("EZ_SearchText") == text then return end
    row:SetAttribute("EZ_SearchText", text)
    row:SetAttribute("EZ_SearchFolded", EZ_SearchText(text))
    local refresh = EZ_SearchRefresh[row]
    if refresh then refresh() end
end
local function EZ_LayoutChild(parent, child)
    local order = (parent:GetAttribute("EZ_LayoutOrder") or 0) + 1
    parent:SetAttribute("EZ_LayoutOrder", order)
    child.LayoutOrder = order
    child.Parent = parent
    local register = EZ_SearchParents[parent]
    if register then register(child) end
end

local function EZ_Normalize(a, b)
    if type(a) == "string" then
        b = type(b) == "table" and b or {}
        b.Title = b.Title or a
        return b
    end
    return type(a) == "table" and a or {}
end

local EZ_Environment
local function EZ_TryEnvironment(candidate)
    if type(candidate) ~= "table" then return false end
    local ok = pcall(function()
        if type(candidate.EazyUIInstances) ~= "table" then candidate.EazyUIInstances = {} end
        candidate.EazyUI = candidate.EazyUI
    end)
    if ok then EZ_Environment = candidate end
    return ok
end
pcall(function() if type(getgenv) == "function" then EZ_TryEnvironment(getgenv()) end end)
if not EZ_Environment then pcall(function() EZ_TryEnvironment(shared) end) end
if not EZ_Environment then pcall(function() EZ_TryEnvironment(_G) end) end
EZ.Compat.instances = EZ_Environment ~= nil
local EZ_PreviousInstance = EZ_Environment and EZ_Environment.EazyUI or nil
local EZ_InstanceRegistry
if EZ_Environment then
    EZ_InstanceRegistry = EZ_Environment.EazyUIInstances
    if EZ_PreviousInstance then
        local found = false
        for _, instance in ipairs(EZ_InstanceRegistry) do if instance == EZ_PreviousInstance then found = true; break end end
        if not found then table.insert(EZ_InstanceRegistry, EZ_PreviousInstance) end
    end
end
local EZ_InstancePrepared = false
local function EZ_PrepareInstance(allowMultiple)
    if EZ_InstancePrepared then return 0 end
    EZ_InstancePrepared = true
    local previous = {}
    if EZ_InstanceRegistry then
        for _, instance in ipairs(EZ_InstanceRegistry) do
            if instance ~= EZ and type(instance) == "table" and type(instance.Destroy) == "function" then table.insert(previous, instance) end
        end
    elseif EZ_PreviousInstance and EZ_PreviousInstance ~= EZ then
        table.insert(previous, EZ_PreviousInstance)
    end
    if not allowMultiple then
        for _, instance in ipairs(previous) do
            local ok, err = pcall(instance.Destroy, instance)
            if not ok then warn("[Eazy UI] Could not close a previous execution: " .. tostring(err)) end
            if ok and EZ_InstanceRegistry then
                for i = #EZ_InstanceRegistry, 1, -1 do
                    if EZ_InstanceRegistry[i] == instance then table.remove(EZ_InstanceRegistry, i) end
                end
            end
        end
        EZ_PreviousInstance = nil
        return 0
    end
    EZ_PreviousInstance = nil
    return #previous
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
    local viewport = Vector2.new(1280, 720)
    pcall(function() viewport = workspace.CurrentCamera.ViewportSize end)
    EZ_NOTIFY_WIDTH = math.min(320, math.max(1, viewport.X - 32))
    EZ_NotifyContainer.Size = UDim2.new(0, EZ_NOTIFY_WIDTH, 1, -40)
    for _, entry in ipairs(EZ_NotifyVisible) do
        if not entry.closed and entry.holder and entry.holder.Parent then
            if entry.resize then
                entry.resize(EZ_NOTIFY_WIDTH)
            else
                entry.holder.Size = UDim2.fromOffset(EZ_NOTIFY_WIDTH, entry.height)
                if entry.card then entry.card.Size = UDim2.fromOffset(EZ_NOTIFY_WIDTH, entry.height) end
            end
        end
    end
    local insetY = 0
    pcall(function()
        local top, bottom = GuiService:GetGuiInset()
        insetY = (top and top.Y or 0) + (bottom and bottom.Y or 0)
    end)
    local available = math.max(1, viewport.Y - insetY - 40)
    local function usedHeight()
        local height = 0
        for _, entry in ipairs(EZ_NotifyVisible) do height = height + entry.height + 8 end
        return height
    end
    while #EZ_NotifyVisible > 1 and usedHeight() - 8 > available do
        local oldest = EZ_NotifyVisible[1]
        if oldest and oldest.destroy then oldest.destroy("Overflow") else break end
        if EZ_Destroyed then break end
    end
    local pos = EZ_NotifyPosition
    if pos == "BottomRight" then
        EZ_NotifyContainer.AnchorPoint = Vector2.new(1, 1)
        EZ_NotifyContainer.Position = UDim2.new(1, -20, 1, -20)
        EZ_NotifyLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
        EZ_NotifyLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    elseif pos == "BottomLeft" then
        EZ_NotifyContainer.AnchorPoint = Vector2.new(0, 1)
        EZ_NotifyContainer.Position = UDim2.new(0, 20, 1, -20)
        EZ_NotifyLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
        EZ_NotifyLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    elseif pos == "TopRight" then
        EZ_NotifyContainer.AnchorPoint = Vector2.new(1, 0)
        EZ_NotifyContainer.Position = UDim2.new(1, -20, 0, 20)
        EZ_NotifyLayout.VerticalAlignment = Enum.VerticalAlignment.Top
        EZ_NotifyLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    elseif pos == "TopLeft" then
        EZ_NotifyContainer.AnchorPoint = Vector2.new(0, 0)
        EZ_NotifyContainer.Position = UDim2.new(0, 20, 0, 20)
        EZ_NotifyLayout.VerticalAlignment = Enum.VerticalAlignment.Top
        EZ_NotifyLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    end
end
EZ_OnLocaleChange(EZ_UpdateNotifyPosition)
EZ_UpdateNotifyPosition()

local function EZ_AddStroke(parent, color, thickness, owner)
    local s = Instance.new("UIStroke")
    s.Color = color or EZ_Theme.Border
    local fixedColor = color and color ~= EZ_Theme.Border and color or nil
    s.Thickness = thickness or 1
    local isTextObj = parent:IsA("TextBox") or parent:IsA("TextLabel") or parent:IsA("TextButton")
    s.ApplyStrokeMode = isTextObj and Enum.ApplyStrokeMode.Border or Enum.ApplyStrokeMode.Contextual
    s.Parent = parent
    table.insert(EZ_StrokeSurf, s)
    s.Transparency = EZ_STROKE_BASE
    EZ_Paint(function()
        if isTextObj and parent:IsA("TextBox") then
            if UserInputService:GetFocusedTextBox() ~= parent then s.Color = EZ_Theme.Border end
        else
            s.Color = fixedColor or EZ_Theme.Border
        end
    end, owner or parent)
    return s
end

local function EZ_AddRadius(parent, radius, owner)
    local c = Instance.new("UICorner")
    local themeField = radius == "Window" and "RadiusWindow" or (radius == "Theme" and "Radius" or nil)
    c.CornerRadius = UDim.new(0, themeField and EZ_Theme[themeField] or radius or EZ_Theme.Radius)
    c.Parent = parent
    if themeField then
        EZ_Paint(function() c.CornerRadius = UDim.new(0, EZ_Theme[themeField]) end, owner or parent)
    end
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
            s.Transparency = EZ_Clamp(EZ_STROKE_BASE + EZ_GlobalTransparency * 0.1, 0, 1)
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
EZ_AddStroke(EZ_DropdownPopup, EZ_Theme.Border)
EZ_AddRadius(EZ_DropdownPopup, "Theme")
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
EZ_DropdownLayout.SortOrder = Enum.SortOrder.LayoutOrder
EZ_DropdownLayout.Parent = EZ_DropdownList

local EZ_DropdownPad = Instance.new("UIPadding")
EZ_DropdownPad.PaddingTop = UDim.new(0, 4)
EZ_DropdownPad.PaddingBottom = UDim.new(0, 4)
EZ_DropdownPad.Parent = EZ_DropdownList

local EZ_DropdownCurrent = nil
EZ_OnLocaleChange(function()
    local search = EZ_DropdownList:FindFirstChild("EZ_DropdownSearch")
    if search then search.PlaceholderText = EZ_Locale.Search end
    if EZ_DropdownCurrent and EZ_DropdownCurrent.refreshOptions then EZ_DropdownCurrent.refreshOptions() end
end)

local function EZ_CloseDropdown()
    if not EZ_DropdownCurrent then return end
    local prev = EZ_DropdownCurrent
    EZ_DropdownCurrent = nil
    prev.refreshOptions = nil
    local focused = UserInputService:GetFocusedTextBox()
    if focused and focused:IsDescendantOf(EZ_DropdownPopup) then focused:ReleaseFocus() end
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
    if EZ_DropdownCurrent then
        if EZ_DropdownCurrent.sign and EZ_DropdownCurrent.sign.Parent then
            TweenService:Create(EZ_DropdownCurrent.sign, EZ_Ease.Med, { Rotation = 0 }):Play()
        end
        EZ_DropdownCurrent.refreshOptions = nil
    end
    EZ_DropdownCurrent = entry
    for _, child in ipairs(EZ_DropdownList:GetChildren()) do
        if child:IsA("TextButton") or child:IsA("TextBox") then child:Destroy() end
    end
    local optionButtons = {}
    local searchBox
    local function filterOptions()
        local q = searchBox and EZ_SearchText(searchBox.Text) or ""
        for _, data in ipairs(optionButtons) do
            local combined = EZ_SearchOriginal(data.name) .. " " .. data.btn.Text
            data.btn.Visible = q == "" or EZ_SearchText(combined):find(q, 1, true) ~= nil
        end
        EZ_DropdownList.CanvasPosition = Vector2.new(0, 0)
    end
    entry.refreshOptions = function()
        for _, data in ipairs(optionButtons) do data.btn.Text = entry.getDisplay(data.value) end
        filterOptions()
    end
    local optionHeight = UserInputService.TouchEnabled and 40 or 30
    if entry.searchable then
        local search = Instance.new("TextBox")
        search.Name = "EZ_DropdownSearch"
        search.Size = UDim2.new(1, 0, 0, UserInputService.TouchEnabled and 40 or 30)
        search.LayoutOrder = 0
        search.BackgroundColor3 = EZ_Theme.Card
        search.BorderSizePixel = 0
        search.Text = ""
        search.PlaceholderText = EZ_Locale.Search
        search.Font = EZ_Brand.FontBody
        search.TextSize = 13
        search.TextColor3 = EZ_Theme.Text
        search.PlaceholderColor3 = EZ_Theme.TextDim
        search.TextXAlignment = Enum.TextXAlignment.Left
        search.ClearTextOnFocus = false
        search.ZIndex = 61
        search.Parent = EZ_DropdownList
        searchBox = search
        local sp = Instance.new("UIPadding")
        sp.PaddingLeft = UDim.new(0, 10)
        sp.Parent = search
        search:GetPropertyChangedSignal("Text"):Connect(filterOptions)
    end
    local values = entry.getValues()
    local function isSelected(v)
        local selected = entry.getValue()
        if type(selected) == "table" then
            for _, sv in ipairs(selected) do if sv == v then return true end end
            return false
        end
        return v == selected
    end
    for index, v in ipairs(values) do
        local op = Instance.new("TextButton")
        op.LayoutOrder = index
        op.Size = UDim2.new(1, 0, 0, optionHeight)
        op.BackgroundTransparency = 1
        op.Text = entry.getDisplay(v)
        op.Font = EZ_Brand.FontBody
        op.TextSize = 13
        op.TextColor3 = isSelected(v) and EZ_Theme.Accent or EZ_Theme.Text
        op.TextXAlignment = Enum.TextXAlignment.Left
        op.AutoButtonColor = false
        op.ZIndex = 61
        op.Parent = EZ_DropdownList
        table.insert(optionButtons, { btn = op, name = tostring(v), value = v })
        local opp = Instance.new("UIPadding")
        opp.PaddingLeft = UDim.new(0, 12)
        opp.Parent = op
        op.MouseEnter:Connect(function()
            TweenService:Create(op, TweenInfo.new(0.1), { BackgroundTransparency = 0, BackgroundColor3 = EZ_Theme.CardHover }):Play()
            if not isSelected(v) then
                TweenService:Create(op, TweenInfo.new(0.1), { TextColor3 = EZ_Theme.Text }):Play()
            end
        end)
        op.MouseLeave:Connect(function()
            TweenService:Create(op, TweenInfo.new(0.1), { TextColor3 = isSelected(v) and EZ_Theme.Accent or EZ_Theme.Text, BackgroundTransparency = 1 }):Play()
        end)
        op.Activated:Connect(function()
            entry.pick(v)
            if not entry.multi then
                EZ_CloseDropdown()
            else
                for _, data in ipairs(optionButtons) do
                    data.btn.TextColor3 = isSelected(data.value) and EZ_Theme.Accent or EZ_Theme.Text
                end
            end
        end)
    end
    local trigPos = entry.trigger.AbsolutePosition
    local trigSize = entry.trigger.AbsoluteSize
    local guiPos = EZ_Gui.AbsolutePosition
    local winPos = entry.windowFrame.AbsolutePosition
    local winSize = entry.windowFrame.AbsoluteSize
    local popH = math.min(#values * optionHeight + (entry.searchable and (UserInputService.TouchEnabled and 48 or 38) or 8), 240, math.max(8, winSize.Y - 12))
    local popW = math.min(math.max(entry.width or 160, trigSize.X), math.max(1, winSize.X - 12))
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

EZ_ConnectGlobal(UserInputService.InputBegan, function(input, processed)
    if not EZ_DropdownCurrent then return end
    if input.KeyCode == Enum.KeyCode.Escape then
        EZ_CloseDropdown()
        return
    end
    if EZ_DropdownCurrent and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
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

local function EZ_ViewportUsable()
    local vp = Vector2.new(1280, 720)
    pcall(function() vp = workspace.CurrentCamera.ViewportSize end)
    local inset, bottom = Vector2.new(0, 0), Vector2.new(0, 0)
    pcall(function()
        local a, b = GuiService:GetGuiInset()
        inset, bottom = a or inset, b or bottom
    end)
    return Vector2.new(math.max(1, vp.X - inset.X - bottom.X), math.max(1, vp.Y - inset.Y - bottom.Y)), inset, bottom
end

local function EZ_ApplyResponsiveScale(frame, baseSize)
    local usable, inset, bottom = EZ_ViewportUsable()
    local margin = 24
    local maxW, maxH = math.max(1, usable.X - margin), math.max(1, usable.Y - margin)
    local desiredW = frame:GetAttribute("EZ_UserResized") and frame.Size.X.Offset or baseSize.X
    local desiredH = frame:GetAttribute("EZ_UserResized") and frame.Size.Y.Offset or baseSize.Y
    frame.Size = UDim2.fromOffset(math.min(math.max(1, desiredW), maxW), math.min(math.max(1, desiredH), maxH))
    local scaler = frame:FindFirstChild("EZ_WindowScale")
    if not scaler then
        scaler = Instance.new("UIScale")
        scaler.Name = "EZ_WindowScale"
        scaler.Parent = frame
    end

    scaler.Scale = 1
    frame:SetAttribute("EZ_Scale", 1)
    if not frame:GetAttribute("EZ_Moved") then
        frame.Position = UDim2.new(0.5, (inset.X - bottom.X) / 2, 0.5, (inset.Y - bottom.Y) / 2)
    end
    return 1
end

local function EZ_ViewportLimits(frame)
    local origin, screenSize = EZ_Gui.AbsolutePosition, EZ_Gui.AbsoluteSize
    if screenSize.X <= 1 or screenSize.Y <= 1 then
        local ok, area = pcall(function() return GuiService:GetInsetArea(Enum.ScreenInsets.DeviceSafeInsets) end)
        if ok and area and area.Max.X > area.Min.X and area.Max.Y > area.Min.Y then
            origin = area.Min
            screenSize = area.Max - area.Min
        else
            local usable, inset, bottom = EZ_ViewportUsable()
            origin = Vector2.new(-inset.X, -inset.Y)
            screenSize = Vector2.new(usable.X + inset.X + bottom.X, usable.Y + inset.Y + bottom.Y)
        end
    end
    local padding = math.max(0, tonumber(frame:GetAttribute("EZ_ViewportPadding")) or 0)
    padding = math.min(padding, screenSize.X / 2, screenSize.Y / 2)
    local size = frame.AbsoluteSize
    local minX, minY = origin.X + padding, origin.Y + padding
    local maxX = math.max(minX, origin.X + screenSize.X - size.X - padding)
    local maxY = math.max(minY, origin.Y + screenSize.Y - size.Y - padding)
    return minX, maxX, minY, maxY
end

local function EZ_ClampToViewport(frame)
    local minX, maxX, minY, maxY = EZ_ViewportLimits(frame)
    local abs = frame.AbsolutePosition
    local dx = math.clamp(abs.X, minX, maxX) - abs.X
    local dy = math.clamp(abs.Y, minY, maxY) - abs.Y
    if dx ~= 0 or dy ~= 0 then
        local pos = frame.Position
        frame.Position = UDim2.new(pos.X.Scale, pos.X.Offset + dx, pos.Y.Scale, pos.Y.Offset + dy)
    end
end

local function EZ_CleanupTransientGui(gui)
    local data = EZ_TransientGuis[gui]
    if not data then return end
    EZ_TransientGuis[gui] = nil
    EZ_ClearTextBindings(gui)
    if data.connection then
        if data.connection.Connected then data.connection:Disconnect() end
        EZ_ServiceConnections[data.connection] = nil
    end
    EZ_ClearPaintersFor(gui)
    for _, child in ipairs(gui:GetDescendants()) do EZ_ClearPaintersFor(child) end
    for i = #EZ_TransSurf, 1, -1 do
        local inst = EZ_TransSurf[i]
        if inst:IsDescendantOf(gui) then EZ_TransFactors[inst] = nil; table.remove(EZ_TransSurf, i) end
    end
    for i = #EZ_StrokeSurf, 1, -1 do
        if EZ_StrokeSurf[i]:IsDescendantOf(gui) then table.remove(EZ_StrokeSurf, i) end
    end
end
local function EZ_CloseTransientGui(gui)
    EZ_CleanupTransientGui(gui)
    gui:Destroy()
end
local function EZ_TrackTransientGui(gui, card, width, height)
    local data = {}
    EZ_TransientGuis[gui] = data
    local scaler = Instance.new("UIScale")
    scaler.Name = "EZ_DialogScale"
    scaler.Parent = card
    local function update()
        local usable = EZ_ViewportUsable()
        scaler.Scale = math.min(1, math.max(0.1, (usable.X - 24) / width), math.max(0.1, (usable.Y - 24) / height))
    end
    update()
    pcall(function() data.connection = EZ_ConnectGlobal(workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"), update) end)
    gui.Destroying:Connect(function() EZ_CleanupTransientGui(gui) end)
end

local function EZ_MakeDraggable(frame, handle)
    handle.Active = true
    local dragging, start, startPos, startAbsolute, dragInput = false, nil, nil, nil, nil
    local function stop(i)
        if not dragging then return end
        if i == dragInput or (dragInput.UserInputType == Enum.UserInputType.MouseButton1 and i.UserInputType == Enum.UserInputType.MouseButton1) then
            dragging, dragInput = false, nil
        end
    end
    handle.InputBegan:Connect(function(i)
        if dragging then return end
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging, dragInput = true, i
            start, startPos, startAbsolute = i.Position, frame.Position, frame.AbsolutePosition
            frame:SetAttribute("EZ_Moved", true)
            EZ_CloseDropdown()
        end
    end)
    handle.InputEnded:Connect(stop)
    EZ_ConnectGlobal(UserInputService.InputEnded, stop)
    EZ_ConnectGlobal(UserInputService.InputChanged, function(i)
        if not dragging or not frame.Parent then return end
        if (dragInput.UserInputType == Enum.UserInputType.Touch and i == dragInput) or
           (dragInput.UserInputType == Enum.UserInputType.MouseButton1 and i.UserInputType == Enum.UserInputType.MouseMovement) then
            local d = i.Position - start
            local minX, maxX, minY, maxY = EZ_ViewportLimits(frame)
            local x = math.clamp(startAbsolute.X + d.X, minX, maxX) - startAbsolute.X
            local y = math.clamp(startAbsolute.Y + d.Y, minY, maxY) - startAbsolute.Y
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + x, startPos.Y.Scale, startPos.Y.Offset + y)
        end
    end)
end

local EZ_RESIZE_DEFS = {
    { id = "N",  pos = UDim2.new(0, 24, 0, 0),   size = UDim2.new(1, -48, 0, 10) },
    { id = "S",  pos = UDim2.new(0, 24, 1, -10), size = UDim2.new(1, -48, 0, 10) },
    { id = "W",  pos = UDim2.new(0, 0, 0, 24),   size = UDim2.new(0, 10, 1, -48) },
    { id = "E",  pos = UDim2.new(1, -10, 0, 24), size = UDim2.new(0, 10, 1, -48) },
    { id = "NW", pos = UDim2.new(0, 0, 0, 0),    size = UDim2.fromOffset(24, 24) },
    { id = "NE", pos = UDim2.new(1, -24, 0, 0),  size = UDim2.fromOffset(24, 24) },
    { id = "SW", pos = UDim2.new(0, 0, 1, -24),  size = UDim2.fromOffset(24, 24) },
    { id = "SE", pos = UDim2.new(1, -24, 1, -24),size = UDim2.fromOffset(24, 24) },
}

local function EZ_MakeResizable(frame)
    local resizing, direction, startInput, startPoint, startSize, startPos = false, nil, nil, nil, nil, nil
    local function stop(i)
        if resizing and (i.UserInputType == Enum.UserInputType.MouseButton1 or i == startInput) then
            resizing, direction, startInput = false, nil, nil
            if frame.Parent then EZ_ClampToViewport(frame) end
        end
    end
    for _, def in ipairs(EZ_RESIZE_DEFS) do
        local h = Instance.new("Frame")
        h.Name = "EZ_Resize_" .. def.id
        h.Active = true
        h.BackgroundTransparency = 1
        h.Position, h.Size = def.pos, def.size
        h.ZIndex = 200
        h.Parent = frame
        h.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                resizing, direction, startInput = true, def.id, i
                startPoint = i.Position
                startSize = Vector2.new(frame.Size.X.Offset, frame.Size.Y.Offset)
                startPos = frame.Position
                frame:SetAttribute("EZ_UserResized", true)
                frame:SetAttribute("EZ_Moved", true)
                EZ_CloseDropdown()
            end
        end)
        h.InputEnded:Connect(stop)
    end
    EZ_ConnectGlobal(UserInputService.InputEnded, stop)
    EZ_ConnectGlobal(UserInputService.InputChanged, function(i)
        if not resizing or not frame.Parent then return end
        if not ((startInput.UserInputType == Enum.UserInputType.Touch and i == startInput) or
                (startInput.UserInputType == Enum.UserInputType.MouseButton1 and i.UserInputType == Enum.UserInputType.MouseMovement)) then return end
        local usable = EZ_ViewportUsable()
        local scale = frame:GetAttribute("EZ_Scale") or 1
        local maxW, maxH = math.max(1, (usable.X - 8) / scale), math.max(1, (usable.Y - 8) / scale)
        local minW, minH = EZ_ResponsiveMinimum(EZ_MIN_SIZE.X, maxW), EZ_ResponsiveMinimum(EZ_MIN_SIZE.Y, maxH)
        local d = i.Position - startPoint
        local w, hgt, dx, dy = startSize.X, startSize.Y, 0, 0
        if direction:find("E") then w = EZ_Clamp(startSize.X + d.X / scale, minW, maxW); dx = (w - startSize.X) * scale / 2 end
        if direction:find("W") then w = EZ_Clamp(startSize.X - d.X / scale, minW, maxW); dx = -(w - startSize.X) * scale / 2 end
        if direction:find("S") then hgt = EZ_Clamp(startSize.Y + d.Y / scale, minH, maxH); dy = (hgt - startSize.Y) * scale / 2 end
        if direction:find("N") then hgt = EZ_Clamp(startSize.Y - d.Y / scale, minH, maxH); dy = -(hgt - startSize.Y) * scale / 2 end
        frame.Size = UDim2.fromOffset(w, hgt)
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + dx, startPos.Y.Scale, startPos.Y.Offset + dy)
    end)
end

local function EZ_NewRow(page, height, element, useHitbox)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, height)
    row.BackgroundColor3 = EZ_Theme.Card
    row.BorderSizePixel = 0
    row.ClipsDescendants = true
    EZ_LayoutChild(page, row)
    local st = EZ_AddStroke(row, EZ_Theme.Border, 1)
    EZ_AddRadius(row, "Theme")
    EZ_RegTrans(row)

    local hoverTarget = row
    local hitbox = nil
    if useHitbox then
        hitbox = Instance.new("TextButton")
        hitbox.Name = "Hitbox"
        hitbox.Size = UDim2.new(1, 0, 1, 0)
        hitbox.BackgroundTransparency = 1
        hitbox.Text = ""
        hitbox.ZIndex = 2
        hitbox.AutoButtonColor = false
        hitbox.Parent = row
        hoverTarget = hitbox
    end

    local hovering = false
    EZ_Paint(function()
        row.BackgroundColor3 = hovering and EZ_Theme.CardHover or EZ_Theme.Card
        st.Color = hovering and EZ_Theme.BorderHover or EZ_Theme.Border
    end, element)
    EZ_Connect(hoverTarget, hoverTarget.MouseEnter, function()
        hovering = true
        TweenService:Create(st, EZ_Ease.Fast, { Color = EZ_Theme.BorderHover }):Play()
        TweenService:Create(row, EZ_Ease.Fast, { BackgroundColor3 = EZ_Theme.CardHover }):Play()
    end)
    EZ_Connect(hoverTarget, hoverTarget.MouseLeave, function()
        hovering = false
        TweenService:Create(st, EZ_Ease.Fast, { Color = EZ_Theme.Border }):Play()
        TweenService:Create(row, EZ_Ease.Fast, { BackgroundColor3 = EZ_Theme.Card }):Play()
    end)
    return row, hitbox
end

local function EZ_RowTitle(row, text, desc, height, rightPad, element)
    local pad = rightPad or 130
    local l = Instance.new("TextLabel")
    l.Position = UDim2.fromOffset(14, desc and 9 or 0)
    l.Size = UDim2.new(1, -pad, 0, desc and 16 or (height or 46))
    l.BackgroundTransparency = 1
    l.Text = EZ_TranslateText(text)
    l.Font = EZ_Brand.FontBody
    l.TextSize = 13
    l.TextColor3 = EZ_Theme.Text
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.TextTruncate = Enum.TextTruncate.AtEnd
    l.Parent = row
    if element then element._titleLabel = l end
    EZ_Paint(function() l.TextColor3 = EZ_Theme.Text end, element)
    local descriptionLabel
    if desc and desc ~= "" then
        local d = Instance.new("TextLabel")
        descriptionLabel = d
        d.Position = UDim2.fromOffset(14, 27)
        d.Size = UDim2.new(1, -pad, 0, 14)
        d.BackgroundTransparency = 1
        d.Text = EZ_TranslateText(desc)
        d.Font = EZ_Brand.FontBody
        d.TextSize = 11
        d.TextColor3 = EZ_Theme.TextDim
        d.TextXAlignment = Enum.TextXAlignment.Left
        d.TextTruncate = Enum.TextTruncate.AtEnd
        d.Parent = row
        if element then element._descriptionLabel = d end
        EZ_Paint(function() d.TextColor3 = EZ_Theme.TextDim end, element)
    end
    local function updateSearch()
        EZ_SetSearchText(row, l.Text, descriptionLabel and descriptionLabel.Text or "", text, desc)
    end
    EZ_BindText(l, "Text", text, row, updateSearch)
    if descriptionLabel then EZ_BindText(descriptionLabel, "Text", desc, row, updateSearch) end
    return l, descriptionLabel
end

local function EZ_ValidConfigName(name)
    if type(name) ~= "string" then return false end
    if name == "" or name == "_autoload" or #name > 80 or name:match("^%s*$") then return false end
    if name:find("..", 1, true) or name:find('[\\/%c:*?"<>|]') then return false end
    return true
end

local function EZ_ConfigDirectory(configId)
    return EZ_ConfigFolder .. "/" .. tostring(configId)
end
local function EZ_ConfigPath(configId, name)
    return EZ_ConfigDirectory(configId) .. "/" .. name .. ".json"
end
local function EZ_LegacyConfigPath(configId, name)
    return EZ_ConfigFolder .. "/" .. tostring(configId) .. "_" .. name .. ".json"
end
local function EZ_EnsureConfigDirectory(configId)
    if not isfolder(EZ_ConfigFolder) then makefolder(EZ_ConfigFolder) end
    local dir = EZ_ConfigDirectory(configId)
    if not isfolder(dir) then makefolder(dir) end
end

local function EZ_SaveConfig(placeId, configName, data)
    if not EZ_ValidConfigName(configName) then return false, "Invalid config name" end
    if type(writefile) ~= "function" or type(isfolder) ~= "function" or type(makefolder) ~= "function" then
        return false, "Filesystem is unavailable"
    end
    local ok, err = pcall(function()
        EZ_EnsureConfigDirectory(placeId)
        writefile(EZ_ConfigPath(placeId, configName), HttpService:JSONEncode(data))
    end)
    if not ok then return false, tostring(err) end
    return true
end

local function EZ_LoadConfig(placeId, configName)
    if not EZ_ValidConfigName(configName) then return nil, "Invalid config name" end
    if type(readfile) ~= "function" or type(isfile) ~= "function" then return nil, "Filesystem is unavailable" end
    local ok, data = pcall(function()
        local path = EZ_ConfigPath(placeId, configName)
        if not isfile(path) then path = EZ_LegacyConfigPath(placeId, configName) end
        if not isfile(path) then return nil end
        return HttpService:JSONDecode(readfile(path))
    end)
    if not ok then return nil, tostring(data) end
    if type(data) ~= "table" then return nil, "Config not found or invalid" end
    return data
end

local function EZ_DeleteConfig(placeId, configName)
    if not EZ_ValidConfigName(configName) then return false, "Invalid config name" end
    if type(delfile) ~= "function" or type(isfile) ~= "function" then return false, "Filesystem is unavailable" end
    local ok, err = pcall(function()
        local path = EZ_ConfigPath(placeId, configName)
        local legacy = EZ_LegacyConfigPath(placeId, configName)

        if isfile(legacy) then error("Legacy file must be removed manually: " .. legacy) end
        if not isfile(path) then error("Config not found") end
        delfile(path)
    end)
    if not ok then return false, tostring(err) end
    return true
end

local function EZ_ListConfigs(placeId)
    if type(listfiles) ~= "function" or type(isfolder) ~= "function" then return {} end
    local configs, seen = {}, {}
    local function add(name)
        if EZ_ValidConfigName(name) and not seen[name] then seen[name] = true; table.insert(configs, name) end
    end
    local ok, files = pcall(function()
        local dir = EZ_ConfigDirectory(placeId)
        return isfolder(dir) and listfiles(dir) or {}
    end)
    if ok then
        for _, file in ipairs(files) do
            local name = file:match("([^/\\]+)$") or file
            if name:sub(-5) == ".json" then add(name:sub(1, #name - 5)) end
        end
    end

    local legacyOk, legacyFiles = pcall(function()
        return isfolder(EZ_ConfigFolder) and listfiles(EZ_ConfigFolder) or {}
    end)
    if legacyOk then
        local base = tostring(placeId) .. "_"
        for _, file in ipairs(legacyFiles) do
            local name = file:match("([^/\\]+)$") or file
            if name:sub(1, #base) == base and name:sub(-5) == ".json" then add(name:sub(#base + 1, #name - 5)) end
        end
    end
    table.sort(configs)
    return configs
end

local function EZ_AutoloadPath(configId)
    return EZ_ConfigDirectory(configId) .. "/_autoload.json"
end
local function EZ_LegacyAutoloadPath(configId)
    return EZ_ConfigFolder .. "/" .. tostring(configId) .. "__autoload.json"
end
local function EZ_GetAutoloadName(configId)
    if type(readfile) ~= "function" or type(isfile) ~= "function" then return nil end
    local ok, name = pcall(function()
        local path = EZ_AutoloadPath(configId)
        if not isfile(path) then path = EZ_LegacyAutoloadPath(configId) end
        if isfile(path) then
            local data = HttpService:JSONDecode(readfile(path))
            return type(data) == "table" and data.name or nil
        end
        return nil
    end)
    return ok and EZ_ValidConfigName(name) and name or nil
end
local function EZ_SetAutoloadName(configId, name)
    if not EZ_ValidConfigName(name) then return false, "Invalid config name" end
    if type(writefile) ~= "function" or type(isfolder) ~= "function" or type(makefolder) ~= "function" then
        return false, "Filesystem is unavailable"
    end
    local ok, err = pcall(function()
        EZ_EnsureConfigDirectory(configId)
        writefile(EZ_AutoloadPath(configId), HttpService:JSONEncode({ name = name }))
    end)
    if not ok then return false, tostring(err) end
    return true
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
    EZ_TrackTransientGui(gui, card, 460, 170)
    EZ_AddRadius(card, "Window")
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
    local letter = Instance.new("CanvasGroup")
    letter.Size = UDim2.fromOffset(58, 58)
    letter.BackgroundTransparency = 1
    letter.GroupTransparency = 1
    letter.Parent = holder
    local loadingLogo = EZ_CreateLogo(letter, 58, function() return EZ_Theme.Accent end)
    loadingLogo.Size = UDim2.fromScale(1, 1)
    local fadeProp = "GroupTransparency"
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.fromOffset(420, 24)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title and EZ_TranslateText(title) or EZ_Locale.Loading
    titleLabel.Font = EZ_Brand.Font
    titleLabel.TextSize = 18
    titleLabel.TextColor3 = EZ_Theme.Text
    titleLabel.TextXAlignment = Enum.TextXAlignment.Center
    titleLabel.TextTruncate = Enum.TextTruncate.AtEnd
    titleLabel.TextTransparency = 1
    titleLabel.Parent = holder
    EZ_Paint(function() titleLabel.TextColor3 = EZ_Theme.Text end, gui)
    local subLabel = Instance.new("TextLabel")
    subLabel.Size = UDim2.fromOffset(420, 18)
    subLabel.BackgroundTransparency = 1
    subLabel.Text = subtitle and EZ_TranslateText(subtitle) or EZ_Locale.PleaseWait
    subLabel.Font = EZ_Brand.FontBody
    subLabel.TextSize = 13
    subLabel.TextColor3 = EZ_Theme.TextDim
    subLabel.TextXAlignment = Enum.TextXAlignment.Center
    subLabel.TextTruncate = Enum.TextTruncate.AtEnd
    subLabel.TextTransparency = 1
    subLabel.Parent = holder
    EZ_Paint(function() subLabel.TextColor3 = EZ_Theme.TextDim end, gui)
    EZ_BindLocaleRefresh(gui, function()
        titleLabel.Text = title and EZ_TranslateText(title) or EZ_Locale.Loading
        subLabel.Text = subtitle and EZ_TranslateText(subtitle) or EZ_Locale.PleaseWait
    end)
    local fadeInfo = TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    TweenService:Create(letter, fadeInfo, { [fadeProp] = 0 }):Play()
    TweenService:Create(titleLabel, fadeInfo, { TextTransparency = 0 }):Play()
    TweenService:Create(subLabel, fadeInfo, { TextTransparency = 0 }):Play()
    task.wait(duration or 2)
    if EZ_Destroyed or not gui.Parent then return end
    local outInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
    TweenService:Create(letter, outInfo, { [fadeProp] = 1 }):Play()
    TweenService:Create(titleLabel, outInfo, { TextTransparency = 1 }):Play()
    TweenService:Create(subLabel, outInfo, { TextTransparency = 1 }):Play()
    TweenService:Create(card, outInfo, { BackgroundTransparency = 1 }):Play()
    TweenService:Create(cardStroke, outInfo, { Transparency = 1 }):Play()
    task.wait(0.32)
    EZ_CloseTransientGui(gui)
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
    EZ_TrackTransientGui(gui, frame, 460, 280)
    EZ_AddStroke(frame, EZ_Theme.Border)
    EZ_AddRadius(frame, "Window")
    EZ_RegTrans(frame)
    EZ_Paint(function() frame.BackgroundColor3 = EZ_Theme.Background end, gui)
    local iconFrame = Instance.new("Frame")
    iconFrame.Size = UDim2.fromOffset(48, 48)
    iconFrame.Position = UDim2.new(0.5, -24, 0, 22)
    iconFrame.BackgroundColor3 = EZ_Theme.Accent
    iconFrame.BorderSizePixel = 0
    iconFrame.Parent = frame
    EZ_AddRadius(iconFrame, 12)
    EZ_Paint(function() iconFrame.BackgroundColor3 = EZ_Theme.Accent end, gui)
    local iconLetter = EZ_CreateLogo(iconFrame, 38, function() return EZ_Theme.Background end)
    iconLetter.Position = UDim2.fromOffset(5, 5)
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -40, 0, 24)
    title.Position = UDim2.new(0.5, 0, 0, 82)
    title.AnchorPoint = Vector2.new(0.5, 0)
    title.BackgroundTransparency = 1
    title.Text = EZ_Locale.JoinDiscord
    title.Font = EZ_Brand.Font
    title.TextSize = 18
    title.TextColor3 = EZ_Theme.Text
    title.TextXAlignment = Enum.TextXAlignment.Center
    title.Parent = frame
    EZ_Paint(function() title.TextColor3 = EZ_Theme.Text end, gui)
    local sub = Instance.new("TextLabel")
    sub.Size = UDim2.new(1, -40, 0, 38)
    sub.Position = UDim2.new(0.5, 0, 0, 112)
    sub.AnchorPoint = Vector2.new(0.5, 0)
    sub.BackgroundTransparency = 1
    sub.Text = EZ_Locale.DiscordSubtitle
    sub.Font = EZ_Brand.FontBody
    sub.TextSize = 13
    sub.TextColor3 = EZ_Theme.TextDim
    sub.TextXAlignment = Enum.TextXAlignment.Center
    sub.TextWrapped = true
    sub.Parent = frame
    EZ_Paint(function() sub.TextColor3 = EZ_Theme.TextDim end, gui)
    local inviteLabel = Instance.new("Frame")
    inviteLabel.Size = UDim2.new(1, -40, 0, 46)
    inviteLabel.Position = UDim2.new(0.5, 0, 0, 160)
    inviteLabel.AnchorPoint = Vector2.new(0.5, 0)
    inviteLabel.BackgroundColor3 = EZ_Theme.Card
    inviteLabel.BorderSizePixel = 0
    inviteLabel.Parent = frame
    EZ_AddStroke(inviteLabel, EZ_Theme.Border)
    EZ_AddRadius(inviteLabel, "Theme")
    EZ_RegTrans(inviteLabel)
    EZ_Paint(function() inviteLabel.BackgroundColor3 = EZ_Theme.Card end, gui)
    local inviteText = Instance.new("TextLabel")
    inviteText.Size = UDim2.new(1, -20, 1, 0)
    inviteText.BackgroundTransparency = 1
    inviteText.Text = "discord.gg/" .. invite
    inviteText.Font = EZ_Brand.FontMono
    inviteText.TextSize = 14
    inviteText.TextColor3 = EZ_Theme.Accent
    inviteText.TextXAlignment = Enum.TextXAlignment.Center
    inviteText.Parent = inviteLabel
    EZ_Paint(function() inviteText.TextColor3 = EZ_Theme.Accent end, gui)
    local copyBtn = Instance.new("TextButton")
    copyBtn.Size = UDim2.new(0.5, -19, 0, 42)
    copyBtn.Position = UDim2.new(0, 14, 0, 218)
    copyBtn.BackgroundColor3 = EZ_Theme.Accent
    copyBtn.BorderSizePixel = 0
    copyBtn.Text = EZ_Locale.CopyLink
    copyBtn.Font = EZ_Brand.FontBody
    copyBtn.TextSize = 14
    copyBtn.TextColor3 = EZ_Theme.Background
    copyBtn.AutoButtonColor = false
    copyBtn.Parent = frame
    EZ_AddRadius(copyBtn, "Theme")
    EZ_Paint(function() copyBtn.BackgroundColor3 = EZ_Theme.Accent; copyBtn.TextColor3 = EZ_Theme.Background end, gui)
    local skipBtn = Instance.new("TextButton")
    skipBtn.Size = UDim2.new(0.5, -19, 0, 42)
    skipBtn.Position = UDim2.new(0.5, 5, 0, 218)
    skipBtn.BackgroundColor3 = EZ_Theme.CardHover
    skipBtn.BorderSizePixel = 0
    skipBtn.Text = EZ_Locale.Skip
    skipBtn.Font = EZ_Brand.FontBody
    skipBtn.TextSize = 14
    skipBtn.TextColor3 = EZ_Theme.TextDim
    skipBtn.AutoButtonColor = false
    skipBtn.Parent = frame
    local showingLink = false
    EZ_BindLocaleRefresh(gui, function()
        title.Text = EZ_Locale.JoinDiscord
        sub.Text = EZ_Locale.DiscordSubtitle
        skipBtn.Text = EZ_Locale.Skip
        if not showingLink then copyBtn.Text = EZ_Locale.CopyLink end
    end)
    local skipSt = EZ_AddStroke(skipBtn, EZ_Theme.Border)
    EZ_AddRadius(skipBtn, "Theme")
    EZ_Paint(function() skipBtn.BackgroundColor3 = EZ_Theme.CardHover; skipBtn.TextColor3 = EZ_Theme.TextDim end, gui)
    skipBtn.MouseEnter:Connect(function() TweenService:Create(skipSt, EZ_Ease.Fast, { Color = EZ_Theme.BorderHover }):Play() end)
    skipBtn.MouseLeave:Connect(function() TweenService:Create(skipSt, EZ_Ease.Fast, { Color = EZ_Theme.Border }):Play() end)
    copyBtn.Activated:Connect(function()
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
            showingLink = true
            copyBtn.Text = link
            task.delay(3, function()
                showingLink = false
                if copyBtn.Parent then copyBtn.Text = EZ_Locale.CopyLink end
            end)
            return
        end
        EZ_CloseTransientGui(gui)
        callback(true)
    end)
    skipBtn.Activated:Connect(function() EZ_CloseTransientGui(gui); callback(false) end)
    return gui
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
    frame.Size = UDim2.fromOffset(430, 280)
    frame.AnchorPoint = Vector2.new(0.5, 0.5)
    frame.Position = UDim2.new(0.5, 0, 0.5, 0)
    frame.BackgroundColor3 = EZ_Theme.Background
    frame.BorderSizePixel = 0
    frame.Parent = gui
    EZ_TrackTransientGui(gui, frame, 430, 280)
    EZ_AddStroke(frame, EZ_Theme.Border)
    EZ_AddRadius(frame, "Window")
    EZ_RegTrans(frame)
    EZ_Paint(function() frame.BackgroundColor3 = EZ_Theme.Background end, gui)
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -24, 0, 24)
    title.Position = UDim2.fromOffset(16, 18)
    title.BackgroundTransparency = 1
    title.Text = options.Title and EZ_TranslateText(options.Title) or EZ_Locale.EnterKey
    title.Font = EZ_Brand.Font
    title.TextSize = 16
    title.TextColor3 = EZ_Theme.Text
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = frame
    EZ_Paint(function() title.TextColor3 = EZ_Theme.Text end, gui)
    local sub = Instance.new("TextLabel")
    sub.Size = UDim2.new(1, -24, 0, 18)
    sub.Position = UDim2.fromOffset(16, 46)
    sub.BackgroundTransparency = 1
    sub.Text = options.Subtitle and EZ_TranslateText(options.Subtitle) or EZ_Locale.EnterKeySubtitle
    sub.Font = EZ_Brand.FontBody
    sub.TextSize = 12
    sub.TextColor3 = EZ_Theme.TextDim
    sub.TextXAlignment = Enum.TextXAlignment.Left
    sub.Parent = frame
    EZ_Paint(function() sub.TextColor3 = EZ_Theme.TextDim end, gui)
    local input = Instance.new("TextBox")
    input.Size = UDim2.new(1, -32, 0, 38)
    input.Position = UDim2.fromOffset(16, 80)
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
    EZ_AddRadius(input, "Theme")
    EZ_RegTrans(input)
    EZ_Paint(function() input.BackgroundColor3 = EZ_Theme.Card; input.TextColor3 = EZ_Theme.Text; input.PlaceholderColor3 = EZ_Theme.TextDim end, gui)
    local ip = Instance.new("UIPadding")
    ip.PaddingLeft = UDim.new(0, 12); ip.PaddingRight = UDim.new(0, 12); ip.Parent = input
    input.Focused:Connect(function() ist.Color = EZ_Theme.BorderHover end)
    input.FocusLost:Connect(function() ist.Color = EZ_Theme.Border end)
    local note = Instance.new("TextLabel")
    note.Size = UDim2.new(1, -32, 0, 18)
    note.Position = UDim2.fromOffset(16, 124)
    note.BackgroundTransparency = 1
    note.Text = EZ_TranslateText(options.Note or "")
    note.Font = EZ_Brand.FontBody
    note.TextSize = 11
    note.TextColor3 = EZ_Theme.TextDim
    note.TextXAlignment = Enum.TextXAlignment.Left
    note.Parent = frame
    EZ_Paint(function() note.TextColor3 = EZ_Theme.TextDim end, gui)
    local submit = Instance.new("TextButton")
    submit.Size = UDim2.new(0.5, -21, 0, 40)
    submit.Position = UDim2.new(0, 16, 0, 162)
    submit.BackgroundColor3 = EZ_Theme.Accent
    submit.BorderSizePixel = 0
    submit.Text = EZ_Locale.Submit
    submit.Font = EZ_Brand.FontBody
    submit.TextSize = 13
    submit.TextColor3 = EZ_Theme.Background
    submit.AutoButtonColor = false
    submit.Parent = frame
    EZ_AddRadius(submit, "Theme")
    EZ_Paint(function() submit.BackgroundColor3 = EZ_Theme.Accent; submit.TextColor3 = EZ_Theme.Background end, gui)
    local cancel = Instance.new("TextButton")
    cancel.Size = UDim2.new(0.5, -21, 0, 40)
    cancel.Position = UDim2.new(0.5, 5, 0, 162)
    cancel.BackgroundColor3 = EZ_Theme.CardHover
    cancel.BorderSizePixel = 0
    cancel.Text = EZ_Locale.Cancel
    cancel.Font = EZ_Brand.FontBody
    cancel.TextSize = 13
    cancel.TextColor3 = EZ_Theme.TextDim
    cancel.AutoButtonColor = false
    cancel.Parent = frame
    local cst = EZ_AddStroke(cancel, EZ_Theme.Border)
    EZ_AddRadius(cancel, "Theme")
    EZ_Paint(function() cancel.BackgroundColor3 = EZ_Theme.CardHover; cancel.TextColor3 = EZ_Theme.TextDim end, gui)
    cancel.MouseEnter:Connect(function() TweenService:Create(cst, EZ_Ease.Fast, { Color = EZ_Theme.BorderHover }):Play() end)
    cancel.MouseLeave:Connect(function() TweenService:Create(cst, EZ_Ease.Fast, { Color = EZ_Theme.Border }):Play() end)
    local err = Instance.new("TextLabel")
    err.Size = UDim2.new(1, -32, 0, 20)
    err.Position = UDim2.fromOffset(16, 214)
    err.BackgroundTransparency = 1
    err.Text = ""
    err.Font = EZ_Brand.FontBody
    err.TextSize = 11
    err.TextColor3 = EZ_Theme.Error
    err.TextXAlignment = Enum.TextXAlignment.Left
    err.Parent = frame
    local statusKey
    EZ_BindLocaleRefresh(gui, function()
        title.Text = options.Title and EZ_TranslateText(options.Title) or EZ_Locale.EnterKey
        sub.Text = options.Subtitle and EZ_TranslateText(options.Subtitle) or EZ_Locale.EnterKeySubtitle
        note.Text = EZ_TranslateText(options.Note or "")
        input.PlaceholderText = EZ_Locale.EnterKeyPlaceholder
        submit.Text = EZ_Locale.Submit
        cancel.Text = EZ_Locale.Cancel
        err.Text = statusKey and EZ_Locale[statusKey] or ""
    end)
    local submitting = false
    local function doSubmit()
        if submitting or not gui.Parent then return end
        submitting = true
        local key = input.Text
        statusKey = "Validating"
        err.Text = EZ_Locale[statusKey]
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
            if not gui.Parent then return end
            submitting = false
            if not resolved then
                statusKey = "KeyTimeout"
                err.Text = EZ_Locale[statusKey]
                err.TextColor3 = EZ_Theme.Error
                return
            end
            if result then
                EZ_SaveKey(key, options.Duration, options.FileName)
                EZ_CloseTransientGui(gui)
                callback(true, key)
            else
                statusKey = "InvalidKey"
                err.Text = EZ_Locale[statusKey]
                err.TextColor3 = EZ_Theme.Error
                input.Text = ""
            end
        end)
    end
    submit.Activated:Connect(doSubmit)
    input.FocusLost:Connect(function(enter) if enter then doSubmit() end end)
    cancel.Activated:Connect(function() EZ_CloseTransientGui(gui); callback(false, nil) end)
    input:CaptureFocus()
    return gui
end

local function EZ_NotifyTextHeight(text, size, width)
    local ok, bounds = pcall(function()
        return TextService:GetTextSize(tostring(text or ""), size, EZ_Brand.FontBody, Vector2.new(math.max(1, width), 1000000))
    end)
    if ok and bounds and type(bounds.Y) == "number" and bounds.Y > 0 then return math.ceil(bounds.Y) end
    local chars = math.max(1, math.floor(math.max(1, width) / (size * 0.55)))
    local lines = 0
    for line in (tostring(text or "") .. "\n"):gmatch("(.-)\n") do
        lines = lines + math.max(1, math.ceil(#line / chars))
    end
    return math.max(size, math.ceil(lines * size * 1.2))
end

local function EZ_NotifyMetrics(title, content, hasInput, hasButtons, width, available)
    available = math.max(1, available)
    local titleHeight = math.min(42, math.max(16, EZ_NotifyTextHeight(title, 14, width - 62)))
    local contentY = 12 + titleHeight + 2
    local contentHeight = math.max(28, EZ_NotifyTextHeight(content, 12, width - 38))
    local extra = hasInput and 54 or (hasButtons and 46 or 10)
    local visibleHeight = math.min(contentHeight, math.max(1, available - contentY - extra))
    return {
        titleHeight = titleHeight, contentY = contentY, contentHeight = contentHeight,
        visibleHeight = visibleHeight, height = contentY + visibleHeight + extra,
    }
end

local EZ_NotifyFlushing = false
local function EZ_FlushNotifyQueue()
    if EZ_NotifyFlushing or EZ_Destroyed then return end
    EZ_NotifyFlushing = true
    local ok, err = pcall(function()
        while #EZ_NotifyQueue > 0 and not EZ_Destroyed do
            local nextEntry = EZ_NotifyQueue[1]
            if nextEntry.measure then nextEntry.height = nextEntry.measure().height end
            local usable = EZ_ViewportUsable()
            local available = math.max(1, usable.Y - 40)
            local function usedHeight()
                local height = 0
                for _, entry in ipairs(EZ_NotifyVisible) do height = height + entry.height + 8 end
                return height
            end
            while #EZ_NotifyVisible > 0 and (#EZ_NotifyVisible >= EZ_NotifyMax or usedHeight() + nextEntry.height > available) do
                local oldest = EZ_NotifyVisible[1]
                if oldest and oldest.destroy then oldest.destroy("Overflow") else break end
                if EZ_Destroyed then break end
            end
            if EZ_Destroyed then break end
            local data = table.remove(EZ_NotifyQueue, 1)
            if data then data.render() end
        end
    end)
    EZ_NotifyFlushing = false
    if not ok then warn("[Eazy UI] Notification error: " .. tostring(err)) end
end

function EZ:Notify(options)
    if EZ_Destroyed then return false, "Library was destroyed" end
    options = options or {}
    local titleSource = tostring(options.Title or "Eazy UI")
    local contentSource = tostring(options.Content or "")
    local t, c
    local d = options.Duration
    local automaticDuration = d == nil
    local style = (options.Style or "Info"):lower()
    local buttons = options.Buttons or {}
    local onOpen = options.OnOpen
    local onClose = options.OnClose
    local inputCallback = options.InputCallback
    local hasInput = options.Input == true
    local hasButtons = #buttons > 0 or hasInput
    local cachedWidth, cachedAvailable, cachedMetrics
    local function resolveText(source, key, args, translateArg)
        local text = key and EZ_Locale[key] or nil
        if text == nil then return EZ_TranslateText(source) end
        if args then
            local formatted = table.clone(args)
            if translateArg and formatted[translateArg] ~= nil then
                formatted[translateArg] = EZ_TranslateError(formatted[translateArg])
            end
            local ok, result = pcall(string.format, text, table.unpack(formatted))
            if ok then return result end
        end
        return text
    end
    local function updateText()
        local newTitle = resolveText(titleSource, options._TitleKey, options._TitleArgs)
        local newContent = resolveText(contentSource, options._ContentKey, options._ContentArgs, options._TranslateArg)
        if t ~= newTitle or c ~= newContent then
            t, c = newTitle, newContent
            cachedWidth, cachedAvailable, cachedMetrics = nil, nil, nil
        end
    end
    local function measure(width)
        updateText()
        width = width or EZ_NOTIFY_WIDTH
        local usable = EZ_ViewportUsable()
        local available = math.max(1, usable.Y - 40)
        if width ~= cachedWidth or available ~= cachedAvailable then
            cachedWidth, cachedAvailable = width, available
            cachedMetrics = EZ_NotifyMetrics(t, c, hasInput, hasButtons, width, available)
        end
        return cachedMetrics
    end
    if d == nil then
        local metrics = measure()
        if metrics.contentHeight > metrics.visibleHeight then
            d = 0
        else
            d = math.clamp(math.ceil(#c / 20), 3, 20)
        end
    end
    local styleColor = EZ_Theme.Info
    if style == "success" then styleColor = EZ_Theme.Success
    elseif style == "warning" then styleColor = EZ_Theme.Warning
    elseif style == "error" then styleColor = EZ_Theme.Error end

    local function render()
        if EZ_Destroyed then return end
        local destroyNotify
        local holder = Instance.new("Frame")
        holder.Name = "EZ_Notification"
        holder.Size = UDim2.fromOffset(0, measure().height)
        holder.BackgroundTransparency = 1
        holder.ClipsDescendants = true
        holder.Parent = EZ_NotifyContainer
        local card = Instance.new("Frame")
        card.Name = "EZ_NotificationCard"
        card.BackgroundColor3 = EZ_Theme.Card
        card.BorderSizePixel = 0
        card.Parent = holder
        EZ_AddStroke(card, EZ_Theme.Border, nil, holder)
        EZ_AddRadius(card, "Theme", holder)
        EZ_RegTrans(card)
        EZ_Paint(function() card.BackgroundColor3 = EZ_Theme.Card end, holder)
        local bar = Instance.new("Frame")
        bar.Size = UDim2.new(0, 2, 1, -18)
        bar.Position = UDim2.fromOffset(10, 9)
        bar.BackgroundColor3 = styleColor
        bar.BorderSizePixel = 0
        bar.Parent = card
        EZ_AddRadius(bar, 1)
        local tl = Instance.new("TextLabel")
        tl.Name = "EZ_NotificationTitle"
        tl.Position = UDim2.fromOffset(20, 12)
        tl.BackgroundTransparency = 1
        tl.Text = t
        tl.Font = EZ_Brand.FontBody
        tl.TextSize = 14
        tl.TextColor3 = EZ_Theme.Text
        tl.TextXAlignment = Enum.TextXAlignment.Left
        tl.TextYAlignment = Enum.TextYAlignment.Top
        tl.TextWrapped = true
        tl.TextTruncate = Enum.TextTruncate.AtEnd
        tl.Parent = card
        EZ_Paint(function() tl.TextColor3 = EZ_Theme.Text end, holder)
        local close = Instance.new("TextButton")
        close.Size = UDim2.fromOffset(32, 32)
        close.Position = UDim2.new(1, -36, 0, 3)
        close.BackgroundTransparency = 1
        close.Text = "×"
        close.TextSize = 20
        close.Font = EZ_Brand.FontBody
        close.TextColor3 = EZ_Theme.TextDim
        close.AutoButtonColor = false
        close.Parent = card
        EZ_Paint(function() close.TextColor3 = EZ_Theme.TextDim end, holder)
        close.Activated:Connect(function() destroyNotify("Close") end)
        local scroll = Instance.new("ScrollingFrame")
        scroll.Name = "EZ_NotificationScroll"
        scroll.BackgroundTransparency = 1
        scroll.BorderSizePixel = 0
        scroll.ClipsDescendants = true
        scroll.ScrollingDirection = Enum.ScrollingDirection.Y
        scroll.VerticalScrollBarInset = Enum.ScrollBarInset.None
        scroll.ScrollBarImageColor3 = EZ_Theme.BorderHover
        scroll.Parent = card
        local cl = Instance.new("TextLabel")
        cl.Name = "EZ_NotificationContent"
        cl.BackgroundTransparency = 1
        cl.Text = c
        cl.Font = EZ_Brand.FontBody
        cl.TextSize = 12
        cl.TextColor3 = EZ_Theme.TextDim
        cl.TextXAlignment = Enum.TextXAlignment.Left
        cl.TextYAlignment = Enum.TextYAlignment.Top
        cl.TextWrapped = true
        cl.Parent = scroll
        EZ_Paint(function() cl.TextColor3 = EZ_Theme.TextDim; scroll.ScrollBarImageColor3 = EZ_Theme.BorderHover end, holder)

        local inputBox, submit, btnRow
        if hasInput then
            inputBox = Instance.new("TextBox")
            inputBox.Size = UDim2.new(1, -120, 0, 36)
            inputBox.BackgroundColor3 = EZ_Theme.Background
            inputBox.BorderSizePixel = 0
            inputBox.Text = ""
            inputBox.PlaceholderText = options.InputPlaceholder and EZ_TranslateText(options.InputPlaceholder) or EZ_Locale.InputPlaceholder
            inputBox.Font = EZ_Brand.FontMono
            inputBox.TextSize = 12
            inputBox.TextColor3 = EZ_Theme.Text
            inputBox.PlaceholderColor3 = EZ_Theme.TextDim
            inputBox.TextXAlignment = Enum.TextXAlignment.Left
            inputBox.ClearTextOnFocus = false
            inputBox.Parent = card
            local ibst = EZ_AddStroke(inputBox, EZ_Theme.Border, nil, holder)
            EZ_AddRadius(inputBox, 5)
            local ibpad = Instance.new("UIPadding")
            ibpad.PaddingLeft = UDim.new(0, 8); ibpad.PaddingRight = UDim.new(0, 8); ibpad.Parent = inputBox
            inputBox.Focused:Connect(function() ibst.Color = EZ_Theme.BorderHover end)
            local function submitInput()
                if EZ_Destroyed then return end
                EZ_SafeCall(inputCallback, inputBox.Text)
                if options.CloseOnInput ~= false then destroyNotify("Input") end
            end
            inputBox.FocusLost:Connect(function(enter)
                if EZ_Destroyed then return end
                ibst.Color = EZ_Theme.Border
                if enter then submitInput() end
            end)
            submit = Instance.new("TextButton")
            submit.Size = UDim2.fromOffset(72, 36)
            submit.BackgroundColor3 = EZ_Theme.Background
            submit.BorderSizePixel = 0
            submit.Text = EZ_Locale.Submit
            submit.Font = EZ_Brand.FontBody
            submit.TextSize = 12
            submit.TextColor3 = EZ_Theme.Text
            submit.AutoButtonColor = false
            submit.Parent = card
            EZ_AddStroke(submit, EZ_Theme.Border, nil, holder)
            EZ_AddRadius(submit, 5)
            EZ_Paint(function()
                submit.BackgroundColor3 = EZ_Theme.Background
                submit.TextColor3 = EZ_Theme.Text
                submit.Text = EZ_Locale.Submit
                inputBox.PlaceholderText = options.InputPlaceholder and EZ_TranslateText(options.InputPlaceholder) or EZ_Locale.InputPlaceholder
            end, holder)
            submit.Activated:Connect(submitInput)
        end

        if hasButtons and not hasInput then
            btnRow = Instance.new("Frame")
            btnRow.Name = "EZ_NotificationActions"
            btnRow.Size = UDim2.new(1, -32, 0, 34)
            btnRow.BackgroundTransparency = 1
            btnRow.Parent = card
            local btnLayout = Instance.new("UIListLayout")
            btnLayout.FillDirection = Enum.FillDirection.Horizontal
            btnLayout.Padding = UDim.new(0, 6)
            btnLayout.Parent = btnRow
            for _, btnData in ipairs(buttons) do
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1 / #buttons, -6 * (#buttons - 1) / #buttons, 1, 0)
                btn.BackgroundColor3 = EZ_Theme.Background
                btn.BorderSizePixel = 0
                btn.Text = EZ_TranslateText(btnData.Title or "")
                btn.Font = EZ_Brand.FontBody
                btn.TextSize = 12
                btn.TextColor3 = EZ_Theme.Text
                btn.AutoButtonColor = false
                btn.Parent = btnRow
                EZ_BindText(btn, "Text", btnData.Title or "", holder)
                local bst = EZ_AddStroke(btn, EZ_Theme.Border, nil, holder)
                EZ_AddRadius(btn, 5)
                EZ_Paint(function() btn.BackgroundColor3 = EZ_Theme.Background; btn.TextColor3 = EZ_Theme.Text end, holder)
                btn.MouseEnter:Connect(function() TweenService:Create(bst, EZ_Ease.Fast, { Color = EZ_Theme.BorderHover }):Play() end)
                btn.MouseLeave:Connect(function() TweenService:Create(bst, EZ_Ease.Fast, { Color = EZ_Theme.Border }):Play() end)
                btn.Activated:Connect(function()
                    EZ_SafeCall(btnData.Callback)
                    destroyNotify("Action")
                end)
            end
        end

        local timer
        if d > 0 and not hasInput then
            timer = Instance.new("Frame")
            timer.Size = UDim2.new(1, -18, 0, 2)
            timer.Position = UDim2.new(0, 9, 1, -7)
            timer.BackgroundColor3 = styleColor
            timer.BackgroundTransparency = 0.5
            timer.BorderSizePixel = 0
            timer.Parent = card
            EZ_AddRadius(timer, 1)
        end
        local entry = { holder = holder, card = card }
        entry.resize = function(width)
            if not holder.Parent then return end
            local metrics = measure(width)
            entry.height = metrics.height
            holder.Size = UDim2.fromOffset(width, metrics.height)
            card.Size = UDim2.fromOffset(width, metrics.height)
            tl.Size = UDim2.new(1, -62, 0, metrics.titleHeight)
            scroll.Position = UDim2.fromOffset(20, metrics.contentY)
            scroll.Size = UDim2.new(1, -30, 0, metrics.visibleHeight)
            scroll.CanvasSize = UDim2.fromOffset(0, metrics.contentHeight)
            scroll.ScrollBarThickness = metrics.contentHeight > metrics.visibleHeight and 3 or 0
            cl.Size = UDim2.new(1, -8, 0, metrics.contentHeight)
            local controlsY = metrics.contentY + metrics.visibleHeight + 2
            if inputBox then inputBox.Position = UDim2.fromOffset(20, controlsY) end
            if submit then submit.Position = UDim2.new(1, -92, 0, controlsY) end
            if btnRow then btnRow.Position = UDim2.fromOffset(20, controlsY) end
            if timer then timer.Visible = not (automaticDuration and metrics.contentHeight > metrics.visibleHeight) end
        end
        EZ_BindLocaleRefresh(holder, function()
            updateText()
            tl.Text, cl.Text = t, c
            if inputBox then inputBox.PlaceholderText = options.InputPlaceholder and EZ_TranslateText(options.InputPlaceholder) or EZ_Locale.InputPlaceholder end
            if submit then submit.Text = EZ_Locale.Submit end
        end)
        entry.resize(EZ_NOTIFY_WIDTH)
        table.insert(EZ_NotifyVisible, entry)
        destroyNotify = function(reason)
            if entry.closed then return end
            entry.closed = true
            EZ_ClearTextBindings(holder)
            for i, e in ipairs(EZ_NotifyVisible) do
                if e == entry then table.remove(EZ_NotifyVisible, i); break end
            end
            EZ_SafeCall(onClose, reason or "Closed")
            if holder.Parent then
                TweenService:Create(holder, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.In), { Size = UDim2.fromOffset(0, entry.height) }):Play()
                task.delay(0.22, function()
                    EZ_ClearPaintersFor(holder)
                    for i = #EZ_TransSurf, 1, -1 do
                        local inst = EZ_TransSurf[i]
                        if inst == holder or inst:IsDescendantOf(holder) then EZ_TransFactors[inst] = nil; table.remove(EZ_TransSurf, i) end
                    end
                    for i = #EZ_StrokeSurf, 1, -1 do
                        if EZ_StrokeSurf[i]:IsDescendantOf(holder) then table.remove(EZ_StrokeSurf, i) end
                    end
                    holder:Destroy()
                    if not EZ_Destroyed then EZ_FlushNotifyQueue() end
                end)
            end
        end
        entry.destroy = destroyNotify
        holder.Size = UDim2.fromOffset(0, entry.height)
        TweenService:Create(holder, TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { Size = UDim2.fromOffset(EZ_NOTIFY_WIDTH, entry.height) }):Play()
        if timer then
            TweenService:Create(timer, TweenInfo.new(d, Enum.EasingStyle.Linear), { Size = UDim2.new(0, 0, 0, 2) }):Play()
        end
        if d > 0 and not hasInput then
            task.delay(d, function()
                if holder.Parent then
                    local metrics = measure()
                    if not automaticDuration or metrics.contentHeight <= metrics.visibleHeight then destroyNotify("Timeout") end
                end
            end)
        end
        EZ_SafeCall(onOpen)
    end

    table.insert(EZ_NotifyQueue, { render = render, height = measure().height, measure = measure })
    EZ_FlushNotifyQueue()
end

function EZ:CreateWindow(options)
    if EZ_Destroyed then return nil, "Library was destroyed" end
    options = options or {}
    local EZ_PreviousCount = EZ_PrepareInstance(options.AllowMultiple == true)
    if options.Translations ~= nil then
        local ok, err = EZ:RegisterTranslations(options.Translations)
        if not ok then warn("[Eazy UI] Invalid translations: " .. tostring(err)) end
    end
    if options.AllowMultiple == true and not EZ_Environment then
        warn("[Eazy UI] No shared environment is available; use a unique ConfigId and MinimizeKey for each execution.")
    end
    local EZ_Name = options.Name or "Eazy UI"
    local EZ_SubTitle = options.SubTitle or ""
    if options.Language then EZ:SetLanguage(options.Language) end
    if options.Theme then EZ:SetTheme(options.Theme) end
    local EZ_Size = options.Size or UDim2.fromOffset(660, 470)
    local EZ_MinKey = options.MinimizeKey or Enum.KeyCode.RightControl
    local EZ_MinMods = type(options.MinimizeModifiers) == "string" and options.MinimizeModifiers or ""
    local EZ_MinMode = options.MinimizeMode or "fade"
    local EZ_ExpandedSidebarWidth = math.clamp(tonumber(options.SidebarWidth) or EZ_SIDEBAR_WIDTH, 120, 300)
    local EZ_CollapsedSidebarWidth = math.clamp(tonumber(options.CollapsedSidebarWidth) or 56, 48, EZ_ExpandedSidebarWidth)
    local configId = options.ConfigId or game.PlaceId
    if options.ConfigId == nil and options.AllowMultiple == true then
        local base = tostring(game.PlaceId) .. "_" .. tostring(EZ_Name):gsub("[^%w%-_]", "_")
        if #base > 100 then base = base:sub(1, 100) end
        local used = {}
        if EZ_InstanceRegistry then
            for _, instance in ipairs(EZ_InstanceRegistry) do
                if type(instance) == "table" and type(instance._Windows) == "table" then
                    for _, window in ipairs(instance._Windows) do if window.ConfigId then used[window.ConfigId] = true end end
                end
            end
        end
        configId = base
        local suffix = 2
        while used[tostring(configId)] do configId = base .. "_" .. suffix; suffix = suffix + 1 end
    end
    local EZ_ConfigId = tostring(configId):gsub("[^%w%-%_ ]", "_")
    if EZ_ConfigId == "" or EZ_ConfigId:match("^%s*$") then EZ_ConfigId = "global" end
    if options.AllowMultiple == true and options.ConfigId ~= nil and EZ_InstanceRegistry then
        local duplicate = false
        for _, instance in ipairs(EZ_InstanceRegistry) do
            if type(instance) == "table" and type(instance._Windows) == "table" then
                for _, window in ipairs(instance._Windows) do
                    if window.ConfigId == EZ_ConfigId then duplicate = true; break end
                end
            end
            if duplicate then break end
        end
        if duplicate then warn("[Eazy UI] ConfigId '" .. EZ_ConfigId .. "' is already in use; simultaneous saves may overwrite each other.") end
    end
    local EZ_KeyFile = EZ_KeyFilePath(EZ_ConfigId)
    local EZ_KeyDuration = options.KeyDuration or 86400
    EZ_GlobalTransparency = EZ_Clamp(options.Transparency or 0, 0, 0.9)
    local EZ_AutoLoad = options.AutoLoad ~= false
    if options.NotifyPosition then
        EZ_NotifyPosition = options.NotifyPosition
        EZ_UpdateNotifyPosition()
    end
    EZ_LoadLogo(options)

    if options.LoadingTitle then
        EZ_ShowLoadingScreen(options.LoadingTitle, options.LoadingSubtitle or "", options.LoadingDuration or 2)
        if EZ_Destroyed then return nil, "Library was destroyed" end
    end
    if options.Discord and options.Discord.Enabled then
        local resolved = false
        local prompt = EZ_ShowDiscordPrompt(options.Discord.Invite, function() resolved = true end)
        local start = tick()
        while not resolved and not EZ_Destroyed and tick() - start < 30 do task.wait(0.1) end
        if prompt and prompt.Parent then EZ_CloseTransientGui(prompt) end
        if EZ_Destroyed then return nil, "Library was destroyed" end
    end
    if options.KeySystem and options.KeySystem.Enabled then
        local keyOptions = { Title = options.KeySystem.Title, Subtitle = options.KeySystem.Subtitle, Note = options.KeySystem.Note, FileName = EZ_KeyFile, Duration = EZ_KeyDuration }
        local savedKey = EZ_LoadKey(EZ_KeyFile)
        if not (savedKey and EZ_ValidateKey(savedKey, options.KeySystem.validator)) then
            local resolved, success = false, false
            local prompt = EZ_ShowKeyScreen(keyOptions, options.KeySystem.validator, function(s) success = s; resolved = true end)
            local start = tick()
            while not resolved and not EZ_Destroyed and tick() - start < 30 do task.wait(0.1) end
            if prompt and prompt.Parent then EZ_CloseTransientGui(prompt) end
            if not success then
                EZ:Notify({ Title = "Eazy UI", _ContentKey = "AccessDenied", Style = "Error", Duration = 3 })
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
    EZ_Window.MinimizeMode = EZ_MinMode
    EZ_Window.ConfigId = EZ_ConfigId
    EZ_Window.AutoSave = options.AutoSave ~= false
    EZ_Window._pendingSaves = {}
    EZ_Window._elementFlags = {}
    EZ_Window._applying = false
    EZ_Window._hasLoadedConfig = false
    table.insert(EZ_Windows, EZ_Window)
    EZ_CurrentWindow = EZ_Window

    function EZ_Window:SetAccent(color)
        EZ_Theme.Accent = color
        local r, g, b = color.R * 255, color.G * 255, color.B * 255
        EZ_Theme.AccentDim = EZ_C(math.floor(r * 0.75), math.floor(g * 0.75), math.floor(b * 0.75))
        EZ_Repaint()
    end

    function EZ_Window:SetMinimizeMode(mode)
        if mode ~= "fade" and mode ~= "shrink" then return false end
        local wasMinimized = self.Minimized
        if wasMinimized and self.SetMinimized then self:SetMinimized(false) end
        self.MinimizeMode = mode
        if self._minimizeModeDropdown then self._minimizeModeDropdown:Set(mode == "shrink" and "Shrink" or "Fade", true) end
        if wasMinimized and self.SetMinimized then self:SetMinimized(true) end
        return true
    end

    local function EZ_SyncConfigDropdown(name)
        EZ_Window._selectedConfig = name
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

    local function EZ_ApplyElementData(el, data)
        if type(data) ~= "table" or data.type ~= el.Type then
            warn("[Eazy UI] Ignoring incompatible config field: " .. tostring(el.Id))
            return false
        end
        local value = data.value
        local ok, err = pcall(function()
            if el.Type == "color" then
                if type(value) ~= "table" or type(value[1]) ~= "number" or type(value[2]) ~= "number" or type(value[3]) ~= "number" then error("invalid color") end
                el:Set(Color3.fromRGB(value[1], value[2], value[3]), false)
            elseif el.Type == "keybind" then
                el.Mods = type(data.mods) == "string" and data.mods or ""
                local key = type(value) == "string" and Enum.KeyCode[value] or nil
                el:Set(key, false)
                if el.Id == "_minimize_key" and key then EZ_MinKey = key end
            elseif el.Type == "multi" or el.Type == "range" then
                if type(value) ~= "table" then error("expected an array") end
                el:Set(EZ_Copy(value), false)
            elseif el.Type == "toggle" then
                if type(value) ~= "boolean" then error("expected a boolean") end
                el:Set(value, false)
            elseif el.Type == "slider" then
                if type(value) ~= "number" then error("expected a number") end
                el:Set(value, false)
            elseif el.Type == "input" or el.Type == "textarea" then
                if type(value) ~= "string" then error("expected text") end
                el:Set(value, false)
            else
                el:Set(value, false)
            end
        end)
        if not ok then warn("[Eazy UI] Invalid config field " .. tostring(el.Id) .. ": " .. tostring(err)) end
        return ok
    end

    function EZ_Window:_RegisterElement(el)
        if not el.Flag then return end
        if type(el.Flag) ~= "string" or el.Flag == "" then error("[Eazy UI] Flag must be a non-empty string", 2) end
        if el.Flag == "_meta" then error("[Eazy UI] Flag _meta is reserved", 2) end
        if self._elementFlags[el.Flag] then error("[Eazy UI] Duplicate Flag: " .. el.Flag, 2) end
        self._elementFlags[el.Flag] = el
        table.insert(self.Elements, el)
        if self._hasLoadedConfig and self.ConfigData[el.Id] then
            local wasApplying = self._applying
            self._applying = true
            EZ_ApplyElementData(el, self.ConfigData[el.Id])
            self._applying = wasApplying
        end
    end

    local function EZ_ApplyConfigData(data, isAutoLoad)
        if type(data) ~= "table" then return false end
        local ignored = 0
        if not isAutoLoad then
            for key in pairs(data) do
                if key ~= "_meta" and not EZ_Window._elementFlags[key] then ignored = ignored + 1 end
            end
        end
        if type(data._meta) == "table" then
            local meta = data._meta
            if type(meta.theme) == "string" then EZ_ApplyThemeAndRepaint(meta.theme) end
            if type(meta.language) == "string" then EZ:SetLanguage(meta.language) end
            if type(meta.transparency) == "number" then EZ_Window:SetTransparency(meta.transparency) end
            if type(meta.autoSave) == "boolean" then EZ_Window.AutoSave = meta.autoSave end
            if meta.minimizeMode == "fade" or meta.minimizeMode == "shrink" then EZ_Window:SetMinimizeMode(meta.minimizeMode) end
            if type(meta.sidebarCollapsed) == "boolean" and EZ_Window.SetSidebarCollapsed then
                EZ_Window:SetSidebarCollapsed(EZ_Window._compact or meta.sidebarCollapsed, true)
            end
            if type(meta.windowSize) == "table" and EZ_Window.Frame then
                local usable = EZ_ViewportUsable()
                local scale = EZ_Window.Frame:GetAttribute("EZ_Scale") or 1
                local maxW, maxH = math.max(1, (usable.X - 8) / scale), math.max(1, (usable.Y - 8) / scale)
                local w = EZ_Clamp(tonumber(meta.windowSize[1]) or 660, EZ_ResponsiveMinimum(EZ_MIN_SIZE.X, maxW), maxW)
                local h = EZ_Clamp(tonumber(meta.windowSize[2]) or 470, EZ_ResponsiveMinimum(EZ_MIN_SIZE.Y, maxH), maxH)
                EZ_Window.Frame.Size = UDim2.fromOffset(w, h)
            end
        end
        if EZ_Window._themeDropdown then EZ_Window._themeDropdown:Set(EZ_CurrentThemeName, true) end
        if EZ_Window._autoSaveToggle then EZ_Window._autoSaveToggle:Set(EZ_Window.AutoSave, true) end
        if EZ_Window._transparencySlider then EZ_Window._transparencySlider:Set(EZ_GlobalTransparency * 100, true) end
        if EZ_Window._minimizeModeDropdown then EZ_Window._minimizeModeDropdown:Set(EZ_Window.MinimizeMode == "shrink" and "Shrink" or "Fade", true) end
        if type(data._minimize_key) == "table" and type(data._minimize_key.value) == "string" then
            local key = Enum.KeyCode[data._minimize_key.value]
            if key then EZ_MinKey = key; EZ_MinMods = type(data._minimize_key.mods) == "string" and data._minimize_key.mods or "" end
        end
        for _, el in ipairs(EZ_Window.Elements) do
            if data[el.Id] then EZ_ApplyElementData(el, data[el.Id]) end
        end
        if ignored > 0 and not isAutoLoad then
            task.defer(function()
                if not EZ_Destroyed then EZ:Notify({ Title = "Config", _ContentKey = "ConfigUnregistered", _ContentArgs = { ignored }, Style = "Warning", Duration = 3 }) end
            end)
        end
        return true
    end

    local function EZ_BuildWindow()
        local frame = Instance.new("CanvasGroup")
        frame.Name = "Window"
        frame.Size = UDim2.fromOffset(EZ_Size.X.Offset * 0.96, EZ_Size.Y.Offset * 0.96)
        frame.AnchorPoint = Vector2.new(0.5, 0.5)
        frame.Position = UDim2.new(0.5, 0, 0.5, 0)
        frame.BackgroundColor3 = EZ_Theme.Background
        frame.BorderSizePixel = 0
        frame.ClipsDescendants = true
        frame.GroupTransparency = 0
        frame:SetAttribute("EZ_ViewportPadding", math.max(0, tonumber(options.ViewportPadding) or 0))
        frame.Parent = EZ_Gui
        if EZ_PreviousCount > 0 then
            local offset = math.min(EZ_PreviousCount, 5) * 24
            frame.Position = UDim2.new(0.5, offset, 0.5, offset)
            frame:SetAttribute("EZ_Moved", true)
        end
        EZ_AddStroke(frame, EZ_Theme.Border)
        EZ_AddRadius(frame, "Window")
        EZ_RegTrans(frame, 1)
        EZ_Paint(function() frame.BackgroundColor3 = EZ_Theme.Background end)

        local EZ_BaseSize = Vector2.new(EZ_Size.X.Offset > 0 and EZ_Size.X.Offset or 660, EZ_Size.Y.Offset > 0 and EZ_Size.Y.Offset or 470)
        local updateResponsiveLayout
        local fab
        local clampQueued = false
        local function onViewportChanged()
            if not frame.Parent then return end
            EZ_ApplyResponsiveScale(frame, EZ_BaseSize)
            EZ_UpdateNotifyPosition()
            local usable = EZ_ViewportUsable()
            local previous = EZ_Window._compact
            EZ_Window._compact = UserInputService.TouchEnabled or usable.X < 700 or frame.Size.X.Offset < 560
            if updateResponsiveLayout then
                if previous ~= nil and not previous and EZ_Window._compact then EZ_Window._sidebarOpen = false end
                updateResponsiveLayout()
            end
            if EZ_DropdownCurrent and EZ_DropdownCurrent.windowFrame == frame then EZ_CloseDropdown() end
            if (frame:GetAttribute("EZ_Moved") or fab) and not clampQueued then
                clampQueued = true
                task.defer(function()
                    clampQueued = false
                    if frame.Parent and frame:GetAttribute("EZ_Moved") then EZ_ClampToViewport(frame) end
                    if fab and fab.Parent then EZ_ClampToViewport(fab) end
                end)
            end
        end
        EZ_Window._responsiveItems = {}
        onViewportChanged()
        local cameraConnection
        local function bindCamera()
            if cameraConnection then
                if cameraConnection.Connected then cameraConnection:Disconnect() end
                EZ_ScaleConns[cameraConnection] = nil
                cameraConnection = nil
            end
            pcall(function()
                cameraConnection = workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(onViewportChanged)
                EZ_ScaleConns[cameraConnection] = true
            end)
        end
        bindCamera()
        pcall(function()
            local conn = workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function() bindCamera(); onViewportChanged() end)
            EZ_ScaleConns[conn] = true
        end)
        pcall(function()
            local conn = EZ_Gui:GetPropertyChangedSignal("AbsoluteSize"):Connect(onViewportChanged)
            EZ_ScaleConns[conn] = true
        end)
        pcall(function()
            local conn = EZ_Gui:GetPropertyChangedSignal("AbsolutePosition"):Connect(onViewportChanged)
            EZ_ScaleConns[conn] = true
        end)
        frame.GroupTransparency = 1
        TweenService:Create(frame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { GroupTransparency = 0 }):Play()

        local titlebar = Instance.new("Frame")
        titlebar.Size = UDim2.new(1, 0, 0, EZ_TITLEBAR_HEIGHT)
        titlebar.BackgroundColor3 = EZ_Theme.Card
        titlebar.BorderSizePixel = 0
        titlebar.Parent = frame
        EZ_AddRadius(titlebar, "Window")
        EZ_RegTrans(titlebar, 1)
        EZ_Paint(function() titlebar.BackgroundColor3 = EZ_Theme.Card end)

        local tbFill = Instance.new("Frame")
        tbFill.Size = UDim2.new(1, 0, 0, "Window")
        tbFill.Position = UDim2.new(0, 0, 1, -EZ_Theme.RadiusWindow)
        tbFill.BackgroundColor3 = EZ_Theme.Card
        tbFill.BorderSizePixel = 0
        tbFill.Parent = titlebar
        EZ_RegTrans(tbFill, 1)
        EZ_Paint(function()
            tbFill.BackgroundColor3 = EZ_Theme.Card
            tbFill.Size = UDim2.new(1, 0, 0, EZ_Theme.RadiusWindow)
            tbFill.Position = UDim2.new(0, 0, 1, -EZ_Theme.RadiusWindow)
        end)

        local tline = Instance.new("Frame")
        tline.Size = UDim2.new(1, 0, 0, 1)
        tline.Position = UDim2.new(0, 0, 1, -1)
        tline.BackgroundColor3 = EZ_Theme.Border
        tline.BorderSizePixel = 0
        tline.Parent = titlebar
        EZ_RegTrans(tline, 1)
        EZ_Paint(function() tline.BackgroundColor3 = EZ_Theme.Border end)

        local logoLetter = EZ_CreateLogo(titlebar, 24, function() return EZ_Theme.Text end)
        logoLetter.Position = UDim2.new(0, 14, 0.5, -12)

        local tholder = Instance.new("Frame")
        tholder.BackgroundTransparency = 1
        tholder.ClipsDescendants = true
        tholder.Size = UDim2.new(1, -120, 1, 0)
        tholder.Position = UDim2.fromOffset(46, 0)
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
        tlabel.Text = EZ_TranslateText(EZ_Name)
        tlabel.Font = EZ_Brand.Font
        tlabel.TextSize = 15
        tlabel.TextColor3 = EZ_Theme.Text
        tlabel.Parent = tholder
        EZ_BindText(tlabel, "Text", EZ_Name, frame)
        EZ_Paint(function() tlabel.TextColor3 = EZ_Theme.Text end)

        local tdiv = Instance.new("TextLabel")
        tdiv.BackgroundTransparency = 1
        tdiv.Size = UDim2.fromOffset(6, 20)
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
        slabel.Text = EZ_TranslateText(EZ_SubTitle)
        slabel.Font = EZ_Brand.FontBody
        slabel.TextSize = 12
        slabel.TextColor3 = EZ_Theme.TextDim
        slabel.Parent = tholder
        EZ_BindText(slabel, "Text", EZ_SubTitle, frame)
        EZ_Paint(function() slabel.TextColor3 = EZ_Theme.TextDim end)

        local minbtn = Instance.new("TextButton")
        minbtn.Size = UDim2.fromOffset(30, 30)
        minbtn.Position = UDim2.new(1, -40, 0.5, -15)
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

        local sidebarWidth = EZ_Window._compact and EZ_CollapsedSidebarWidth or EZ_ExpandedSidebarWidth
        local sidebar = Instance.new("Frame")
        sidebar.Size = UDim2.new(0, sidebarWidth, 1, -EZ_TITLEBAR_HEIGHT)
        sidebar.Position = UDim2.new(0, 0, 0, EZ_TITLEBAR_HEIGHT)
        sidebar.BackgroundColor3 = EZ_Theme.Card
        sidebar.BorderSizePixel = 0
        sidebar.ClipsDescendants = true
        sidebar.Parent = frame
        EZ_AddRadius(sidebar, "Window")
        EZ_RegTrans(sidebar, 1)
        EZ_Paint(function() sidebar.BackgroundColor3 = EZ_Theme.Card end)

        local sbFillTop = Instance.new("Frame")
        sbFillTop.Size = UDim2.new(1, 0, 0, "Window")
        sbFillTop.Position = UDim2.new(0, 0, 0, 0)
        sbFillTop.BackgroundColor3 = EZ_Theme.Card
        sbFillTop.BorderSizePixel = 0
        sbFillTop.ZIndex = 10
        sbFillTop.Parent = sidebar
        EZ_RegTrans(sbFillTop, 1)
        EZ_Paint(function()
            sbFillTop.BackgroundColor3 = EZ_Theme.Card
            sbFillTop.Size = UDim2.new(1, 0, 0, EZ_Theme.RadiusWindow)
        end)

        local sbFillRight = Instance.new("Frame")
        sbFillRight.Size = UDim2.new(0, EZ_Theme.RadiusWindow, 1, 0)
        sbFillRight.Position = UDim2.new(1, -EZ_Theme.RadiusWindow, 0, 0)
        sbFillRight.BackgroundColor3 = EZ_Theme.Card
        sbFillRight.BorderSizePixel = 0
        sbFillRight.ZIndex = 10
        sbFillRight.Parent = sidebar
        EZ_RegTrans(sbFillRight, 1)
        EZ_Paint(function()
            sbFillRight.BackgroundColor3 = EZ_Theme.Card
            sbFillRight.Size = UDim2.new(0, EZ_Theme.RadiusWindow, 1, 0)
            sbFillRight.Position = UDim2.new(1, -EZ_Theme.RadiusWindow, 0, 0)
        end)

        local tabsContainer = Instance.new("ScrollingFrame")
        tabsContainer.ScrollBarThickness = 3
        tabsContainer.VerticalScrollBarInset = Enum.ScrollBarInset.None
        tabsContainer.ScrollBarImageColor3 = EZ_Theme.BorderHover
        tabsContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
        tabsContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
        tabsContainer.ScrollingDirection = Enum.ScrollingDirection.Y
        tabsContainer.BorderSizePixel = 0
        tabsContainer.Size = UDim2.new(1, 0, 1, 0)
        tabsContainer.Position = UDim2.new(0, 0, 0, 0)
        tabsContainer.BackgroundTransparency = 1
        tabsContainer.ClipsDescendants = true
        tabsContainer.ZIndex = 11
        tabsContainer.Parent = sidebar

        local slay = Instance.new("UIListLayout")
        slay.Padding = UDim.new(0, 2)
        slay.SortOrder = Enum.SortOrder.LayoutOrder
        slay.Parent = tabsContainer

        local spad = Instance.new("UIPadding")
        spad.PaddingTop = UDim.new(0, 10)
        spad.PaddingBottom = UDim.new(0, 10)
        spad.PaddingLeft = UDim.new(0, 8)
        spad.PaddingRight = UDim.new(0, 8)
        spad.Parent = tabsContainer

        local sline = Instance.new("Frame")
        sline.Size = UDim2.new(0, 1, 1, -EZ_TITLEBAR_HEIGHT)
        sline.Position = UDim2.new(0, sidebarWidth - 1, 0, EZ_TITLEBAR_HEIGHT)
        sline.BackgroundColor3 = EZ_Theme.Border
        sline.BorderSizePixel = 0
        sline.Parent = frame
        EZ_RegTrans(sline, 1)
        EZ_Paint(function() sline.BackgroundColor3 = EZ_Theme.Border end)

        local content = Instance.new("Frame")
        content.Position = UDim2.new(0, sidebarWidth, 0, EZ_TITLEBAR_HEIGHT)
        content.Size = UDim2.new(1, -sidebarWidth, 1, -EZ_TITLEBAR_HEIGHT)
        content.BackgroundTransparency = 1
        content.ClipsDescendants = true
        content.Parent = frame

        local wm = Instance.new("TextLabel")
        wm.AnchorPoint = Vector2.new(1, 1)
        wm.Position = UDim2.new(1, -12, 1, -8)
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
        local searchEnabled = options.SearchEnabled ~= false and options.Search ~= false
        local searchHeight = searchEnabled and 52 or 0
        local searchBox, searchEmpty, searchClear
        local searchValue = ""
        local refreshQueued = false

        local function restoreSearch(data)
            if not data or not data.Searching then return end
            for _, item in ipairs(data.SearchItems) do
                if item.row.Parent then item.row.Visible = item.originalVisible end
                item.originalVisible = nil
            end
            for _, group in ipairs(data.SearchSections) do
                if group.header.Parent then group.header.Visible = group.originalHeader end
                if group.body and group.body.Parent then group.body.Visible = group.originalBody end
                if group.chevron and group.chevron.Parent then group.chevron.Rotation = group.originalBody and 0 or -90 end
                group.originalHeader, group.originalBody, group.searchOverride = nil, nil, nil
            end
            data.Searching = false
        end

        local function filterSearch(data, value)
            if not data then return 0 end
            local query = EZ_SearchText(value):gsub("^%s+", ""):gsub("%s+$", "")
            if query == "" then restoreSearch(data); return 0 end
            if not data.Searching then
                data.Searching = true
                for _, item in ipairs(data.SearchItems) do item.originalVisible = item.row.Visible end
                for _, group in ipairs(data.SearchSections) do
                    group.originalHeader = group.header.Visible
                    group.originalBody = group.body and group.body.Visible or false
                    group.searchOverride = nil
                end
            end
            for _, group in ipairs(data.SearchSections) do
                group.match = (group.header:GetAttribute("EZ_SearchFolded") or ""):find(query, 1, true) ~= nil
                group.matches = 0
            end
            local count = 0
            for _, item in ipairs(data.SearchItems) do
                local row, group = item.row, item.section
                local inSection = not group or group.originalHeader
                local match = row.Parent and item.originalVisible and inSection and not row:GetAttribute("EZ_SearchSkip") and
                    ((group and group.match) or (row:GetAttribute("EZ_SearchFolded") or ""):find(query, 1, true) ~= nil)
                row.Visible = match and true or false
                if match then
                    count = count + 1
                    if group then group.matches = group.matches + 1 end
                end
            end
            for _, group in ipairs(data.SearchSections) do
                local visible = group.originalHeader and (group.match or group.matches > 0)
                group.header.Visible = visible and true or false
                local bodyVisible = visible and (group.searchOverride == nil or group.searchOverride)
                if group.body and group.body.Parent then group.body.Visible = bodyVisible and true or false end
                if group.chevron and group.chevron.Parent then group.chevron.Rotation = bodyVisible and 0 or -90 end
                if visible and group.match and group.matches == 0 then count = count + 1 end
            end
            return count
        end

        local function applySearch(resetScroll)
            if EZ_Destroyed or not frame.Parent then return end
            local count = filterSearch(activeData, searchValue)
            if searchEmpty then searchEmpty.Visible = activeData ~= nil and EZ_SearchText(searchValue):match("%S") ~= nil and count == 0 end
            if resetScroll and activeData and activeData.Page then activeData.Page.CanvasPosition = Vector2.new(0, 0) end
        end

        local function queueSearch()
            if refreshQueued or not activeData or searchValue == "" then return end
            refreshQueued = true
            task.defer(function()
                refreshQueued = false
                if not EZ_Destroyed then applySearch(false) end
            end)
        end

        if searchEnabled then
            local searchBar = Instance.new("Frame")
            searchBar.Name = "EZ_SearchBar"
            searchBar.Position = UDim2.fromOffset(18, 10)
            searchBar.Size = UDim2.new(1, -36, 0, 34)
            searchBar.BackgroundColor3 = EZ_Theme.Card
            searchBar.BorderSizePixel = 0
            searchBar.Parent = content
            EZ_AddRadius(searchBar, "Theme")
            EZ_AddStroke(searchBar, EZ_Theme.Border)
            EZ_RegTrans(searchBar)
            local ring = Instance.new("Frame")
            ring.Name = "EZ_SearchIcon"
            ring.Position = UDim2.fromOffset(13, 10)
            ring.Size = UDim2.fromOffset(10, 10)
            ring.BackgroundTransparency = 1
            ring.Parent = searchBar
            EZ_AddRadius(ring, 5)
            local ringStroke = Instance.new("UIStroke")
            ringStroke.Color = EZ_Theme.TextDim
            ringStroke.Thickness = 1.2
            ringStroke.Parent = ring
            local handle = Instance.new("Frame")
            handle.Position = UDim2.fromOffset(8, 8)
            handle.Size = UDim2.fromOffset(5, 1)
            handle.Rotation = 45
            handle.BorderSizePixel = 0
            handle.BackgroundColor3 = EZ_Theme.TextDim
            handle.Parent = ring
            searchBox = Instance.new("TextBox")
            searchBox.Name = "EZ_SearchInput"
            searchBox.Position = UDim2.fromOffset(34, 0)
            searchBox.Size = UDim2.new(1, -68, 1, 0)
            searchBox.BackgroundTransparency = 1
            searchBox.Text = ""
            searchBox.PlaceholderText = EZ_Locale.SearchTab
            searchBox.ClearTextOnFocus = false
            searchBox.Font = EZ_Brand.FontBody
            searchBox.TextSize = 12
            searchBox.TextColor3 = EZ_Theme.Text
            searchBox.PlaceholderColor3 = EZ_Theme.TextDim
            searchBox.TextXAlignment = Enum.TextXAlignment.Left
            searchBox.Parent = searchBar
            local clear = Instance.new("TextButton")
            clear.Name = "EZ_SearchClear"
            clear.AnchorPoint = Vector2.new(1, 0)
            clear.Position = UDim2.new(1, 0, 0, 0)
            clear.Size = UDim2.fromOffset(34, 34)
            clear.BackgroundTransparency = 1
            clear.Text = "×"
            clear.TextSize = 18
            clear.TextColor3 = EZ_Theme.TextDim
            clear.Font = EZ_Brand.FontBody
            clear.AutoButtonColor = false
            clear.Visible = false
            clear.Parent = searchBar
            searchClear = clear
            searchEmpty = Instance.new("TextLabel")
            searchEmpty.Name = "EZ_SearchEmpty"
            searchEmpty.Position = UDim2.fromOffset(12, searchHeight)
            searchEmpty.Size = UDim2.new(1, -24, 1, -searchHeight)
            searchEmpty.BackgroundTransparency = 1
            searchEmpty.Text = EZ_Locale.SearchEmpty
            searchEmpty.Font = EZ_Brand.FontBody
            searchEmpty.TextSize = 13
            searchEmpty.TextColor3 = EZ_Theme.TextDim
            searchEmpty.TextWrapped = true
            searchEmpty.Visible = false
            searchEmpty.Parent = content
            EZ_Paint(function()
                searchBar.BackgroundColor3 = EZ_Theme.Card
                ringStroke.Color = EZ_Theme.TextDim
                handle.BackgroundColor3 = EZ_Theme.TextDim
                searchBox.TextColor3 = EZ_Theme.Text
                searchBox.PlaceholderColor3 = EZ_Theme.TextDim
                clear.TextColor3 = EZ_Theme.TextDim
                searchEmpty.TextColor3 = EZ_Theme.TextDim
            end, searchBar)
            EZ_OnLocaleChange(function()
                if searchBox.Parent then searchBox.PlaceholderText = EZ_Locale.SearchTab end
                if searchEmpty.Parent then searchEmpty.Text = EZ_Locale.SearchEmpty end
            end)
            searchBox:GetPropertyChangedSignal("Text"):Connect(function()
                searchValue = searchBox.Text
                clear.Visible = searchValue ~= ""
                EZ_CloseDropdown()
                applySearch(true)
            end)
            clear.Activated:Connect(function() searchBox.Text = "" end)
            EZ_Window.SearchBox = searchBox
        end
        function EZ_Window:SetSearch(value)
            if EZ_Destroyed then return false, "Window was destroyed" end
            searchValue = tostring(value or "")
            if searchBox then searchBox.Text = searchValue end
            if searchClear then searchClear.Visible = searchValue ~= "" end
            EZ_CloseDropdown()
            applySearch(true)
        end
        function EZ_Window:GetSearch() return searchValue end
        EZ_Window._sidebarOpen = not EZ_Window._compact
        if type(options.SidebarCollapsed) == "boolean" then EZ_Window._sidebarOpen = not options.SidebarCollapsed end
        local menuBtn = Instance.new("TextButton")
        menuBtn.Name = "EZ_SidebarToggle"
        menuBtn.Size = UDim2.fromOffset(40, 40)
        menuBtn.Position = UDim2.new(1, -84, 0.5, -20)
        menuBtn.BackgroundColor3 = EZ_Theme.CardHover
        menuBtn.BackgroundTransparency = 1
        menuBtn.Text = ""
        menuBtn.AutoButtonColor = false
        menuBtn.Parent = titlebar
        EZ_AddRadius(menuBtn, 6)

        local menuGlyph = Instance.new("Frame")
        menuGlyph.Name = "EZ_SidebarGlyph"
        menuGlyph.AnchorPoint = Vector2.new(0.5, 0.5)
        menuGlyph.Position = UDim2.fromScale(0.5, 0.5)
        menuGlyph.Size = UDim2.fromOffset(16, 14)
        menuGlyph.BackgroundTransparency = 1
        menuGlyph.BorderSizePixel = 0
        menuGlyph.Parent = menuBtn
        EZ_AddRadius(menuGlyph, 2)
        local menuOutline = Instance.new("UIStroke")
        menuOutline.Name = "EZ_SidebarOutline"
        menuOutline.Thickness = 1.25
        menuOutline.Color = EZ_Theme.TextDim
        menuOutline.Parent = menuGlyph
        local menuDivider = Instance.new("Frame")
        menuDivider.Name = "EZ_SidebarDivider"
        menuDivider.Position = UDim2.fromOffset(5, 1)
        menuDivider.Size = UDim2.new(0, 1, 1, -2)
        menuDivider.BackgroundColor3 = EZ_Theme.TextDim
        menuDivider.BorderSizePixel = 0
        menuDivider.Parent = menuGlyph
        local menuChevronTop = Instance.new("Frame")
        menuChevronTop.Name = "EZ_ChevronTop"
        menuChevronTop.AnchorPoint = Vector2.new(0.5, 0.5)
        menuChevronTop.Position = UDim2.fromOffset(11, 5)
        menuChevronTop.Size = UDim2.fromOffset(5, 1)
        menuChevronTop.BackgroundColor3 = EZ_Theme.TextDim
        menuChevronTop.BorderSizePixel = 0
        menuChevronTop.Parent = menuGlyph
        local menuChevronBottom = Instance.new("Frame")
        menuChevronBottom.Name = "EZ_ChevronBottom"
        menuChevronBottom.AnchorPoint = Vector2.new(0.5, 0.5)
        menuChevronBottom.Position = UDim2.fromOffset(11, 9)
        menuChevronBottom.Size = UDim2.fromOffset(5, 1)
        menuChevronBottom.BackgroundColor3 = EZ_Theme.TextDim
        menuChevronBottom.BorderSizePixel = 0
        menuChevronBottom.Parent = menuGlyph
        EZ_Paint(function()
            menuBtn.BackgroundColor3 = EZ_Theme.CardHover
            menuOutline.Color = EZ_Theme.TextDim
            menuDivider.BackgroundColor3 = EZ_Theme.TextDim
            menuChevronTop.BackgroundColor3 = EZ_Theme.TextDim
            menuChevronBottom.BackgroundColor3 = EZ_Theme.TextDim
        end, menuBtn)
        menuBtn.MouseEnter:Connect(function() TweenService:Create(menuBtn, EZ_Ease.Fast, { BackgroundTransparency = 0.45 }):Play() end)
        menuBtn.MouseLeave:Connect(function() TweenService:Create(menuBtn, EZ_Ease.Fast, { BackgroundTransparency = 1 }):Play() end)
        tholder.Size = UDim2.new(1, -150, 1, 0)

        local function updateSidebarTab(d, collapsed)
            d.Button.Size = UDim2.new(1, 0, 0, EZ_Window._compact and 44 or 36)
            d.Indicator.Position = UDim2.fromOffset(collapsed and 0 or 6, EZ_Window._compact and 14 or 10)
            if d.Icon then
                d.Icon.AnchorPoint = collapsed and Vector2.new(0.5, 0.5) or Vector2.new(0, 0.5)
                d.Icon.Position = collapsed and UDim2.fromScale(0.5, 0.5) or UDim2.new(0, 20, 0.5, 0)
                d.Label.Visible = not collapsed
                d.Label.Text = d.Title
            else
                d.Label.Visible = true
                local first = d.Title ~= "" and utf8.char(utf8.codepoint(d.Title, 1)) or "•"
                d.Label.Text = collapsed and first or d.Title
                d.Label.Position = UDim2.fromOffset(collapsed and 0 or 18, 0)
                d.Label.Size = UDim2.new(1, collapsed and 0 or -24, 1, 0)
                d.Label.TextXAlignment = collapsed and Enum.TextXAlignment.Center or Enum.TextXAlignment.Left
            end
        end
        local lastResponsiveCompact
        updateResponsiveLayout = function()
            local collapsed = not EZ_Window._sidebarOpen
            local width = collapsed and EZ_CollapsedSidebarWidth or EZ_ExpandedSidebarWidth
            sidebar.Size = UDim2.new(0, width, 1, -EZ_TITLEBAR_HEIGHT)
            sline.Position = UDim2.new(0, width - 1, 0, EZ_TITLEBAR_HEIGHT)
            content.Position = UDim2.new(0, width, 0, EZ_TITLEBAR_HEIGHT)
            content.Size = UDim2.new(1, -width, 1, -EZ_TITLEBAR_HEIGHT)
            menuBtn.Visible = true
            menuChevronTop.Rotation = collapsed and 45 or -45
            menuChevronBottom.Rotation = collapsed and -45 or 45
            for _, d in ipairs(registry) do updateSidebarTab(d, collapsed) end
            if lastResponsiveCompact ~= EZ_Window._compact then
                lastResponsiveCompact = EZ_Window._compact
                for _, update in ipairs(EZ_Window._responsiveItems) do update(EZ_Window._compact) end
            end
        end
        function EZ_Window:SetSidebarCollapsed(collapsed, silent)
            local open = not (collapsed == true)
            if self._sidebarOpen == open then return end
            self._sidebarOpen = open
            if EZ_DropdownCurrent and EZ_DropdownCurrent.windowFrame == frame then EZ_CloseDropdown() end
            updateResponsiveLayout()
            if not silent and self.AutoSave and self._ScheduleSave then self:_ScheduleSave(self.CurrentConfig) end
        end
        menuBtn.Activated:Connect(function() EZ_Window:SetSidebarCollapsed(EZ_Window._sidebarOpen) end)
        updateResponsiveLayout()
        frame:GetPropertyChangedSignal("Size"):Connect(function()
            if not frame.Parent then return end
            if EZ_DropdownCurrent and EZ_DropdownCurrent.windowFrame == frame then EZ_CloseDropdown() end
            local usable = EZ_ViewportUsable()
            local compact = UserInputService.TouchEnabled or usable.X < 700 or frame.Size.X.Offset < 560
            if compact ~= EZ_Window._compact then
                EZ_Window._compact = compact
                if compact then EZ_Window._sidebarOpen = false end
                updateResponsiveLayout()
            end
        end)

        local function selectTab(target)
            EZ_CloseDropdown()
            if activeData ~= target then restoreSearch(activeData) end
            activeData = target
            if EZ_Window._compact and EZ_Window._sidebarOpen then EZ_Window._sidebarOpen = false; updateResponsiveLayout() end
            for _, d in ipairs(registry) do
                local wasActive = d.Active
                d.Active = (d == target)
                if d.Active then
                    if not wasActive then
                        d.Page.Visible = true
                        d.Page.Position = UDim2.new(0.025, 0, 0, searchHeight)
                        TweenService:Create(d.Page, TweenInfo.new(0.24, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                            Position = UDim2.new(0, 0, 0, searchHeight)
                        }):Play()
                    end
                else
                    d.Page.Visible = false
                end
                TweenService:Create(d.Button, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                    BackgroundTransparency = d.Active and (EZ_GlobalTransparency * 0.55) or 1
                }):Play()
                TweenService:Create(d.Label, EZ_Ease.Fast, {
                    TextColor3 = d.Active and EZ_Theme.Text or EZ_Theme.TextDim
                }):Play()
                if d.Icon then
                    TweenService:Create(d.Icon, EZ_Ease.Fast, {
                        ImageColor3 = d.Active and EZ_Theme.Text or EZ_Theme.TextDim
                    }):Play()
                end
                TweenService:Create(d.Indicator, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                    Size = d.Active and UDim2.new(0, 2, 0, 16) or UDim2.new(0, 0, 0, 0)
                }):Play()
            end
            applySearch(searchValue:match("%S") ~= nil)
        end

        local isMobile = UserInputService.TouchEnabled
        local setMinimized
        if isMobile then
            fab = Instance.new("Frame")
            fab.Name = "EZ_MobileFab"
            fab.Size = UDim2.fromOffset(60, 60)
            local usable = EZ_ViewportUsable()
            local columns = math.max(1, math.floor(math.max(1, usable.X - 20) / 70))
            local index = EZ_PreviousCount
            fab.Position = UDim2.new(0, 20 + (index % columns) * 70, 0.5, -30 + math.floor(index / columns) * 70)
            fab.BackgroundColor3 = EZ_Theme.Accent
            fab.BorderSizePixel = 0
            fab.Active = true
            fab.Visible = false
            fab.ZIndex = 200
            fab.Parent = EZ_Gui
            if EZ_PreviousCount > 0 then task.defer(function() if fab.Parent then EZ_ClampToViewport(fab) end end) end
            EZ_AddStroke(fab, EZ_Theme.Border)
            EZ_AddRadius(fab, 30)
            EZ_Paint(function() fab.BackgroundColor3 = EZ_Theme.Accent end)

            local fabBtn = Instance.new("TextButton")
            fabBtn.Size = UDim2.new(1, 0, 1, 0)
            fabBtn.BackgroundTransparency = 1
            fabBtn.Text = ""
            fabBtn.Font = EZ_Brand.Font
            fabBtn.TextSize = 28
            fabBtn.TextColor3 = EZ_Theme.Background
            fabBtn.AutoButtonColor = false
            fabBtn.Active = true
            fabBtn.Parent = fab
            EZ_Paint(function() fabBtn.TextColor3 = EZ_Theme.Background end)
            local fabLogo = EZ_CreateLogo(fabBtn, 36, function() return EZ_Theme.Background end)
            fabLogo.AnchorPoint = Vector2.new(0.5, 0.5)
            fabLogo.Position = UDim2.fromScale(0.5, 0.5)

            local fabDidDrag = false
            fabBtn.Activated:Connect(function()
                if EZ_Window.Minimized and not fabDidDrag then setMinimized(false) end
            end)

            local fabDragging = false
            local fabStartPos = nil
            local fabStartInput = nil
            local fabPointer = nil

            fabBtn.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    fabDidDrag = false
                    fabDragging = true
                    fabPointer = input
                    fabStartInput = input.Position
                    fabStartPos = fab.Position
                end
            end)

            EZ_ConnectGlobal(UserInputService.InputChanged, function(input)
                if fabDragging and fabStartInput and fabPointer and ((fabPointer.UserInputType == Enum.UserInputType.Touch and input == fabPointer) or (fabPointer.UserInputType == Enum.UserInputType.MouseButton1 and input.UserInputType == Enum.UserInputType.MouseMovement)) then
                    local delta = input.Position - fabStartInput
                    if math.abs(delta.X) + math.abs(delta.Y) > 6 then fabDidDrag = true end
                    fab.Position = UDim2.new(fabStartPos.X.Scale, fabStartPos.X.Offset + delta.X, fabStartPos.Y.Scale, fabStartPos.Y.Offset + delta.Y)
                end
            end)

            local function stopFabDrag(input)
                if fabDragging and (input == fabPointer or (fabPointer.UserInputType == Enum.UserInputType.MouseButton1 and input.UserInputType == Enum.UserInputType.MouseButton1)) then
                    fabDragging, fabStartInput, fabPointer = false, nil, nil
                    if fab.Parent then EZ_ClampToViewport(fab) end
                end
            end
            fabBtn.InputEnded:Connect(stopFabDrag)
            EZ_ConnectGlobal(UserInputService.InputEnded, stopFabDrag)
        end

        local function applyMinimizeFade(state)
            if state then
                TweenService:Create(frame, TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { GroupTransparency = 1 }):Play()
                task.delay(0.24, function()
                    if EZ_Window.Minimized and EZ_Window.MinimizeMode == "fade" then
                        frame.Visible = false
                    end
                end)
            else
                frame.Visible = true
                TweenService:Create(frame, TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { GroupTransparency = 0 }):Play()
            end
        end

        local expandedSize, savedVisibility
        local function applyMinimizeShrink(state)
            local info = TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
            if state then
                expandedSize = frame.Size
                savedVisibility = {}
                TweenService:Create(frame, info, {
                    Size = UDim2.fromOffset(frame.Size.X.Offset, EZ_TITLEBAR_HEIGHT)
                }):Play()
                task.delay(0.14, function()
                    if not EZ_Window.Minimized or EZ_Window.MinimizeMode ~= "shrink" then return end
                    for _, child in ipairs(frame:GetChildren()) do
                        if child ~= titlebar and child:IsA("GuiObject") then
                            savedVisibility[child] = child.Visible
                            child.Visible = false
                        end
                    end
                end)
            else
                for _, child in ipairs(frame:GetChildren()) do
                    if child ~= titlebar and child:IsA("GuiObject") and savedVisibility and savedVisibility[child] ~= nil then
                        child.Visible = savedVisibility[child]
                    end
                end
                TweenService:Create(frame, info, {
                    Size = expandedSize or UDim2.fromOffset(EZ_BaseSize.X, EZ_BaseSize.Y)
                }):Play()
            end
        end

        setMinimized = function(state)
            if not frame.Parent or EZ_Window.Minimized == state then return end
            EZ_CloseDropdown()
            if state then
                local focused = UserInputService:GetFocusedTextBox()
                if focused then focused:ReleaseFocus() end
            end
            EZ_Window.Minimized = state
            if isMobile and fab then
                fab.Visible = state
            end
            if EZ_Window.MinimizeMode == "shrink" then
                applyMinimizeShrink(state)
            else
                applyMinimizeFade(state)
            end
        end

        minbtn.MouseEnter:Connect(function()
            TweenService:Create(minbtn, EZ_Ease.Fast, { BackgroundTransparency = 0 }):Play()
            TweenService:Create(minicon, EZ_Ease.Fast, { BackgroundColor3 = EZ_Theme.Text }):Play()
        end)
        minbtn.MouseLeave:Connect(function()
            TweenService:Create(minbtn, EZ_Ease.Fast, { BackgroundTransparency = 1 }):Play()
            TweenService:Create(minicon, EZ_Ease.Fast, { BackgroundColor3 = EZ_Theme.TextDim }):Play()
        end)
        minbtn.Activated:Connect(function() setMinimized(not EZ_Window.Minimized) end)

        EZ_ConnectGlobal(UserInputService.InputBegan, function(input, processed)
            if processed or EZ_CapturingKeybind or UserInputService:GetFocusedTextBox() then return end
            if input.KeyCode == EZ_MinKey and EZ_CurrentModifiers(input.KeyCode) == EZ_MinMods then setMinimized(not EZ_Window.Minimized) end
        end)

        EZ_MakeDraggable(frame, titlebar)
        EZ_MakeResizable(frame)

        local function EZ_ResponsiveRow(row, title, description, control)
            local function update(compact)
                local hasDescription = description ~= nil
                if compact then
                    row.Size = UDim2.new(1, 0, 0, hasDescription and 92 or 76)
                    title.Position = UDim2.fromOffset(14, hasDescription and 9 or 5)
                    title.Size = UDim2.new(1, -28, 0, hasDescription and 16 or 22)
                    if description then description.Size = UDim2.new(1, -28, 0, 14) end
                    control.Position = UDim2.fromOffset(14, hasDescription and 49 or 33)
                    control.Size = UDim2.new(1, -28, 0, 36)
                else
                    row.Size = UDim2.new(1, 0, 0, 46)
                    title.Position = UDim2.fromOffset(14, hasDescription and 9 or 0)
                    title.Size = UDim2.new(1, -200, 0, hasDescription and 16 or 46)
                    if description then description.Size = UDim2.new(1, -200, 0, 14) end
                    control.Position = UDim2.new(1, -184, 0.5, -14)
                    control.Size = UDim2.fromOffset(170, 28)
                end
            end
            table.insert(EZ_Window._responsiveItems, update)
            update(EZ_Window._compact)
        end

        local function EZ_ValidateFlag(flag)
            if flag == nil or flag == false then return end
            if type(flag) ~= "string" or flag == "" then error("[Eazy UI] Flag must be a non-empty string", 3) end
            if flag == "_meta" then error("[Eazy UI] Flag _meta is reserved for configuration metadata", 3) end
            if EZ_Window._elementFlags[flag] then error("[Eazy UI] Duplicate Flag: " .. flag, 3) end
        end

        function EZ_Window:AddTab(opt)
            opt = opt or {}
            local tabTitle = opt.Title or "Tab"
            local tabIcon = opt.Icon
            local data = { SearchItems = {}, SearchSections = {} }
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
            indicator.Position = UDim2.fromOffset(6, 10)
            indicator.Size = UDim2.new(0, 0, 0, 0)
            indicator.BackgroundColor3 = EZ_Theme.Accent
            indicator.BorderSizePixel = 0
            indicator.Parent = btn
            EZ_AddRadius(indicator, 1)

            local iconLbl = nil
            local iconOffset = 18
            if tabIcon then
                iconLbl = EZ_CreateIcon(btn, tabIcon, 16)
                if iconLbl then
                    iconLbl.Position = UDim2.new(0, 20, 0.5, -8)
                    iconLbl.ImageColor3 = EZ_Theme.TextDim
                    iconOffset = 44
                end
            end

            local lbl = Instance.new("TextLabel")
            lbl.Position = UDim2.fromOffset(iconOffset, 0)
            lbl.Size = UDim2.new(1, -(iconOffset + 6), 1, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = EZ_TranslateText(tabTitle)
            lbl.Font = EZ_Brand.FontBody
            lbl.TextSize = 13
            lbl.TextColor3 = EZ_Theme.TextDim
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.TextTruncate = Enum.TextTruncate.AtEnd
            lbl.Parent = btn

            data.Button = btn; data.Label = lbl; data.Page = nil; data.Icon = iconLbl
            data.Indicator = indicator; data.Active = false; data.Title = EZ_TranslateText(tabTitle)

            EZ_Paint(function()
                btn.BackgroundColor3 = EZ_Theme.TabActive
                indicator.BackgroundColor3 = EZ_Theme.Accent
                if data.Active then
                    lbl.TextColor3 = EZ_Theme.Text
                    if iconLbl and iconLbl:IsA("ImageLabel") then iconLbl.ImageColor3 = EZ_Theme.Text end
                else
                    lbl.TextColor3 = EZ_Theme.TextDim
                    if iconLbl and iconLbl:IsA("ImageLabel") then iconLbl.ImageColor3 = EZ_Theme.TextDim end
                end
            end)

            local page = Instance.new("ScrollingFrame")
            page.Position = UDim2.fromOffset(0, searchHeight)
            page.Size = UDim2.new(1, 0, 1, -searchHeight)
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
            local elementParent = page
            local play = Instance.new("UIListLayout")
            play.Padding = UDim.new(0, 8); play.SortOrder = Enum.SortOrder.LayoutOrder; play.Parent = page
            local ppad = Instance.new("UIPadding")
            ppad.PaddingTop = UDim.new(0, 16); ppad.PaddingBottom = UDim.new(0, 16)
            ppad.PaddingLeft = UDim.new(0, 18); ppad.PaddingRight = UDim.new(0, 18); ppad.Parent = page
            page:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
                if EZ_DropdownCurrent and EZ_DropdownCurrent.trigger and EZ_DropdownCurrent.trigger:IsDescendantOf(page) then EZ_CloseDropdown() end
            end)
            local function addSearchItem(row, section)
                local item = { row = row, section = section }
                if data.Searching then item.originalVisible = row.Visible end
                table.insert(data.SearchItems, item)
                EZ_SearchRefresh[row] = queueSearch
                queueSearch()
                return item
            end
            EZ_SearchParents[page] = function(child)
                if child:GetAttribute("EZ_Section") then
                    local group = { header = child }
                    if data.Searching then group.originalHeader = child.Visible end
                    data._lastSearchSection = group
                    table.insert(data.SearchSections, group)
                    EZ_SearchRefresh[child] = queueSearch
                    queueSearch()
                elseif child.Name == "EZ_SectionBody" and data._lastSearchSection then
                    local group = data._lastSearchSection
                    group.body = child
                    if data.Searching then group.originalBody = child.Visible end
                    EZ_SearchParents[child] = function(row) addSearchItem(row, group) end
                    queueSearch()
                else
                    addSearchItem(child, nil)
                end
            end

            table.insert(registry, data)
            btn.LayoutOrder = #registry
            updateSidebarTab(data, not EZ_Window._sidebarOpen)
            EZ_BindLocaleRefresh(btn, function()
                data.Title = EZ_TranslateText(tabTitle)
                updateSidebarTab(data, not EZ_Window._sidebarOpen)
            end)

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
            btn.Activated:Connect(function() selectTab(data) end)
            if #registry == 1 then selectTab(data) end

            function tab:AddSection(o)
                o = o or {}
                local holder = Instance.new("Frame")
                holder:SetAttribute("EZ_Section", true)
                holder.Size = UDim2.new(1, 0, 0, 28)
                holder.BackgroundColor3 = EZ_Theme.Card
                holder.BackgroundTransparency = 0.4
                holder.BorderSizePixel = 0
                local function updateSectionLayout(compact)
                    holder.Size = UDim2.new(1, 0, 0, compact and 44 or 28)
                end
                table.insert(EZ_Window._responsiveItems, updateSectionLayout)
                updateSectionLayout(EZ_Window._compact)
                EZ_LayoutChild(page, holder)
                EZ_AddRadius(holder, "Theme")
                local hs = EZ_AddStroke(holder, EZ_Theme.Border, 1)
                EZ_Paint(function() holder.BackgroundColor3 = EZ_Theme.Card end)

                local t = Instance.new("TextLabel")
                t.Size = UDim2.new(1, -40, 1, 0)
                t.Position = UDim2.new(0, 14, 0, 0)
                t.BackgroundTransparency = 1
                t.Text = EZ_Upper(EZ_TranslateText(o.Title))
                t.Font = EZ_Brand.Font
                t.TextSize = 12
                t.TextColor3 = EZ_Theme.Text
                t.TextXAlignment = Enum.TextXAlignment.Left
                t.Parent = holder
                EZ_Paint(function() t.TextColor3 = EZ_Theme.Text end)

                local chev = EZ_CreateIcon(holder, "chevron-down", 14)
                if chev then
                    chev.AnchorPoint = Vector2.new(1, 0.5)
                    chev.Position = UDim2.new(1, -10, 0.5, 0)
                    chev.ImageColor3 = EZ_Theme.TextDim
                end
                local body = Instance.new("Frame")
                body.Name = "EZ_SectionBody"
                body.Size = UDim2.new(1, 0, 0, 0)
                body.AutomaticSize = Enum.AutomaticSize.Y
                body.BackgroundTransparency = 1
                EZ_LayoutChild(page, body)
                local bodyLayout = Instance.new("UIListLayout")
                bodyLayout.Padding = UDim.new(0, 8)
                bodyLayout.SortOrder = Enum.SortOrder.LayoutOrder
                bodyLayout.Parent = body
                elementParent = body
                local searchSection = data._lastSearchSection
                if searchSection then searchSection.chevron = chev end
                local collapsed = false
                local click = Instance.new("TextButton")
                click.Size = UDim2.new(1, 0, 1, 0)
                click.BackgroundTransparency = 1
                click.Text = ""
                click.AutoButtonColor = false
                click.Parent = holder
                click.Activated:Connect(function()
                    if EZ_DropdownCurrent and EZ_DropdownCurrent.trigger and EZ_DropdownCurrent.trigger:IsDescendantOf(body) then EZ_CloseDropdown() end
                    if data.Searching and searchSection then
                        local visible = not body.Visible
                        searchSection.searchOverride = visible
                        searchSection.originalBody = visible
                        collapsed = not visible
                    else
                        collapsed = not collapsed
                    end
                    if chev then
                        TweenService:Create(chev, EZ_Ease.Med, { Rotation = collapsed and -90 or 0 }):Play()
                    end
                    body.Visible = not collapsed
                end)
                local titleSource = o.Title or ""
                local titleBinding = EZ_BindText(t, "Text", titleSource, holder, function(translated)
                    EZ_SetSearchText(holder, translated, "", titleSource, "")
                end, EZ_Upper)
                local obj = { _titleLabel = t, _row = holder, _isSection = true }
                function obj:Set(x)
                    titleSource = x or ""
                    EZ_SetTextSource(titleBinding, titleSource)
                end
                return obj
            end

            function tab:AddDivider()
                local page = elementParent
                local div = Instance.new("Frame")
                div:SetAttribute("EZ_SearchSkip", true)
                div.Size = UDim2.new(1, 0, 0, 1)
                div.BackgroundColor3 = EZ_Theme.Border
                div.BorderSizePixel = 0
                EZ_LayoutChild(page, div)
                EZ_RegTrans(div, 1)
                EZ_Paint(function() div.BackgroundColor3 = EZ_Theme.Border end)
                local obj = { _row = div }
                function obj:Set(v)
                    if data.Searching then
                        for _, item in ipairs(data.SearchItems) do if item.row == div then item.originalVisible = v and true or false; break end end
                        div.Visible = false
                    else
                        div.Visible = v
                    end
                end
                return obj
            end

            function tab:AddParagraph(a, b)
                local page = elementParent
                local o = EZ_Normalize(a, b)
                local row = Instance.new("Frame")
                row.Size = UDim2.new(1, 0, 0, 0)
                row.AutomaticSize = Enum.AutomaticSize.Y
                row.BackgroundColor3 = EZ_Theme.Card
                row.BorderSizePixel = 0
                EZ_LayoutChild(page, row)
                EZ_AddStroke(row, EZ_Theme.Border)
                EZ_AddRadius(row, "Theme")
                EZ_RegTrans(row)
                EZ_Paint(function() row.BackgroundColor3 = EZ_Theme.Card end)
                local lay = Instance.new("UIListLayout")
                lay.Padding = UDim.new(0, 4); lay.Parent = row
                local pad = Instance.new("UIPadding")
                pad.PaddingLeft = UDim.new(0, 14); pad.PaddingRight = UDim.new(0, 14)
                pad.PaddingTop = UDim.new(0, 12); pad.PaddingBottom = UDim.new(0, 12); pad.Parent = row
                local pt, cl
                if o.Title and o.Title ~= "" then
                    pt = Instance.new("TextLabel")
                    pt.Size = UDim2.new(1, 0, 0, 0); pt.AutomaticSize = Enum.AutomaticSize.Y
                    pt.BackgroundTransparency = 1; pt.Text = EZ_TranslateText(o.Title)
                    pt.Font = EZ_Brand.FontBody; pt.TextSize = 13; pt.TextColor3 = EZ_Theme.Text
                    pt.TextXAlignment = Enum.TextXAlignment.Left; pt.TextWrapped = true; pt.Parent = row
                    EZ_Paint(function() pt.TextColor3 = EZ_Theme.Text end)
                end
                if o.Content and o.Content ~= "" then
                    cl = Instance.new("TextLabel")
                    cl.Size = UDim2.new(1, 0, 0, 0); cl.AutomaticSize = Enum.AutomaticSize.Y
                    cl.BackgroundTransparency = 1; cl.Text = EZ_TranslateText(o.Content)
                    cl.Font = EZ_Brand.FontBody; cl.TextSize = 12; cl.TextColor3 = EZ_Theme.TextDim
                    cl.TextXAlignment = Enum.TextXAlignment.Left; cl.TextWrapped = true; cl.Parent = row
                    EZ_Paint(function() cl.TextColor3 = EZ_Theme.TextDim end)
                end
                local titleSource, contentSource = o.Title or "", o.Content or ""
                local function updateSearch()
                    EZ_SetSearchText(row, pt and pt.Text or "", cl and cl.Text or "", titleSource, contentSource)
                end
                if pt then EZ_BindText(pt, "Text", titleSource, row, updateSearch) end
                local contentBinding = cl and EZ_BindText(cl, "Text", contentSource, row, updateSearch)
                if not pt and not cl then updateSearch() end
                local obj = {}
                function obj:Set(x)
                    contentSource = x or ""
                    if contentBinding then EZ_SetTextSource(contentBinding, contentSource) else updateSearch() end
                end
                obj._row = row
                return obj
            end

            function tab:AddLabel(text)
                local page = elementParent
                local row = Instance.new("Frame")
                row.Size = UDim2.new(1, 0, 0, 0)
                row.AutomaticSize = Enum.AutomaticSize.Y
                row.BackgroundTransparency = 1
                EZ_LayoutChild(page, row)
                local pad = Instance.new("UIPadding")
                pad.PaddingLeft = UDim.new(0, 12); pad.PaddingRight = UDim.new(0, 12); pad.Parent = row
                local t = Instance.new("TextLabel")
                t.Size = UDim2.new(1, 0, 0, 0); t.AutomaticSize = Enum.AutomaticSize.Y
                t.BackgroundTransparency = 1; t.Text = EZ_TranslateText(text or "")
                t.Font = EZ_Brand.FontBody; t.TextSize = 12; t.TextColor3 = EZ_Theme.TextDim
                t.TextXAlignment = Enum.TextXAlignment.Left; t.TextWrapped = true; t.Parent = row
                EZ_Paint(function() t.TextColor3 = EZ_Theme.TextDim end)
                local source = text or ""
                local binding = EZ_BindText(t, "Text", source, row, function(translated)
                    EZ_SetSearchText(row, translated, "", source, "")
                end)
                local obj = {}
                function obj:Set(x)
                    source = x or ""
                    EZ_SetTextSource(binding, source)
                end
                obj._row = row
                return obj
            end

            function tab:AddToggle(a, b)
                local page = elementParent
                local o = EZ_Normalize(a, b)
                EZ_ValidateFlag(o.Flag)
                local cb = o.Callback or function() end
                local rightCb = o.RightClick or o.RightCallback or function() end
                local middleCb = o.MiddleClick or o.MiddleCallback or function() end
                local id = o.Flag or o.Id or o.Title or "toggle_" .. os.clock()
                local obj = { Value = o.Default and true or false, Id = id, Flag = o.Flag, Type = "toggle", Default = o.Default and true or false }
                local row, hitbox = EZ_NewRow(page, 46, obj, true)
                EZ_RowTitle(row, o.Title or "Toggle", o.Description, 46, nil, obj)
                local track = Instance.new("Frame")
                track.Size = UDim2.fromOffset(38, 20)
                track.Position = UDim2.new(1, -52, 0.5, -10)
                track.BackgroundColor3 = EZ_Theme.BorderHover
                track.BorderSizePixel = 0
                track.ZIndex = 1
                track.Parent = row
                EZ_AddRadius(track, 10)
                local knob = Instance.new("Frame")
                knob.Size = UDim2.fromOffset(14, 14)
                knob.Position = UDim2.fromOffset(3, 3)
                knob.BackgroundColor3 = EZ_Theme.TextDim
                knob.BorderSizePixel = 0
                knob.ZIndex = 1
                knob.Parent = track
                EZ_AddRadius(knob, 7)
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
                        EZ_SafeCall(cb, obj.Value)
                        if obj.Flag and EZ_Window.AutoSave then
                            EZ_Window.ConfigData[id] = { type = "toggle", value = obj.Value }
                            EZ_Window:_ScheduleSave(EZ_Window.CurrentConfig)
                        end
                    end
                end
                EZ_Connect(hitbox, hitbox.Activated, function() obj:Set(not obj.Value) end)
                EZ_Connect(hitbox, hitbox.InputBegan, function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton2 then
                        EZ_SafeCall(rightCb, obj)
                    elseif i.UserInputType == Enum.UserInputType.MouseButton3 then
                        EZ_SafeCall(middleCb, obj)
                    end
                end)
                renderTween()
                EZ_Window:_RegisterElement(obj)
                obj._row = row
                return obj
            end

            function tab:AddButton(a, b)
                local page = elementParent
                local o = EZ_Normalize(a, b)
                local cb = o.Callback or function() end
                local rightCb = o.RightClick or o.RightCallback or function() end
                local middleCb = o.MiddleClick or o.MiddleCallback or function() end
                local obj = {}
                local row, hitbox = EZ_NewRow(page, 46, obj, true)
                EZ_RowTitle(row, o.Title or "Button", o.Description, 46, nil, obj)
                local act = Instance.new("TextButton")
                act.Size = UDim2.fromOffset(96, 28)
                act.Position = UDim2.new(1, -110, 0.5, -14)
                act.BackgroundColor3 = EZ_Theme.Accent
                act.BorderSizePixel = 0
                act.Text = EZ_TranslateText(o.ButtonText or "Run")
                obj._buttonLabel = act
                act.Font = EZ_Brand.FontBody
                act.TextSize = 12
                act.TextColor3 = EZ_Theme.Background
                act.AutoButtonColor = false
                act.ZIndex = 3
                act.Parent = row
                local buttonBinding = EZ_BindText(act, "Text", o.ButtonText or "Run", row)
                EZ_AddRadius(act, "Theme")
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
                    EZ_SafeCall(cb)
                end
                act.Activated:Connect(function() obj:Fire() end)
                act.MouseButton2Click:Connect(function() EZ_SafeCall(rightCb, obj) end)
                EZ_Connect(act, act.InputBegan, function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton3 then EZ_SafeCall(middleCb, obj) end
                end)
                EZ_Connect(hitbox, hitbox.Activated, function() obj:Fire() end)
                EZ_Connect(hitbox, hitbox.InputBegan, function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton2 then
                        EZ_SafeCall(rightCb, obj)
                    elseif i.UserInputType == Enum.UserInputType.MouseButton3 then
                        EZ_SafeCall(middleCb, obj)
                    end
                end)
                function obj:SetTitle(t) EZ_SetTextSource(buttonBinding, t or "") end
                obj._row = row
                return obj
            end

            function tab:AddSlider(a, b)
                local page = elementParent
                local o = EZ_Normalize(a, b)
                EZ_ValidateFlag(o.Flag)
                local mn, mx, st = tonumber(o.Min) or 0, tonumber(o.Max) or 100, tonumber(o.Step) or 1
                if mn > mx then mn, mx = mx, mn end
                if st <= 0 then st = 1 end
                local cb = o.Callback or function() end
                local id = o.Flag or o.Id or o.Title or "slider_" .. os.clock()
                local obj = { Value = o.Default or mn, Id = id, Flag = o.Flag, Type = "slider", Default = o.Default or mn }
                local lastCallbackValue = obj.Value
                local row = EZ_NewRow(page, 62, obj)
                local tl = Instance.new("TextLabel")
                tl.Position = UDim2.fromOffset(14, 11)
                tl.Size = UDim2.new(1, -120, 0, 16)
                tl.BackgroundTransparency = 1
                tl.Text = EZ_TranslateText(o.Title or "Slider")
                obj._titleLabel = tl
                tl.Font = EZ_Brand.FontBody; tl.TextSize = 13; tl.TextColor3 = EZ_Theme.Text
                tl.TextXAlignment = Enum.TextXAlignment.Left; tl.TextTruncate = Enum.TextTruncate.AtEnd
                tl.Parent = row
                EZ_BindText(tl, "Text", o.Title or "Slider", row, function(translated)
                    EZ_SetSearchText(row, translated, EZ_TranslateText(o.Description), o.Title or "Slider", o.Description)
                end)
                EZ_Paint(function() tl.TextColor3 = EZ_Theme.Text end, obj)
                local vl = Instance.new("TextLabel")
                vl.AnchorPoint = Vector2.new(1, 0)
                vl.Position = UDim2.new(1, -14, 0, 11)
                vl.Size = UDim2.fromOffset(90, 16)
                vl.BackgroundTransparency = 1
                vl.Font = EZ_Brand.FontMono; vl.TextSize = 13; vl.TextColor3 = EZ_Theme.Accent
                vl.TextXAlignment = Enum.TextXAlignment.Right
                vl.Parent = row
                EZ_Paint(function() vl.TextColor3 = EZ_Theme.Accent end, obj)
                local track = Instance.new("Frame")
                track.Position = UDim2.fromOffset(14, 40)
                track.Size = UDim2.new(1, -28, 0, 4)
                track.BackgroundColor3 = EZ_Theme.Border
                track.BorderSizePixel = 0
                track.Parent = row
                EZ_AddRadius(track, 2)
                local fill = Instance.new("Frame")
                fill.Size = UDim2.new(0, 0, 1, 0)
                fill.BackgroundColor3 = EZ_Theme.Accent
                fill.BorderSizePixel = 0
                fill.Parent = track
                EZ_AddRadius(fill, 2)
                local knob = Instance.new("Frame")
                knob.AnchorPoint = Vector2.new(0.5, 0.5)
                knob.Size = UDim2.fromOffset(12, 12)
                knob.Position = UDim2.new(0, 0, 0.5, 0)
                knob.BackgroundColor3 = EZ_Theme.Accent
                knob.BorderSizePixel = 0
                knob.Parent = track
                EZ_AddRadius(knob, 6)
                local cap = Instance.new("TextButton")
                cap.Position = UDim2.fromOffset(14, 25)
                cap.Size = UDim2.new(1, -28, 0, 34)
                cap.BackgroundTransparency = 1
                cap.Text = ""
                cap.AutoButtonColor = false
                cap.ZIndex = 2
                cap.Parent = row
                local function fmt(n) return EZ_FormatStep(n, st) end
                local function refreshVisual()
                    local r = (mx - mn) == 0 and 0 or (obj.Value - mn) / (mx - mn)
                    fill.Size = UDim2.new(r, 0, 1, 0)
                    knob.Position = UDim2.new(r, 0, 0.5, 0)
                    vl.Text = fmt(obj.Value)
                end
                EZ_Paint(function()
                    track.BackgroundColor3 = EZ_Theme.Border
                    fill.BackgroundColor3 = EZ_Theme.Accent
                    knob.BackgroundColor3 = EZ_Theme.Accent
                    refreshVisual()
                end, obj)
                local function applyVisual(raw)
                    local v = EZ_Snap(raw, mn, mx, st)
                    obj.Value = v
                    refreshVisual()
                end
                local function applyFinal(silent)
                    if silent then lastCallbackValue = obj.Value; return end
                    if not silent then
                        if obj.Value ~= lastCallbackValue then
                            lastCallbackValue = obj.Value
                            EZ_SafeCall(cb, obj.Value)
                            if obj.Flag and EZ_Window.AutoSave then
                                EZ_Window.ConfigData[id] = { type = "slider", value = obj.Value }
                                EZ_Window:_ScheduleSave(EZ_Window.CurrentConfig)
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
                        applyVisual(fromPtr(i.Position.X))
                        EZ_StartPointer(i, function(event) applyVisual(fromPtr(event.Position.X)) end, function() applyFinal(false) end)
                    end
                end)
                EZ_EnsureSliderDispatcher()
                local function sliderInc()
                    applyVisual(obj.Value + st)
                    applyFinal(false)
                end
                local function sliderDec()
                    applyVisual(obj.Value - st)
                    applyFinal(false)
                end
                local function sliderWheel(up)
                    applyVisual(obj.Value + (up and st or -st))
                    applyFinal(false)
                end
                local function selectSlider()
                    EZ_HoveredSlider = { inc = sliderInc, dec = sliderDec, wheel = sliderWheel }
                end
                local function deselectSlider()
                    if EZ_HoveredSlider and EZ_HoveredSlider.inc == sliderInc then EZ_HoveredSlider = nil end
                end
                row.MouseEnter:Connect(selectSlider)
                row.MouseLeave:Connect(deselectSlider)
                cap.SelectionGained:Connect(selectSlider)
                cap.SelectionLost:Connect(deselectSlider)
                local editBtn = Instance.new("TextButton")
                editBtn.AnchorPoint = Vector2.new(1, 0)
                editBtn.Position = UDim2.new(1, -14, 0, 11)
                editBtn.Size = UDim2.fromOffset(90, 16)
                editBtn.BackgroundTransparency = 1
                editBtn.Text = ""
                editBtn.AutoButtonColor = false
                editBtn.Parent = row
                editBtn.Activated:Connect(function()
                    local box = Instance.new("TextBox")
                    box.AnchorPoint = Vector2.new(1, 0)
                    box.Position = UDim2.new(1, -14, 0, 9)
                    box.Size = UDim2.fromOffset(90, 20)
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
                obj.Default, lastCallbackValue = obj.Value, obj.Value
                EZ_Window:_RegisterElement(obj)
                obj._row = row
                return obj
            end

            function tab:AddRangeSlider(a, b)
                local page = elementParent
                local o = EZ_Normalize(a, b)
                EZ_ValidateFlag(o.Flag)
                local mn, mx, st = tonumber(o.Min) or 0, tonumber(o.Max) or 100, tonumber(o.Step) or 1
                if mn > mx then mn, mx = mx, mn end
                if st <= 0 then st = 1 end
                local cb = o.Callback or function() end
                local id = o.Flag or o.Id or o.Title or "range_" .. os.clock()
                local obj = {
                    MinValue = (type(o.Default) == "table" and o.Default[1]) or mn,
                    MaxValue = (type(o.Default) == "table" and o.Default[2]) or mx,
                    Id = id, Flag = o.Flag, Type = "range",
                    Default = { (type(o.Default) == "table" and o.Default[1]) or mn, (type(o.Default) == "table" and o.Default[2]) or mx }
                }
                obj.MinValue = EZ_Snap(obj.MinValue, mn, mx, st)
                obj.MaxValue = EZ_Snap(obj.MaxValue, mn, mx, st)
                if obj.MinValue > obj.MaxValue then obj.MinValue, obj.MaxValue = obj.MaxValue, obj.MinValue end
                obj.Default = { obj.MinValue, obj.MaxValue }
                local lastCallbackMin = obj.MinValue
                local lastCallbackMax = obj.MaxValue
                local row = EZ_NewRow(page, 62, obj)
                local tl = Instance.new("TextLabel")
                tl.Position = UDim2.fromOffset(14, 11)
                tl.Size = UDim2.new(1, -190, 0, 16)
                tl.BackgroundTransparency = 1
                tl.Text = EZ_TranslateText(o.Title or "Range")
                obj._titleLabel = tl
                tl.Font = EZ_Brand.FontBody; tl.TextSize = 13; tl.TextColor3 = EZ_Theme.Text
                tl.TextXAlignment = Enum.TextXAlignment.Left; tl.TextTruncate = Enum.TextTruncate.AtEnd
                tl.Parent = row
                EZ_BindText(tl, "Text", o.Title or "Range", row, function(translated)
                    EZ_SetSearchText(row, translated, EZ_TranslateText(o.Description), o.Title or "Range", o.Description)
                end)
                EZ_Paint(function() tl.TextColor3 = EZ_Theme.Text end, obj)
                local vl = Instance.new("TextLabel")
                vl.AnchorPoint = Vector2.new(1, 0)
                vl.Position = UDim2.new(1, -14, 0, 11)
                vl.Size = UDim2.fromOffset(160, 16)
                vl.BackgroundTransparency = 1
                vl.Font = EZ_Brand.FontMono; vl.TextSize = 13; vl.TextColor3 = EZ_Theme.Accent
                vl.TextXAlignment = Enum.TextXAlignment.Right
                vl.TextTruncate = Enum.TextTruncate.AtEnd
                vl.Parent = row
                EZ_Paint(function() vl.TextColor3 = EZ_Theme.Accent end, obj)
                local function updateRangeLayout(compact)
                    tl.Size = UDim2.new(1, compact and -130 or -190, 0, 16)
                    vl.Size = UDim2.fromOffset(compact and 100 or 160, 16)
                end
                table.insert(EZ_Window._responsiveItems, updateRangeLayout)
                updateRangeLayout(EZ_Window._compact)
                local track = Instance.new("Frame")
                track.Position = UDim2.fromOffset(14, 40)
                track.Size = UDim2.new(1, -28, 0, 4)
                track.BackgroundColor3 = EZ_Theme.Border
                track.BorderSizePixel = 0
                track.Parent = row
                EZ_AddRadius(track, 2)
                local fill = Instance.new("Frame")
                fill.BackgroundColor3 = EZ_Theme.Accent
                fill.BorderSizePixel = 0
                fill.Parent = track
                EZ_AddRadius(fill, 2)
                local knobMin = Instance.new("Frame")
                knobMin.AnchorPoint = Vector2.new(0.5, 0.5)
                knobMin.Size = UDim2.fromOffset(12, 12)
                knobMin.BackgroundColor3 = EZ_Theme.Accent
                knobMin.BorderSizePixel = 0
                knobMin.ZIndex = 2
                knobMin.Parent = track
                EZ_AddRadius(knobMin, 6)
                local knobMax = Instance.new("Frame")
                knobMax.AnchorPoint = Vector2.new(0.5, 0.5)
                knobMax.Size = UDim2.fromOffset(12, 12)
                knobMax.BackgroundColor3 = EZ_Theme.Accent
                knobMax.BorderSizePixel = 0
                knobMax.ZIndex = 2
                knobMax.Parent = track
                EZ_AddRadius(knobMax, 6)
                local cap = Instance.new("TextButton")
                cap.Position = UDim2.fromOffset(14, 25)
                cap.Size = UDim2.new(1, -28, 0, 34)
                cap.BackgroundTransparency = 1
                cap.Text = ""
                cap.AutoButtonColor = false
                cap.ZIndex = 3
                cap.Parent = row
                local function fmt(n) return EZ_FormatStep(n, st) end
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
                    track.BackgroundColor3 = EZ_Theme.Border
                    fill.BackgroundColor3 = EZ_Theme.Accent
                    knobMin.BackgroundColor3 = EZ_Theme.Accent
                    knobMax.BackgroundColor3 = EZ_Theme.Accent
                    refreshVisual()
                end, obj)
                local function applyVisualMin(raw)
                    local v = math.min(EZ_Snap(raw, mn, mx, st), obj.MaxValue)
                    obj.MinValue = v
                    refreshVisual()
                end
                local function applyVisualMax(raw)
                    local v = math.max(EZ_Snap(raw, mn, mx, st), obj.MinValue)
                    obj.MaxValue = v
                    refreshVisual()
                end
                local function applyFinal(silent)
                    if not silent then
                        if obj.MinValue ~= lastCallbackMin or obj.MaxValue ~= lastCallbackMax then
                            lastCallbackMin = obj.MinValue
                            lastCallbackMax = obj.MaxValue
                            EZ_SafeCall(cb, { obj.MinValue, obj.MaxValue })
                            if obj.Flag and EZ_Window.AutoSave then
                                EZ_Window.ConfigData[id] = { type = "range", value = { obj.MinValue, obj.MaxValue } }
                                EZ_Window:_ScheduleSave(EZ_Window.CurrentConfig)
                            end
                        end
                    end
                end
                local function fromPtr(x)
                    local w = track.AbsoluteSize.X
                    if w <= 0 then return 0 end
                    return mn + EZ_Clamp((x - track.AbsolutePosition.X) / w, 0, 1) * (mx - mn)
                end
                cap.InputBegan:Connect(function(i)
                    if i.UserInputType ~= Enum.UserInputType.MouseButton1 and i.UserInputType ~= Enum.UserInputType.Touch then return end
                    local value = fromPtr(i.Position.X)
                    local useMin = math.abs(value - obj.MinValue) <= math.abs(value - obj.MaxValue)
                    local apply = useMin and applyVisualMin or applyVisualMax
                    apply(value)
                    EZ_StartPointer(i, function(event) apply(fromPtr(event.Position.X)) end, function() applyFinal(false) end)
                end)
                function obj:Set(values, silent)
                    if type(values) == "table" then
                        local low = EZ_Snap(values[1] or mn, mn, mx, st)
                        local high = EZ_Snap(values[2] or mx, mn, mx, st)
                        obj.MinValue, obj.MaxValue = math.min(low, high), math.max(low, high)
                    end
                    lastCallbackMin, lastCallbackMax = obj.MinValue, obj.MaxValue
                    refreshVisual()
                    if not silent then
                        EZ_SafeCall(cb, { obj.MinValue, obj.MaxValue })
                        if obj.Flag and EZ_Window.AutoSave then
                            EZ_Window.ConfigData[id] = { type = "range", value = { obj.MinValue, obj.MaxValue } }
                            EZ_Window:_ScheduleSave(EZ_Window.CurrentConfig)
                        end
                    end
                end
                refreshVisual()
                EZ_Window:_RegisterElement(obj)
                obj._row = row
                return obj
            end

            function tab:AddBanner(o)
                local page = elementParent
                o = o or {}
                local holder = Instance.new("Frame")
                holder.Size = UDim2.new(1, 0, 0, o.Height or 96)
                holder.BackgroundColor3 = EZ_Theme.Card
                holder.BorderSizePixel = 0
                holder.ClipsDescendants = true
                EZ_LayoutChild(page, holder)
                EZ_AddRadius(holder, "Theme")
                EZ_RegTrans(holder)
                EZ_Paint(function() holder.BackgroundColor3 = EZ_Theme.Card end)
                if o.Image then
                    local img = Instance.new("ImageLabel")
                    img.Size = UDim2.new(1, 0, 1, 0)
                    img.BackgroundTransparency = 1
                    img.Image = o.Image
                    img.ScaleType = Enum.ScaleType.Crop
                    img.Parent = holder
                    EZ_AddRadius(img, "Theme")
                end
                local titleLbl, subLbl
                if o.Title then
                    titleLbl = Instance.new("TextLabel")
                    titleLbl.Size = UDim2.new(1, -20, 0, 22)
                    titleLbl.Position = UDim2.new(0, 14, 0, 12)
                    titleLbl.BackgroundTransparency = 1
                    titleLbl.Text = EZ_TranslateText(o.Title)
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
                    subLbl.Text = EZ_TranslateText(o.SubTitle)
                    subLbl.Font = EZ_Brand.FontBody
                    subLbl.TextSize = 12
                    subLbl.TextColor3 = o.SubColor or EZ_Theme.TextDim
                    subLbl.TextXAlignment = Enum.TextXAlignment.Left
                    subLbl.Parent = holder
                    EZ_Paint(function() subLbl.TextColor3 = o.SubColor or EZ_Theme.TextDim end)
                end
                local titleSource, subSource = o.Title or "", o.SubTitle or ""
                local function updateSearch()
                    EZ_SetSearchText(holder, titleLbl and titleLbl.Text or "", subLbl and subLbl.Text or "", titleSource, subSource)
                end
                local titleBinding = titleLbl and EZ_BindText(titleLbl, "Text", titleSource, holder, updateSearch)
                local subBinding = subLbl and EZ_BindText(subLbl, "Text", subSource, holder, updateSearch)
                if not titleLbl and not subLbl then updateSearch() end
                local obj = {}
                function obj:SetTitle(x)
                    titleSource = x or ""
                    if titleBinding then EZ_SetTextSource(titleBinding, titleSource) else updateSearch() end
                end
                function obj:SetSubtitle(x)
                    subSource = x or ""
                    if subBinding then EZ_SetTextSource(subBinding, subSource) else updateSearch() end
                end
                obj._holder = holder
                return obj
            end

            function tab:AddDropdown(a, b)
                local page = elementParent
                local o = EZ_Normalize(a, b)
                EZ_ValidateFlag(o.Flag)
                local values = o.Values or o.Options or {}
                local cb = o.Callback or function() end
                local multi = o.Multi == true
                local function displayValue(value)
                    local text = tostring(value)
                    return o.TranslateValues == false and text or EZ_TranslateText(text)
                end
                local id = o.Flag or o.Id or o.Title or "dropdown_" .. os.clock()
                local defaultVal
                if multi then
                    if type(o.Default) == "table" then
                        defaultVal = EZ_Copy(o.Default)
                    elseif o.Default ~= nil then
                        defaultVal = { o.Default }
                    else
                        defaultVal = {}
                    end
                else
                    defaultVal = o.Default
                end
                local obj = {
                    Value = multi and EZ_Copy(defaultVal) or defaultVal,
                    Id = id, Flag = o.Flag,
                    Type = multi and "multi" or "dropdown",
                    Default = multi and EZ_Copy(defaultVal) or defaultVal
                }
                local row = EZ_NewRow(page, 46, obj)
                local titleLabel, descriptionLabel = EZ_RowTitle(row, o.Title or "Dropdown", o.Description, 46, 200, obj)
                local trigger = Instance.new("TextButton")
                trigger.Size = UDim2.fromOffset(170, 28)
                trigger.Position = UDim2.new(1, -184, 0.5, -14)
                trigger.BackgroundColor3 = EZ_Theme.Background
                trigger.BorderSizePixel = 0
                trigger.Text = ""
                trigger.AutoButtonColor = false
                trigger.Parent = row
                EZ_ResponsiveRow(row, titleLabel, descriptionLabel, trigger)
                local tst = EZ_AddStroke(trigger, EZ_Theme.Border)
                EZ_AddRadius(trigger, "Theme")
                EZ_RegTrans(trigger)
                local trigText = Instance.new("TextLabel")
                trigText.Size = UDim2.new(1, -34, 1, 0)
                trigText.Position = UDim2.fromOffset(12, 0)
                trigText.BackgroundTransparency = 1
                trigText.Font = EZ_Brand.FontBody
                trigText.TextSize = 12
                trigText.TextColor3 = EZ_Theme.Text
                trigText.TextXAlignment = Enum.TextXAlignment.Left
                trigText.TextTruncate = Enum.TextTruncate.AtEnd
                trigText.Parent = trigger
                local function updateTrigger()
                    if multi then
                        local labels = {}
                        for _, value in ipairs(obj.Value) do table.insert(labels, displayValue(value)) end
                        trigText.Text = #labels > 0 and table.concat(labels, ", ") or EZ_Locale.None
                    else
                        trigText.Text = obj.Value == nil and EZ_Locale.None or displayValue(obj.Value)
                    end
                end
                EZ_BindLocaleRefresh(row, updateTrigger)
                local sign = EZ_CreateIcon(trigger, "chevron-down", 14)
                if sign then
                    sign.AnchorPoint = Vector2.new(1, 0.5)
                    sign.Position = UDim2.new(1, -8, 0.5, 0)
                    sign.ImageColor3 = EZ_Theme.TextDim
                end
                EZ_Paint(function()
                    trigger.BackgroundColor3 = EZ_Theme.Background
                    trigText.TextColor3 = EZ_Theme.Text
                    if (multi and #obj.Value == 0) or (not multi and obj.Value == nil) then trigText.Text = EZ_Locale.None end
                    if sign and sign:IsA("ImageLabel") then sign.ImageColor3 = EZ_Theme.TextDim end
                end, obj)
                trigger.MouseEnter:Connect(function() TweenService:Create(tst, EZ_Ease.Fast, { Color = EZ_Theme.BorderHover }):Play() end)
                trigger.MouseLeave:Connect(function() TweenService:Create(tst, EZ_Ease.Fast, { Color = EZ_Theme.Border }):Play() end)
                local entry = {
                    trigger = trigger,
                    sign = sign,
                    windowFrame = frame,
                    width = 184,
                    searchable = o.Searchable and true or false,
                    multi = multi,
                    getValues = function() return values end,
                    getValue = function() return obj.Value end,
                    getDisplay = displayValue,
                    pick = function(v)
                        if multi then
                            local found = false
                            for i, item in ipairs(obj.Value) do
                                if item == v then table.remove(obj.Value, i); found = true; break end
                            end
                            if not found then table.insert(obj.Value, v) end
                            updateTrigger()
                            EZ_SafeCall(cb, EZ_Copy(obj.Value))
                            if obj.Flag and EZ_Window.AutoSave then
                                EZ_Window.ConfigData[id] = { type = "multi", value = EZ_Copy(obj.Value) }
                                EZ_Window:_ScheduleSave(EZ_Window.CurrentConfig)
                            end
                        else
                            obj:Set(v, false)
                        end
                    end,
                }
                function obj:Set(v, silent)
                    if multi then
                        obj.Value = type(v) == "table" and EZ_Copy(v) or {}
                    else
                        obj.Value = v
                    end
                    updateTrigger()
                    if not silent then
                        EZ_SafeCall(cb, multi and EZ_Copy(obj.Value) or obj.Value)
                        if obj.Flag and EZ_Window.AutoSave then
                            EZ_Window.ConfigData[id] = { type = multi and "multi" or "dropdown", value = multi and EZ_Copy(obj.Value) or obj.Value }
                            EZ_Window:_ScheduleSave(EZ_Window.CurrentConfig)
                        end
                    end
                end
                function obj:SetValues(newValues)
                    values = type(newValues) == "table" and newValues or {}
                    if EZ_DropdownCurrent == entry then EZ_CloseDropdown() end
                end
                obj.getValues = function() return values end
                trigger.Activated:Connect(function() EZ_OpenDropdown(entry) end)
                EZ_Window:_RegisterElement(obj)
                obj._row = row
                return obj
            end

            function tab:AddInput(a, b)
                local page = elementParent
                local o = EZ_Normalize(a, b)
                EZ_ValidateFlag(o.Flag)
                local cb = o.Callback or function() end
                local id = o.Flag or o.Id or o.Title or "input_" .. os.clock()
                local obj = { Value = o.Default or "", Id = id, Flag = o.Flag, Type = "input", Default = o.Default or "" }
                local row = EZ_NewRow(page, 46, obj)
                local titleLabel, descriptionLabel = EZ_RowTitle(row, o.Title or "Input", o.Description, 46, 200, obj)
                local box = Instance.new("TextBox")
                box.Size = UDim2.fromOffset(170, 28)
                box.Position = UDim2.new(1, -184, 0.5, -14)
                box.BackgroundColor3 = EZ_Theme.Background
                box.BorderSizePixel = 0
                box.Text = obj.Value
                box.Font = EZ_Brand.FontMono
                box.TextSize = 12
                box.TextColor3 = EZ_Theme.Text
                box.PlaceholderText = EZ_TranslateText(o.Placeholder or "...")
                box.PlaceholderColor3 = EZ_Theme.TextDim
                box.TextXAlignment = Enum.TextXAlignment.Left
                box.ClearTextOnFocus = false
                box.Parent = row
                EZ_BindText(box, "PlaceholderText", o.Placeholder or "...", row)
                EZ_ResponsiveRow(row, titleLabel, descriptionLabel, box)
                local bst = EZ_AddStroke(box, EZ_Theme.Border)
                EZ_AddRadius(box, "Theme")
                EZ_RegTrans(box)
                EZ_Paint(function()
                    box.BackgroundColor3 = EZ_Theme.Background
                    box.TextColor3 = EZ_Theme.Text
                    box.PlaceholderColor3 = EZ_Theme.TextDim
                end, obj)
                local bpad = Instance.new("UIPadding")
                bpad.PaddingLeft = UDim.new(0, 10); bpad.PaddingRight = UDim.new(0, 10); bpad.Parent = box
                EZ_Connect(box, box.Focused, function() bst.Color = EZ_Theme.BorderHover end)
                EZ_Connect(box, box.FocusLost, function()
                    bst.Color = EZ_Theme.Border
                    obj:Set(box.Text, false)
                end)
                function obj:Set(t, silent)
                    obj.Value = t or ""
                    box.Text = obj.Value
                    if not silent then
                        EZ_SafeCall(cb, obj.Value)
                        if obj.Flag and EZ_Window.AutoSave then
                            EZ_Window.ConfigData[id] = { type = "input", value = t }
                            EZ_Window:_ScheduleSave(EZ_Window.CurrentConfig)
                        end
                    end
                end
                obj._box = box
                EZ_Window:_RegisterElement(obj)
                obj._row = row
                return obj
            end

            function tab:AddTextArea(a, b)
                local page = elementParent
                local o = EZ_Normalize(a, b)
                EZ_ValidateFlag(o.Flag)
                local cb = o.Callback or function() end
                local id = o.Flag or o.Id or o.Title or "textarea_" .. os.clock()
                local obj = { Value = o.Default or "", Id = id, Flag = o.Flag, Type = "textarea", Default = o.Default or "" }
                local row = Instance.new("Frame")
                row.Size = UDim2.new(1, 0, 0, 116)
                row.BackgroundColor3 = EZ_Theme.Card
                row.BorderSizePixel = 0
                EZ_LayoutChild(page, row)
                EZ_AddStroke(row, EZ_Theme.Border)
                EZ_AddRadius(row, "Theme")
                EZ_RegTrans(row)
                EZ_Paint(function() row.BackgroundColor3 = EZ_Theme.Card end, obj)
                local tl = Instance.new("TextLabel")
                tl.Position = UDim2.fromOffset(14, 11)
                tl.Size = UDim2.new(1, -24, 0, 16)
                tl.BackgroundTransparency = 1
                tl.Text = EZ_TranslateText(o.Title or "Text Area")
                obj._titleLabel = tl
                tl.Font = EZ_Brand.FontBody; tl.TextSize = 13; tl.TextColor3 = EZ_Theme.Text
                tl.TextXAlignment = Enum.TextXAlignment.Left
                tl.Parent = row
                EZ_BindText(tl, "Text", o.Title or "Text Area", row, function(translated)
                    EZ_SetSearchText(row, translated, EZ_TranslateText(o.Description), o.Title or "Text Area", o.Description)
                end)
                EZ_Paint(function() tl.TextColor3 = EZ_Theme.Text end, obj)
                local box = Instance.new("TextBox")
                box.Size = UDim2.new(1, -28, 0, 76)
                box.Position = UDim2.fromOffset(14, 34)
                box.BackgroundColor3 = EZ_Theme.Background
                box.BorderSizePixel = 0
                box.Text = obj.Value
                box.Font = EZ_Brand.FontMono; box.TextSize = 12; box.TextColor3 = EZ_Theme.Text
                box.PlaceholderText = EZ_TranslateText(o.Placeholder or "...")
                box.PlaceholderColor3 = EZ_Theme.TextDim
                box.TextXAlignment = Enum.TextXAlignment.Left
                box.TextYAlignment = Enum.TextYAlignment.Top
                box.TextWrapped = true
                box.ClearTextOnFocus = false
                box.MultiLine = true
                box.Parent = row
                EZ_BindText(box, "PlaceholderText", o.Placeholder or "...", row)
                local bst = EZ_AddStroke(box, EZ_Theme.Border)
                EZ_AddRadius(box, "Theme")
                EZ_RegTrans(box)
                EZ_Paint(function()
                    box.BackgroundColor3 = EZ_Theme.Background
                    box.TextColor3 = EZ_Theme.Text
                    box.PlaceholderColor3 = EZ_Theme.TextDim
                end, obj)
                local bpad = Instance.new("UIPadding")
                bpad.PaddingLeft = UDim.new(0, 10); bpad.PaddingRight = UDim.new(0, 10)
                bpad.PaddingTop = UDim.new(0, 8); bpad.PaddingBottom = UDim.new(0, 8); bpad.Parent = box
                EZ_Connect(box, box.Focused, function() bst.Color = EZ_Theme.BorderHover end)
                EZ_Connect(box, box.FocusLost, function()
                    bst.Color = EZ_Theme.Border
                    obj:Set(box.Text, false)
                end)
                function obj:Set(t, silent)
                    obj.Value = t or ""
                    box.Text = obj.Value
                    if not silent then
                        EZ_SafeCall(cb, obj.Value)
                        if obj.Flag and EZ_Window.AutoSave then
                            EZ_Window.ConfigData[id] = { type = "textarea", value = t }
                            EZ_Window:_ScheduleSave(EZ_Window.CurrentConfig)
                        end
                    end
                end
                obj._box = box
                EZ_Window:_RegisterElement(obj)
                obj._row = row
                return obj
            end

            function tab:AddProgressBar(a, b)
                local page = elementParent
                local o = EZ_Normalize(a, b)
                local obj = { Value = o.Default or 0 }
                local row = EZ_NewRow(page, 50, obj)
                local tl = Instance.new("TextLabel")
                tl.Position = UDim2.fromOffset(14, 11)
                tl.Size = UDim2.new(1, -90, 0, 16)
                tl.BackgroundTransparency = 1
                tl.Text = EZ_TranslateText(o.Title or "Progress")
                obj._titleLabel = tl
                tl.Font = EZ_Brand.FontBody; tl.TextSize = 13; tl.TextColor3 = EZ_Theme.Text
                tl.TextXAlignment = Enum.TextXAlignment.Left
                tl.Parent = row
                EZ_BindText(tl, "Text", o.Title or "Progress", row, function(translated)
                    EZ_SetSearchText(row, translated, EZ_TranslateText(o.Description), o.Title or "Progress", o.Description)
                end)
                EZ_Paint(function() tl.TextColor3 = EZ_Theme.Text end, obj)
                local vl = Instance.new("TextLabel")
                vl.AnchorPoint = Vector2.new(1, 0)
                vl.Position = UDim2.new(1, -14, 0, 11)
                vl.Size = UDim2.fromOffset(70, 16)
                vl.BackgroundTransparency = 1
                vl.Font = EZ_Brand.FontMono; vl.TextSize = 12; vl.TextColor3 = EZ_Theme.Accent
                vl.TextXAlignment = Enum.TextXAlignment.Right
                vl.Text = tostring(obj.Value) .. "%"
                vl.Parent = row
                EZ_Paint(function() vl.TextColor3 = EZ_Theme.Accent end, obj)
                local track = Instance.new("Frame")
                track.Position = UDim2.fromOffset(14, 34)
                track.Size = UDim2.new(1, -28, 0, 4)
                track.BackgroundColor3 = EZ_Theme.Border
                track.BorderSizePixel = 0
                track.Parent = row
                EZ_AddRadius(track, 2)
                local fill = Instance.new("Frame")
                fill.Size = UDim2.new(obj.Value / 100, 0, 1, 0)
                fill.BackgroundColor3 = EZ_Theme.Accent
                fill.BorderSizePixel = 0
                fill.Parent = track
                EZ_AddRadius(fill, 2)
                EZ_Paint(function()
                    track.BackgroundColor3 = EZ_Theme.Border
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
                local page = elementParent
                local o = EZ_Normalize(a, b)
                EZ_ValidateFlag(o.Flag)
                local cb = o.Callback or function() end
                local id = o.Flag or o.Id or o.Title or "color_" .. os.clock()
                local def = o.Default or Color3.fromRGB(255, 255, 255)
                local obj = { Value = def, Id = id, Flag = o.Flag, Type = "color", Default = def }

                local h, s, v = def:ToHSV()

                local ROW_H = 46
                local BODY_H = 184

                local row = EZ_NewRow(page, ROW_H, obj)

                local header = Instance.new("TextButton")
                header.Text = ""
                header.AutoButtonColor = false
                header.Name = "Header"
                header.Size = UDim2.new(1, 0, 0, ROW_H)
                header.Position = UDim2.fromOffset(0, 0)
                header.BackgroundTransparency = 1
                header.Parent = row

                local lbl = Instance.new("TextLabel")
                lbl.Position = UDim2.fromOffset(14, 0)
                lbl.Size = UDim2.new(1, -80, 1, 0)
                lbl.BackgroundTransparency = 1
                lbl.Text = EZ_TranslateText(o.Title or "Color")
                obj._titleLabel = lbl
                lbl.Font = EZ_Brand.FontBody
                lbl.TextSize = 13
                lbl.TextColor3 = EZ_Theme.Text
                lbl.TextXAlignment = Enum.TextXAlignment.Left
                lbl.Parent = header
                EZ_BindText(lbl, "Text", o.Title or "Color", row, function(translated)
                    EZ_SetSearchText(row, translated, EZ_TranslateText(o.Description), o.Title or "Color", o.Description)
                end)
                EZ_Paint(function() lbl.TextColor3 = EZ_Theme.Text end, obj)

                local swatch = Instance.new("Frame")
                swatch.AnchorPoint = Vector2.new(1, 0.5)
                swatch.Size = UDim2.fromOffset(28, 28)
                swatch.Position = UDim2.new(1, -52, 0.5, 0)
                swatch.BackgroundColor3 = def
                swatch.BorderSizePixel = 0
                swatch.Parent = header
                EZ_AddStroke(swatch, EZ_Theme.Border)
                EZ_AddRadius(swatch, "Theme")

                local chev = EZ_CreateIcon(header, "chevron-down", 14)
                if chev then
                    chev.AnchorPoint = Vector2.new(1, 0.5)
                    chev.Position = UDim2.new(1, -14, 0.5, 0)
                    chev.ImageColor3 = EZ_Theme.TextDim
                end
                EZ_Paint(function()
                    if chev and chev:IsA("ImageLabel") then chev.ImageColor3 = EZ_Theme.TextDim end
                end, obj)

                local panel = Instance.new("Frame")
                panel.Position = UDim2.fromOffset(1, ROW_H)
                panel.Size = UDim2.new(1, -2, 0, 0)
                panel.BackgroundColor3 = EZ_Theme.Background
                panel.BorderSizePixel = 0
                panel.ClipsDescendants = true
                panel.Parent = row
                EZ_RegTrans(panel)
                EZ_Paint(function() panel.BackgroundColor3 = EZ_Theme.Background end, obj)

                local canvasBg = Instance.new("Frame")
                canvasBg.Position = UDim2.fromOffset(12, 12)
                canvasBg.Size = UDim2.new(1, -60, 0, 120)
                canvasBg.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                canvasBg.BorderSizePixel = 0
                canvasBg.Parent = panel
                EZ_AddRadius(canvasBg, 6)
                EZ_AddStroke(canvasBg, EZ_Theme.Border, 1)
                EZ_Paint(function()
                    canvasBg.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                end, obj)

                local whiteGrad = Instance.new("Frame")
                whiteGrad.Size = UDim2.new(1, 0, 1, 0)
                whiteGrad.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                whiteGrad.BorderSizePixel = 0
                whiteGrad.Parent = canvasBg
                EZ_AddRadius(whiteGrad, 6)
                local wg = Instance.new("UIGradient")
                wg.Color = ColorSequence.new(Color3.new(1, 1, 1))
                wg.Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0),
                    NumberSequenceKeypoint.new(1, 1),
                })
                wg.Parent = whiteGrad

                local blackGrad = Instance.new("Frame")
                blackGrad.Size = UDim2.new(1, 0, 1, 0)
                blackGrad.BackgroundColor3 = Color3.new(0, 0, 0)
                blackGrad.BorderSizePixel = 0
                blackGrad.Parent = canvasBg
                EZ_AddRadius(blackGrad, 6)
                local bg2 = Instance.new("UIGradient")
                bg2.Rotation = 90
                bg2.Color = ColorSequence.new(Color3.new(0, 0, 0))
                bg2.Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 1),
                    NumberSequenceKeypoint.new(1, 0),
                })
                bg2.Parent = blackGrad

                local svCursor = Instance.new("Frame")
                svCursor.AnchorPoint = Vector2.new(0.5, 0.5)
                svCursor.Position = UDim2.new(s, 0, 1 - v, 0)
                svCursor.Size = UDim2.fromOffset(12, 12)
                svCursor.BackgroundColor3 = Color3.new(1, 1, 1)
                svCursor.BorderSizePixel = 0
                svCursor.ZIndex = 5
                svCursor.Parent = canvasBg
                EZ_AddRadius(svCursor, 6)
                EZ_AddStroke(svCursor, Color3.new(0, 0, 0), 2)

                local hueBar = Instance.new("Frame")
                hueBar.Position = UDim2.new(1, -40, 0, 12)
                hueBar.Size = UDim2.fromOffset(20, 120)
                hueBar.BackgroundColor3 = Color3.new(1, 1, 1)
                hueBar.BorderSizePixel = 0
                hueBar.Parent = panel
                EZ_AddRadius(hueBar, 6)
                EZ_AddStroke(hueBar, EZ_Theme.Border, 1)

                local hueGrad = Instance.new("UIGradient")
                hueGrad.Rotation = 90
                hueGrad.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 0)),
                    ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
                    ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
                    ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0, 255, 255)),
                    ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
                    ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
                    ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 0)),
                })
                hueGrad.Parent = hueBar

                local hueCursor = Instance.new("Frame")
                hueCursor.AnchorPoint = Vector2.new(0.5, 0.5)
                hueCursor.Position = UDim2.new(0.5, 0, h, 0)
                hueCursor.Size = UDim2.new(1, 4, 0, 4)
                hueCursor.BackgroundColor3 = Color3.new(1, 1, 1)
                hueCursor.BorderSizePixel = 0
                hueCursor.ZIndex = 5
                hueCursor.Parent = hueBar
                EZ_AddRadius(hueCursor, 2)
                EZ_AddStroke(hueCursor, Color3.new(0, 0, 0), 2)

                local bottomRow = Instance.new("Frame")
                bottomRow.Position = UDim2.fromOffset(12, 144)
                bottomRow.Size = UDim2.new(1, -24, 0, 28)
                bottomRow.BackgroundTransparency = 1
                bottomRow.Parent = panel

                local preview = Instance.new("Frame")
                preview.Size = UDim2.new(0, 28, 1, 0)
                preview.BackgroundColor3 = def
                preview.BorderSizePixel = 0
                preview.Parent = bottomRow
                EZ_AddRadius(preview, 6)
                EZ_AddStroke(preview, EZ_Theme.Border, 1)

                local hexBox = Instance.new("TextBox")
                hexBox.Position = UDim2.fromOffset(36, 0)
                hexBox.Size = UDim2.new(1, -36, 1, 0)
                hexBox.BackgroundColor3 = EZ_Theme.Card
                hexBox.BorderSizePixel = 0
                hexBox.Text = string.format("#%02X%02X%02X",
                    math.floor(def.R * 255 + 0.5),
                    math.floor(def.G * 255 + 0.5),
                    math.floor(def.B * 255 + 0.5))
                hexBox.Font = EZ_Brand.FontMono
                hexBox.TextSize = 13
                hexBox.TextColor3 = EZ_Theme.Text
                hexBox.TextXAlignment = Enum.TextXAlignment.Center
                hexBox.ClearTextOnFocus = false
                hexBox.Parent = bottomRow
                EZ_AddRadius(hexBox, 6)
                EZ_AddStroke(hexBox, EZ_Theme.Border, 1)
                EZ_Paint(function()
                    hexBox.BackgroundColor3 = EZ_Theme.Card
                    hexBox.TextColor3 = EZ_Theme.Text
                end, obj)

                local updateScheduled = false
                local colorGeneration = 0
                local function refreshUI()
                    local col = Color3.fromHSV(h, s, v)
                    obj.Value = col
                    swatch.BackgroundColor3 = col
                    preview.BackgroundColor3 = col
                    canvasBg.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                    svCursor.Position = UDim2.new(s, 0, 1 - v, 0)
                    hueCursor.Position = UDim2.new(0.5, 0, h, 0)
                    if not hexBox:IsFocused() then
                        hexBox.Text = string.format("#%02X%02X%02X",
                            math.floor(col.R * 255 + 0.5),
                            math.floor(col.G * 255 + 0.5),
                            math.floor(col.B * 255 + 0.5))
                    end
                end

                local function fire()
                    if updateScheduled then return end
                    updateScheduled = true
                    local generation = colorGeneration
                    task.delay(0.06, function()
                        if EZ_Destroyed or not row.Parent or generation ~= colorGeneration then return end
                        updateScheduled = false
                        local col = obj.Value
                        EZ_SafeCall(cb, col)
                        if obj.Flag and EZ_Window.AutoSave then
                            EZ_Window.ConfigData[id] = {
                                type = "color",
                                value = {
                                    math.floor(col.R * 255 + 0.5),
                                    math.floor(col.G * 255 + 0.5),
                                    math.floor(col.B * 255 + 0.5),
                                }
                            }
                            EZ_Window:_ScheduleSave(EZ_Window.CurrentConfig)
                        end
                    end)
                end

                local function svFromPtr(x, y)
                    local ap = canvasBg.AbsolutePosition
                    local sz = canvasBg.AbsoluteSize
                    s = math.clamp((x - ap.X) / sz.X, 0, 1)
                    v = 1 - math.clamp((y - ap.Y) / sz.Y, 0, 1)
                    refreshUI()
                    fire()
                end

                local function hueFromPtr(y)
                    local ap = hueBar.AbsolutePosition
                    local sz = hueBar.AbsoluteSize
                    h = math.clamp((y - ap.Y) / sz.Y, 0, 1)
                    refreshUI()
                    fire()
                end

                local svCap = Instance.new("TextButton")
                svCap.BackgroundTransparency = 1
                svCap.Size = UDim2.new(1, 0, 1, 0)
                svCap.Text = ""
                svCap.AutoButtonColor = false
                svCap.ZIndex = 4
                svCap.Parent = canvasBg

                svCap.InputBegan:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                        svFromPtr(i.Position.X, i.Position.Y)
                        EZ_StartPointer(i, function(event) svFromPtr(event.Position.X, event.Position.Y) end)
                    end
                end)

                local hueCap = Instance.new("TextButton")
                hueCap.BackgroundTransparency = 1
                hueCap.Size = UDim2.new(1, 0, 1, 0)
                hueCap.Text = ""
                hueCap.AutoButtonColor = false
                hueCap.ZIndex = 4
                hueCap.Parent = hueBar

                hueCap.InputBegan:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                        hueFromPtr(i.Position.Y)
                        EZ_StartPointer(i, function(event) hueFromPtr(event.Position.Y) end)
                    end
                end)

                hexBox.FocusLost:Connect(function(enter)
                    if not enter then return end
                    local hex = hexBox.Text:match("^#?(%x%x%x%x%x%x)$")
                    if hex then
                        local r = tonumber(hex:sub(1, 2), 16)
                        local g = tonumber(hex:sub(3, 4), 16)
                        local bl = tonumber(hex:sub(5, 6), 16)
                        local col = Color3.fromRGB(r, g, bl)
                        h, s, v = col:ToHSV()
                        refreshUI()
                        fire()
                    else
                        refreshUI()
                    end
                end)

                local function setOpen(state)
                    if state then
                        TweenService:Create(row, EZ_Ease.Med, {
                            Size = UDim2.new(1, 0, 0, ROW_H + BODY_H)
                        }):Play()
                        TweenService:Create(panel, EZ_Ease.Med, {
                            Size = UDim2.new(1, -2, 0, BODY_H)
                        }):Play()
                        if chev then
                            TweenService:Create(chev, EZ_Ease.Med, { Rotation = 180 }):Play()
                        end
                    else
                        TweenService:Create(row, EZ_Ease.Med, {
                            Size = UDim2.new(1, 0, 0, ROW_H)
                        }):Play()
                        TweenService:Create(panel, EZ_Ease.Med, {
                            Size = UDim2.new(1, -2, 0, 0)
                        }):Play()
                        if chev then
                            TweenService:Create(chev, EZ_Ease.Med, { Rotation = 0 }):Play()
                        end
                    end
                end

                header.Activated:Connect(function()
                    setOpen(row.Size.Y.Offset <= ROW_H)
                end)

                refreshUI()

                function obj:Set(color, silent)
                    colorGeneration = colorGeneration + 1
                    updateScheduled = false
                    color = color or Color3.new(1, 1, 1)
                    h, s, v = color:ToHSV()
                    refreshUI()
                    if not silent then
                        if EZ_Window._applying then EZ_SafeCall(cb, obj.Value) else fire() end
                    end
                end
                function obj:Get()
                    return obj.Value
                end

                EZ_Window:_RegisterElement(obj)
                obj._row = row
                return obj
            end

            function tab:AddKeybind(a, b)
                local page = elementParent
                local o = EZ_Normalize(a, b)
                EZ_ValidateFlag(o.Flag)
                local onTriggered = o.OnTriggered or o.Callback or function() end
                local onChanged = o.OnChanged or function() end
                local id = o.Flag or o.Id or o.Title or "keybind_" .. os.clock()
                local defaultKey = o.Default or Enum.KeyCode.RightShift
                local defaultMods = type(o.DefaultMods) == "string" and o.DefaultMods or ""
                local obj = { Value = defaultKey, Id = id, Flag = o.Flag, Type = "keybind", Default = defaultKey, DefaultMods = defaultMods, Mods = defaultMods }
                local listening = false
                local row = EZ_NewRow(page, 46, obj)
                EZ_RowTitle(row, o.Title or "Keybind", o.Description, 46, 110, obj)
                local kl = Instance.new("TextButton")
                kl.Position = UDim2.new(1, -100, 0.5, -13)
                kl.Size = UDim2.fromOffset(86, 26)
                kl.BackgroundColor3 = EZ_Theme.Background
                kl.BorderSizePixel = 0
                kl.Text = obj.Value and (obj.Mods .. obj.Value.Name) or EZ_Locale.None
                kl.Font = EZ_Brand.FontBody
                kl.TextSize = 12
                kl.TextColor3 = EZ_Theme.Text
                kl.TextXAlignment = Enum.TextXAlignment.Center
                kl.TextTruncate = Enum.TextTruncate.AtEnd
                kl.AutoButtonColor = false
                kl.Parent = row
                local klst = EZ_AddStroke(kl, EZ_Theme.Border)
                EZ_AddRadius(kl, "Theme")
                EZ_RegTrans(kl)
                EZ_Paint(function()
                    kl.BackgroundColor3 = EZ_Theme.Background
                    kl.TextColor3 = EZ_Theme.Text
                    if not listening then
                        klst.Color = EZ_Theme.Border
                        if not obj.Value then kl.Text = EZ_Locale.None end
                    end
                end, obj)
                local function updateLayout(compact)
                    row.Size = UDim2.new(1, 0, 0, compact and 50 or 46)
                    kl.Size = UDim2.fromOffset(compact and 100 or 86, compact and 36 or 26)
                    kl.Position = UDim2.new(1, compact and -114 or -100, 0.5, compact and -18 or -13)
                end
                table.insert(EZ_Window._responsiveItems, updateLayout)
                updateLayout(EZ_Window._compact)
                local function isModifier(key)
                    return key == Enum.KeyCode.LeftControl or key == Enum.KeyCode.RightControl or
                        key == Enum.KeyCode.LeftShift or key == Enum.KeyCode.RightShift or
                        key == Enum.KeyCode.LeftAlt or key == Enum.KeyCode.RightAlt
                end
                local function cancelCapture()
                    listening = false
                    if EZ_CapturingKeybind == obj then EZ_CapturingKeybind = nil end
                    kl.Text = obj.Value and (obj.Mods .. obj.Value.Name) or EZ_Locale.None
                    klst.Color = EZ_Theme.Border
                end
                obj._cancelCapture = cancelCapture
                function obj:Set(key, silent, modifiers)
                    if type(modifiers) == "string" then obj.Mods = modifiers end
                    obj.Value = key
                    kl.Text = key and (obj.Mods .. key.Name) or EZ_Locale.None
                    if not silent then
                        EZ_SafeCall(onChanged, key, obj.Mods)
                        if obj.Flag and EZ_Window.AutoSave then
                            EZ_Window.ConfigData[id] = { type = "keybind", value = key and key.Name or nil, mods = obj.Mods }
                            EZ_Window:_ScheduleSave(EZ_Window.CurrentConfig)
                        end
                    end
                end
                EZ_RegisterKeybind(function(input, processed)
                    if EZ_LastCaptureInput == input then return end
                    if listening then
                        if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
                        if input.KeyCode == Enum.KeyCode.Escape then
                            EZ_LastCaptureInput = input
                            task.defer(function() if EZ_LastCaptureInput == input then EZ_LastCaptureInput = nil end end)
                            cancelCapture()
                        elseif not isModifier(input.KeyCode) and input.KeyCode ~= Enum.KeyCode.Unknown then
                            EZ_LastCaptureInput = input
                            task.defer(function() if EZ_LastCaptureInput == input then EZ_LastCaptureInput = nil end end)
                            local mods = EZ_CurrentModifiers(input.KeyCode)
                            cancelCapture()
                            obj:Set(input.KeyCode, false, mods)
                        end
                        return
                    end
                    if EZ_CapturingKeybind or processed then return end
                    if obj.Value and input.KeyCode == obj.Value and not UserInputService:GetFocusedTextBox() and EZ_CurrentModifiers(input.KeyCode) == obj.Mods then
                        EZ_SafeCall(onTriggered, obj.Value, obj.Mods)
                    end
                end)
                kl.MouseEnter:Connect(function() if not listening then klst.Color = EZ_Theme.BorderHover end end)
                kl.MouseLeave:Connect(function() if not listening then klst.Color = EZ_Theme.Border end end)
                kl.Activated:Connect(function()
                    if EZ_CapturingKeybind and EZ_CapturingKeybind._cancelCapture then EZ_CapturingKeybind._cancelCapture() end
                    EZ_CapturingKeybind = obj
                    listening = true
                    kl.Text = "..."
                    klst.Color = EZ_Theme.Accent
                end)
                EZ_Window:_RegisterElement(obj)
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
            if self._transparencySlider then self._transparencySlider:Set(EZ_GlobalTransparency * 100, true) end
        end

        function EZ_Window:SetMinimizeKey(key, modifiers)
            EZ_MinKey = key
            EZ_MinMods = type(modifiers) == "string" and modifiers or ""
            if self._minimizeKeyBind then self._minimizeKeyBind:Set(key, true, EZ_MinMods) end
        end

        function EZ_Window:_BuildConfigData()
            local data = EZ_Copy(self.ConfigData or {})
            data._meta = { theme = EZ_CurrentThemeName, language = EZ_CurrentLanguage, transparency = EZ_GlobalTransparency, autoSave = self.AutoSave, minimizeMode = self.MinimizeMode, sidebarCollapsed = not self._sidebarOpen }
            if self.Frame then
                data._meta.windowSize = { math.floor(self.Frame.Size.X.Offset), math.floor(self.Frame.Size.Y.Offset) }
            end
            for _, el in ipairs(self.Elements) do
                if el.Type == "color" then
                    data[el.Id] = { type = "color", value = { math.floor(el.Value.R * 255 + 0.5), math.floor(el.Value.G * 255 + 0.5), math.floor(el.Value.B * 255 + 0.5) } }
                elseif el.Type == "keybind" then
                    data[el.Id] = { type = "keybind", value = el.Value and el.Value.Name or nil, mods = el.Mods }
                elseif el.Type == "multi" then
                    data[el.Id] = { type = "multi", value = EZ_Copy(el.Value) }
                elseif el.Type == "range" then
                    data[el.Id] = { type = "range", value = { el.MinValue, el.MaxValue } }
                else
                    data[el.Id] = { type = el.Type, value = el.Value }
                end
            end
            return data
        end

        function EZ_Window:_CancelPendingSave(name)
            local pending = self._pendingSaves[name]
            if pending and pending.timer then pcall(task.cancel, pending.timer) end
            self._pendingSaves[name] = nil
        end

        function EZ_Window:_ScheduleSave(configName)
            if self._applying or EZ_Destroyed or not self.AutoSave then return false end
            configName = configName or self.CurrentConfig
            if not EZ_ValidConfigName(configName) then return false, "Invalid config name" end
            self:_CancelPendingSave(configName)
            local pending = { data = self:_BuildConfigData() }
            self._pendingSaves[configName] = pending
            pending.timer = task.delay(1, function()
                if EZ_Destroyed or self._pendingSaves[configName] ~= pending then return end
                local ok, err = EZ_SaveConfig(EZ_ConfigId, configName, pending.data)
                pending.timer = nil
                if ok and self._pendingSaves[configName] == pending then
                    self._pendingSaves[configName] = nil
                elseif not ok then
                    warn("[Eazy UI] Auto-save failed; pending snapshot retained: " .. tostring(err))
                end
            end)
            return true
        end

        function EZ_Window:FlushSaves()
            if EZ_Destroyed then return false, "Window was destroyed" end
            local names = {}
            for name in pairs(self._pendingSaves) do table.insert(names, name) end
            for _, name in ipairs(names) do
                local pending = self._pendingSaves[name]
                if pending then
                    local ok, err = EZ_SaveConfig(EZ_ConfigId, name, pending.data)
                    if not ok then return false, err end
                    if self._pendingSaves[name] == pending then self:_CancelPendingSave(name) end
                end
            end
            return true
        end

        function EZ_Window:SaveConfig(configName)
            if self._applying or EZ_Destroyed then return false, "Window is applying a config or destroyed" end
            configName = configName or self.CurrentConfig
            if not EZ_ValidConfigName(configName) then return false, "Invalid config name" end
            local data = self:_BuildConfigData()
            local previousPending = self._pendingSaves[configName]
            local ok, err = EZ_SaveConfig(EZ_ConfigId, configName, data)
            if not ok then return false, err end
            if self._pendingSaves[configName] == previousPending then self:_CancelPendingSave(configName) end
            self.ConfigData = data
            self.CurrentConfig = configName
            if self._configDropdown then self._configDropdown:SetValues(EZ_ListConfigs(EZ_ConfigId)) end
            EZ_SyncConfigDropdown(configName)
            return true
        end

        function EZ_Window:LoadConfig(configName)
            if EZ_Destroyed then return false, "Window was destroyed" end
            configName = configName or self.CurrentConfig
            local flushed, flushErr = self:FlushSaves()
            if not flushed then return false, flushErr end
            local data, err = EZ_LoadConfig(EZ_ConfigId, configName)
            if not data then return false, err end
            self.CurrentConfig = configName
            self.ConfigData = EZ_Copy(data)
            self._hasLoadedConfig = true
            self._applying = true
            local ok, result = pcall(EZ_ApplyConfigData, self.ConfigData, false)
            self._applying = false
            if not ok then return false, tostring(result) end
            EZ_SyncConfigDropdown(configName)
            return result
        end

        function EZ_Window:ResetConfig(configName)
            if EZ_Destroyed then return false, "Window was destroyed" end
            configName = configName or self.CurrentConfig
            if not EZ_ValidConfigName(configName) then return false, "Invalid config name" end
            self:_CancelPendingSave(configName)
            self.ConfigData = {}
            self.CurrentConfig = configName
            self._applying = true
            for _, el in ipairs(self.Elements) do
                if el.Default ~= nil then
                    if el.Type == "keybind" then el.Mods = el.DefaultMods or "" end
                    local default = (el.Type == "multi" or el.Type == "range") and EZ_Copy(el.Default) or el.Default
                    local ok, err = pcall(el.Set, el, default, false)
                    if not ok then warn("[Eazy UI] Reset failed for " .. tostring(el.Id) .. ": " .. tostring(err)) end
                end
            end
            self._applying = false
            return self:SaveConfig(configName)
        end

        function EZ_Window:DeleteConfig(configName)
            if EZ_Destroyed then return false, "Window was destroyed" end
            configName = configName or self.CurrentConfig
            local ok, err = EZ_DeleteConfig(EZ_ConfigId, configName)
            if not ok then return false, err end
            self:_CancelPendingSave(configName)
            if self.CurrentConfig == configName then self.CurrentConfig = "default"; self.ConfigData = {} end
            if self._selectedConfig == configName then self._selectedConfig = nil end
            if self._configDropdown then self._configDropdown:SetValues(EZ_ListConfigs(EZ_ConfigId)); self._configDropdown:Set(nil, true) end
            if EZ_GetAutoloadName(EZ_ConfigId) == configName then
                local cleared, clearErr = EZ_SetAutoloadName(EZ_ConfigId, "default")
                if not cleared then return true, "Config deleted, but autoload could not be reset: " .. tostring(clearErr) end
            end
            return true
        end

        function EZ_Window:ListConfigs()
            if EZ_Destroyed then return {} end
            return EZ_ListConfigs(EZ_ConfigId)
        end

        function EZ_Window:BuildConfigSection(tab)
            if tab._ezConfigBuilt then return end
            tab._ezConfigBuilt = true
            local savedConfigsDropdown, themeDropdown, languageDropdown
            local function persistAppearance()
                if EZ_Window.AutoSave then EZ_Window:_ScheduleSave(EZ_Window.CurrentConfig) end
            end
            local function report(ok, successKey, err, argument)
                local args = ok and (argument ~= nil and { argument } or nil) or { tostring(err or "unknown error") }
                EZ:Notify({ Title = "Config", _ContentKey = ok and successKey or "ConfigFailed", _ContentArgs = args, _TranslateArg = not ok and 1 or nil, Style = ok and "Success" or "Error", Duration = 3 })
            end
            local function selected() return EZ_Window._selectedConfig or EZ_Window.CurrentConfig end
            local function localized(control, titleKey, descriptionKey, buttonKey)
                local function update()
                    if not control or not control._row or not control._row.Parent then return end
                    if control._isSection then
                        control:Set(EZ_Locale[titleKey])
                        EZ_SetSearchText(control._row, control._titleLabel.Text, "", EZ_DefaultLocale[titleKey], "")
                    else
                        if control._titleLabel then control._titleLabel.Text = EZ_Locale[titleKey] end
                        if control._descriptionLabel and descriptionKey then control._descriptionLabel.Text = EZ_Locale[descriptionKey] end
                        if control._buttonLabel and buttonKey then control._buttonLabel.Text = EZ_Locale[buttonKey] end
                        EZ_SetSearchText(control._row, EZ_Locale[titleKey], descriptionKey and EZ_Locale[descriptionKey] or "", EZ_DefaultLocale[titleKey], descriptionKey and EZ_DefaultLocale[descriptionKey] or "")
                    end
                end
                EZ_OnLocaleChange(update)
                update()
                return control
            end
            localized(tab:AddSection({ Title = EZ_Locale.Configuration }), "Configuration")
            EZ_Window._autoSaveToggle = localized(tab:AddToggle({
                Title = EZ_Locale.AutoSave, Description = EZ_Locale.AutoSaveDesc,
                Default = EZ_Window.AutoSave,
                Callback = function(value)
                    EZ_Window.AutoSave = value
                    if not EZ_Window._applying then
                        local ok, err = EZ_Window:SaveConfig(EZ_Window.CurrentConfig)
                        if not ok then report(false, "", err) end
                    end
                end,
            }), "AutoSave", "AutoSaveDesc")
            local configNameInput = localized(tab:AddInput({
                Title = EZ_Locale.ConfigName, Description = EZ_Locale.ConfigNameDesc,
                Placeholder = "default", Default = "",
            }), "ConfigName", "ConfigNameDesc")
            localized(tab:AddButton({
                Title = EZ_Locale.SaveConfig, Description = EZ_Locale.SaveConfigDesc, ButtonText = EZ_Locale.Save,
                Callback = function()
                    local name = configNameInput.Value ~= "" and configNameInput.Value or EZ_Window.CurrentConfig
                    local ok, err = EZ_Window:SaveConfig(name)
                    if ok then
                        if savedConfigsDropdown then savedConfigsDropdown:SetValues(EZ_Window:ListConfigs()) end
                        EZ_SyncConfigDropdown(name)
                        local autoloadOk, autoloadErr = EZ_SetAutoloadName(EZ_ConfigId, name)
                        if not autoloadOk then
                            EZ:Notify({ Title = "Config", _ContentKey = "ConfigSavedAutoloadFailed", _ContentArgs = { name, tostring(autoloadErr) }, _TranslateArg = 2, Style = "Warning", Duration = 4 })
                            return
                        end
                    end
                    report(ok, "ConfigSaved", err, name)
                end,
            }), "SaveConfig", "SaveConfigDesc", "Save")
            savedConfigsDropdown = localized(tab:AddDropdown({
                Title = EZ_Locale.SavedConfigs, Description = EZ_Locale.SavedConfigsDesc,
                Values = EZ_Window:ListConfigs(), Default = nil, TranslateValues = false,
                Callback = function(name) EZ_Window._selectedConfig = name end,
            }), "SavedConfigs", "SavedConfigsDesc")
            EZ_Window._configDropdown = savedConfigsDropdown
            if EZ_Window._pendingConfigSync then
                EZ_SyncConfigDropdown(EZ_Window._pendingConfigSync)
                EZ_Window._pendingConfigSync = nil
            end
            localized(tab:AddButton({
                Title = EZ_Locale.LoadConfig, Description = EZ_Locale.LoadConfigDesc, ButtonText = EZ_Locale.Load,
                Callback = function()
                    local name = selected()
                    local ok, err = EZ_Window:LoadConfig(name)
                    report(ok, "ConfigLoaded", err, name)
                end,
            }), "LoadConfig", "LoadConfigDesc", "Load")
            localized(tab:AddButton({
                Title = EZ_Locale.SetAutoload, Description = EZ_Locale.SetAutoloadDesc, ButtonText = EZ_Locale.Set,
                Callback = function()
                    local name = selected()
                    local data, loadErr = EZ_LoadConfig(EZ_ConfigId, name)
                    if not data then report(false, "", loadErr); return end
                    local ok, err = EZ_SetAutoloadName(EZ_ConfigId, name)
                    report(ok, "AutoloadSet", err, name)
                end,
            }), "SetAutoload", "SetAutoloadDesc", "Set")
            localized(tab:AddButton({
                Title = EZ_Locale.ClearAutoload, Description = EZ_Locale.ClearAutoloadDesc, ButtonText = EZ_Locale.Clear,
                Callback = function()
                    local ok, err = EZ_SetAutoloadName(EZ_ConfigId, "default")
                    report(ok, "AutoloadSet", err, "default")
                end,
            }), "ClearAutoload", "ClearAutoloadDesc", "Clear")
            localized(tab:AddButton({
                Title = EZ_Locale.DeleteConfig, Description = EZ_Locale.DeleteConfigDesc, ButtonText = EZ_Locale.Delete,
                Callback = function()
                    local name = selected()
                    local ok, err = EZ_Window:DeleteConfig(name)
                    if ok and err then
                        local prefix = "Config deleted, but autoload could not be reset: "
                        if err:sub(1, #prefix) == prefix then
                            EZ:Notify({ Title = "Config", _ContentKey = "ConfigDeletedAutoloadFailed", _ContentArgs = { err:sub(#prefix + 1) }, _TranslateArg = 1, Style = "Warning", Duration = 4 })
                        else
                            EZ:Notify({ Title = "Config", Content = err, Style = "Warning", Duration = 4 })
                        end
                    else
                        report(ok, "ConfigDeleted", err, name)
                    end
                end,
            }), "DeleteConfig", "DeleteConfigDesc", "Delete")
            localized(tab:AddButton({
                Title = EZ_Locale.ResetDefaults, Description = EZ_Locale.ResetDefaultsDesc, ButtonText = EZ_Locale.Reset,
                Callback = function()
                    local ok, err = EZ_Window:ResetConfig(EZ_Window.CurrentConfig)
                    report(ok, "ConfigReset", err)
                end,
            }), "ResetDefaults", "ResetDefaultsDesc", "Reset")
            localized(tab:AddSection({ Title = EZ_Locale.Appearance }), "Appearance")
            EZ_Window._minimizeKeyBind = localized(tab:AddKeybind({
                Title = EZ_Locale.MinimizeKey, Description = EZ_Locale.MinimizeKeyDesc,
                Flag = "_minimize_key", Default = EZ_MinKey,
                OnChanged = function(key, modifiers)
                    if key then
                        EZ_MinKey = key
                        EZ_MinMods = modifiers or ""
                        persistAppearance()
                        if not EZ_Window._applying then EZ:Notify({ _TitleKey = "MinimizeKey", _ContentKey = "KeyChanged", _ContentArgs = { key.Name }, Style = "Success", Duration = 2 }) end
                    end
                end,
            }), "MinimizeKey", "MinimizeKeyDesc")
            EZ_Window._minimizeModeDropdown = localized(tab:AddDropdown({
                Title = EZ_Locale.MinimizeMode, Description = EZ_Locale.MinimizeModeDesc,
                Values = { "Fade", "Shrink" }, Default = EZ_Window.MinimizeMode == "shrink" and "Shrink" or "Fade",
                Callback = function(mode) EZ_Window:SetMinimizeMode(mode:lower()); persistAppearance() end,
            }), "MinimizeMode", "MinimizeModeDesc")
            EZ_Window._transparencySlider = localized(tab:AddSlider({
                Title = EZ_Locale.Transparency, Description = EZ_Locale.TransparencyDesc,
                Min = 0, Max = 90, Default = math.floor(EZ_GlobalTransparency * 100), Step = 5,
                Callback = function(v) EZ_Window:SetTransparency(v / 100); persistAppearance() end,
            }), "Transparency", "TransparencyDesc")
            themeDropdown = localized(tab:AddDropdown({
                Title = EZ_Locale.Theme, Description = EZ_Locale.ThemeDesc,
                Values = EZ:ListThemes(), Default = EZ_CurrentThemeName,
                Callback = function(theme)
                    EZ:SetTheme(theme)
                    persistAppearance()
                    EZ:Notify({ _TitleKey = "Theme", _ContentKey = "ThemeChanged", _ContentArgs = { theme }, Style = "Success", Duration = 2 })
                end,
            }), "Theme", "ThemeDesc")
            EZ_OnThemeChange(function(name)
                if themeDropdown and themeDropdown.Value ~= name then themeDropdown:Set(name, true) end
            end)
            table.insert(EZ_ThemeListListeners, function(names)
                if themeDropdown and themeDropdown._row and themeDropdown._row.Parent then themeDropdown:SetValues(names) end
            end)
            EZ_Window._themeDropdown = themeDropdown
            languageDropdown = localized(tab:AddDropdown({
                Title = EZ_Locale.Language, Description = EZ_Locale.LanguageDesc,
                Values = { "English", "Português (Brasil)", "Español" }, Default = EZ_LanguageNames[EZ_CurrentLanguage],
                Callback = function(name)
                    local code = EZ_LanguageCodes[name]
                    if code and EZ:SetLanguage(code) then persistAppearance() end
                end,
            }), "Language", "LanguageDesc")
            EZ_OnLocaleChange(function()
                if languageDropdown and languageDropdown.Value ~= EZ_LanguageNames[EZ_CurrentLanguage] then
                    languageDropdown:Set(EZ_LanguageNames[EZ_CurrentLanguage], true)
                end
            end)
            EZ_Window._languageDropdown = languageDropdown
        end

        EZ_Window.Frame = frame
        EZ_Window.Titlebar = titlebar
        EZ_Window.Sidebar = sidebar
        EZ_Window.Content = content
        function EZ_Window:SetMinimized(state) setMinimized(state == true) end

        function EZ_Window:LoadAutoConfig()
            if EZ_Destroyed then return false, "Window was destroyed" end
            if not EZ_AutoLoad then return false, "AutoLoad is disabled" end
            if self._autoLoaded then return false, "AutoLoad already attempted" end
            self._autoLoaded = true
            local name = EZ_GetAutoloadName(EZ_ConfigId) or "default"
            local saved, err = EZ_LoadConfig(EZ_ConfigId, name)
            if not saved then return false, err end
            self.ConfigData = EZ_Copy(saved)
            self.CurrentConfig = name
            self._hasLoadedConfig = true
            self._applying = true
            local ok, result = pcall(EZ_ApplyConfigData, self.ConfigData, true)
            self._applying = false
            if not ok then return false, tostring(result) end
            EZ_SyncConfigDropdown(name)
            EZ_Repaint()
            EZ_ApplyTransparency(EZ_GlobalTransparency)
            return result
        end

        if EZ_AutoLoad then EZ_Window:LoadAutoConfig() end

        return EZ_Window
    end

    return EZ_BuildWindow()
end

function EZ:Destroy()
    if EZ_Destroyed or EZ_Destroying then return end
    EZ_Destroying = true

    local focused = UserInputService:GetFocusedTextBox()
    if focused then
        for _, window in ipairs(EZ_Windows) do
            for _, element in ipairs(window.Elements) do
                if element._box == focused then
                    local ok, err = pcall(element.Set, element, focused.Text, false)
                    if not ok then warn("[Eazy UI] Could not commit focused text: " .. tostring(err)) end
                end
            end
        end
    end
    for _, window in ipairs(EZ_Windows) do
        if window.FlushSaves then
            local ok, err = window:FlushSaves()
            if not ok then warn("[Eazy UI] Could not flush pending saves: " .. tostring(err)) end
        end
        for name in pairs(window._pendingSaves or {}) do window:_CancelPendingSave(name) end
    end
    EZ_CloseDropdown()
    EZ_Destroyed = true
    EZ_CapturingKeybind = nil
    EZ_HoveredSlider = nil
    EZ_LastCaptureInput = nil
    EZ_Pointer.input, EZ_Pointer.move, EZ_Pointer.finish = nil, nil, nil
    table.clear(EZ_KeybindHandlers)
    EZ_LogoRequest = EZ_LogoRequest + 1
    EZ_LogoLoading = false
    table.clear(EZ_LogoWatchers)
    for connection in pairs(EZ_ServiceConnections) do
        if connection.Connected then connection:Disconnect() end
    end
    table.clear(EZ_ServiceConnections)
    table.clear(EZ_NotifyQueue)
    local visible = table.clone(EZ_NotifyVisible)
    for _, entry in ipairs(visible) do if entry.destroy then entry.destroy("Destroy") end end
    table.clear(EZ_NotifyVisible)
    table.clear(EZ_Windows)
    local transient = {}
    for gui in pairs(EZ_TransientGuis) do table.insert(transient, gui) end
    for _, gui in ipairs(transient) do EZ_CloseTransientGui(gui) end
    table.clear(EZ_TransientGuis)
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
    for conn in pairs(EZ_ScaleConns) do
        if conn.Connected then conn:Disconnect() end
    end
    table.clear(EZ_ScaleConns)
    table.clear(EZ_ThemeListeners)
    table.clear(EZ_ThemeListListeners)
    table.clear(EZ_LocaleListeners)
    for owner in pairs(EZ_TextBindingsByOwner) do EZ_ClearTextBindings(owner) end
    table.clear(EZ_TextBindings)
    table.clear(EZ_TextBindingsByOwner)
    table.clear(EZ_TextOwnerConnections)
    table.clear(EZ_SearchParents)
    table.clear(EZ_SearchRefresh)
    EZ_PreviousInstance = nil
    if EZ_InstanceRegistry then
        for i = #EZ_InstanceRegistry, 1, -1 do if EZ_InstanceRegistry[i] == EZ then table.remove(EZ_InstanceRegistry, i) end end
    end
    if EZ_Environment and EZ_Environment.EazyUI == EZ then
        EZ_Environment.EazyUI = EZ_InstanceRegistry and EZ_InstanceRegistry[#EZ_InstanceRegistry] or nil
    end
    EZ_CurrentWindow = nil
end

function EZ:Logout()
    if EZ_CurrentWindow then
        local configId = EZ_CurrentWindow.ConfigId or tostring(game.PlaceId)
        EZ_ClearKey(EZ_KeyFilePath(configId))
    end
    EZ:Notify({ Title = "Eazy UI", _ContentKey = "LogoutMessage", Style = "Info", Duration = 3 })
end

if EZ_Environment then
    table.insert(EZ_InstanceRegistry, EZ)
    EZ_Environment.EazyUI = EZ
end

return EZ