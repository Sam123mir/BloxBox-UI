-- [[ BLOXBOX UI: UNIVERSAL BOOTSTRAPPER ]]
-- Este script descarga la estructura modular completa desde GitHub y la prepara para su uso.

local function LoadBloxBox()
    local GITHUB_USER = "Sam123mir"
    local GITHUB_REPO = "BloxBox-UI"
    local GITHUB_BRANCH = "master"
    local BASE_URL = string.format("https://raw.githubusercontent.com/%s/%s/%s/UIFramework/", GITHUB_USER, GITHUB_REPO, GITHUB_BRANCH)

    local function HttpGet(url)
        return game:HttpGet(url)
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

    print("[BloxBox] Descargando componentes núcleo...")

    local Root = Instance.new("ModuleScript")
    Root.Name = "BloxBoxUI"
    Root.Source = HttpGet(BASE_URL .. "init.lua")
    Root.Parent = game:GetService("ReplicatedStorage")
    
    local Folders = {
        Core = CreateFolder("Core", Root),
        Components = CreateFolder("Components", Root),
        Utils = CreateFolder("Utils", Root),
        Types = CreateFolder("Types", Root)
    }

    local Files = {
        ["Core/AnimationEngine.lua"] = "Core",
        ["Core/ComponentRegistry.lua"] = "Core",
        ["Core/ConfigManager.lua"] = "Core",
        ["Core/IntroManager.lua"] = "Core",
        ["Core/NotificationManager.lua"] = "Core",
        ["Core/StateManager.lua"] = "Core",
        ["Core/ThemeManager.lua"] = "Core",
        ["Core/WindowManager.lua"] = "Core",
        
        ["Components/BaseComponent.lua"] = "Components",
        ["Components/Button.lua"] = "Components",
        ["Components/Dropdown.lua"] = "Components",
        ["Components/Keybind.lua"] = "Components",
        ["Components/Label.lua"] = "Components",
        ["Components/Section.lua"] = "Components",
        ["Components/Slider.lua"] = "Components",
        ["Components/Tab.lua"] = "Components",
        ["Components/TextBox.lua"] = "Components",
        ["Components/Toggle.lua"] = "Components",
        ["Components/Window.lua"] = "Components",
        
        ["Utils/DragSystem.lua"] = "Utils",
        ["Utils/Maid.lua"] = "Utils",
        ["Utils/Signal.lua"] = "Utils",
        
        ["Types/ComponentTypes.lua"] = "Types",
        ["Types/ThemeTypes.lua"] = "Types"
    }

    for path, folderKey in pairs(Files) do
        local source = HttpGet(BASE_URL .. path)
        local name = path:match("([^/]+)%.lua$")
        CreateModule(name, Folders[folderKey], source)
    end

    task.wait(0.2) -- Espera para asegurar sincronización en el executor
    
    if Root:IsA("ModuleScript") then
        print("[BloxBox] Carga completada con éxito v1.00.0")
        return require(Root)
    else
        error("[BloxBox Error] El objeto raíz no es un ModuleScript: " .. Root.ClassName)
    end
end

return LoadBloxBox()
