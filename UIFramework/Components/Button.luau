-- BloxBox UI: Button (Executor Compatible)
local BaseComponent = require(script.Parent.BaseComponent)
local AnimationEngine = require(script.Parent.Parent.Core.AnimationEngine)

local Button = setmetatable({}, BaseComponent)
Button.__index = Button

function Button.new(tab, options)
	local self = setmetatable(BaseComponent.new(tab.Library), Button)
	self.Tab = tab
	self.Options = options
	self:_mount()
	return self
end

function Button:_mount()
	local theme = self.Library.Theme:GetTheme()
	
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 0, 34)
	btn.BackgroundColor3 = theme.Colors.Surface
	btn.BorderSizePixel = 0
	btn.Text = self.Options.Name
	btn.TextColor3 = theme.Colors.Text
	btn.Font = theme.Typography.MainFont
	btn.TextSize = theme.Typography.BaseSize
	btn.AutoButtonColor = false
	btn.Parent = self.Tab.Container

	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

	btn.MouseEnter:Connect(function()
		AnimationEngine:Tween(btn, { BackgroundColor3 = theme.Colors.Accent, Size = UDim2.new(1, 0, 0, 36) }, "Fast")
	end)

	btn.MouseLeave:Connect(function()
		AnimationEngine:Tween(btn, { BackgroundColor3 = theme.Colors.Surface, Size = UDim2.new(1, 0, 0, 34) }, "Fast")
	end)

	btn.MouseButton1Click:Connect(function()
		local original = btn.Size
		AnimationEngine:Tween(btn, { Size = UDim2.new(1, -6, 0, 32) }, "Fast")
		task.wait(0.1)
		AnimationEngine:Tween(btn, { Size = original }, "Fast")
		if self.Options.Callback then
			self.Options.Callback()
		end
	end)
end

return Button
