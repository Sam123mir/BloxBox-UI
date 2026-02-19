--!strict
local BaseComponent = require(script.Parent.BaseComponent)
local Core = script.Parent.Parent.Core
local AnimationEngine = require(Core.AnimationEngine)

local Tab = setmetatable({}, BaseComponent)
Tab.__index = Tab

function Tab.new(window: any, name: string)
	local self = setmetatable(BaseComponent.new(window.Library), Tab)
	self.Window = window
	self.Name = name
	self.Active = false
	self.ContentLoaded = false
	
	self:_mount()
	return self
end

function Tab:_mount()
	local theme = self.Window.Library.Theme:GetTheme()
	
	local btn = Instance.new("TextButton")
	btn.Name = self.Name
	btn.Size = UDim2.new(1, 0, 0, 34)
	btn.BackgroundColor3 = theme.Colors.Surface
	btn.BackgroundTransparency = 1
	btn.BorderSizePixel = 0
	btn.Text = ""
	btn.AutoButtonColor = false
	btn.Parent = self.Window.Containers.Tabs
	self.Button = btn

	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
	
	local title = Instance.new("TextLabel", btn)
	title.Size = UDim2.new(1, -10, 1, 0)
	title.Position = UDim2.fromOffset(10, 0)
	title.BackgroundTransparency = 1
	title.Text = self.Name
	title.TextColor3 = theme.Colors.TextDim
	title.Font = Enum.Font.InterMedium
	title.TextSize = 13
	title.TextXAlignment = Enum.TextXAlignment.Left
	self.ButtonTitle = title

	btn.MouseEnter:Connect(function()
		if not self.Active then
			AnimationEngine:Tween(btn, { BackgroundTransparency = 0.5 }, "Fast")
		end
	end)
	btn.MouseLeave:Connect(function()
		if not self.Active then
			AnimationEngine:Tween(btn, { BackgroundTransparency = 1 }, "Fast")
		end
	end)

	btn.MouseButton1Click:Connect(function() self:Select() end)
	
	local container = Instance.new("ScrollingFrame")
	container.Name = self.Name .. "_Content"
	container.Size = UDim2.fromScale(1, 1)
	container.BackgroundTransparency = 1
	container.BorderSizePixel = 0
	container.Visible = false
	container.ScrollBarThickness = 1
	container.ScrollBarImageColor3 = theme.Colors.Accent
	container.CanvasSize = UDim2.new(0, 0, 0, 0)
	container.AutomaticCanvasSize = Enum.AutomaticSize.Y
	container.Parent = self.Window.Containers.Content
	self.Container = container
	
	local list = Instance.new("UIListLayout", container)
	list.Padding = UDim.new(0, 6)
	list.SortOrder = Enum.SortOrder.LayoutOrder
	
	Instance.new("UIPadding", container).PaddingTop = UDim.new(0, 2)
	Instance.new("UIPadding", container).PaddingLeft = UDim.new(0, 2)
	Instance.new("UIPadding", container).PaddingRight = UDim.new(0, 6)
end

function Tab:Select()
	if self.Window.ActiveTab == self then return end
	if self.Window.ActiveTab then self.Window.ActiveTab:Deselect() end
	self.Window.ActiveTab = self
	self.Active = true
	
	local theme = self.Window.Library.Theme:GetTheme()
	AnimationEngine:Tween(self.Button, { BackgroundTransparency = 0, BackgroundColor3 = theme.Colors.Accent }, "Fast")
	AnimationEngine:Tween(self.ButtonTitle, { TextColor3 = Color3.new(1,1,1) }, "Fast")
	
	self.Container.Visible = true
end

function Tab:Deselect()
	self.Active = false
	local theme = self.Window.Library.Theme:GetTheme()
	AnimationEngine:Tween(self.Button, { BackgroundTransparency = 1, BackgroundColor3 = theme.Colors.Surface }, "Fast")
	AnimationEngine:Tween(self.ButtonTitle, { TextColor3 = theme.Colors.TextDim }, "Fast")
	self.Container.Visible = false
end

function Tab:Filter(query: string)
	local q = query:lower()
	for _, child in ipairs(self.Container:GetChildren()) do
		if child:IsA("GuiObject") and not child:IsA("UIListLayout") and not child:IsA("UIPadding") then
			local visible = true
			if q ~= "" then
				-- Intentar encontrar un label de texto en el componente
				local content = child:FindFirstChild("Title", true) or child:FindFirstChildOfClass("TextLabel")
				if content and (content :: TextLabel).Text:lower():find(q) then
					visible = true
				else
					visible = false
				end
			end
			child.Visible = visible
		end
	end
end

-- Component Factories (Proxy redirects)
function Tab:CreateButton(options) return require(script.Parent.Button).new(self, options) end
function Tab:CreateToggle(options) return require(script.Parent.Toggle).new(self, options) end
function Tab:CreateSlider(options) return require(script.Parent.Slider).new(self, options) end
function Tab:CreateDropdown(options) return require(script.Parent.Dropdown).new(self, options) end
function Tab:CreateLabel(text) return require(script.Parent.Label).new(self, text) end
function Tab:CreateSection(name) return require(script.Parent.Section).new(self, name) end
function Tab:CreateTextBox(options) return require(script.Parent.TextBox).new(self, options) end
function Tab:CreateKeybind(options) return require(script.Parent.Keybind).new(self, options) end

return Tab
