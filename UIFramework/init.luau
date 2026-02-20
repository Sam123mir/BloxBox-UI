-- BloxBox UI: init (Executor Compatible)
-- Punto de entrada principal del framework
local Core = script.Core
local Components = script.Components

local ThemeManager = require(Core.ThemeManager)
local StateManager = require(Core.StateManager)
local ConfigManager = require(Core.ConfigManager)
local IntroManager = require(Core.IntroManager)
local NotificationManager = require(Core.NotificationManager)
local WindowManager = require(Core.WindowManager)

local Window = require(Components.Window)

local BloxBoxUI = {}
BloxBoxUI.__index = BloxBoxUI

function BloxBoxUI.new()
	local self = setmetatable({}, BloxBoxUI)
	
	self.Theme = ThemeManager.new()
	self.State = StateManager.new("main")
	self.Config = ConfigManager.new(self.State)
	self.Intro = IntroManager.new(self.Theme)
	self.Notifications = NotificationManager.new()
	self.WindowManager = WindowManager
	
	return self
end

function BloxBoxUI:SetAccent(color)
	self.Theme:SetAccent(color)
end

function BloxBoxUI:ShowIntro()
	self.Intro:Show()
end

function BloxBoxUI:CreateWindow(options)
	return Window.new(self, options)
end

function BloxBoxUI:Notify(options)
	self.Notifications:Show(options)
end

function BloxBoxUI:SaveConfig(name)
	return self.Config:Save(name)
end

function BloxBoxUI:LoadConfig(name)
	return self.Config:Load(name)
end

return BloxBoxUI
