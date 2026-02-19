--!strict
local RunService = game:GetService("RunService")
local AnimationEngine = require(script.Parent.AnimationEngine)
local Maid = require(script.Parent.Parent.Utils.Maid)

local IntroManager = {}

function IntroManager:Show(theme: any)
	local maid = Maid.new()
	local sg = Instance.new("ScreenGui")
	sg.Name = "BloxBox_Intro"
	sg.DisplayOrder = 1000
	sg.IgnoreGuiInset = true
	sg.Parent = (RunService:IsStudio() and game.Players.LocalPlayer:WaitForChild("PlayerGui")) or game:GetService("CoreGui")
	
	local background = Instance.new("Frame", sg)
	background.Size = UDim2.fromScale(1, 1)
	background.BackgroundColor3 = theme.Colors.Background
	background.BorderSizePixel = 0
	background.BackgroundTransparency = 0

	local container = Instance.new("Frame", background)
	container.Size = UDim2.fromOffset(400, 250)
	container.Position = UDim2.fromScale(0.5, 0.5)
	container.AnchorPoint = Vector2.new(0.5, 0.5)
	container.BackgroundTransparency = 1

    -- Logo BloxBox
    local logo = Instance.new("ImageLabel", container)
    logo.Name = "Logo"
    logo.Size = UDim2.fromOffset(120, 120)
    logo.Position = UDim2.new(0.5, 0, 0, 0)
    logo.AnchorPoint = Vector2.new(0.5, 0)
    logo.BackgroundTransparency = 1
    logo.Image = "rbxassetid://123456789" -- ID TEMPORAL: El usuario debe subir el archivo images/logo-BloxBox.png a Roblox y poner el ID aquí
    logo.ImageTransparency = 1

	local title = Instance.new("TextLabel", container)
	title.Size = UDim2.new(1, 0, 0, 40)
	title.BackgroundTransparency = 1
	title.Text = "BLOXBOX UI"
	title.TextColor3 = Color3.new(1, 1, 1)
	title.Font = Enum.Font.InterBold
	title.TextSize = 28
	title.TextTransparency = 1
	title.Position = UDim2.new(0.5, 0, 0, 130)
    title.AnchorPoint = Vector2.new(0.5, 0)

	local version = Instance.new("TextLabel", container)
	version.Size = UDim2.new(1, 0, 0, 20)
	version.Position = UDim2.fromOffset(0, 45)
	version.BackgroundTransparency = 1
	version.Text = "v1.00.0"
	version.TextColor3 = theme.Colors.Accent
	version.Font = Enum.Font.InterMedium
	version.TextSize = 14
	version.TextTransparency = 1

	local barBackground = Instance.new("Frame", container)
	barBackground.Size = UDim2.new(0.7, 0, 0, 4)
	barBackground.Position = UDim2.new(0.15, 0, 0, 185)
	barBackground.BackgroundColor3 = theme.Colors.Surface
	barBackground.BorderSizePixel = 0
	barBackground.BackgroundTransparency = 1
    Instance.new("UICorner", barBackground).CornerRadius = UDim.new(1, 0)

	local barFill = Instance.new("Frame", barBackground)
	barFill.Size = UDim2.fromScale(0, 1)
	barFill.BackgroundColor3 = theme.Colors.Accent
	barFill.BorderSizePixel = 0
    Instance.new("UICorner", barFill).CornerRadius = UDim.new(1, 0)

	-- Animación Fluida y Branding
	task.spawn(function()
		AnimationEngine:Tween(logo, { ImageTransparency = 0, Position = UDim2.new(0.5, 0, 0, 10) }, "Slow")
		task.wait(0.4)
		AnimationEngine:Tween(title, { TextTransparency = 0, Position = UDim2.new(0.5, 0, 0, 140) }, "Normal")
		task.wait(0.3)
		AnimationEngine:Tween(barBackground, { BackgroundTransparency = 0.5 }, "Normal")
		
		-- Carga de barra elegante
		local tween = AnimationEngine:Tween(barFill, { Size = UDim2.fromScale(1, 1) }, TweenInfo.new(2.8, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
		tween.Completed:Wait()
		
		task.wait(0.8)
		
		-- Fade Out General con Estilo
		AnimationEngine:Tween(logo, { ImageTransparency = 1 }, "Normal")
		AnimationEngine:Tween(title, { TextTransparency = 1 }, "Normal")
		AnimationEngine:Tween(barBackground, { BackgroundTransparency = 1 }, "Normal")
		AnimationEngine:Tween(barFill, { BackgroundTransparency = 1 }, "Normal")
		
		task.wait(0.5)
		local bgTween = AnimationEngine:Tween(background, { BackgroundTransparency = 1 }, "Normal")
		bgTween.Completed:Wait()
		
		sg:Destroy()
		maid:Destroy()
	end)
end

return IntroManager
