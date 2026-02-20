--!strict
local UserInputService = game:GetService("UserInputService")
local BaseComponent = require(script.Parent.BaseComponent)
local Types = require(script.Parent.Parent.Types.ComponentTypes)

local Keybind = setmetatable({}, BaseComponent)
Keybind.__index = Keybind

function Keybind.new(tab: any, options: Types.KeybindOptions)
	local self = setmetatable(BaseComponent.new(tab.Library), Keybind)
	self.Tab = tab
	self.Options = options
	self.Binding = false
	self:_mount()
	return self
end

function Keybind:_mount()
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
	title.Size = UDim2.new(1, -80, 1, 0)
	title.Position = UDim2.fromOffset(10, 0)
	title.BackgroundTransparency = 1
	title.Text = self.Options.Name
	title.TextColor3 = theme.Colors.Text
	title.Parent = container

	local bindLabel = Instance.new("TextLabel")
	bindLabel.Size = UDim2.fromOffset(70, 24)
	bindLabel.Position = UDim2.new(1, -80, 0.5, 0)
	bindLabel.AnchorPoint = Vector2.new(0, 0.5)
	bindLabel.BackgroundColor3 = theme.Colors.Background
	bindLabel.TextColor3 = theme.Colors.Accent
	bindLabel.Parent = container
	Instance.new("UICorner", bindLabel).CornerRadius = UDim.new(0, 4)

	local function updateBind(key)
		bindLabel.Text = key.Name
		self.Options.Callback(key)
	end

	self.Maid:GiveTask(state:Subscribe(self.Options.Flag, updateBind))

	container.MouseButton1Click:Connect(function()
		self.Binding = true
		bindLabel.Text = "..."
	end)

	self.Maid:GiveTask(UserInputService.InputBegan:Connect(function(input)
		if self.Binding and input.UserInputType == Enum.UserInputType.Keyboard then
			self.Binding = false
			state:Set(self.Options.Flag, input.KeyCode)
		end
	end))
	
	state:Set(self.Options.Flag, self.Options.Default or Enum.KeyCode.RightControl)
end

return Keybind
