-- [[ SCRIPT DE PRUEBA: BLOXBOX UI v1.00.0 ]]
--!strict

local UIFramework = script.Parent.UIFramework -- Ajustar ruta según ubicación
local Library = require(UIFramework)

-- 1. Inicialización de la Librería
local UI = Library.new()
UI:SetAccent(Color3.fromRGB(0, 170, 255))

-- 2. Ejecutar Pantalla de Carga (Intro Animada)
UI:ShowIntro()

-- 3. Cargar Interfaz Principal después de la Intro
task.delay(4.5, function()
    -- Crear Ventana
    local Window = UI:CreateWindow({
        Title = "BloxBox Panel - Dashboard",
        Size = UDim2.fromOffset(600, 440)
    })

    -- Notificación de Bienvenida
    UI:Notify({
        Title = "BloxBox Sistema",
        Content = "Librería cargada con éxito. Listo para operar.",
        Duration = 6,
        Type = "Success"
    })

    -- Pestaña Principal
    local MainTab = Window:CreateTab("Principal")
    
    local MainSection = MainTab:CreateSection("Ajustes de Servidor")
    
    MainSection:CreateButton({
        Name = "Reiniciar Instancia",
        Callback = function()
            UI:Notify({
                Title = "Acción Ejecutada",
                Content = "Reiniciando los servicios de BloxBox...",
                Type = "Warning"
            })
        end
    })

    MainSection:CreateToggle({
        Name = "Modo Dios (GodMode)",
        Flag = "GodMode",
        Default = true,
        Callback = function(v)
            print("GodMode:", v)
        end
    })

    MainSection:CreateSlider({
        Name = "Velocidad de Movimiento",
        Flag = "WalkSpeed",
        Min = 16,
        Max = 300,
        Default = 16,
        Callback = function(v)
            print("Velocidad:", v)
        end
    })

    -- Pestaña de Configuración
    local ConfigTab = Window:CreateTab("Avanzado")
    
    ConfigTab:CreateDropdown({
        Name = "Región de Servidor",
        Flag = "Region",
        List = {"USA - East", "Europe", "Asia", "Brazil"},
        Callback = function(v)
            print("Region cambiada a:", v)
        end
    })

    ConfigTab:CreateKeybind({
        Name = "Abrir Menú (Toggle)",
        Flag = "MenuKey",
        Default = Enum.KeyCode.Insert,
        Callback = function(key)
            print("Nueva tecla:", key.Name)
        end
    })

    ConfigTab:CreateTextBox({
        Name = "Motivo de Reporte",
        Flag = "ReportReason",
        Placeholder = "Escribe aquí la razón...",
        Callback = function(t)
            print("Reporte:", t)
        end
    })

    -- Pestaña de Créditos
    local InfoTab = Window:CreateTab("Créditos")
    InfoTab:CreateLabel("BloxBox UI Framework")
    InfoTab:CreateLabel("Versión: 1.00.0 (Elite Edition)")
    InfoTab:CreateLabel("By Samir & Team")
    
    InfoTab:CreateButton({
        Name = "Cerrar Panel",
        Callback = function()
            Window:Destroy()
            UI:Notify({
                Title = "Sistema",
                Content = "Panel cerrado correctamente.",
                Duration = 3
            })
        end
    })
end)
