--!strict
local BaseComponent = require(script.Parent.BaseComponent)
local Types = require(script.Parent.Parent.Types.ComponentTypes)

local TextBox = setmetatable({}, BaseComponent)
TextBox.__index = TextBox

function TextBox.new(tab: any, options: Types.TextBoxOptions)
	local self = setmetatable(BaseComponent.new(tab.Library), TextBox)
	self.Tab = tab
	self.Options = options
	self:_mount()
	return self
end

function TextBox:_mount()
	local theme = self.Library.Theme:GetTheme()
	local state = self.Library.State
	
	local container = Instance.new("Frame")
	container.Size = UDim2.new(1, 0, 0, 60)
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

	local box = Instance.new("TextBox")
	box.Size = UDim2.new(1, -20, 0, 28)
	box.Position = UDim2.fromOffset(10, 27)
	box.BackgroundColor3 = theme.Colors.Background
	box.BorderSizePixel = 0
	box.Text = self.Options.Default or ""
	box.PlaceholderText = self.Options.Placeholder or "Type here..."
	box.PlaceholderColor3 = theme.Colors.TextDim
	box.TextColor3 = theme.Colors.Text
	box.Font = theme.Typography.MainFont
	box.TextSize = theme.Typography.BaseSize
	box.ClearTextOnFocus = false
	box.Parent = container
	Instance.new("UICorner", box).CornerRadius = UDim.new(0, 4)

	box.FocusLost:Connect(function()
		state:Set(self.Options.Flag, box.Text)
		self.Options.Callback(box.Text)
	end)
	
	state:Set(self.Options.Flag, self.Options.Default or "")
end

return TextBox
