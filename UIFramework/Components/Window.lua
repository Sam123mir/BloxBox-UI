--!strict
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local BaseComponent = require(script.Parent.BaseComponent)
local Core = script.Parent.Parent.Core
local Utils = script.Parent.Parent.Utils
local Types = script.Parent.Parent.Types

local WindowManager = require(Core.WindowManager)
local AnimationEngine = require(Core.AnimationEngine)
local DragSystem = require(Utils.DragSystem)
local ComponentTypes = require(Types.ComponentTypes)

local Window = setmetatable({}, BaseComponent)
Window.__index = Window

type WindowOptions = ComponentTypes.WindowOptions

function Window.new(library: any, options: WindowOptions)
	local self = setmetatable(BaseComponent.new(library), Window)
	self.Options = options
	self.Tabs = {}
	self.ActiveTab = nil
	
	self:_mount()
	return self
end

function Window:_mount()
	local theme = self.Library.Theme:GetTheme()
	
	local sg = Instance.new("ScreenGui")
	sg.Name = "SaaS_" .. HttpService:GenerateGUID(false):sub(1, 8)
	sg.ResetOnSpawn = false
	sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	sg.Parent = (RunService:IsStudio() and game.Players.LocalPlayer:WaitForChild("PlayerGui")) or game:GetService("CoreGui")
	self.Instance = sg
	self.Maid:GiveTask(sg)

	-- Sombra exterior
	local shadowContainer = Instance.new("Frame", sg)
	shadowContainer.Size = self.Options.Size
	shadowContainer.Position = self.Options.Position or UDim2.fromScale(0.5, 0.5)
	shadowContainer.AnchorPoint = Vector2.new(0.5, 0.5)
	shadowContainer.BackgroundTransparency = 1
	
	local shadow = Instance.new("ImageLabel", shadowContainer)
	shadow.AnchorPoint = Vector2.new(0.5, 0.5)
	shadow.Position = UDim2.fromScale(0.5, 0.5)
	shadow.Size = UDim2.new(1, 40, 1, 40)
	shadow.BackgroundTransparency = 1
	shadow.Image = "rbxassetid://6015267023"
	shadow.ImageColor3 = Color3.new(0, 0, 0)
	shadow.ImageTransparency = 0.6
	shadow.ScaleType = Enum.ScaleType.Slice
	shadow.SliceCenter = Rect.new(49, 49, 450, 450)

	local main = Instance.new("Frame")
	main.Name = "Main"
	main.Size = UDim2.fromScale(1, 1)
	main.BackgroundColor3 = theme.Colors.Background
	main.BorderSizePixel = 0
	main.Parent = shadowContainer
	self.MainInstance = main

	Instance.new("UICorner", main).CornerRadius = UDim.new(0, theme.Layout.Radius)
	local stroke = Instance.new("UIStroke", main)
	stroke.Color = theme.Colors.Border
	stroke.Transparency = theme.Effects.StrokeTransparency
	stroke.Thickness = 1.2

	local header = Instance.new("Frame")
	header.Name = "Header"
	header.Size = UDim2.new(1, 0, 0, 45)
	header.BackgroundTransparency = 1
	header.Parent = main
	
	self.Maid:GiveTask(DragSystem.new(header, shadowContainer))

	local title = Instance.new("TextLabel")
	title.Name = "Title"
	title.Size = UDim2.new(0.5, 0, 1, 0)
	title.Position = UDim2.fromOffset(20, 0)
	title.BackgroundTransparency = 1
	title.TextColor3 = theme.Colors.Text
	title.Text = self.Options.Title
	title.Font = Enum.Font.InterBold
	title.TextSize = 16
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = header

	-- Barra lateral de Pestañas (Elegante)
	local tabsContainer = Instance.new("Frame")
	tabsContainer.Name = "Tabs"
	tabsContainer.Size = UDim2.new(0, 160, 1, -55)
	tabsContainer.Position = UDim2.fromOffset(10, 45)
	tabsContainer.BackgroundColor3 = theme.Colors.Surface
	tabsContainer.BackgroundTransparency = 0.2
	tabsContainer.BorderSizePixel = 0
	tabsContainer.Parent = main
	
	Instance.new("UICorner", tabsContainer).CornerRadius = UDim.new(0, 10)
	local tabsList = Instance.new("UIListLayout", tabsContainer)
	tabsList.Padding = UDim.new(0, 4)
	tabsList.SortOrder = Enum.SortOrder.LayoutOrder
	Instance.new("UIPadding", tabsContainer).PaddingBottom = UDim.new(0, 10)
	Instance.new("UIPadding", tabsContainer).PaddingTop = UDim.new(0, 10)
	Instance.new("UIPadding", tabsContainer).PaddingLeft = UDim.new(0, 8)
	Instance.new("UIPadding", tabsContainer).PaddingRight = UDim.new(0, 8)

	-- Área de Contenido con Barra de Búsqueda
	local contentArea = Instance.new("Frame")
	contentArea.Name = "ContentArea"
	contentArea.Size = UDim2.new(1, -190, 1, -55)
	contentArea.Position = UDim2.fromOffset(180, 45)
	contentArea.BackgroundTransparency = 1
	contentArea.Parent = main

	local searchContainer = Instance.new("Frame")
	searchContainer.Name = "Search"
	searchContainer.Size = UDim2.new(1, 0, 0, 32)
	searchContainer.BackgroundColor3 = theme.Colors.Surface
	searchContainer.Parent = contentArea
	Instance.new("UICorner", searchContainer).CornerRadius = UDim.new(0, 8)
	
	local searchInput = Instance.new("TextBox")
	searchInput.Size = UDim2.new(1, -30, 1, 0)
	searchInput.Position = UDim2.fromOffset(30, 0)
	searchInput.BackgroundTransparency = 1
	searchInput.PlaceholderText = "Buscar componentes..."
	searchInput.PlaceholderColor3 = theme.Colors.TextDim
	searchInput.TextColor3 = theme.Colors.Text
	searchInput.Text = ""
	searchInput.Font = Enum.Font.Inter
	searchInput.TextSize = 13
	searchInput.TextXAlignment = Enum.TextXAlignment.Left
	searchInput.ClearTextOnFocus = false
	searchInput.Parent = searchContainer

	local searchIcon = Instance.new("ImageLabel", searchContainer)
	searchIcon.Size = UDim2.fromOffset(16, 16)
	searchIcon.Position = UDim2.new(0, 8, 0.5, 0)
	searchIcon.AnchorPoint = Vector2.new(0, 0.5)
	searchIcon.BackgroundTransparency = 1
	searchIcon.Image = "rbxassetid://6031289116"
	searchIcon.ImageColor3 = theme.Colors.TextDim

	local contentScroll = Instance.new("Frame")
	contentScroll.Name = "ScrollArea"
	contentScroll.Size = UDim2.new(1, 0, 1, -40)
	contentScroll.Position = UDim2.fromOffset(0, 40)
	contentScroll.BackgroundTransparency = 1
	contentScroll.Parent = contentArea

	self.Containers = { Tabs = tabsContainer, Content = contentScroll }
	self.SearchInput = searchInput
	self.WindowId = WindowManager:Register(self)

	-- Evento de búsqueda global
	self.Maid:GiveTask(searchInput:GetPropertyChangedSignal("Text"):Connect(function()
		if self.ActiveTab then
			self.ActiveTab:Filter(searchInput.Text)
		end
	end))

	-- Animación de foco
	self.Maid:GiveTask(header.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			WindowManager:SetFocus(self.WindowId)
			AnimationEngine:Tween(stroke, { Transparency = 0.4 }, "Fast")
		end
	end))
	
	self.Maid:GiveTask(sg.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			AnimationEngine:Tween(stroke, { Transparency = theme.Effects.StrokeTransparency }, "Fast")
		end
	end))
end

function Window:CreateTab(name: string)
	local Tab = require(script.Parent.Tab)
	local tab = Tab.new(self, name)
	table.insert(self.Tabs, tab)
	if not self.ActiveTab then tab:Select() end
	return tab
end

return Window
