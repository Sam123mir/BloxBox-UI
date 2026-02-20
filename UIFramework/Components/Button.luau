--!strict
local BaseComponent = require(script.Parent.BaseComponent)
local Core = script.Parent.Parent.Core
local AnimationEngine = require(Core.AnimationEngine)
local Types = require(script.Parent.Parent.Types.ComponentTypes)

local Button = setmetatable({}, BaseComponent)
Button.__index = Button

function Button.new(tab: any, options: Types.ButtonOptions)
	local self = setmetatable(BaseComponent.new(tab.Library), Button)
	self.Tab = tab
	self.Options = options
	self:_mount()
	return self
end

function Button:_mount()
	local theme = self.Library.Theme:GetTheme()
	local btn = Instance.new("TextButton")
	btn.Name = self.Options.Name
	btn.Size = UDim2.new(1, 0, 0, 38)
	btn.BackgroundColor3 = theme.Colors.Surface
	btn.BorderSizePixel = 0
	btn.Text = ""
	btn.AutoButtonColor = false
	btn.Parent = self.Tab.Container
	self.Instance = btn

	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, -20, 1, 0)
	title.Position = UDim2.fromOffset(10, 0)
	title.BackgroundTransparency = 1
	title.Text = self.Options.Name
	title.TextColor3 = theme.Colors.Text
	title.Font = theme.Typography.MainFont
	title.TextSize = theme.Typography.BaseSize
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = btn

	btn.MouseEnter:Connect(function()
		AnimationEngine:Tween(btn, { BackgroundColor3 = theme.Colors.Border, BackgroundTransparency = 0.5 }, "Fast")
	end)
	btn.MouseLeave:Connect(function()
		AnimationEngine:Tween(btn, { BackgroundColor3 = theme.Colors.Surface, BackgroundTransparency = 0 }, "Fast")
	end)

	btn.MouseButton1Down:Connect(function()
		AnimationEngine:Tween(btn, { Size = UDim2.new(1, -4, 0, 34) }, "Fast")
	end)
	
	btn.MouseButton1Up:Connect(function()
		AnimationEngine:Tween(btn, { Size = UDim2.new(1, 0, 0, 38) }, "Fast")
		self.Options.Callback()
	end)
end

return Button
