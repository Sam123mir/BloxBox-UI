-- ╔══════════════════════════════════════════════════╗
-- ║    BLOXBOX UI v1.02.0 - PRUEBA COMPLETA         ║
-- ║    Copia y pega esto en tu executor              ║
-- ╚══════════════════════════════════════════════════╝

-- ▸ Paso 1: Cargar BloxBox UI desde GitHub
local BloxBox = loadstring(game:HttpGet("https://raw.githubusercontent.com/Sam123mir/BloxBox-UI/master/Loader.lua"))()

-- ▸ Paso 2: Crear la Librería
local UI = BloxBox.new()
UI:SetAccent(Color3.fromRGB(0, 170, 255))

-- ▸ Paso 3: Pantalla de Carga con Logo
UI:ShowIntro()

-- ▸ Paso 4: Construir la UI completa
task.delay(4, function()

    -- ═══════════════════════════════════════
    --  VENTANA PRINCIPAL
    -- ═══════════════════════════════════════
    local Window = UI:CreateWindow({
        Title = "BloxBox UI - Panel de Control",
        Size = UDim2.fromOffset(620, 460)
    })

    -- Notificación de bienvenida
    UI:Notify({
        Title = "🎉 Bienvenido",
        Content = "BloxBox UI v1.02.0 cargado correctamente.",
        Duration = 4,
        Type = "Success"
    })

    -- ═══════════════════════════════════════
    --  PESTAÑA 1: CONTROLES
    -- ═══════════════════════════════════════
    local TabControles = Window:CreateTab("Controles")

    -- Sección: Botones
    TabControles:CreateSection("Botones")

    TabControles:CreateButton({
        Name = "Botón Normal",
        Callback = function()
            UI:Notify({
                Title = "Botón",
                Content = "¡Botón presionado! Observa la animación de escala.",
                Type = "Info"
            })
        end
    })

    TabControles:CreateButton({
        Name = "Botón de Acción",
        Callback = function()
            UI:Notify({
                Title = "Acción",
                Content = "Acción ejecutada correctamente.",
                Type = "Success"
            })
        end
    })

    -- Sección: Toggles
    TabControles:CreateSection("Interruptores")

    TabControles:CreateToggle({
        Name = "Modo Oscuro",
        Flag = "DarkMode",
        Default = true,
        Callback = function(val)
            print("[BloxBox] Modo Oscuro:", val)
        end
    })

    TabControles:CreateToggle({
        Name = "Anti-AFK",
        Flag = "AntiAFK",
        Default = false,
        Callback = function(val)
            print("[BloxBox] Anti-AFK:", val)
            if val then
                UI:Notify({
                    Title = "Anti-AFK",
                    Content = "Sistema Anti-AFK activado.",
                    Type = "Success"
                })
            end
        end
    })

    TabControles:CreateToggle({
        Name = "ESP Jugadores",
        Flag = "ESP",
        Default = false,
        Callback = function(val)
            print("[BloxBox] ESP:", val)
        end
    })

    -- ═══════════════════════════════════════
    --  PESTAÑA 2: SLIDERS
    -- ═══════════════════════════════════════
    local TabSliders = Window:CreateTab("Ajustes")

    TabSliders:CreateSection("Movimiento")

    TabSliders:CreateSlider({
        Name = "Velocidad (WalkSpeed)",
        Flag = "Speed",
        Min = 16,
        Max = 200,
        Default = 16,
        Callback = function(val)
            local player = game.Players.LocalPlayer
            if player and player.Character then
                local hum = player.Character:FindFirstChildOfClass("Humanoid")
                if hum then hum.WalkSpeed = val end
            end
        end
    })

    TabSliders:CreateSlider({
        Name = "Altura de Salto",
        Flag = "JumpPower",
        Min = 50,
        Max = 300,
        Default = 50,
        Callback = function(val)
            local player = game.Players.LocalPlayer
            if player and player.Character then
                local hum = player.Character:FindFirstChildOfClass("Humanoid")
                if hum then hum.JumpPower = val end
            end
        end
    })

    TabSliders:CreateSection("Visual")

    TabSliders:CreateSlider({
        Name = "Campo de Visión (FOV)",
        Flag = "FOV",
        Min = 70,
        Max = 120,
        Default = 70,
        Callback = function(val)
            game.Workspace.CurrentCamera.FieldOfView = val
        end
    })

    -- ═══════════════════════════════════════
    --  PESTAÑA 3: ENTRADAS
    -- ═══════════════════════════════════════
    local TabEntradas = Window:CreateTab("Entradas")

    TabEntradas:CreateSection("Selección")

    TabEntradas:CreateDropdown({
        Name = "Seleccionar Equipo",
        Flag = "Team",
        List = {"Rojo", "Azul", "Verde", "Amarillo", "Neutro"},
        Default = "Neutro",
        Callback = function(val)
            print("[BloxBox] Equipo:", val)
            UI:Notify({
                Title = "Equipo",
                Content = "Has seleccionado: " .. val,
                Type = "Info"
            })
        end
    })

    TabEntradas:CreateDropdown({
        Name = "Idioma",
        Flag = "Language",
        List = {"Español", "English", "Português", "Français"},
        Default = "Español",
        Callback = function(val)
            print("[BloxBox] Idioma:", val)
        end
    })

    TabEntradas:CreateSection("Texto")

    TabEntradas:CreateTextBox({
        Name = "Mensaje del Chat",
        Flag = "ChatMsg",
        Placeholder = "Escribe un mensaje...",
        Callback = function(text)
            print("[BloxBox] Mensaje:", text)
        end
    })

    TabEntradas:CreateSection("Teclas")

    TabEntradas:CreateKeybind({
        Name = "Ocultar/Mostrar UI",
        Flag = "ToggleUI",
        Default = Enum.KeyCode.RightControl,
        Callback = function()
            UI:Notify({
                Title = "Keybind",
                Content = "¡Tecla de acceso rápido activada!",
                Type = "Warning"
            })
        end
    })

    -- ═══════════════════════════════════════
    --  PESTAÑA 4: CONFIGURACIÓN
    -- ═══════════════════════════════════════
    local TabConfig = Window:CreateTab("Config")

    TabConfig:CreateSection("Perfil de Configuración")

    TabConfig:CreateButton({
        Name = "💾 Guardar Configuración",
        Callback = function()
            UI:SaveConfig("BloxBox_Perfil1")
            UI:Notify({
                Title = "Guardado",
                Content = "Tu configuración ha sido guardada localmente.",
                Type = "Success"
            })
        end
    })

    TabConfig:CreateButton({
        Name = "📂 Cargar Configuración",
        Callback = function()
            UI:LoadConfig("BloxBox_Perfil1")
            UI:Notify({
                Title = "Cargado",
                Content = "Configuración restaurada con éxito.",
                Type = "Info"
            })
        end
    })

    TabConfig:CreateSection("Notificaciones de Prueba")

    TabConfig:CreateButton({
        Name = "✅ Notificación Éxito",
        Callback = function()
            UI:Notify({ Title = "Éxito", Content = "Operación completada.", Duration = 3, Type = "Success" })
        end
    })

    TabConfig:CreateButton({
        Name = "⚠️ Notificación Advertencia",
        Callback = function()
            UI:Notify({ Title = "Advertencia", Content = "¡Ten cuidado con esta acción!", Duration = 3, Type = "Warning" })
        end
    })

    TabConfig:CreateButton({
        Name = "❌ Notificación Error",
        Callback = function()
            UI:Notify({ Title = "Error", Content = "Algo salió mal.", Duration = 3, Type = "Error" })
        end
    })

    -- ═══════════════════════════════════════
    --  PESTAÑA 5: INFORMACIÓN
    -- ═══════════════════════════════════════
    local TabInfo = Window:CreateTab("Info")

    TabInfo:CreateLabel("╔══════════════════════╗")
    TabInfo:CreateLabel("  BLOXBOX UI FRAMEWORK")
    TabInfo:CreateLabel("╚══════════════════════╝")
    TabInfo:CreateLabel("")
    TabInfo:CreateLabel("Versión: 1.02.0")
    TabInfo:CreateLabel("Autor: Samir & Team")
    TabInfo:CreateLabel("Motor: Luau Strict")
    TabInfo:CreateLabel("Licencia: Libre")
    TabInfo:CreateLabel("")
    TabInfo:CreateLabel("Características:")
    TabInfo:CreateLabel("• Ventanas con drag & drop")
    TabInfo:CreateLabel("• Pestañas con animación")
    TabInfo:CreateLabel("• Búsqueda de componentes")
    TabInfo:CreateLabel("• Notificaciones premium")
    TabInfo:CreateLabel("• Guardado de configuración")
    TabInfo:CreateLabel("• Sistema de temas")

    print("[BloxBox] ✅ Todas las características cargadas.")
end)
