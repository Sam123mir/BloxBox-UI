--!strict
local BaseComponent = require(script.Parent.BaseComponent)
local Core = script.Parent.Parent.Core
local AnimationEngine = require(Core.AnimationEngine)
local Types = require(script.Parent.Parent.Types.ComponentTypes)

local Toggle = setmetatable({}, BaseComponent)
Toggle.__index = Toggle

function Toggle.new(tab: any, options: Types.ToggleOptions)
	local self = setmetatable(BaseComponent.new(tab.Library), Toggle)
	self.Tab = tab
	self.Options = options
	self:_mount()
	return self
end

function Toggle:_mount()
	local theme = self.Library.Theme:GetTheme()
	local state = self.Library.State
	
	local container = Instance.new("TextButton")
	container.Size = UDim2.new(1, 0, 0, 38)
	container.BackgroundColor3 = theme.Colors.Surface
	container.BorderSizePixel = 0
	container.Text = ""
	container.AutoButtonColor = false
	container.Parent = self.Tab.Container

	Instance.new("UICorner", container).CornerRadius = UDim.new(0, 6)

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, -60, 1, 0)
	title.Position = UDim2.fromOffset(10, 0)
	title.BackgroundTransparency = 1
	title.Text = self.Options.Name
	title.TextColor3 = theme.Colors.Text
	title.Parent = container

	local track = Instance.new("Frame")
	track.Size = UDim2.fromOffset(36, 18)
	track.Position = UDim2.new(1, -46, 0.5, 0)
	track.AnchorPoint = Vector2.new(0, 0.5)
	track.BackgroundColor3 = theme.Colors.Background
	track.Parent = container
	Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

	local knob = Instance.new("Frame")
	knob.Size = UDim2.fromOffset(14, 14)
	knob.Position = UDim2.fromOffset(2, 2)
	knob.BackgroundColor3 = theme.Colors.TextDim
	knob.Parent = track
	Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

	local function updateVisual(val)
		if val then
			AnimationEngine:Tween(track, { BackgroundColor3 = theme.Colors.Accent }, "Fast")
			AnimationEngine:Tween(knob, { 
				Position = UDim2.fromScale(1, 0.5), 
				AnchorPoint = Vector2.new(1.1, 0.5),
				BackgroundColor3 = Color3.new(1, 1, 1) 
			}, "Fast")
		else
			AnimationEngine:Tween(track, { BackgroundColor3 = theme.Colors.Background }, "Fast")
			AnimationEngine:Tween(knob, { 
				Position = UDim2.fromScale(0, 0.5), 
				AnchorPoint = Vector2.new(-0.1, 0.5),
				BackgroundColor3 = theme.Colors.TextDim 
			}, "Fast")
		end
	end

	self.Maid:GiveTask(state:Subscribe(self.Options.Flag, function(val)
		updateVisual(val)
		self.Options.Callback(val)
	end))

	container.MouseButton1Down:Connect(function()
		AnimationEngine:Tween(container, { BackgroundTransparency = 0.5 }, "Fast")
	end)

	container.MouseButton1Up:Connect(function()
		AnimationEngine:Tween(container, { BackgroundTransparency = 0 }, "Fast")
		state:Set(self.Options.Flag, not state:Get(self.Options.Flag, false))
	end)
	
	state:Set(self.Options.Flag, self.Options.Default or false)
end

return Toggle
