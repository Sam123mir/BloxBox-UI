-- BloxBox UI: Toggle (Executor Compatible)
local BaseComponent = require(script.Parent.BaseComponent)
local AnimationEngine = require(script.Parent.Parent.Core.AnimationEngine)

local Toggle = setmetatable({}, BaseComponent)
Toggle.__index = Toggle

function Toggle.new(tab, options)
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
			AnimationEngine:Tween(knob, { Position = UDim2.fromOffset(20, 2), BackgroundColor3 = Color3.fromRGB(255, 255, 255) }, "Fast")
			AnimationEngine:Tween(track, { BackgroundColor3 = theme.Colors.Accent }, "Fast")
		else
			AnimationEngine:Tween(knob, { Position = UDim2.fromOffset(2, 2), BackgroundColor3 = Color3.fromRGB(200, 200, 200) }, "Fast")
			AnimationEngine:Tween(track, { BackgroundColor3 = Color3.fromRGB(60, 60, 60) }, "Fast")
		end
	end

	self.Maid:GiveTask(state:Subscribe(self.Options.Flag, function(val)
		updateVisual(val)
		if self.Options.Callback then
			self.Options.Callback(val)
		end
	end))

	container.MouseButton1Click:Connect(function()
		local current = state:Get(self.Options.Flag, false)
		state:Set(self.Options.Flag, not current)
	end)

	-- Set default
	local default = self.Options.Default
	if default == nil then default = false end
	state:Set(self.Options.Flag, default)
end

return Toggle
