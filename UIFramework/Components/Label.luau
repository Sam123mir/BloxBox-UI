-- BloxBox UI: Label (Executor Compatible)
local BaseComponent = require(script.Parent.BaseComponent)

local Label = setmetatable({}, BaseComponent)
Label.__index = Label

function Label.new(tab, text)
	local self = setmetatable(BaseComponent.new(tab.Library), Label)
	self.Tab = tab
	self.Text = text
	self:_mount()
	return self
end

function Label:_mount()
	local theme = self.Library.Theme:GetTheme()
	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(1, 0, 0, 20)
	lbl.BackgroundTransparency = 1
	lbl.Text = self.Text
	lbl.TextColor3 = theme.Colors.TextDim
	lbl.Font = theme.Typography.MainFont
	lbl.TextSize = theme.Typography.BaseSize
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.Parent = self.Tab.Container
end

return Label
