-- [[ BLOXBOX UI v1.00.0 - UNIVERSAL SHOWCASE SCRIPT ]]
-- Este script carga la librería remotamente y construye una interfaz completa con todos los componentes.

-- 1. Carga Remota (API de BloxBox)
local BloxBox = loadstring(game:HttpGet("https://raw.githubusercontent.com/Sam123mir/BloxBox-UI/master/Loader.lua"))()

-- 2. Configuración Inicial
local UI = BloxBox.new()
UI:SetAccent(Color3.fromRGB(0, 170, 255)) -- Color Azul SaaS

-- 3. Mostrar Pantalla de Carga Animada
UI:ShowIntro()

-- 4. Construcción de la Interfaz (Después de la Intro)
task.delay(4.5, function()
    local Window = UI:CreateWindow({
        Title = "BloxBox Dashboard - Showcase",
        Size = UDim2.fromOffset(600, 440)
    })

    -- Notificación de Inicio
    UI:Notify({
        Title = "Sistema",
        Content = "Mostrando capacidades Elite de BloxBox UI.",
        Duration = 5,
        Type = "Info"
    })

    -- Pestaña Principal (Widgets Interactivos)
    local WidgetTab = Window:CreateTab("Widgets")
    local ButtonSection = WidgetTab:CreateSection("Botones y Toggles")

    ButtonSection:CreateButton({
        Name = "Botón de Prueba",
        Callback = function()
            UI:Notify({
                Title = "Interacción",
                Content = "¡Has presionado el botón con micro-animación de escala!",
                Type = "Success"
            })
        end
    })

    ButtonSection:CreateToggle({
        Name = "Interruptor Premium",
        Flag = "ToggleTest",
        Default = true,
        Callback = function(v)
            print("Toggle:", v)
        end
    })

    local SliderSection = WidgetTab:CreateSection("Ajustes Numéricos")

    SliderSection:CreateSlider({
        Name = "Velocidad de Movimiento",
        Flag = "Speed",
        Min = 16,
        Max = 250,
        Default = 16,
        Callback = function(v)
            print("Velocidad:", v)
        end
    })

    -- Pestaña de Entradas (Inputs)
    local InputTab = Window:CreateTab("Entradas")

    InputTab:CreateDropdown({
        Name = "Región del Servidor",
        Flag = "Region",
        List = {"Norteamérica", "Europa", "Asia", "Sudamérica"},
        Callback = function(v)
            print("Región seleccionada:", v)
        end
    })

    InputTab:CreateTextBox({
        Name = "Mensaje Personalizado",
        Flag = "CustomMsg",
        Placeholder = "Escribe algo aquí...",
        Callback = function(text)
            print("Texto ingresado:", text)
        end
    })

    InputTab:CreateKeybind({
        Name = "Cerrar Panel",
        Flag = "CloseKey",
        Default = Enum.KeyCode.RightControl,
        Callback = function()
            Window:Destroy()
            UI:Notify({
                Title = "Sistema",
                Content = "Panel destruido por Keybind.",
                Type = "Warning"
            })
        end
    })

    -- Pestaña de Configuración (Estado)
    local ConfigTab = Window:CreateTab("Config")
    
    ConfigTab:CreateSection("Perfiles")
    
    ConfigTab:CreateButton({
        Name = "Guardar Configuración Actual",
        Callback = function()
            UI:SaveConfig("MiAjuste")
            UI:Notify({
                Title = "Sincronización",
                Content = "Configuración guardada en JSON localmente.",
                Type = "Success"
            })
        end
    })

    ConfigTab:CreateButton({
        Name = "Cargar Configuración Guardada",
        Callback = function()
            UI:LoadConfig("MiAjuste")
            UI:Notify({
                Title = "Sincronización",
                Content = "Configuración restaurada con éxito.",
                Type = "Info"
            })
        end
    })

    -- Pestaña de Información
    local InfoTab = Window:CreateTab("Acerca de")
    InfoTab:CreateLabel("BloxBox UI Framework")
    InfoTab:CreateLabel("Versión: 1.00.0")
    InfoTab:CreateLabel("Desarrollado por Samir & Team")
    InfoTab:CreateLabel("Estado: Elite & Modular")
end)
