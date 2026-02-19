--!strict
local RunService = game:GetService("RunService")
local Core = script.Parent
local Utils = script.Parent.Parent.Utils
local Maid = require(Utils.Maid)
local AnimationEngine = require(Core.AnimationEngine)

local NotificationManager = {
	_container = nil,
	_notifications = {},
	_maxNotifications = 5,
}

function NotificationManager:_initContainer()
	if self._container then return end
	
	local sg = Instance.new("ScreenGui")
	sg.Name = "SaaS_Notifications"
	sg.DisplayOrder = 100
	sg.ResetOnSpawn = false
	sg.Parent = (RunService:IsStudio() and game.Players.LocalPlayer:WaitForChild("PlayerGui")) or game:GetService("CoreGui")
	
	local frame = Instance.new("Frame")
	frame.Name = "Container"
	frame.Size = UDim2.new(0, 300, 1, -40)
	frame.Position = UDim2.new(1, -310, 0, 20)
	frame.BackgroundTransparency = 1
	frame.Parent = sg
	
	local list = Instance.new("UIListLayout", frame)
	list.VerticalAlignment = Enum.VerticalAlignment.Bottom
	list.HorizontalAlignment = Enum.HorizontalAlignment.Right
	list.Padding = UDim.new(0, 10)
	list.SortOrder = Enum.SortOrder.LayoutOrder
	
	self._container = frame
end

type NotificationOptions = {
	Title: string,
	Content: string,
	Duration: number?,
	Type: ("Info" | "Success" | "Warning" | "Error")?,
}

function NotificationManager:Notify(library: any, options: NotificationOptions)
	self:_initContainer()
	
	local theme = library.Theme:GetTheme()
	local duration = options.Duration or 5
	local maid = Maid.new()
	
	local notification = Instance.new("Frame")
	notification.Name = "Notification"
	notification.Size = UDim2.new(1, 0, 0, 0) -- Inicia invisible para animar la altura
	notification.BackgroundColor3 = theme.Colors.Surface
	notification.BorderSizePixel = 0
	notification.ClipsDescendants = true
	notification.LayoutOrder = -os.clock() * 1000
	notification.Parent = self._container
	
	Instance.new("UICorner", notification).CornerRadius = UDim.new(0, 8)
	local stroke = Instance.new("UIStroke", notification)
	stroke.Color = theme.Colors.Border
	stroke.Transparency = theme.Effects.StrokeTransparency
	
	local shadow = Instance.new("ImageLabel", notification)
	shadow.Name = "Shadow"
	shadow.AnchorPoint = Vector2.new(0.5, 0.5)
	shadow.Position = UDim2.fromScale(0.5, 0.5)
	shadow.Size = UDim2.new(1, 10, 1, 10)
	shadow.BackgroundTransparency = 1
	shadow.Image = "rbxassetid://6015267023"
	shadow.ImageColor3 = Color3.new(0, 0, 0)
	shadow.ImageTransparency = 0.5
	shadow.ScaleType = Enum.ScaleType.Slice
	shadow.SliceCenter = Rect.new(49, 49, 450, 450)
	shadow.ZIndex = -1

	local accentBar = Instance.new("Frame", notification)
	accentBar.Size = UDim2.new(0, 4, 1, 0)
	accentBar.BackgroundColor3 = options.Type == "Error" and Color3.fromRGB(255, 80, 80) 
		or options.Type == "Success" and Color3.fromRGB(80, 255, 80)
		or theme.Colors.Accent
	accentBar.BorderSizePixel = 0
	
	local title = Instance.new("TextLabel", notification)
	title.Size = UDim2.new(1, -20, 0, 20)
	title.Position = UDim2.fromOffset(12, 8)
	title.BackgroundTransparency = 1
	title.Text = options.Title
	title.TextColor3 = theme.Colors.Text
	title.Font = Enum.Font.InterBold
	title.TextSize = 14
	title.TextXAlignment = Enum.TextXAlignment.Left
	
	local content = Instance.new("TextLabel", notification)
	content.Size = UDim2.new(1, -20, 0, 0)
	content.Position = UDim2.fromOffset(12, 28)
	content.BackgroundTransparency = 1
	content.Text = options.Content
	content.TextColor3 = theme.Colors.TextDim
	content.Font = Enum.Font.Inter
	content.TextSize = 13
	content.TextXAlignment = Enum.TextXAlignment.Left
	content.TextWrapped = true
	
	-- Calcular altura basada en el texto
	local textBounds = game:GetService("TextService"):GetTextSize(options.Content, 13, Enum.Font.Inter, Vector2.new(280, 1000))
	local targetHeight = 40 + textBounds.Y
	
	-- Barra de progreso
	local progressBackground = Instance.new("Frame", notification)
	progressBackground.Size = UDim2.new(1, 0, 0, 2)
	progressBackground.Position = UDim2.new(0, 0, 1, -2)
	progressBackground.BackgroundColor3 = theme.Colors.Background
	progressBackground.BackgroundTransparency = 0.5
	progressBackground.BorderSizePixel = 0
	
	local progressBar = Instance.new("Frame", progressBackground)
	progressBar.Size = UDim2.fromScale(1, 1)
	progressBar.BackgroundColor3 = accentBar.BackgroundColor3
	progressBar.BorderSizePixel = 0

	-- Animación de entrada
	AnimationEngine:Tween(notification, { Size = UDim2.new(1, 0, 0, targetHeight) }, "Normal")
	AnimationEngine:Tween(progressBar, { Size = UDim2.fromScale(0, 1) }, TweenInfo.new(duration, Enum.EasingStyle.Linear))
	
	-- Auto-destrucción
	task.delay(duration, function()
		local out = AnimationEngine:Tween(notification, { Position = UDim2.fromOffset(350, 0), ImageTransparency = 1 }, "Normal")
		out.Completed:Wait()
		notification:Destroy()
		maid:Destroy()
	end)
end

return NotificationManager
