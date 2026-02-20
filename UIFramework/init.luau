--!strict
local Core = script.Core
local ThemeManager = require(Core.ThemeManager)
local StateManager = require(Core.StateManager)
local ConfigManager = require(Core.ConfigManager)
local NotificationManager = require(Core.NotificationManager)
local IntroManager = require(Core.IntroManager)
local Window = require(script.Components.Window)

local Library = {}
Library.__index = Library

function Library.new()
	local instanceId = game:GetService("HttpService"):GenerateGUID(false)
	
	local self = setmetatable({
		_id = instanceId,
		Theme = ThemeManager.new(),
		State = StateManager.new(instanceId),
	}, Library)
	
	self.Config = ConfigManager.new(self.State)
	return self
end

function Library:CreateWindow(options)
	return Window.new(self, options)
end

function Library:Notify(options)
	NotificationManager:Notify(self, options)
end

function Library:ShowIntro()
	IntroManager:Show(self.Theme:GetTheme())
end

function Library:SetTheme(themeName: string)
	self.Theme:SetTheme(themeName)
end

function Library:SetAccent(color: Color3)
	self.Theme:SetAccent(color)
end

function Library:SaveConfig(name: string)
	return self.Config:Save(name)
end

function Library:LoadConfig(name: string)
	return self.Config:Load(name)
end

return Library
