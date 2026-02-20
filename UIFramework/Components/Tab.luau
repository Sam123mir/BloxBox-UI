-- BloxBox UI: Tab (Executor Compatible)
local BaseComponent = require(script.Parent.BaseComponent)
local AnimationEngine = require(script.Parent.Parent.Core.AnimationEngine)

local Tab = setmetatable({}, BaseComponent)
Tab.__index = Tab

function Tab.new(window, name)
	local self = setmetatable(BaseComponent.new(window.Library), Tab)
	self.Window = window
	self.TabName = name
	self.Container = nil
	self.TabButton = nil
	self:_mount()
	return self
end

function Tab:_mount()
	local theme = self.Library.Theme:GetTheme()

	-- Botón de pestaña en la sidebar
	local tabBtn = Instance.new("TextButton")
	tabBtn.Size = UDim2.new(1, 0, 0, 32)
	tabBtn.BackgroundColor3 = theme.Colors.Surface
	tabBtn.BackgroundTransparency = 1
	tabBtn.BorderSizePixel = 0
	tabBtn.Text = self.TabName
	tabBtn.TextColor3 = theme.Colors.TextDim
	tabBtn.Font = theme.Typography.MainFont
	tabBtn.TextSize = 13
	tabBtn.AutoButtonColor = false
	tabBtn.Parent = self.Window.TabList
	self.TabButton = tabBtn

	-- Contenedor de contenido
	local container = Instance.new("ScrollingFrame")
	container.Size = UDim2.fromScale(1, 1)
	container.BackgroundTransparency = 1
	container.BorderSizePixel = 0
	container.ScrollBarThickness = 3
	container.ScrollBarImageColor3 = theme.Colors.Accent
	container.CanvasSize = UDim2.fromScale(0, 0)
	container.AutomaticCanvasSize = Enum.AutomaticSize.Y
	container.Visible = false
	container.Parent = self.Window.ContentFrame

	local layout = Instance.new("UIListLayout")
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Padding = UDim.new(0, 4)
	layout.Parent = container

	local padding = Instance.new("UIPadding")
	padding.PaddingLeft = UDim.new(0, 6)
	padding.PaddingRight = UDim.new(0, 6)
	padding.PaddingTop = UDim.new(0, 6)
	padding.Parent = container

	self.Container = container

	tabBtn.MouseButton1Click:Connect(function()
		self.Window:SelectTab(self)
	end)
end

function Tab:Show()
	self.Container.Visible = true
	local theme = self.Library.Theme:GetTheme()
	AnimationEngine:Tween(self.TabButton, { TextColor3 = theme.Colors.Accent, BackgroundTransparency = 0.8 }, "Fast")
end

function Tab:Hide()
	self.Container.Visible = false
	local theme = self.Library.Theme:GetTheme()
	AnimationEngine:Tween(self.TabButton, { TextColor3 = theme.Colors.TextDim, BackgroundTransparency = 1 }, "Fast")
end

-- Component creation methods
function Tab:CreateButton(options)
	local Button = require(script.Parent.Button)
	return Button.new(self, options)
end

function Tab:CreateToggle(options)
	local ToggleModule = require(script.Parent.Toggle)
	return ToggleModule.new(self, options)
end

function Tab:CreateSlider(options)
	local SliderModule = require(script.Parent.Slider)
	return SliderModule.new(self, options)
end

function Tab:CreateDropdown(options)
	local DropdownModule = require(script.Parent.Dropdown)
	return DropdownModule.new(self, options)
end

function Tab:CreateKeybind(options)
	local KeybindModule = require(script.Parent.Keybind)
	return KeybindModule.new(self, options)
end

function Tab:CreateTextBox(options)
	local TextBoxModule = require(script.Parent.TextBox)
	return TextBoxModule.new(self, options)
end

function Tab:CreateLabel(text)
	local LabelModule = require(script.Parent.Label)
	return LabelModule.new(self, text)
end

function Tab:CreateSection(name)
	local SectionModule = require(script.Parent.Section)
	return SectionModule.new(self, name)
end

return Tab
