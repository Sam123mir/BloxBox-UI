-- BloxBox UI: IntroManager (Executor Compatible)
local AnimationEngine = require(script.Parent.AnimationEngine)

local IntroManager = {}
IntroManager.__index = IntroManager

function IntroManager.new(themeManager)
	return setmetatable({
		_theme = themeManager,
	}, IntroManager)
end

function IntroManager:Show()
	local theme = self._theme:GetTheme()
	local player = game:GetService("Players").LocalPlayer

	local gui = Instance.new("ScreenGui")
	gui.Name = "BloxBoxIntro"
	gui.ResetOnSpawn = false
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	gui.DisplayOrder = 999

	pcall(function() gui.Parent = game:GetService("CoreGui") end)
	if not gui.Parent then
		gui.Parent = player:WaitForChild("PlayerGui")
	end

	-- Fondo oscuro
	local bg = Instance.new("Frame")
	bg.Size = UDim2.fromScale(1, 1)
	bg.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
	bg.BackgroundTransparency = 0
	bg.BorderSizePixel = 0
	bg.Parent = gui

	-- Contenedor central
	local container = Instance.new("Frame")
	container.Size = UDim2.fromOffset(300, 200)
	container.Position = UDim2.fromScale(0.5, 0.5)
	container.AnchorPoint = Vector2.new(0.5, 0.5)
	container.BackgroundTransparency = 1
	container.Parent = bg

	-- Logo (imagen)
	local logo = Instance.new("ImageLabel")
	logo.Name = "Logo"
	logo.Size = UDim2.fromOffset(120, 120)
	logo.Position = UDim2.new(0.5, 0, 0, 0)
	logo.AnchorPoint = Vector2.new(0.5, 0)
	logo.BackgroundTransparency = 1
	logo.Image = "rbxassetid://123456789" -- Reemplazar con el ID real del logo
	logo.ImageTransparency = 1
	logo.Parent = container

	-- Título
	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, 0, 0, 30)
	title.Position = UDim2.new(0.5, 0, 0, 130)
	title.AnchorPoint = Vector2.new(0.5, 0)
	title.BackgroundTransparency = 1
	title.Text = "BloxBox UI"
	title.TextColor3 = theme.Colors.Accent
	title.Font = Enum.Font.GothamBold
	title.TextSize = 22
	title.TextTransparency = 1
	title.Parent = container

	-- Barra de carga - Fondo
	local barBackground = Instance.new("Frame")
	barBackground.Size = UDim2.new(0.7, 0, 0, 6)
	barBackground.Position = UDim2.new(0.5, 0, 0, 175)
	barBackground.AnchorPoint = Vector2.new(0.5, 0)
	barBackground.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	barBackground.BackgroundTransparency = 1
	barBackground.BorderSizePixel = 0
	barBackground.Parent = container
	Instance.new("UICorner", barBackground).CornerRadius = UDim.new(1, 0)

	-- Barra de carga - Relleno
	local barFill = Instance.new("Frame")
	barFill.Size = UDim2.fromScale(0, 1)
	barFill.BackgroundColor3 = theme.Colors.Accent
	barFill.BorderSizePixel = 0
	barFill.Parent = barBackground
	Instance.new("UICorner", barFill).CornerRadius = UDim.new(1, 0)

	-- Animación
	task.spawn(function()
		AnimationEngine:Tween(logo, { ImageTransparency = 0, Position = UDim2.new(0.5, 0, 0, 10) }, "Slow")
		task.wait(0.4)
		AnimationEngine:Tween(title, { TextTransparency = 0, Position = UDim2.new(0.5, 0, 0, 140) }, "Normal")
		task.wait(0.3)
		AnimationEngine:Tween(barBackground, { BackgroundTransparency = 0.5 }, "Normal")
		
		-- Barra de carga
		local tween = AnimationEngine:Tween(barFill, { Size = UDim2.fromScale(1, 1) }, TweenInfo.new(2.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
		tween.Completed:Wait()
		
		-- Fade out
		task.wait(0.3)
		AnimationEngine:Tween(bg, { BackgroundTransparency = 1 }, "Normal")
		AnimationEngine:Tween(logo, { ImageTransparency = 1 }, "Normal")
		AnimationEngine:Tween(title, { TextTransparency = 1 }, "Normal")
		AnimationEngine:Tween(barBackground, { BackgroundTransparency = 1 }, "Normal")
		AnimationEngine:Tween(barFill, { BackgroundTransparency = 1 }, "Normal")
		task.wait(0.5)
		gui:Destroy()
	end)
end

return IntroManager
