--[[
╔══════════════════════════════════════════════════╗
║        BLOXBOX UI v1.02.0 - SOURCE               ║
║        by Samir & Team                            ║
║        Single-File Architecture                   ║
╚══════════════════════════════════════════════════╝

Credits:
  Samir | Main Developer & Designer
  Inspired by modern UI libraries

NOTES:
  This is a single-file UI library designed for Roblox executors.
  Everything is self-contained — no require(), no ModuleScripts.
  Just loadstring() and go.
]]

--// ═══════════════════════════════════════════════
--// SECTION: Services
--// ═══════════════════════════════════════════════

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Player = Players.LocalPlayer

--// ═══════════════════════════════════════════════
--// SECTION: Signal (Event System)
--// ═══════════════════════════════════════════════

local Signal = {}
Signal.__index = Signal

function Signal.new()
	return setmetatable({ _connections = {} }, Signal)
end

function Signal:Connect(handler)
	local connection = { _signal = self, _handler = handler }
	connection.Disconnect = function(conn)
		for i, c in ipairs(self._connections) do
			if c == conn then table.remove(self._connections, i) break end
		end
	end
	table.insert(self._connections, connection)
	return connection
end

function Signal:Fire(...)
	for _, conn in ipairs(self._connections) do
		task.spawn(conn._handler, ...)
	end
end

function Signal:Destroy()
	self._connections = {}
end

--// ═══════════════════════════════════════════════
--// SECTION: Maid (Cleanup System)
--// ═══════════════════════════════════════════════

local Maid = {}
Maid.__index = Maid

function Maid.new()
	return setmetatable({ _tasks = {} }, Maid)
end

function Maid:GiveTask(t)
	table.insert(self._tasks, t)
end

function Maid:Destroy()
	for _, t in ipairs(self._tasks) do
		if typeof(t) == "function" then
			t()
		elseif typeof(t) == "RBXScriptConnection" then
			t:Disconnect()
		elseif typeof(t) == "Instance" then
			t:Destroy()
		elseif typeof(t) == "table" and t.Destroy then
			t:Destroy()
		elseif typeof(t) == "table" and t.Disconnect then
			t:Disconnect()
		end
	end
	self._tasks = {}
end

--// ═══════════════════════════════════════════════
--// SECTION: AnimationEngine
--// ═══════════════════════════════════════════════

local Presets = {
	Fast = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
	Normal = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
	Slow = TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
}

local function Tween(instance, properties, presetOrInfo)
	local info
	if typeof(presetOrInfo) == "TweenInfo" then
		info = presetOrInfo
	else
		info = Presets[presetOrInfo or "Normal"]
	end
	local tween = TweenService:Create(instance, info, properties)
	tween:Play()
	return tween
end

--// ═══════════════════════════════════════════════
--// SECTION: Theme System
--// ═══════════════════════════════════════════════

local DefaultTheme = {
	Colors = {
		Background = Color3.fromRGB(15, 15, 15),
		Surface = Color3.fromRGB(22, 22, 22),
		Accent = Color3.fromRGB(0, 170, 255),
		Text = Color3.fromRGB(255, 255, 255),
		TextDim = Color3.fromRGB(160, 160, 160),
		Border = Color3.fromRGB(40, 40, 40),
	},
	Typography = {
		MainFont = Enum.Font.GothamMedium,
		HeaderFont = Enum.Font.GothamBold,
		BaseSize = 14,
		HeaderSize = 16,
	},
	Layout = {
		Padding = 12,
		Radius = 8,
	},
}

--// ═══════════════════════════════════════════════
--// SECTION: State Manager
--// ═══════════════════════════════════════════════

local StateManager = {}
StateManager.__index = StateManager

function StateManager.new()
	return setmetatable({
		_states = {},
		_subscribers = {},
	}, StateManager)
end

function StateManager:Set(flag, value)
	if self._states[flag] == value then return end
	self._states[flag] = value
	if self._subscribers[flag] then
		self._subscribers[flag]:Fire(value)
	end
end

function StateManager:Get(flag, fallback)
	local val = self._states[flag]
	if val == nil then return fallback end
	return val
end

function StateManager:Subscribe(flag, handler)
	if not self._subscribers[flag] then
		self._subscribers[flag] = Signal.new()
	end
	return self._subscribers[flag]:Connect(handler)
end

--// ═══════════════════════════════════════════════
--// SECTION: Config Manager
--// ═══════════════════════════════════════════════

local ConfigManager = {}
ConfigManager.__index = ConfigManager

function ConfigManager.new(stateManager)
	return setmetatable({
		_state = stateManager,
		_folder = "BloxBox_Configs"
	}, ConfigManager)
end

function ConfigManager:Save(name)
	pcall(function()
		if writefile then
			if not isfolder(self._folder) then makefolder(self._folder) end
			writefile(self._folder .. "/" .. name .. ".json", HttpService:JSONEncode(self._state._states))
		end
	end)
end

function ConfigManager:Load(name)
	pcall(function()
		if readfile and isfile and isfile(self._folder .. "/" .. name .. ".json") then
			local decoded = HttpService:JSONDecode(readfile(self._folder .. "/" .. name .. ".json"))
			if decoded and typeof(decoded) == "table" then
				for flag, value in pairs(decoded) do
					self._state:Set(flag, value)
				end
			end
		end
	end)
end

--// ═══════════════════════════════════════════════
--// SECTION: Drag System
--// ═══════════════════════════════════════════════

local function CreateDrag(frame, parent)
	local dragging, dragStart, startPos = false, nil, nil

	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = parent.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			parent.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
end

--// ═══════════════════════════════════════════════
--// SECTION: Notification System
--// ═══════════════════════════════════════════════

local NotificationContainer = nil

local function GetNotificationContainer()
	if NotificationContainer and NotificationContainer.Parent then
		return NotificationContainer
	end
	
	local gui = Instance.new("ScreenGui")
	gui.Name = "BloxBoxNotifications"
	gui.ResetOnSpawn = false
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	gui.DisplayOrder = 100
	pcall(function() gui.Parent = game:GetService("CoreGui") end)
	if not gui.Parent then gui.Parent = Player:WaitForChild("PlayerGui") end

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

	NotificationContainer = container
	return container
end

local function ShowNotification(options)
	local container = GetNotificationContainer()
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

	notif.Position = UDim2.fromOffset(300, 0)
	Tween(notif, { Position = UDim2.fromOffset(0, 0) }, "Fast")

	task.delay(options.Duration or 4, function()
		Tween(notif, { BackgroundTransparency = 1 }, "Normal")
		Tween(title, { TextTransparency = 1 }, "Normal")
		Tween(content, { TextTransparency = 1 }, "Normal")
		Tween(stroke, { Transparency = 1 }, "Normal")
		task.wait(0.4)
		notif:Destroy()
	end)
end

--// ═══════════════════════════════════════════════
--// SECTION: Intro / Splash Screen
--// ═══════════════════════════════════════════════

local function ShowIntro(theme)
	local gui = Instance.new("ScreenGui")
	gui.Name = "BloxBoxIntro"
	gui.ResetOnSpawn = false
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	gui.DisplayOrder = 999
	pcall(function() gui.Parent = game:GetService("CoreGui") end)
	if not gui.Parent then gui.Parent = Player:WaitForChild("PlayerGui") end

	local bg = Instance.new("Frame")
	bg.Size = UDim2.fromScale(1, 1)
	bg.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
	bg.BorderSizePixel = 0
	bg.Parent = gui

	local container = Instance.new("Frame")
	container.Size = UDim2.fromOffset(300, 200)
	container.Position = UDim2.fromScale(0.5, 0.5)
	container.AnchorPoint = Vector2.new(0.5, 0.5)
	container.BackgroundTransparency = 1
	container.Parent = bg

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, 0, 0, 40)
	title.Position = UDim2.new(0.5, 0, 0, 50)
	title.AnchorPoint = Vector2.new(0.5, 0)
	title.BackgroundTransparency = 1
	title.Text = "BloxBox UI"
	title.TextColor3 = theme.Colors.Accent
	title.Font = Enum.Font.GothamBold
	title.TextSize = 28
	title.TextTransparency = 1
	title.Parent = container

	local subtitle = Instance.new("TextLabel")
	subtitle.Size = UDim2.new(1, 0, 0, 20)
	subtitle.Position = UDim2.new(0.5, 0, 0, 95)
	subtitle.AnchorPoint = Vector2.new(0.5, 0)
	subtitle.BackgroundTransparency = 1
	subtitle.Text = "v1.02.0"
	subtitle.TextColor3 = theme.Colors.TextDim
	subtitle.Font = Enum.Font.Gotham
	subtitle.TextSize = 14
	subtitle.TextTransparency = 1
	subtitle.Parent = container

	local barBg = Instance.new("Frame")
	barBg.Size = UDim2.new(0.6, 0, 0, 4)
	barBg.Position = UDim2.new(0.5, 0, 0, 135)
	barBg.AnchorPoint = Vector2.new(0.5, 0)
	barBg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	barBg.BackgroundTransparency = 1
	barBg.BorderSizePixel = 0
	barBg.Parent = container
	Instance.new("UICorner", barBg).CornerRadius = UDim.new(1, 0)

	local barFill = Instance.new("Frame")
	barFill.Size = UDim2.fromScale(0, 1)
	barFill.BackgroundColor3 = theme.Colors.Accent
	barFill.BorderSizePixel = 0
	barFill.Parent = barBg
	Instance.new("UICorner", barFill).CornerRadius = UDim.new(1, 0)

	task.spawn(function()
		Tween(title, { TextTransparency = 0 }, "Slow")
		task.wait(0.3)
		Tween(subtitle, { TextTransparency = 0 }, "Normal")
		task.wait(0.2)
		Tween(barBg, { BackgroundTransparency = 0.5 }, "Normal")
		
		local t = Tween(barFill, { Size = UDim2.fromScale(1, 1) }, TweenInfo.new(2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
		t.Completed:Wait()
		
		task.wait(0.3)
		Tween(bg, { BackgroundTransparency = 1 }, "Normal")
		Tween(title, { TextTransparency = 1 }, "Normal")
		Tween(subtitle, { TextTransparency = 1 }, "Normal")
		Tween(barBg, { BackgroundTransparency = 1 }, "Normal")
		Tween(barFill, { BackgroundTransparency = 1 }, "Normal")
		task.wait(0.5)
		gui:Destroy()
	end)
end

--// ═══════════════════════════════════════════════
--// SECTION: Components — Section
--// ═══════════════════════════════════════════════

local function CreateSection(tab, name)
	local theme = tab._library._theme

	local container = Instance.new("Frame")
	container.Size = UDim2.new(1, 0, 0, 28)
	container.BackgroundTransparency = 1
	container.Parent = tab._container

	local line = Instance.new("Frame")
	line.Size = UDim2.new(1, 0, 0, 1)
	line.Position = UDim2.new(0, 0, 0.5, 0)
	line.BackgroundColor3 = theme.Colors.Border
	line.BorderSizePixel = 0
	line.Parent = container

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(0, 0, 0, 20)
	label.Position = UDim2.fromOffset(10, 4)
	label.AutomaticSize = Enum.AutomaticSize.X
	label.BackgroundColor3 = theme.Colors.Background
	label.Text = "  " .. name .. "  "
	label.TextColor3 = theme.Colors.TextDim
	label.Font = theme.Typography.HeaderFont
	label.TextSize = 12
	label.Parent = container
end

--// ═══════════════════════════════════════════════
--// SECTION: Components — Button
--// ═══════════════════════════════════════════════

local function CreateButton(tab, options)
	local theme = tab._library._theme

	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 0, 34)
	btn.BackgroundColor3 = theme.Colors.Surface
	btn.BorderSizePixel = 0
	btn.Text = options.Name
	btn.TextColor3 = theme.Colors.Text
	btn.Font = theme.Typography.MainFont
	btn.TextSize = theme.Typography.BaseSize
	btn.AutoButtonColor = false
	btn.Parent = tab._container
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

	btn.MouseEnter:Connect(function()
		Tween(btn, { BackgroundColor3 = theme.Colors.Accent }, "Fast")
	end)
	btn.MouseLeave:Connect(function()
		Tween(btn, { BackgroundColor3 = theme.Colors.Surface }, "Fast")
	end)
	btn.MouseButton1Click:Connect(function()
		Tween(btn, { Size = UDim2.new(1, -6, 0, 32) }, "Fast")
		task.wait(0.1)
		Tween(btn, { Size = UDim2.new(1, 0, 0, 34) }, "Fast")
		if options.Callback then options.Callback() end
	end)
end

--// ═══════════════════════════════════════════════
--// SECTION: Components — Toggle
--// ═══════════════════════════════════════════════

local function CreateToggle(tab, options)
	local theme = tab._library._theme
	local state = tab._library._state

	local container = Instance.new("TextButton")
	container.Size = UDim2.new(1, 0, 0, 38)
	container.BackgroundColor3 = theme.Colors.Surface
	container.BorderSizePixel = 0
	container.Text = ""
	container.AutoButtonColor = false
	container.Parent = tab._container
	Instance.new("UICorner", container).CornerRadius = UDim.new(0, 6)

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, -60, 1, 0)
	title.Position = UDim2.fromOffset(10, 0)
	title.BackgroundTransparency = 1
	title.Text = options.Name
	title.TextColor3 = theme.Colors.Text
	title.Font = theme.Typography.MainFont
	title.TextSize = theme.Typography.BaseSize
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = container

	local track = Instance.new("Frame")
	track.Size = UDim2.fromOffset(38, 20)
	track.Position = UDim2.new(1, -48, 0.5, 0)
	track.AnchorPoint = Vector2.new(0, 0.5)
	track.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	track.BorderSizePixel = 0
	track.Parent = container
	Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

	local knob = Instance.new("Frame")
	knob.Size = UDim2.fromOffset(16, 16)
	knob.Position = UDim2.fromOffset(2, 2)
	knob.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
	knob.BorderSizePixel = 0
	knob.Parent = track
	Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

	local function updateVisual(val)
		if val then
			Tween(knob, { Position = UDim2.fromOffset(20, 2), BackgroundColor3 = Color3.new(1, 1, 1) }, "Fast")
			Tween(track, { BackgroundColor3 = theme.Colors.Accent }, "Fast")
		else
			Tween(knob, { Position = UDim2.fromOffset(2, 2), BackgroundColor3 = Color3.fromRGB(200, 200, 200) }, "Fast")
			Tween(track, { BackgroundColor3 = Color3.fromRGB(60, 60, 60) }, "Fast")
		end
	end

	state:Subscribe(options.Flag, function(val)
		updateVisual(val)
		if options.Callback then options.Callback(val) end
	end)

	container.MouseButton1Click:Connect(function()
		state:Set(options.Flag, not state:Get(options.Flag, false))
	end)

	local default = options.Default
	if default == nil then default = false end
	state:Set(options.Flag, default)
end

--// ═══════════════════════════════════════════════
--// SECTION: Components — Slider
--// ═══════════════════════════════════════════════

local function CreateSlider(tab, options)
	local theme = tab._library._theme
	local state = tab._library._state

	local container = Instance.new("Frame")
	container.Size = UDim2.new(1, 0, 0, 50)
	container.BackgroundColor3 = theme.Colors.Surface
	container.BorderSizePixel = 0
	container.Parent = tab._container
	Instance.new("UICorner", container).CornerRadius = UDim.new(0, 6)

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, -80, 0, 24)
	title.Position = UDim2.fromOffset(10, 2)
	title.BackgroundTransparency = 1
	title.Text = options.Name
	title.TextColor3 = theme.Colors.Text
	title.Font = theme.Typography.MainFont
	title.TextSize = theme.Typography.BaseSize
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = container

	local valueLabel = Instance.new("TextLabel")
	valueLabel.Size = UDim2.fromOffset(60, 24)
	valueLabel.Position = UDim2.new(1, -70, 0, 2)
	valueLabel.BackgroundTransparency = 1
	valueLabel.Text = tostring(options.Default or options.Min)
	valueLabel.TextColor3 = theme.Colors.Accent
	valueLabel.Font = theme.Typography.MainFont
	valueLabel.TextSize = 13
	valueLabel.TextXAlignment = Enum.TextXAlignment.Right
	valueLabel.Parent = container

	local trackFrame = Instance.new("Frame")
	trackFrame.Size = UDim2.new(1, -20, 0, 6)
	trackFrame.Position = UDim2.fromOffset(10, 34)
	trackFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	trackFrame.BorderSizePixel = 0
	trackFrame.Parent = container
	Instance.new("UICorner", trackFrame).CornerRadius = UDim.new(1, 0)

	local fill = Instance.new("Frame")
	fill.Size = UDim2.fromScale(0, 1)
	fill.BackgroundColor3 = theme.Colors.Accent
	fill.BorderSizePixel = 0
	fill.Parent = trackFrame
	Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

	local dragging = false
	local min, max = options.Min, options.Max

	local function updateSlider(percent)
		percent = math.clamp(percent, 0, 1)
		local value = math.floor(min + (max - min) * percent + 0.5)
		fill.Size = UDim2.fromScale(percent, 1)
		valueLabel.Text = tostring(value)
		state:Set(options.Flag, value)
		if options.Callback then options.Callback(value) end
	end

	trackFrame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			updateSlider((input.Position.X - trackFrame.AbsolutePosition.X) / trackFrame.AbsoluteSize.X)
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			updateSlider((input.Position.X - trackFrame.AbsolutePosition.X) / trackFrame.AbsoluteSize.X)
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)

	local default = options.Default or min
	fill.Size = UDim2.fromScale((default - min) / (max - min), 1)
	valueLabel.Text = tostring(default)
	state:Set(options.Flag, default)
end

--// ═══════════════════════════════════════════════
--// SECTION: Components — Dropdown
--// ═══════════════════════════════════════════════

local function CreateDropdown(tab, options)
	local theme = tab._library._theme
	local state = tab._library._state
	local isOpen = false

	local container = Instance.new("Frame")
	container.Size = UDim2.new(1, 0, 0, 38)
	container.BackgroundColor3 = theme.Colors.Surface
	container.BorderSizePixel = 0
	container.ClipsDescendants = true
	container.Parent = tab._container
	Instance.new("UICorner", container).CornerRadius = UDim.new(0, 6)

	local header = Instance.new("TextButton")
	header.Size = UDim2.new(1, 0, 0, 38)
	header.BackgroundTransparency = 1
	header.Text = ""
	header.Parent = container

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, -80, 1, 0)
	title.Position = UDim2.fromOffset(10, 0)
	title.BackgroundTransparency = 1
	title.Text = options.Name
	title.TextColor3 = theme.Colors.Text
	title.Font = theme.Typography.MainFont
	title.TextSize = theme.Typography.BaseSize
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = header

	local selected = Instance.new("TextLabel")
	selected.Size = UDim2.fromOffset(60, 20)
	selected.Position = UDim2.new(1, -70, 0.5, 0)
	selected.AnchorPoint = Vector2.new(0, 0.5)
	selected.BackgroundTransparency = 1
	selected.Text = options.Default or "..."
	selected.TextColor3 = theme.Colors.Accent
	selected.Font = theme.Typography.MainFont
	selected.TextSize = 12
	selected.TextXAlignment = Enum.TextXAlignment.Right
	selected.Parent = header

	local list = Instance.new("Frame")
	list.Size = UDim2.new(1, -10, 0, 0)
	list.Position = UDim2.fromOffset(5, 40)
	list.BackgroundTransparency = 1
	list.Parent = container

	local layout = Instance.new("UIListLayout")
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Padding = UDim.new(0, 2)
	layout.Parent = list

	for _, item in ipairs(options.List or {}) do
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(1, 0, 0, 26)
		btn.BackgroundColor3 = theme.Colors.Background
		btn.BorderSizePixel = 0
		btn.Text = item
		btn.TextColor3 = theme.Colors.TextDim
		btn.Font = theme.Typography.MainFont
		btn.TextSize = 12
		btn.AutoButtonColor = false
		btn.Parent = list
		Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)

		btn.MouseButton1Click:Connect(function()
			selected.Text = item
			state:Set(options.Flag, item)
			if options.Callback then options.Callback(item) end
			isOpen = false
			Tween(container, { Size = UDim2.new(1, 0, 0, 38) }, "Fast")
		end)
	end

	header.MouseButton1Click:Connect(function()
		isOpen = not isOpen
		local openHeight = 38 + 2 + (#(options.List or {}) * 28)
		Tween(container, { Size = UDim2.new(1, 0, 0, isOpen and openHeight or 38) }, "Fast")
	end)

	if options.Default then state:Set(options.Flag, options.Default) end
end

--// ═══════════════════════════════════════════════
--// SECTION: Components — TextBox
--// ═══════════════════════════════════════════════

local function CreateTextBoxComponent(tab, options)
	local theme = tab._library._theme
	local state = tab._library._state

	local container = Instance.new("Frame")
	container.Size = UDim2.new(1, 0, 0, 60)
	container.BackgroundColor3 = theme.Colors.Surface
	container.BorderSizePixel = 0
	container.Parent = tab._container
	Instance.new("UICorner", container).CornerRadius = UDim.new(0, 6)

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, -20, 0, 20)
	title.Position = UDim2.fromOffset(10, 5)
	title.BackgroundTransparency = 1
	title.Text = options.Name
	title.TextColor3 = theme.Colors.Text
	title.Font = theme.Typography.MainFont
	title.TextSize = theme.Typography.BaseSize
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = container

	local box = Instance.new("TextBox")
	box.Size = UDim2.new(1, -20, 0, 28)
	box.Position = UDim2.fromOffset(10, 27)
	box.BackgroundColor3 = theme.Colors.Background
	box.BorderSizePixel = 0
	box.Text = options.Default or ""
	box.PlaceholderText = options.Placeholder or "Type here..."
	box.PlaceholderColor3 = theme.Colors.TextDim
	box.TextColor3 = theme.Colors.Text
	box.Font = theme.Typography.MainFont
	box.TextSize = theme.Typography.BaseSize
	box.ClearTextOnFocus = false
	box.Parent = container
	Instance.new("UICorner", box).CornerRadius = UDim.new(0, 4)

	box.FocusLost:Connect(function()
		state:Set(options.Flag, box.Text)
		if options.Callback then options.Callback(box.Text) end
	end)
	state:Set(options.Flag, options.Default or "")
end

--// ═══════════════════════════════════════════════
--// SECTION: Components — Keybind
--// ═══════════════════════════════════════════════

local function CreateKeybind(tab, options)
	local theme = tab._library._theme
	local state = tab._library._state
	local binding = false

	local container = Instance.new("TextButton")
	container.Size = UDim2.new(1, 0, 0, 38)
	container.BackgroundColor3 = theme.Colors.Surface
	container.BorderSizePixel = 0
	container.Text = ""
	container.AutoButtonColor = false
	container.Parent = tab._container
	Instance.new("UICorner", container).CornerRadius = UDim.new(0, 6)

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, -80, 1, 0)
	title.Position = UDim2.fromOffset(10, 0)
	title.BackgroundTransparency = 1
	title.Text = options.Name
	title.TextColor3 = theme.Colors.Text
	title.Font = theme.Typography.MainFont
	title.TextSize = theme.Typography.BaseSize
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = container

	local bindLabel = Instance.new("TextLabel")
	bindLabel.Size = UDim2.fromOffset(70, 24)
	bindLabel.Position = UDim2.new(1, -80, 0.5, 0)
	bindLabel.AnchorPoint = Vector2.new(0, 0.5)
	bindLabel.BackgroundColor3 = theme.Colors.Background
	bindLabel.TextColor3 = theme.Colors.Accent
	bindLabel.Font = theme.Typography.MainFont
	bindLabel.TextSize = 12
	bindLabel.Parent = container
	Instance.new("UICorner", bindLabel).CornerRadius = UDim.new(0, 4)

	state:Subscribe(options.Flag, function(key)
		bindLabel.Text = key.Name
	end)

	container.MouseButton1Click:Connect(function()
		binding = true
		bindLabel.Text = "..."
	end)

	UserInputService.InputBegan:Connect(function(input)
		if binding and input.UserInputType == Enum.UserInputType.Keyboard then
			binding = false
			state:Set(options.Flag, input.KeyCode)
			if options.Callback then options.Callback(input.KeyCode) end
		end
	end)

	state:Set(options.Flag, options.Default or Enum.KeyCode.RightControl)
end

--// ═══════════════════════════════════════════════
--// SECTION: Components — Label
--// ═══════════════════════════════════════════════

local function CreateLabel(tab, text)
	local theme = tab._library._theme
	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(1, 0, 0, 20)
	lbl.BackgroundTransparency = 1
	lbl.Text = text
	lbl.TextColor3 = theme.Colors.TextDim
	lbl.Font = theme.Typography.MainFont
	lbl.TextSize = theme.Typography.BaseSize
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.Parent = tab._container
end

--// ═══════════════════════════════════════════════
--// SECTION: Tab System
--// ═══════════════════════════════════════════════

local Tab = {}
Tab.__index = Tab

function Tab.new(window, name)
	local self = setmetatable({}, Tab)
	self._window = window
	self._library = window._library
	self._name = name
	self._container = nil
	self._tabButton = nil
	self:_build()
	return self
end

function Tab:_build()
	local theme = self._library._theme

	local tabBtn = Instance.new("TextButton")
	tabBtn.Size = UDim2.new(1, 0, 0, 32)
	tabBtn.BackgroundTransparency = 1
	tabBtn.BorderSizePixel = 0
	tabBtn.Text = self._name
	tabBtn.TextColor3 = theme.Colors.TextDim
	tabBtn.Font = theme.Typography.MainFont
	tabBtn.TextSize = 13
	tabBtn.AutoButtonColor = false
	tabBtn.Parent = self._window._tabList
	self._tabButton = tabBtn

	local container = Instance.new("ScrollingFrame")
	container.Size = UDim2.fromScale(1, 1)
	container.BackgroundTransparency = 1
	container.BorderSizePixel = 0
	container.ScrollBarThickness = 3
	container.ScrollBarImageColor3 = theme.Colors.Accent
	container.CanvasSize = UDim2.fromScale(0, 0)
	container.AutomaticCanvasSize = Enum.AutomaticSize.Y
	container.Visible = false
	container.Parent = self._window._contentFrame

	local layout = Instance.new("UIListLayout")
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Padding = UDim.new(0, 4)
	layout.Parent = container

	local padding = Instance.new("UIPadding")
	padding.PaddingLeft = UDim.new(0, 6)
	padding.PaddingRight = UDim.new(0, 6)
	padding.PaddingTop = UDim.new(0, 6)
	padding.Parent = container

	self._container = container

	tabBtn.MouseButton1Click:Connect(function()
		self._window:SelectTab(self)
	end)
end

function Tab:Show()
	self._container.Visible = true
	local theme = self._library._theme
	Tween(self._tabButton, { TextColor3 = theme.Colors.Accent, BackgroundTransparency = 0.8 }, "Fast")
end

function Tab:Hide()
	self._container.Visible = false
	local theme = self._library._theme
	Tween(self._tabButton, { TextColor3 = theme.Colors.TextDim, BackgroundTransparency = 1 }, "Fast")
end

function Tab:CreateSection(name) CreateSection(self, name) end
function Tab:CreateButton(options) CreateButton(self, options) end
function Tab:CreateToggle(options) CreateToggle(self, options) end
function Tab:CreateSlider(options) CreateSlider(self, options) end
function Tab:CreateDropdown(options) CreateDropdown(self, options) end
function Tab:CreateTextBox(options) CreateTextBoxComponent(self, options) end
function Tab:CreateKeybind(options) CreateKeybind(self, options) end
function Tab:CreateLabel(text) CreateLabel(self, text) end

--// ═══════════════════════════════════════════════
--// SECTION: Window System
--// ═══════════════════════════════════════════════

local Window = {}
Window.__index = Window

function Window.new(library, options)
	local self = setmetatable({}, Window)
	self._library = library
	self._options = options
	self._tabs = {}
	self._selectedTab = nil
	self._tabList = nil
	self._contentFrame = nil
	self._gui = nil
	self:_build()
	return self
end

function Window:_build()
	local theme = self._library._theme

	local gui = Instance.new("ScreenGui")
	gui.Name = "BloxBoxWindow"
	gui.ResetOnSpawn = false
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	pcall(function() gui.Parent = game:GetService("CoreGui") end)
	if not gui.Parent then gui.Parent = Player:WaitForChild("PlayerGui") end
	self._gui = gui

	local size = self._options.Size or UDim2.fromOffset(600, 400)

	local main = Instance.new("Frame")
	main.Name = "Main"
	main.Size = size
	main.Position = self._options.Position or UDim2.fromScale(0.5, 0.5)
	main.AnchorPoint = Vector2.new(0.5, 0.5)
	main.BackgroundColor3 = theme.Colors.Background
	main.BorderSizePixel = 0
	main.Parent = gui
	Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)

	local stroke = Instance.new("UIStroke")
	stroke.Color = theme.Colors.Border
	stroke.Thickness = 1
	stroke.Transparency = 0.5
	stroke.Parent = main

	-- Header
	local header = Instance.new("Frame")
	header.Size = UDim2.new(1, 0, 0, 36)
	header.BackgroundColor3 = theme.Colors.Surface
	header.BorderSizePixel = 0
	header.Parent = main
	Instance.new("UICorner", header).CornerRadius = UDim.new(0, 10)

	local headerFix = Instance.new("Frame")
	headerFix.Size = UDim2.new(1, 0, 0, 12)
	headerFix.Position = UDim2.new(0, 0, 1, -12)
	headerFix.BackgroundColor3 = theme.Colors.Surface
	headerFix.BorderSizePixel = 0
	headerFix.Parent = header

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Size = UDim2.new(1, -80, 1, 0)
	titleLabel.Position = UDim2.fromOffset(12, 0)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = self._options.Title or "BloxBox Window"
	titleLabel.TextColor3 = theme.Colors.Text
	titleLabel.Font = theme.Typography.HeaderFont
	titleLabel.TextSize = theme.Typography.HeaderSize
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.Parent = header

	-- Close button
	local closeBtn = Instance.new("TextButton")
	closeBtn.Size = UDim2.fromOffset(28, 28)
	closeBtn.Position = UDim2.new(1, -34, 0.5, 0)
	closeBtn.AnchorPoint = Vector2.new(0, 0.5)
	closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
	closeBtn.BackgroundTransparency = 0.8
	closeBtn.Text = "X"
	closeBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
	closeBtn.Font = Enum.Font.GothamBold
	closeBtn.TextSize = 14
	closeBtn.BorderSizePixel = 0
	closeBtn.AutoButtonColor = false
	closeBtn.Parent = header
	Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

	closeBtn.MouseButton1Click:Connect(function()
		self:Destroy()
	end)

	-- Sidebar
	local sidebar = Instance.new("Frame")
	sidebar.Size = UDim2.new(0, 130, 1, -36)
	sidebar.Position = UDim2.fromOffset(0, 36)
	sidebar.BackgroundColor3 = theme.Colors.Surface
	sidebar.BackgroundTransparency = 0.5
	sidebar.BorderSizePixel = 0
	sidebar.Parent = main

	local sidebarLayout = Instance.new("UIListLayout")
	sidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
	sidebarLayout.Padding = UDim.new(0, 2)
	sidebarLayout.Parent = sidebar

	local sidebarPadding = Instance.new("UIPadding")
	sidebarPadding.PaddingTop = UDim.new(0, 6)
	sidebarPadding.PaddingLeft = UDim.new(0, 4)
	sidebarPadding.PaddingRight = UDim.new(0, 4)
	sidebarPadding.Parent = sidebar

	self._tabList = sidebar

	-- Content area
	local contentFrame = Instance.new("Frame")
	contentFrame.Size = UDim2.new(1, -130, 1, -36)
	contentFrame.Position = UDim2.fromOffset(130, 36)
	contentFrame.BackgroundTransparency = 1
	contentFrame.BorderSizePixel = 0
	contentFrame.Parent = main
	self._contentFrame = contentFrame

	-- Drag
	CreateDrag(header, main)

	-- Entrance animation
	main.BackgroundTransparency = 1
	titleLabel.TextTransparency = 1
	Tween(main, { BackgroundTransparency = 0 }, "Normal")
	Tween(titleLabel, { TextTransparency = 0 }, "Normal")
end

function Window:CreateTab(name)
	local tab = Tab.new(self, name)
	table.insert(self._tabs, tab)
	if #self._tabs == 1 then self:SelectTab(tab) end
	return tab
end

function Window:SelectTab(tab)
	for _, t in ipairs(self._tabs) do t:Hide() end
	tab:Show()
	self._selectedTab = tab
end

function Window:Destroy()
	if self._gui then self._gui:Destroy() end
end

--// ═══════════════════════════════════════════════
--// SECTION: Main Library (Public API)
--// ═══════════════════════════════════════════════

local BloxBoxUI = {}
BloxBoxUI.__index = BloxBoxUI

function BloxBoxUI.new()
	local self = setmetatable({}, BloxBoxUI)
	self._theme = DefaultTheme
	self._state = StateManager.new()
	self._config = ConfigManager.new(self._state)
	return self
end

function BloxBoxUI:SetAccent(color)
	self._theme.Colors.Accent = color
end

function BloxBoxUI:ShowIntro()
	ShowIntro(self._theme)
end

function BloxBoxUI:CreateWindow(options)
	return Window.new(self, options)
end

function BloxBoxUI:Notify(options)
	ShowNotification(options)
end

function BloxBoxUI:SaveConfig(name)
	self._config:Save(name)
end

function BloxBoxUI:LoadConfig(name)
	self._config:Load(name)
end

print("[BloxBox UI] v1.02.0 loaded successfully")
return BloxBoxUI
