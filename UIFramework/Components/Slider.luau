-- BloxBox UI: Slider (Executor Compatible)
local BaseComponent = require(script.Parent.BaseComponent)
local AnimationEngine = require(script.Parent.Parent.Core.AnimationEngine)

local Slider = setmetatable({}, BaseComponent)
Slider.__index = Slider

function Slider.new(tab, options)
	local self = setmetatable(BaseComponent.new(tab.Library), Slider)
	self.Tab = tab
	self.Options = options
	self:_mount()
	return self
end

function Slider:_mount()
	local theme = self.Library.Theme:GetTheme()
	local state = self.Library.State
	
	local container = Instance.new("Frame")
	container.Size = UDim2.new(1, 0, 0, 50)
	container.BackgroundColor3 = theme.Colors.Surface
	container.BorderSizePixel = 0
	container.Parent = self.Tab.Container
	Instance.new("UICorner", container).CornerRadius = UDim.new(0, 6)

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, -80, 0, 24)
	title.Position = UDim2.fromOffset(10, 2)
	title.BackgroundTransparency = 1
	title.Text = self.Options.Name
	title.TextColor3 = theme.Colors.Text
	title.Font = theme.Typography.MainFont
	title.TextSize = theme.Typography.BaseSize
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = container

	local valueLabel = Instance.new("TextLabel")
	valueLabel.Size = UDim2.fromOffset(60, 24)
	valueLabel.Position = UDim2.new(1, -70, 0, 2)
	valueLabel.BackgroundTransparency = 1
	valueLabel.Text = tostring(self.Options.Default or self.Options.Min)
	valueLabel.TextColor3 = theme.Colors.Accent
	valueLabel.Font = theme.Typography.MainFont
	valueLabel.TextSize = 13
	valueLabel.TextXAlignment = Enum.TextXAlignment.Right
	valueLabel.Parent = container

	local track = Instance.new("Frame")
	track.Size = UDim2.new(1, -20, 0, 6)
	track.Position = UDim2.new(0, 10, 0, 34)
	track.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	track.BorderSizePixel = 0
	track.Parent = container
	Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

	local fill = Instance.new("Frame")
	fill.Size = UDim2.fromScale(0, 1)
	fill.BackgroundColor3 = theme.Colors.Accent
	fill.BorderSizePixel = 0
	fill.Parent = track
	Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

	-- Slider drag logic
	local dragging = false
	local min = self.Options.Min
	local max = self.Options.Max

	local function updateSlider(percent)
		percent = math.clamp(percent, 0, 1)
		local value = math.floor(min + (max - min) * percent + 0.5)
		fill.Size = UDim2.fromScale(percent, 1)
		valueLabel.Text = tostring(value)
		state:Set(self.Options.Flag, value)
		if self.Options.Callback then
			self.Options.Callback(value)
		end
	end

	track.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			local percent = (input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X
			updateSlider(percent)
		end
	end)

	game:GetService("UserInputService").InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local percent = (input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X
			updateSlider(percent)
		end
	end)

	game:GetService("UserInputService").InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)

	-- Default
	local default = self.Options.Default or min
	local defaultPercent = (default - min) / (max - min)
	fill.Size = UDim2.fromScale(defaultPercent, 1)
	valueLabel.Text = tostring(default)
	state:Set(self.Options.Flag, default)
end

return Slider
