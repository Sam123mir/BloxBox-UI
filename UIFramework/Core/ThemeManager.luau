-- BloxBox UI: ThemeManager (Executor Compatible)
local Signal = require(script.Parent.Parent.Utils.Signal)

local DefaultTheme = {
	Colors = {
		Background = Color3.fromRGB(15, 15, 15),
		Surface = Color3.fromRGB(22, 22, 22),
		Accent = Color3.fromRGB(0, 170, 255),
		Text = Color3.fromRGB(255, 255, 255),
		TextDim = Color3.fromRGB(160, 160, 160),
		Border = Color3.fromRGB(40, 40, 40),
	},
	Typography = {
		MainFont = Enum.Font.GothamMedium,
		HeaderFont = Enum.Font.GothamBold,
		BaseSize = 14,
		HeaderSize = 16,
	},
	Layout = {
		Padding = 12,
		Radius = 8,
	},
	Effects = {
		ShadowDepth = 4,
		StrokeTransparency = 0.8,
		HoverOpacity = 0.9,
		DisabledOpacity = 0.5,
	}
}

local ThemeManager = {}
ThemeManager.__index = ThemeManager

function ThemeManager.new()
	local self = setmetatable({
		_currentTheme = DefaultTheme,
		_themeChanged = Signal.new()
	}, ThemeManager)
	return self
end

function ThemeManager:GetTheme()
	return self._currentTheme
end

function ThemeManager:SetAccent(color)
	self._currentTheme.Colors.Accent = color
	self._themeChanged:Fire(self._currentTheme)
end

function ThemeManager:SetTheme(theme)
	self._themeChanged:Fire(self._currentTheme)
end

return ThemeManager
