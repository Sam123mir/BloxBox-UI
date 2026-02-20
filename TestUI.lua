-- [[ BLOXBOX UI: TEST SCRIPT v1.02.0 ]]
-- Script de demostración del framework

-- Cargar el framework
local BloxBoxUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Sam123mir/BloxBox-UI/master/Source.lua" .. "?v=" .. os.time()))()

-- Crear instancia
local Library = BloxBoxUI.new()

-- Personalizar color de acento (opcional)
Library:SetAccent(Color3.fromRGB(0, 170, 255))

-- Mostrar intro con animación
Library:ShowIntro()
task.wait(3.5) -- Esperar que termine la intro

-- Crear ventana principal
local Window = Library:CreateWindow({
    Title = "BloxBox UI | Demo v1.02.0",
    Size = UDim2.fromOffset(600, 400),
})

-- TAB 1: General
local MainTab = Window:CreateTab("Principal")
MainTab:CreateSection("Opciones")

MainTab:CreateToggle({
    Name = "Activar Feature",
    Flag = "feature_enabled",
    Default = false,
    Callback = function(val)
        Library:Notify({
            Title = "Toggle",
            Content = "Feature: " .. (val and "ON" or "OFF"),
            Type = val and "Success" or "Info",
        })
    end,
})

MainTab:CreateSlider({
    Name = "Velocidad",
    Min = 16,
    Max = 100,
    Default = 16,
    Flag = "speed_value",
    Callback = function(val)
        local humanoid = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
        if humanoid then humanoid.WalkSpeed = val end
    end,
})

MainTab:CreateButton({
    Name = "Saludar",
    Callback = function()
        Library:Notify({
            Title = "BloxBox",
            Content = "¡Hola! El framework está funcionando correctamente 🎉",
            Type = "Success",
        })
    end,
})

MainTab:CreateSection("Más Opciones")

MainTab:CreateDropdown({
    Name = "Seleccionar Modo",
    List = {"Normal", "Turbo", "God Mode"},
    Default = "Normal",
    Flag = "game_mode",
    Callback = function(val)
        Library:Notify({
            Title = "Modo",
            Content = "Cambiado a: " .. val,
            Type = "Info",
        })
    end,
})

MainTab:CreateTextBox({
    Name = "Nombre personalizado",
    Default = "",
    Placeholder = "Escribe tu nombre...",
    Flag = "custom_name",
    Callback = function(text)
        print("[BloxBox] Nombre: " .. text)
    end,
})

-- TAB 2: Configuración
local ConfigTab = Window:CreateTab("Config")

ConfigTab:CreateToggle({
    Name = "Anti-AFK",
    Flag = "anti_afk",
    Default = true,
    Callback = function(val)
        if val then
            Library:Notify({ Title = "Anti-AFK", Content = "Activado", Type = "Success" })
        end
    end,
})

ConfigTab:CreateKeybind({
    Name = "Toggle UI",
    Flag = "toggle_keybind",
    Default = Enum.KeyCode.RightControl,
    Callback = function(key)
        Library:Notify({
            Title = "Keybind",
            Content = "Cambiado a: " .. key.Name,
            Type = "Info",
        })
    end,
})

ConfigTab:CreateButton({
    Name = "Guardar Config",
    Callback = function()
        Library:SaveConfig("default")
        Library:Notify({ Title = "Config", Content = "Guardada exitosamente", Type = "Success" })
    end,
})

ConfigTab:CreateButton({
    Name = "Cargar Config",
    Callback = function()
        Library:LoadConfig("default")
        Library:Notify({ Title = "Config", Content = "Cargada exitosamente", Type = "Info" })
    end,
})

-- TAB 3: Info
local InfoTab = Window:CreateTab("Info")
InfoTab:CreateLabel("BloxBox UI Framework v1.02.0")
InfoTab:CreateLabel("by Samir & Team")
InfoTab:CreateLabel("github.com/Sam123mir/BloxBox-UI")
InfoTab:CreateSection("Créditos")
InfoTab:CreateLabel("Diseño: Premium Dark Theme")
InfoTab:CreateLabel("Componentes: 8 tipos")
InfoTab:CreateLabel("Arquitectura: Single-File")
