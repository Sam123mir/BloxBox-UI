-- [[ BLOXBOX UI: TEST v3.3 SPACESHIP ]]

local BloxBoxUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Sam123mir/BloxBox-UI/master/Source.lua?v=" .. os.time()))()

local Library = BloxBoxUI.new()
Library:SetAccent(Color3.fromRGB(88, 128, 255))

-- Intro with logo
Library:ShowIntro("rbxassetid://74440190043939", function()
    local Window = Library:CreateWindow({
        Title = "BloxBox UI | v3.3",
        Size = UDim2.fromOffset(680, 480),
    })

    local Main = Window:CreateTab("Principal")
    Main:CreateSection("Funciones")
    Main:CreateToggle({ Name = "Activar Feature", Flag = "feat", Default = false, Callback = function(v) Library:Notify({Title="Toggle",Content=v and"Activado"or"Desactivado",Type=v and"Success"or"Info"}) end })
    Main:CreateSlider({ Name = "Velocidad", Min = 16, Max = 100, Default = 16, Flag = "spd", Callback = function(v) pcall(function() game.Players.LocalPlayer.Character.Humanoid.WalkSpeed=v end) end })
    Main:CreateButton({ Name = "Saludar", Icon = "waving_hand", Callback = function() Library:Notify({Title="¡Hola!",Content="BloxBox UI v3.3 Spaceship funcionando correctamente.",Type="Success"}) end })
    Main:CreateSection("Seleccion")
    Main:CreateDropdown({ Name = "Modo", List = {"Normal","Turbo","God"}, Default = "Normal", Flag = "mode", Callback = function(v) Library:Notify({Title="Modo",Content="Seleccionado: "..v,Type="Info"}) end })
    Main:CreateTextBox({ Name = "Nickname", Placeholder = "Nombre...", Flag = "nick" })

    local Cfg = Window:CreateTab("Config")
    Cfg:CreateSection("Configuracion")
    Cfg:CreateToggle({ Name = "Anti-AFK", Flag = "afk", Default = true })
    Cfg:CreateKeybind({ Name = "Toggle UI", Flag = "key", Default = Enum.KeyCode.RightControl })
    Cfg:CreateButton({ Name = "Guardar Config", Icon = "save", Callback = function() Library:SaveConfig("def");Library:Notify({Title="Config",Content="Configuracion guardada",Type="Success"}) end })
    Cfg:CreateButton({ Name = "Cargar Config", Icon = "folder_open", Callback = function() Library:LoadConfig("def");Library:Notify({Title="Config",Content="Configuracion cargada",Type="Info"}) end })

    local Info = Window:CreateTab("Info")
    Info:CreateSection("Acerca de")
    Info:CreateLabel("BloxBox UI v3.3 Spaceship")
    Info:CreateLabel("by Samir & Team")
    Info:CreateSection("Sistema")
    Info:CreateLabel("Single-File Architecture")
    Info:CreateLabel("Compatible: Todos los executors")
    Info:CreateLabel("Estilo: Floating Spaceship")
end)
