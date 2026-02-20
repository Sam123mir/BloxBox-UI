-- [[ BLOXBOX UI: UNIVERSAL BOOTSTRAPPER ]]
-- Este script descarga la estructura modular completa desde GitHub y la prepara para su uso.

local function LoadBloxBox()
    local GITHUB_USER = "Sam123mir"
    local GITHUB_REPO = "BloxBox-UI"
    local GITHUB_BRANCH = "master"
    local BASE_URL = string.format("https://raw.githubusercontent.com/%s/%s/%s/UIFramework/", GITHUB_USER, GITHUB_REPO, GITHUB_BRANCH)

    local function HttpGet(url)
        return game:HttpGet(url .. "?v=" .. os.time()) -- Bypass cache
    end

    local function CreateModule(name, parent, source)
        local m = Instance.new("ModuleScript")
        m.Name = name
        m.Source = source
        m.Parent = parent
        return m
    end

    local function CreateFolder(name, parent)
        local f = Instance.new("Folder")
        f.Name = name
        f.Parent = parent
        return f
    end

    print("[BloxBox] Descargando componentes núcleo (.luau)...")

    local OldRoot = game:GetService("ReplicatedStorage"):FindFirstChild("BloxBoxUI")
    if OldRoot then OldRoot:Destroy() end

    local Root = Instance.new("ModuleScript")
    Root.Name = "BloxBoxUI"
    Root.Source = HttpGet(BASE_URL .. "init.luau")
    Root.Parent = game:GetService("ReplicatedStorage")
    
    local Folders = {
        Core = CreateFolder("Core", Root),
        Components = CreateFolder("Components", Root),
        Utils = CreateFolder("Utils", Root),
        Types = CreateFolder("Types", Root)
    }

    local Files = {
        ["Core/AnimationEngine.luau"] = "Core",
        ["Core/ComponentRegistry.luau"] = "Core",
        ["Core/ConfigManager.luau"] = "Core",
        ["Core/IntroManager.luau"] = "Core",
        ["Core/NotificationManager.luau"] = "Core",
        ["Core/StateManager.luau"] = "Core",
        ["Core/ThemeManager.luau"] = "Core",
        ["Core/WindowManager.luau"] = "Core",
        
        ["Components/BaseComponent.luau"] = "Components",
        ["Components/Button.luau"] = "Components",
        ["Components/Dropdown.luau"] = "Components",
        ["Components/Keybind.luau"] = "Components",
        ["Components/Label.luau"] = "Components",
        ["Components/Section.luau"] = "Components",
        ["Components/Slider.luau"] = "Components",
        ["Components/Tab.luau"] = "Components",
        ["Components/TextBox.luau"] = "Components",
        ["Components/Toggle.luau"] = "Components",
        ["Components/Window.luau"] = "Components",
        
        ["Utils/DragSystem.luau"] = "Utils",
        ["Utils/Maid.luau"] = "Utils",
        ["Utils/Signal.luau"] = "Utils",
        
        ["Types/ComponentTypes.luau"] = "Types",
        ["Types/ThemeTypes.luau"] = "Types"
    }

    for path, folderKey in pairs(Files) do
        local source = HttpGet(BASE_URL .. path)
        local name = path:match("([^/]+)%.luau$")
        CreateModule(name, Folders[folderKey], source)
    end

    task.wait(0.3)
    
    local success, result = pcall(function()
        return require(Root)
    end)
    
    if success then
        print("[BloxBox] Framework cargado con éxito v1.02.0 (Luau Edition)")
        return result
    else
        warn("[BloxBox Error] Fallo al cargar el módulo raíz: " .. tostring(result))
        error(result)
    end
end

return LoadBloxBox()
