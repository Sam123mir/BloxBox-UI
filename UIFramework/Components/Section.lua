--!strict
local BaseComponent = require(script.Parent.BaseComponent)
local Core = script.Parent.Parent.Core
local AnimationEngine = require(Core.AnimationEngine)

local Section = setmetatable({}, BaseComponent)
Section.__index = Section

function Section.new(tab: any, name: string)
	local self = setmetatable(BaseComponent.new(tab.Library), Section)
	self.Tab = tab
	self.Name = name
	self.Open = true
	self:_mount()
	return self
end

function Section:_mount()
	local theme = self.Library.Theme:GetTheme()
	
	local container = Instance.new("Frame")
	container.Size = UDim2.new(1, 0, 0, 30)
	container.BackgroundTransparency = 1
	container.ClipsDescendants = true
	container.Parent = self.Tab.Container

	local header = Instance.new("TextButton")
	header.Size = UDim2.new(1, 0, 0, 30)
	header.BackgroundTransparency = 1
	header.Text = ""
	header.Parent = container

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, -20, 1, 0)
	title.BackgroundTransparency = 1
	title.Text = self.Name:upper()
	title.TextColor3 = theme.Colors.Accent
	title.Font = Enum.Font.InterBold
	title.TextSize = 12
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = header

	local content = Instance.new("Frame")
	content.Size = UDim2.new(1, 0, 0, 0)
	content.Position = UDim2.fromOffset(0, 30)
	content.BackgroundTransparency = 1
	content.Parent = container
	self.Content = content
	
	local list = Instance.new("UIListLayout", content)
	list.Padding = UDim.new(0, 5)

	self.Maid:GiveTask(list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		if self.Open then
			container.Size = UDim2.new(1, 0, 0, list.AbsoluteContentSize.Y + 35)
			content.Size = UDim2.new(1, 0, 0, list.AbsoluteContentSize.Y)
		end
	end))

	header.MouseButton1Click:Connect(function()
		self.Open = not self.Open
		local targetSize = self.Open and (list.AbsoluteContentSize.Y + 35) or 30
		AnimationEngine:Tween(container, { Size = UDim2.new(1, 0, 0, targetSize) }, "Fast")
	end)
end

-- Child factories for section
function Section:CreateButton(options) return require(script.Parent.Button).new(self, options) end
function Section:CreateToggle(options) return require(script.Parent.Toggle).new(self, options) end
-- ... etc (simplificado para el ejemplo)

return Section
