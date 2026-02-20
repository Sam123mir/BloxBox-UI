-- BloxBox UI: Dropdown (Executor Compatible)
local BaseComponent = require(script.Parent.BaseComponent)
local AnimationEngine = require(script.Parent.Parent.Core.AnimationEngine)

local Dropdown = setmetatable({}, BaseComponent)
Dropdown.__index = Dropdown

function Dropdown.new(tab, options)
	local self = setmetatable(BaseComponent.new(tab.Library), Dropdown)
	self.Tab = tab
	self.Options = options
	self:_mount()
	return self
end

function Dropdown:_mount()
	local theme = self.Library.Theme:GetTheme()
	local state = self.Library.State
	local isOpen = false
	
	local container = Instance.new("Frame")
	container.Size = UDim2.new(1, 0, 0, 38)
	container.BackgroundColor3 = theme.Colors.Surface
	container.BorderSizePixel = 0
	container.ClipsDescendants = true
	container.Parent = self.Tab.Container
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
	title.Text = self.Options.Name
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
	selected.Text = self.Options.Default or "..."
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

	for _, item in ipairs(self.Options.List or {}) do
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
			state:Set(self.Options.Flag, item)
			if self.Options.Callback then
				self.Options.Callback(item)
			end
			isOpen = false
			AnimationEngine:Tween(container, { Size = UDim2.new(1, 0, 0, 38) }, "Fast")
		end)
	end

	header.MouseButton1Click:Connect(function()
		isOpen = not isOpen
		local items = #(self.Options.List or {})
		local openHeight = 38 + 2 + (items * 28)
		AnimationEngine:Tween(container, { Size = UDim2.new(1, 0, 0, isOpen and openHeight or 38) }, "Fast")
	end)

	if self.Options.Default then
		state:Set(self.Options.Flag, self.Options.Default)
	end
end

return Dropdown
