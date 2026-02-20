-- [[ BLOXBOX UI: TEST v2.1 PREMIUM ]]

local BloxBoxUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Sam123mir/BloxBox-UI/master/Source.lua?v=" .. os.time()))()

local Library = BloxBoxUI.new()
Library:SetAccent(Color3.fromRGB(88, 128, 255))

-- Intro
Library:ShowIntro("rbxassetid://123456789", function()
    local Window = Library:CreateWindow({
        Title = "BloxBox UI | v2.1",
        Size = UDim2.fromOffset(560, 370),
        Logo = "rbxassetid://123456789",
    })

    local Main = Window:CreateTab("Principal")
    Main:CreateSection("Funciones")
    Main:CreateToggle({ Name = "Activar Feature", Flag = "feat", Default = false, Callback = function(v) Library:Notify({Title="Toggle",Content=v and"ON"or"OFF",Type=v and"Success"or"Info"}) end })
    Main:CreateSlider({ Name = "Velocidad", Min = 16, Max = 100, Default = 16, Flag = "spd", Callback = function(v) pcall(function()P.Character.Humanoid.WalkSpeed=v end) end })
    Main:CreateButton({ Name = "Saludar", Callback = function() Library:Notify({Title="Hola",Content="Framework OK!",Type="Success"}) end })
    Main:CreateSection("Seleccion")
    Main:CreateDropdown({ Name = "Modo", List = {"Normal","Turbo","God"}, Default = "Normal", Flag = "mode", Callback = function(v) Library:Notify({Title="Modo",Content=v,Type="Info"}) end })
    Main:CreateTextBox({ Name = "Nickname", Placeholder = "Nombre...", Flag = "nick" })

    local Cfg = Window:CreateTab("Config")
    Cfg:CreateToggle({ Name = "Anti-AFK", Flag = "afk", Default = true })
    Cfg:CreateKeybind({ Name = "Toggle UI", Flag = "key", Default = Enum.KeyCode.RightControl })
    Cfg:CreateButton({ Name = "Guardar Config", Callback = function() Library:SaveConfig("def");Library:Notify({Title="Config",Content="Guardada",Type="Success"}) end })
    Cfg:CreateButton({ Name = "Cargar Config", Callback = function() Library:LoadConfig("def");Library:Notify({Title="Config",Content="Cargada",Type="Info"}) end })

    local Info = Window:CreateTab("Info")
    Info:CreateLabel("BloxBox UI v2.1 Premium")
    Info:CreateLabel("by Samir & Team")
    Info:CreateSection("Sistema")
    Info:CreateLabel("Single-File Architecture")
    Info:CreateLabel("Compatible: Todos los executors")
end)
