-- [[ BLOXBOX UI: UNIVERSAL BOOTSTRAPPER v1.02.0 ]]
-- Carga la estructura modular completa desde GitHub con diagnósticos integrados

local function LoadBloxBox()
    local GITHUB_USER = "Sam123mir"
    local GITHUB_REPO = "BloxBox-UI"
    local GITHUB_BRANCH = "master"
    local BASE_URL = string.format("https://raw.githubusercontent.com/%s/%s/%s/UIFramework/", GITHUB_USER, GITHUB_REPO, GITHUB_BRANCH)

    local function HttpGet(url)
        return game:HttpGet(url .. "?v=" .. os.time())
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

    print("[BloxBox] Iniciando carga del framework...")

    -- Limpiar instancia anterior
    local OldRoot = game:GetService("ReplicatedStorage"):FindFirstChild("BloxBoxUI")
    if OldRoot then OldRoot:Destroy() end

    -- Crear estructura de carpetas
    local Root = Instance.new("ModuleScript")
    Root.Name = "BloxBoxUI"

    local Folders = {
        Core = CreateFolder("Core", Root),
        Components = CreateFolder("Components", Root),
        Utils = CreateFolder("Utils", Root),
        Types = CreateFolder("Types", Root)
    }

    -- Lista de archivos a descargar
    local Files = {
        {"Utils/Signal.luau", "Utils"},
        {"Utils/Maid.luau", "Utils"},
        {"Utils/DragSystem.luau", "Utils"},
        {"Types/ComponentTypes.luau", "Types"},
        {"Types/ThemeTypes.luau", "Types"},
        {"Core/AnimationEngine.luau", "Core"},
        {"Core/ComponentRegistry.luau", "Core"},
        {"Core/ThemeManager.luau", "Core"},
        {"Core/StateManager.luau", "Core"},
        {"Core/ConfigManager.luau", "Core"},
        {"Core/IntroManager.luau", "Core"},
        {"Core/NotificationManager.luau", "Core"},
        {"Core/WindowManager.luau", "Core"},
        {"Components/BaseComponent.luau", "Components"},
        {"Components/Button.luau", "Components"},
        {"Components/Dropdown.luau", "Components"},
        {"Components/Keybind.luau", "Components"},
        {"Components/Label.luau", "Components"},
        {"Components/Section.luau", "Components"},
        {"Components/Slider.luau", "Components"},
        {"Components/Tab.luau", "Components"},
        {"Components/TextBox.luau", "Components"},
        {"Components/Toggle.luau", "Components"},
        {"Components/Window.luau", "Components"},
    }

    -- Descargar y crear cada módulo
    local errors = {}
    for _, fileInfo in ipairs(Files) do
        local path = fileInfo[1]
        local folderKey = fileInfo[2]
        
        local ok, source = pcall(HttpGet, BASE_URL .. path)
        if not ok then
            warn("[BloxBox] ERROR descargando: " .. path .. " -> " .. tostring(source))
            table.insert(errors, path)
        else
            local name = path:match("([^/]+)%.luau$")
            -- Validar que el source es código Lua real (no un 404)
            if source and #source > 0 and not source:find("<!DOCTYPE") then
                CreateModule(name, Folders[folderKey], source)
            else
                warn("[BloxBox] ARCHIVO NO ENCONTRADO (404): " .. path)
                table.insert(errors, path)
            end
        end
    end

    if #errors > 0 then
        warn("[BloxBox] Hay " .. #errors .. " archivos con errores de descarga.")
        return nil
    end

    -- Descargar init.luau
    local initSource = HttpGet(BASE_URL .. "init.luau")
    if not initSource or initSource:find("<!DOCTYPE") then
        warn("[BloxBox] ERROR: init.luau no encontrado en GitHub")
        return nil
    end
    
    Root.Source = initSource
    Root.Parent = game:GetService("ReplicatedStorage")

    task.wait(0.1)

    -- Diagnóstico: probar cada módulo individualmente
    print("[BloxBox] Verificando módulos...")
    for _, child in ipairs(Root:GetDescendants()) do
        if child:IsA("ModuleScript") then
            local s, e = pcall(require, child)
            if not s then
                warn("[BloxBox] FALLO en módulo: " .. child:GetFullName() .. " -> " .. tostring(e))
            else
                print("[BloxBox] OK: " .. child.Name)
            end
        end
    end

    -- Cargar el framework
    local success, result = pcall(function()
        return require(Root)
    end)
    
    if success then
        print("[BloxBox] Framework v1.02.0 cargado con éxito!")
        return result
    else
        warn("[BloxBox Error] " .. tostring(result))
        error(result)
    end
end

return LoadBloxBox()
