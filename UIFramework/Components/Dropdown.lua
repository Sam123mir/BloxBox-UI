--!strict
local BaseComponent = require(script.Parent.BaseComponent)
local Core = script.Parent.Parent.Core
local AnimationEngine = require(Core.AnimationEngine)
local Types = require(script.Parent.Parent.Types.ComponentTypes)

local Dropdown = setmetatable({}, BaseComponent)
Dropdown.__index = Dropdown

function Dropdown.new(tab: any, options: Types.DropdownOptions)
	local self = setmetatable(BaseComponent.new(tab.Library), Dropdown)
	self.Tab = tab
	self.Options = options
	self.Open = false
	self:_mount()
	return self
end

function Dropdown:_mount()
	local theme = self.Library.Theme:GetTheme()
	local state = self.Library.State
	
	local container = Instance.new("Frame")
	container.Size = UDim2.new(1, 0, 0, 38)
	container.BackgroundColor3 = theme.Colors.Surface
	container.BorderSizePixel = 0
	container.ClipsDescendants = true
	container.Parent = self.Tab.Container
	self.Instance = container

	Instance.new("UICorner", container).CornerRadius = UDim.new(0, 6)

	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 0, 38)
	btn.BackgroundTransparency = 1
	btn.Text = ""
	btn.Parent = container

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, -40, 1, 0)
	title.Position = UDim2.fromOffset(10, 0)
	title.BackgroundTransparency = 1
	title.Text = self.Options.Name
	title.TextColor3 = theme.Colors.Text
	title.Parent = btn

	local selectedLabel = Instance.new("TextLabel")
	selectedLabel.Size = UDim2.new(0, 100, 1, 0)
	selectedLabel.Position = UDim2.new(1, -110, 0, 0)
	selectedLabel.BackgroundTransparency = 1
	selectedLabel.TextColor3 = theme.Colors.Accent
	selectedLabel.Parent = btn

	local list = Instance.new("Frame")
	list.Size = UDim2.new(1, -10, 0, 0)
	list.Position = UDim2.fromOffset(5, 40)
	list.BackgroundTransparency = 1
	list.Parent = container
	local listLayout = Instance.new("UIListLayout", list)
	listLayout.Padding = UDim.new(0, 2)

	for _, item in ipairs(self.Options.List) do
		local itemBtn = Instance.new("TextButton")
		itemBtn.Size = UDim2.new(1, 0, 0, 28)
		itemBtn.BackgroundColor3 = theme.Colors.Background
		itemBtn.BorderSizePixel = 0
		itemBtn.Text = item
		itemBtn.TextColor3 = theme.Colors.TextDim
		itemBtn.Parent = list
		Instance.new("UICorner", itemBtn).CornerRadius = UDim.new(0, 4)
		itemBtn.MouseButton1Click:Connect(function()
			state:Set(self.Options.Flag, item)
			self:Toggle()
		end)
	end

	function self:Toggle()
		self.Open = not self.Open
		local targetSize = self.Open and (42 + (#self.Options.List * 30)) or 38
		AnimationEngine:Tween(container, { Size = UDim2.new(1, 0, 0, targetSize) }, "Normal")
	end

	btn.MouseButton1Click:Connect(function() self:Toggle() end)

	self.Maid:GiveTask(state:Subscribe(self.Options.Flag, function(val)
		selectedLabel.Text = val
		self.Options.Callback(val)
	end))
	
	state:Set(self.Options.Flag, self.Options.Default or self.Options.List[1])
end

return Dropdown
