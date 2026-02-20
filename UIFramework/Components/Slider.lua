--!strict
local UserInputService = game:GetService("UserInputService")
local BaseComponent = require(script.Parent.BaseComponent)
local Core = script.Parent.Parent.Core
local AnimationEngine = require(Core.AnimationEngine)
local Types = require(script.Parent.Parent.Types.ComponentTypes)

local Slider = setmetatable({}, BaseComponent)
Slider.__index = Slider

function Slider.new(tab: any, options: Types.SliderOptions)
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
	container.Size = UDim2.new(1, 0, 0, 45)
	container.BackgroundColor3 = theme.Colors.Surface
	container.BorderSizePixel = 0
	container.Parent = self.Tab.Container

	Instance.new("UICorner", container).CornerRadius = UDim.new(0, 6)

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, -20, 0, 20)
	title.Position = UDim2.fromOffset(10, 5)
	title.BackgroundTransparency = 1
	title.Text = self.Options.Name
	title.TextColor3 = theme.Colors.Text
	title.Parent = container

	local valLabel = Instance.new("TextLabel")
	valLabel.Size = UDim2.new(0, 40, 0, 20)
	valLabel.Position = UDim2.new(1, -50, 0, 5)
	valLabel.BackgroundTransparency = 1
	valLabel.TextColor3 = theme.Colors.Accent
	valLabel.Parent = container

	local track = Instance.new("TextButton")
	track.Size = UDim2.new(1, -20, 0, 4)
	track.Position = UDim2.fromOffset(10, 32)
	track.BackgroundColor3 = theme.Colors.Background
	track.BorderSizePixel = 0
	track.Text = ""
	track.AutoButtonColor = false
	track.Parent = container
	
	local fill = Instance.new("Frame")
	fill.Size = UDim2.fromScale(0, 1)
	fill.BackgroundColor3 = theme.Colors.Accent
	fill.BorderSizePixel = 0
	fill.Parent = track

	local function setValue(pos)
		local val = self.Options.Min + (self.Options.Max - self.Options.Min) * pos
		if self.Options.Decimals then
			val = math.floor(val * (10 ^ self.Options.Decimals) + 0.5) / (10 ^ self.Options.Decimals)
		else
			val = math.floor(val + 0.5)
		end
		state:Set(self.Options.Flag, val)
	end

	local function updateVisual(val)
		local percent = (val - self.Options.Min) / (self.Options.Max - self.Options.Min)
		fill.Size = UDim2.fromScale(percent, 1)
		valLabel.Text = tostring(val)
		self.Options.Callback(val)
	end

	self.Maid:GiveTask(state:Subscribe(self.Options.Flag, updateVisual))

	local dragging = false
	
	local function setDragging(val)
		dragging = val
		if val then
			AnimationEngine:Tween(container, { BackgroundColor3 = theme.Colors.Border, BackgroundTransparency = 0.5 }, "Fast")
			AnimationEngine:Tween(fill, { BackgroundColor3 = Color3.new(1,1,1) }, "Fast")
		else
			AnimationEngine:Tween(container, { BackgroundColor3 = theme.Colors.Surface, BackgroundTransparency = 0 }, "Fast")
			AnimationEngine:Tween(fill, { BackgroundColor3 = theme.Colors.Accent }, "Fast")
		end
	end

	track.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			setDragging(true)
		end
	end)
	self.Maid:GiveTask(UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			setDragging(false)
		end
	end))
	self.Maid:GiveTask(UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local pos = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
			setValue(pos)
		end
	end))

	state:Set(self.Options.Flag, self.Options.Default or self.Options.Min)
end

return Slider
