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
	background.BackgroundTransparency = 0 -- Opaco inicialmente

	local container = Instance.new("Frame", background)
	container.Size = UDim2.fromOffset(400, 100)
	container.Position = UDim2.fromScale(0.5, 0.5)
	container.AnchorPoint = Vector2.new(0.5, 0.5)
	container.BackgroundTransparency = 1

	local title = Instance.new("TextLabel", container)
	title.Size = UDim2.new(1, 0, 0, 40)
	title.BackgroundTransparency = 1
	title.Text = "BLOXBOX UI"
	title.TextColor3 = Color3.new(1, 1, 1)
	title.Font = Enum.Font.InterBold
	title.TextSize = 32
	title.TextTransparency = 1
	title.Position = UDim2.fromOffset(0, 10)

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
	barBackground.Size = UDim2.new(0.6, 0, 0, 2)
	barBackground.Position = UDim2.new(0.2, 0, 0, 75)
	barBackground.BackgroundColor3 = theme.Colors.Surface
	barBackground.BorderSizePixel = 0
	barBackground.BackgroundTransparency = 1

	local barFill = Instance.new("Frame", barBackground)
	barFill.Size = UDim2.fromScale(0, 1)
	barFill.BackgroundColor3 = theme.Colors.Accent
	barFill.BorderSizePixel = 0

	-- Animación Fluida y Despacio
	task.spawn(function()
		-- Fade In Texto
		AnimationEngine:Tween(title, { TextTransparency = 0, Position = UDim2.fromOffset(0, 0) }, "Slow")
		task.wait(0.5)
		AnimationEngine:Tween(version, { TextTransparency = 0 }, "Normal")
		task.wait(0.3)
		AnimationEngine:Tween(barBackground, { BackgroundTransparency = 0.5 }, "Normal")
		
		-- Carga de barra (Despacio)
		local tween = AnimationEngine:Tween(barFill, { Size = UDim2.fromScale(1, 1) }, TweenInfo.new(2.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
		tween.Completed:Wait()
		
		task.wait(0.8)
		
		-- Fade Out General
		AnimationEngine:Tween(title, { TextTransparency = 1 }, "Normal")
		AnimationEngine:Tween(version, { TextTransparency = 1 }, "Normal")
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
