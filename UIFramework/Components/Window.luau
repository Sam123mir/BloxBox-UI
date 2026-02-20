-- BloxBox UI: Window (Executor Compatible)
local AnimationEngine = require(script.Parent.Parent.Core.AnimationEngine)
local DragSystem = require(script.Parent.Parent.Utils.DragSystem)

local Window = {}
Window.__index = Window

function Window.new(library, options)
	local self = setmetatable({
		Library = library,
		Options = options,
		Tabs = {},
		SelectedTab = nil,
		Instance = nil,
		TabList = nil,
		ContentFrame = nil,
	}, Window)
	self:_mount()
	return self
end

function Window:_mount()
	local theme = self.Library.Theme:GetTheme()
	local player = game:GetService("Players").LocalPlayer

	local gui = Instance.new("ScreenGui")
	gui.Name = "BloxBoxWindow"
	gui.ResetOnSpawn = false
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	pcall(function() gui.Parent = game:GetService("CoreGui") end)
	if not gui.Parent then
		gui.Parent = player:WaitForChild("PlayerGui")
	end
	self.Instance = gui

	local size = self.Options.Size or UDim2.fromOffset(600, 400)

	-- Frame principal
	local main = Instance.new("Frame")
	main.Name = "Main"
	main.Size = size
	main.Position = self.Options.Position or UDim2.fromScale(0.5, 0.5)
	main.AnchorPoint = Vector2.new(0.5, 0.5)
	main.BackgroundColor3 = theme.Colors.Background
	main.BorderSizePixel = 0
	main.Parent = gui
	Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)

	local stroke = Instance.new("UIStroke")
	stroke.Color = theme.Colors.Border
	stroke.Thickness = 1
	stroke.Transparency = 0.5
	stroke.Parent = main

	-- Header / Barra de título
	local header = Instance.new("Frame")
	header.Size = UDim2.new(1, 0, 0, 36)
	header.BackgroundColor3 = theme.Colors.Surface
	header.BorderSizePixel = 0
	header.Parent = main
	Instance.new("UICorner", header).CornerRadius = UDim.new(0, 10)

	-- Fix corners visibles de abajo
	local headerFix = Instance.new("Frame")
	headerFix.Size = UDim2.new(1, 0, 0, 12)
	headerFix.Position = UDim2.new(0, 0, 1, -12)
	headerFix.BackgroundColor3 = theme.Colors.Surface
	headerFix.BorderSizePixel = 0
	headerFix.Parent = header

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Size = UDim2.new(1, -80, 1, 0)
	titleLabel.Position = UDim2.fromOffset(12, 0)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = self.Options.Title or "BloxBox Window"
	titleLabel.TextColor3 = theme.Colors.Text
	titleLabel.Font = theme.Typography.HeaderFont
	titleLabel.TextSize = theme.Typography.HeaderSize
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.Parent = header

	-- Botón cerrar
	local closeBtn = Instance.new("TextButton")
	closeBtn.Size = UDim2.fromOffset(28, 28)
	closeBtn.Position = UDim2.new(1, -34, 0.5, 0)
	closeBtn.AnchorPoint = Vector2.new(0, 0.5)
	closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
	closeBtn.BackgroundTransparency = 0.8
	closeBtn.Text = "✕"
	closeBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
	closeBtn.Font = Enum.Font.GothamBold
	closeBtn.TextSize = 14
	closeBtn.BorderSizePixel = 0
	closeBtn.AutoButtonColor = false
	closeBtn.Parent = header
	Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

	closeBtn.MouseButton1Click:Connect(function()
		self:Destroy()
	end)

	-- Sidebar de pestañas
	local sidebar = Instance.new("Frame")
	sidebar.Size = UDim2.new(0, 130, 1, -36)
	sidebar.Position = UDim2.fromOffset(0, 36)
	sidebar.BackgroundColor3 = theme.Colors.Surface
	sidebar.BackgroundTransparency = 0.5
	sidebar.BorderSizePixel = 0
	sidebar.Parent = main

	local sidebarLayout = Instance.new("UIListLayout")
	sidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
	sidebarLayout.Padding = UDim.new(0, 2)
	sidebarLayout.Parent = sidebar

	local sidebarPadding = Instance.new("UIPadding")
	sidebarPadding.PaddingTop = UDim.new(0, 6)
	sidebarPadding.PaddingLeft = UDim.new(0, 4)
	sidebarPadding.PaddingRight = UDim.new(0, 4)
	sidebarPadding.Parent = sidebar

	self.TabList = sidebar

	-- Área de contenido
	local contentFrame = Instance.new("Frame")
	contentFrame.Size = UDim2.new(1, -130, 1, -36)
	contentFrame.Position = UDim2.fromOffset(130, 36)
	contentFrame.BackgroundTransparency = 1
	contentFrame.BorderSizePixel = 0
	contentFrame.Parent = main

	self.ContentFrame = contentFrame

	-- Drag
	DragSystem.new(header, main)

	-- Animación de entrada
	main.BackgroundTransparency = 1
	titleLabel.TextTransparency = 1
	AnimationEngine:Tween(main, { BackgroundTransparency = 0 }, "Normal")
	AnimationEngine:Tween(titleLabel, { TextTransparency = 0 }, "Normal")

	-- Registrar ventana
	self.Library.WindowManager:Register(self)
end

function Window:CreateTab(name)
	local TabModule = require(script.Parent.Tab)
	local tab = TabModule.new(self, name)
	table.insert(self.Tabs, tab)
	
	-- Auto-seleccionar primera pestaña
	if #self.Tabs == 1 then
		self:SelectTab(tab)
	end
	
	return tab
end

function Window:SelectTab(tab)
	-- Ocultar todas
	for _, t in ipairs(self.Tabs) do
		t:Hide()
	end
	-- Mostrar la seleccionada
	tab:Show()
	self.SelectedTab = tab
end

function Window:Destroy()
	if self.Instance then
		self.Instance:Destroy()
	end
end

return Window
