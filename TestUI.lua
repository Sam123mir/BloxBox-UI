-- [[ BLOXBOX UI: TEST v2.0 PREMIUM ]]

local BloxBoxUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Sam123mir/BloxBox-UI/master/Source.lua?v=" .. os.time()))()

local Library = BloxBoxUI.new()

-- Color de acento personalizable
Library:SetAccent(Color3.fromRGB(90, 130, 255))

-- Intro con logo (reemplazar ID cuando subas el logo a Roblox)
Library:ShowIntro("rbxassetid://123456789", function()
    -- Esta función se ejecuta DESPUÉS de que termine la intro

    local Window = Library:CreateWindow({
        Title = "BloxBox UI | Premium v2.0",
        Size = UDim2.fromOffset(580, 380),
    })

    -- TAB: Principal
    local Main = Window:CreateTab("Principal")
    Main:CreateSection("Funciones")

    Main:CreateToggle({
        Name = "Activar Feature",
        Flag = "feature_on",
        Default = false,
        Callback = function(v)
            Library:Notify({ Title = "Toggle", Content = v and "Activado" or "Desactivado", Type = v and "Success" or "Info" })
        end,
    })

    Main:CreateSlider({
        Name = "Velocidad",
        Min = 16, Max = 100, Default = 16,
        Flag = "speed",
        Callback = function(v)
            pcall(function() game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v end)
        end,
    })

    Main:CreateButton({
        Name = "Saludar",
        Callback = function()
            Library:Notify({ Title = "BloxBox", Content = "Framework funcionando correctamente!", Type = "Success" })
        end,
    })

    Main:CreateSection("Selección")

    Main:CreateDropdown({
        Name = "Modo de Juego",
        List = {"Normal", "Turbo", "God Mode"},
        Default = "Normal",
        Flag = "mode",
        Callback = function(v)
            Library:Notify({ Title = "Modo", Content = "Seleccionado: " .. v, Type = "Info" })
        end,
    })

    Main:CreateTextBox({
        Name = "Nickname",
        Placeholder = "Escribe un nombre...",
        Flag = "nickname",
        Callback = function(t) print("[BloxBox] Nickname: " .. t) end,
    })

    -- TAB: Config
    local Config = Window:CreateTab("Config")

    Config:CreateToggle({
        Name = "Anti-AFK",
        Flag = "anti_afk",
        Default = true,
    })

    Config:CreateKeybind({
        Name = "Toggle UI",
        Flag = "toggle_key",
        Default = Enum.KeyCode.RightControl,
    })

    Config:CreateButton({
        Name = "Guardar Config",
        Callback = function()
            Library:SaveConfig("default")
            Library:Notify({ Title = "Config", Content = "Guardada", Type = "Success" })
        end,
    })

    Config:CreateButton({
        Name = "Cargar Config",
        Callback = function()
            Library:LoadConfig("default")
            Library:Notify({ Title = "Config", Content = "Cargada", Type = "Info" })
        end,
    })

    -- TAB: Info
    local Info = Window:CreateTab("Info")
    Info:CreateLabel("BloxBox UI v2.0 Premium")
    Info:CreateLabel("by Samir & Team")
    Info:CreateSection("Arquitectura")
    Info:CreateLabel("Single-File | 0 require()")
    Info:CreateLabel("Compatible con todos los executors")
    Info:CreateLabel("github.com/Sam123mir/BloxBox-UI")
end)
