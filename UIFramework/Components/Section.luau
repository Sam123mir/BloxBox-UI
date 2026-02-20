-- BloxBox UI: Section (Executor Compatible)
local BaseComponent = require(script.Parent.BaseComponent)
local AnimationEngine = require(script.Parent.Parent.Core.AnimationEngine)

local Section = setmetatable({}, BaseComponent)
Section.__index = Section

function Section.new(tab, name)
	local self = setmetatable(BaseComponent.new(tab.Library), Section)
	self.Tab = tab
	self.SectionName = name
	self:_mount()
	return self
end

function Section:_mount()
	local theme = self.Library.Theme:GetTheme()

	local container = Instance.new("Frame")
	container.Size = UDim2.new(1, 0, 0, 28)
	container.BackgroundTransparency = 1
	container.Parent = self.Tab.Container

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
	label.BackgroundTransparency = 0
	label.Text = "  " .. self.SectionName .. "  "
	label.TextColor3 = theme.Colors.TextDim
	label.Font = theme.Typography.HeaderFont
	label.TextSize = 12
	label.Parent = container
end

return Section
