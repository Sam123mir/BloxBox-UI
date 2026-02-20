-- BloxBox UI: NotificationManager (Executor Compatible)
local AnimationEngine = require(script.Parent.AnimationEngine)
local Maid = require(script.Parent.Parent.Utils.Maid)

local NotificationManager = {}
NotificationManager.__index = NotificationManager

function NotificationManager.new()
	return setmetatable({
		_container = nil,
		_maid = Maid.new(),
	}, NotificationManager)
end

function NotificationManager:_getContainer()
	if self._container and self._container.Parent then
		return self._container
	end
	local player = game:GetService("Players").LocalPlayer
	local gui = Instance.new("ScreenGui")
	gui.Name = "BloxBoxNotifications"
	gui.ResetOnSpawn = false
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	gui.DisplayOrder = 100

	pcall(function() gui.Parent = game:GetService("CoreGui") end)
	if not gui.Parent then
		gui.Parent = player:WaitForChild("PlayerGui")
	end
	
	local container = Instance.new("Frame")
	container.Size = UDim2.new(0, 300, 1, 0)
	container.Position = UDim2.new(1, -310, 0, 0)
	container.BackgroundTransparency = 1
	container.Parent = gui
	
	local layout = Instance.new("UIListLayout")
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Padding = UDim.new(0, 6)
	layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
	layout.Parent = container
	
	self._container = container
	return container
end

function NotificationManager:Show(options)
	local container = self:_getContainer()
	
	local typeColors = {
		Info = Color3.fromRGB(0, 170, 255),
		Success = Color3.fromRGB(0, 200, 80),
		Warning = Color3.fromRGB(255, 180, 0),
		Error = Color3.fromRGB(255, 60, 60),
	}
	
	local color = typeColors[options.Type or "Info"] or typeColors.Info
	
	local notif = Instance.new("Frame")
	notif.Size = UDim2.new(1, 0, 0, 60)
	notif.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	notif.BackgroundTransparency = 0.1
	notif.BorderSizePixel = 0
	notif.Parent = container
	
	Instance.new("UICorner", notif).CornerRadius = UDim.new(0, 8)
	
	local stroke = Instance.new("UIStroke")
	stroke.Color = color
	stroke.Thickness = 1
	stroke.Transparency = 0.5
	stroke.Parent = notif
	
	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, -16, 0, 22)
	title.Position = UDim2.fromOffset(8, 4)
	title.BackgroundTransparency = 1
	title.Text = options.Title or "Notification"
	title.TextColor3 = color
	title.Font = Enum.Font.GothamBold
	title.TextSize = 14
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = notif
	
	local content = Instance.new("TextLabel")
	content.Size = UDim2.new(1, -16, 0, 28)
	content.Position = UDim2.fromOffset(8, 26)
	content.BackgroundTransparency = 1
	content.Text = options.Content or ""
	content.TextColor3 = Color3.fromRGB(200, 200, 200)
	content.Font = Enum.Font.Gotham
	content.TextSize = 12
	content.TextXAlignment = Enum.TextXAlignment.Left
	content.TextWrapped = true
	content.Parent = notif
	
	-- Animación entrada
	notif.Position = UDim2.fromOffset(300, 0)
	AnimationEngine:Tween(notif, { Position = UDim2.fromOffset(0, 0) }, "Fast")
	
	-- Auto-destruir
	task.delay(options.Duration or 4, function()
		AnimationEngine:Tween(notif, { BackgroundTransparency = 1 }, "Normal")
		AnimationEngine:Tween(title, { TextTransparency = 1 }, "Normal")
		AnimationEngine:Tween(content, { TextTransparency = 1 }, "Normal")
		AnimationEngine:Tween(stroke, { Transparency = 1 }, "Normal")
		task.wait(0.4)
		notif:Destroy()
	end)
end

return NotificationManager
