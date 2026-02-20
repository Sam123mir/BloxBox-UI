--[[
╔══════════════════════════════════════════════════════════╗
║           BLOXBOX UI v2.0 — PREMIUM EDITION             ║
║           by Samir & Team | Single-File                 ║
║           github.com/Sam123mir/BloxBox-UI               ║
╚══════════════════════════════════════════════════════════╝
]]

--// ═══════════════════════════════════════════════
--// SECTION: Services
--// ═══════════════════════════════════════════════

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local Player = Players.LocalPlayer

--// ═══════════════════════════════════════════════
--// SECTION: Signal
--// ═══════════════════════════════════════════════

local Signal = {}
Signal.__index = Signal
function Signal.new() return setmetatable({ _conns = {} }, Signal) end
function Signal:Connect(fn)
	local c = { _handler = fn }
	c.Disconnect = function(s) for i,v in ipairs(self._conns) do if v == s then table.remove(self._conns, i) break end end end
	table.insert(self._conns, c)
	return c
end
function Signal:Fire(...)
	for _, c in ipairs(self._conns) do task.spawn(c._handler, ...) end
end
function Signal:Destroy() self._conns = {} end

--// ═══════════════════════════════════════════════
--// SECTION: Utility
--// ═══════════════════════════════════════════════

local Presets = {
	Instant = TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
	Fast = TweenInfo.new(0.18, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
	Normal = TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
	Slow = TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
	Smooth = TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out),
	Bounce = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
}
local function Tween(inst, props, preset)
	local info = typeof(preset) == "TweenInfo" and preset or Presets[preset or "Normal"]
	local t = TweenService:Create(inst, info, props)
	t:Play()
	return t
end
local function CreateCorner(parent, radius) local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, radius or 8); c.Parent = parent; return c end
local function CreateStroke(parent, color, thickness, transparency) local s = Instance.new("UIStroke"); s.Color = color; s.Thickness = thickness or 1; s.Transparency = transparency or 0.7; s.Parent = parent; return s end
local function CreatePadding(parent, t, b, l, r)
	local p = Instance.new("UIPadding"); p.PaddingTop = UDim.new(0, t or 0); p.PaddingBottom = UDim.new(0, b or 0); p.PaddingLeft = UDim.new(0, l or 0); p.PaddingRight = UDim.new(0, r or 0); p.Parent = parent; return p
end
local function CreateGUI(name, order)
	local gui = Instance.new("ScreenGui"); gui.Name = name; gui.ResetOnSpawn = false; gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling; gui.DisplayOrder = order or 1
	pcall(function() gui.Parent = game:GetService("CoreGui") end)
	if not gui.Parent then gui.Parent = Player:WaitForChild("PlayerGui") end
	return gui
end

--// ═══════════════════════════════════════════════
--// SECTION: Theme
--// ═══════════════════════════════════════════════

local Theme = {
	Bg = Color3.fromRGB(18, 18, 22),
	BgAlt = Color3.fromRGB(24, 24, 30),
	Surface = Color3.fromRGB(30, 30, 38),
	SurfaceHover = Color3.fromRGB(38, 38, 48),
	Accent = Color3.fromRGB(90, 130, 255),
	AccentDark = Color3.fromRGB(60, 90, 200),
	Text = Color3.fromRGB(240, 240, 245),
	TextDim = Color3.fromRGB(140, 140, 160),
	TextMuted = Color3.fromRGB(90, 90, 110),
	Border = Color3.fromRGB(50, 50, 65),
	Success = Color3.fromRGB(80, 200, 120),
	Warning = Color3.fromRGB(255, 190, 60),
	Error = Color3.fromRGB(240, 70, 70),
	Font = Enum.Font.GothamMedium,
	FontBold = Enum.Font.GothamBold,
	FontLight = Enum.Font.Gotham,
	Radius = 10,
	RadiusSmall = 6,
}

--// ═══════════════════════════════════════════════
--// SECTION: State Manager
--// ═══════════════════════════════════════════════

local StateManager = {}
StateManager.__index = StateManager
function StateManager.new() return setmetatable({ _s = {}, _sub = {} }, StateManager) end
function StateManager:Set(f, v)
	if self._s[f] == v then return end
	self._s[f] = v
	if self._sub[f] then self._sub[f]:Fire(v) end
end
function StateManager:Get(f, d)
	local v = self._s[f]
	return v == nil and d or v
end
function StateManager:Subscribe(f, fn)
	if not self._sub[f] then self._sub[f] = Signal.new() end
	return self._sub[f]:Connect(fn)
end

--// ═══════════════════════════════════════════════
--// SECTION: Config Manager
--// ═══════════════════════════════════════════════

local function SaveConfig(state, name)
	pcall(function()
		if writefile then
			if not isfolder("BloxBox_Configs") then makefolder("BloxBox_Configs") end
			writefile("BloxBox_Configs/" .. name .. ".json", HttpService:JSONEncode(state._s))
		end
	end)
end
local function LoadConfig(state, name)
	pcall(function()
		if readfile and isfile and isfile("BloxBox_Configs/" .. name .. ".json") then
			local d = HttpService:JSONDecode(readfile("BloxBox_Configs/" .. name .. ".json"))
			if d then for k,v in pairs(d) do state:Set(k, v) end end
		end
	end)
end

--// ═══════════════════════════════════════════════
--// SECTION: Drag System
--// ═══════════════════════════════════════════════

local function MakeDraggable(handle, frame)
	local dragging, dragStart, startPos = false, nil, nil
	handle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true; dragStart = input.Position; startPos = frame.Position
			input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local d = input.Position - dragStart
			Tween(frame, { Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y) }, "Instant")
		end
	end)
end

--// ═══════════════════════════════════════════════
--// SECTION: Notifications (TOP RIGHT)
--// ═══════════════════════════════════════════════

local NotifContainer = nil
local function GetNotifContainer()
	if NotifContainer and NotifContainer.Parent then return NotifContainer end
	local gui = CreateGUI("BloxBoxNotifs", 200)
	local c = Instance.new("Frame"); c.Size = UDim2.new(0, 320, 1, 0); c.Position = UDim2.new(1, -330, 0, 10)
	c.BackgroundTransparency = 1; c.Parent = gui
	local l = Instance.new("UIListLayout"); l.SortOrder = Enum.SortOrder.LayoutOrder; l.Padding = UDim.new(0, 8)
	l.VerticalAlignment = Enum.VerticalAlignment.Top; l.Parent = c
	NotifContainer = c
	return c
end

local function ShowNotification(opts)
	local container = GetNotifContainer()
	local colors = { Info = Theme.Accent, Success = Theme.Success, Warning = Theme.Warning, Error = Theme.Error }
	local color = colors[opts.Type or "Info"] or Theme.Accent

	local card = Instance.new("Frame")
	card.Size = UDim2.new(1, 0, 0, 68); card.BackgroundColor3 = Theme.Surface; card.BackgroundTransparency = 0.05
	card.BorderSizePixel = 0; card.ClipsDescendants = true; card.Parent = container
	CreateCorner(card, 10); CreateStroke(card, color, 1.5, 0.4)

	-- Accent bar left
	local bar = Instance.new("Frame"); bar.Size = UDim2.new(0, 3, 1, -12); bar.Position = UDim2.fromOffset(6, 6)
	bar.BackgroundColor3 = color; bar.BorderSizePixel = 0; bar.Parent = card; CreateCorner(bar, 2)

	local title = Instance.new("TextLabel"); title.Size = UDim2.new(1, -24, 0, 22); title.Position = UDim2.fromOffset(18, 8)
	title.BackgroundTransparency = 1; title.Text = opts.Title or "Notification"; title.TextColor3 = Theme.Text
	title.Font = Theme.FontBold; title.TextSize = 14; title.TextXAlignment = Enum.TextXAlignment.Left; title.Parent = card

	local body = Instance.new("TextLabel"); body.Size = UDim2.new(1, -24, 0, 30); body.Position = UDim2.fromOffset(18, 32)
	body.BackgroundTransparency = 1; body.Text = opts.Content or ""; body.TextColor3 = Theme.TextDim
	body.Font = Theme.FontLight; body.TextSize = 12; body.TextXAlignment = Enum.TextXAlignment.Left; body.TextWrapped = true; body.Parent = card

	-- Slide in from right
	card.Position = UDim2.fromOffset(340, 0)
	Tween(card, { Position = UDim2.fromOffset(0, 0) }, "Bounce")

	task.delay(opts.Duration or 4, function()
		Tween(card, { Position = UDim2.fromOffset(340, 0), BackgroundTransparency = 1 }, "Normal")
		task.wait(0.4); card:Destroy()
	end)
end

--// ═══════════════════════════════════════════════
--// SECTION: Intro / Splash Screen (Compact)
--// ═══════════════════════════════════════════════

local function ShowIntro(logoId, callback)
	local gui = CreateGUI("BloxBoxIntro", 999)
	
	local bg = Instance.new("Frame"); bg.Size = UDim2.fromScale(1, 1); bg.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
	bg.BorderSizePixel = 0; bg.Parent = gui

	-- Compact card
	local card = Instance.new("Frame")
	card.Size = UDim2.fromOffset(260, 160); card.Position = UDim2.fromScale(0.5, 0.5); card.AnchorPoint = Vector2.new(0.5, 0.5)
	card.BackgroundColor3 = Theme.Surface; card.BackgroundTransparency = 0.1; card.BorderSizePixel = 0
	card.Parent = bg
	CreateCorner(card, 14); CreateStroke(card, Theme.Border, 1, 0.5)

	-- Logo
	local logo = Instance.new("ImageLabel"); logo.Size = UDim2.fromOffset(52, 52)
	logo.Position = UDim2.new(0.5, 0, 0, 22); logo.AnchorPoint = Vector2.new(0.5, 0)
	logo.BackgroundTransparency = 1; logo.Image = logoId or ""; logo.ImageTransparency = 1; logo.Parent = card

	-- Title
	local title = Instance.new("TextLabel"); title.Size = UDim2.new(1, 0, 0, 24)
	title.Position = UDim2.new(0.5, 0, 0, 80); title.AnchorPoint = Vector2.new(0.5, 0)
	title.BackgroundTransparency = 1; title.Text = "BloxBox UI"; title.TextColor3 = Theme.Text
	title.Font = Theme.FontBold; title.TextSize = 18; title.TextTransparency = 1; title.Parent = card

	-- Version
	local ver = Instance.new("TextLabel"); ver.Size = UDim2.new(1, 0, 0, 16)
	ver.Position = UDim2.new(0.5, 0, 0, 104); ver.AnchorPoint = Vector2.new(0.5, 0)
	ver.BackgroundTransparency = 1; ver.Text = "v2.0 Premium"; ver.TextColor3 = Theme.TextMuted
	ver.Font = Theme.FontLight; ver.TextSize = 11; ver.TextTransparency = 1; ver.Parent = card

	-- Loading bar bg
	local barBg = Instance.new("Frame"); barBg.Size = UDim2.new(0.7, 0, 0, 3)
	barBg.Position = UDim2.new(0.5, 0, 0, 135); barBg.AnchorPoint = Vector2.new(0.5, 0)
	barBg.BackgroundColor3 = Theme.Border; barBg.BackgroundTransparency = 1; barBg.BorderSizePixel = 0; barBg.Parent = card
	CreateCorner(barBg, 2)

	local barFill = Instance.new("Frame"); barFill.Size = UDim2.fromScale(0, 1)
	barFill.BackgroundColor3 = Theme.Accent; barFill.BorderSizePixel = 0; barFill.Parent = barBg
	CreateCorner(barFill, 2)

	-- Animation sequence (slow, elegant)
	task.spawn(function()
		-- Card scales in
		card.Size = UDim2.fromOffset(240, 140)
		Tween(card, { Size = UDim2.fromOffset(260, 160) }, "Bounce")
		task.wait(0.3)
		Tween(logo, { ImageTransparency = 0 }, "Slow")
		task.wait(0.4)
		Tween(title, { TextTransparency = 0 }, "Normal")
		task.wait(0.2)
		Tween(ver, { TextTransparency = 0 }, "Normal")
		task.wait(0.3)
		Tween(barBg, { BackgroundTransparency = 0.5 }, "Normal")
		task.wait(0.1)

		-- Slow loading bar (3 seconds)
		local tw = Tween(barFill, { Size = UDim2.fromScale(1, 1) }, TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut))
		tw.Completed:Wait()

		task.wait(0.4)
		-- Fade out
		Tween(card, { BackgroundTransparency = 1, Size = UDim2.fromOffset(280, 180) }, "Normal")
		Tween(logo, { ImageTransparency = 1 }, "Normal")
		Tween(title, { TextTransparency = 1 }, "Normal")
		Tween(ver, { TextTransparency = 1 }, "Normal")
		Tween(barBg, { BackgroundTransparency = 1 }, "Normal")
		Tween(barFill, { BackgroundTransparency = 1 }, "Normal")
		task.wait(0.3)
		Tween(bg, { BackgroundTransparency = 1 }, "Slow")
		task.wait(0.6)
		gui:Destroy()
		if callback then callback() end
	end)
end

--// ═══════════════════════════════════════════════
--// SECTION: Components — Section Divider
--// ═══════════════════════════════════════════════

local function CreateSection(tab, name)
	local f = Instance.new("Frame"); f.Size = UDim2.new(1, 0, 0, 28); f.BackgroundTransparency = 1; f.Parent = tab._container
	local line = Instance.new("Frame"); line.Size = UDim2.new(1, 0, 0, 1); line.Position = UDim2.new(0, 0, 0.5, 0)
	line.BackgroundColor3 = Theme.Border; line.BackgroundTransparency = 0.5; line.BorderSizePixel = 0; line.Parent = f
	local lbl = Instance.new("TextLabel"); lbl.AutomaticSize = Enum.AutomaticSize.X
	lbl.Size = UDim2.new(0, 0, 0, 18); lbl.Position = UDim2.fromOffset(8, 5)
	lbl.BackgroundColor3 = Theme.Bg; lbl.Text = "  " .. name .. "  "; lbl.TextColor3 = Theme.TextMuted
	lbl.Font = Theme.FontBold; lbl.TextSize = 11; lbl.Parent = f
end

--// ═══════════════════════════════════════════════
--// SECTION: Components — Button (Premium)
--// ═══════════════════════════════════════════════

local function CreateButton(tab, opts)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 0, 36); btn.BackgroundColor3 = Theme.Surface; btn.BorderSizePixel = 0
	btn.Text = ""; btn.AutoButtonColor = false; btn.Parent = tab._container
	CreateCorner(btn, Theme.RadiusSmall); CreateStroke(btn, Theme.Border, 1, 0.7)

	local icon = Instance.new("TextLabel"); icon.Size = UDim2.fromOffset(20, 36); icon.Position = UDim2.fromOffset(10, 0)
	icon.BackgroundTransparency = 1; icon.Text = "▶"; icon.TextColor3 = Theme.Accent
	icon.Font = Theme.Font; icon.TextSize = 10; icon.Parent = btn

	local lbl = Instance.new("TextLabel"); lbl.Size = UDim2.new(1, -40, 1, 0); lbl.Position = UDim2.fromOffset(30, 0)
	lbl.BackgroundTransparency = 1; lbl.Text = opts.Name; lbl.TextColor3 = Theme.Text
	lbl.Font = Theme.Font; lbl.TextSize = 13; lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.Parent = btn

	btn.MouseEnter:Connect(function()
		Tween(btn, { BackgroundColor3 = Theme.SurfaceHover }, "Fast")
		Tween(icon, { TextColor3 = Theme.Text }, "Fast")
	end)
	btn.MouseLeave:Connect(function()
		Tween(btn, { BackgroundColor3 = Theme.Surface }, "Fast")
		Tween(icon, { TextColor3 = Theme.Accent }, "Fast")
	end)
	btn.MouseButton1Click:Connect(function()
		-- Click ripple effect
		Tween(btn, { BackgroundColor3 = Theme.AccentDark }, "Instant")
		Tween(btn, { Size = UDim2.new(1, -4, 0, 34) }, "Instant")
		task.wait(0.08)
		Tween(btn, { BackgroundColor3 = Theme.SurfaceHover, Size = UDim2.new(1, 0, 0, 36) }, "Fast")
		if opts.Callback then opts.Callback() end
	end)
end

--// ═══════════════════════════════════════════════
--// SECTION: Components — Toggle (Premium)
--// ═══════════════════════════════════════════════

local function CreateToggle(tab, opts)
	local state = tab._library._state
	local c = Instance.new("TextButton"); c.Size = UDim2.new(1, 0, 0, 36); c.BackgroundColor3 = Theme.Surface
	c.BorderSizePixel = 0; c.Text = ""; c.AutoButtonColor = false; c.Parent = tab._container
	CreateCorner(c, Theme.RadiusSmall); CreateStroke(c, Theme.Border, 1, 0.7)

	local lbl = Instance.new("TextLabel"); lbl.Size = UDim2.new(1, -60, 1, 0); lbl.Position = UDim2.fromOffset(12, 0)
	lbl.BackgroundTransparency = 1; lbl.Text = opts.Name; lbl.TextColor3 = Theme.Text
	lbl.Font = Theme.Font; lbl.TextSize = 13; lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.Parent = c

	local track = Instance.new("Frame"); track.Size = UDim2.fromOffset(36, 18)
	track.Position = UDim2.new(1, -46, 0.5, 0); track.AnchorPoint = Vector2.new(0, 0.5)
	track.BackgroundColor3 = Color3.fromRGB(55, 55, 65); track.BorderSizePixel = 0; track.Parent = c
	CreateCorner(track, 9)

	local knob = Instance.new("Frame"); knob.Size = UDim2.fromOffset(14, 14)
	knob.Position = UDim2.fromOffset(2, 2); knob.BackgroundColor3 = Theme.TextDim; knob.BorderSizePixel = 0; knob.Parent = track
	CreateCorner(knob, 7)

	local function upd(v)
		if v then
			Tween(knob, { Position = UDim2.fromOffset(20, 2), BackgroundColor3 = Color3.new(1,1,1) }, "Fast")
			Tween(track, { BackgroundColor3 = Theme.Accent }, "Fast")
		else
			Tween(knob, { Position = UDim2.fromOffset(2, 2), BackgroundColor3 = Theme.TextDim }, "Fast")
			Tween(track, { BackgroundColor3 = Color3.fromRGB(55, 55, 65) }, "Fast")
		end
	end
	state:Subscribe(opts.Flag, function(v) upd(v); if opts.Callback then opts.Callback(v) end end)
	c.MouseButton1Click:Connect(function() state:Set(opts.Flag, not state:Get(opts.Flag, false)) end)
	c.MouseEnter:Connect(function() Tween(c, { BackgroundColor3 = Theme.SurfaceHover }, "Fast") end)
	c.MouseLeave:Connect(function() Tween(c, { BackgroundColor3 = Theme.Surface }, "Fast") end)
	state:Set(opts.Flag, opts.Default == true)
end

--// ═══════════════════════════════════════════════
--// SECTION: Components — Slider (Premium)
--// ═══════════════════════════════════════════════

local function CreateSlider(tab, opts)
	local state = tab._library._state
	local c = Instance.new("Frame"); c.Size = UDim2.new(1, 0, 0, 50); c.BackgroundColor3 = Theme.Surface
	c.BorderSizePixel = 0; c.Parent = tab._container
	CreateCorner(c, Theme.RadiusSmall); CreateStroke(c, Theme.Border, 1, 0.7)

	local lbl = Instance.new("TextLabel"); lbl.Size = UDim2.new(1, -70, 0, 22); lbl.Position = UDim2.fromOffset(12, 4)
	lbl.BackgroundTransparency = 1; lbl.Text = opts.Name; lbl.TextColor3 = Theme.Text
	lbl.Font = Theme.Font; lbl.TextSize = 13; lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.Parent = c

	local val = Instance.new("TextLabel"); val.Size = UDim2.fromOffset(50, 22); val.Position = UDim2.new(1, -60, 0, 4)
	val.BackgroundTransparency = 1; val.Text = tostring(opts.Default or opts.Min); val.TextColor3 = Theme.Accent
	val.Font = Theme.FontBold; val.TextSize = 13; val.TextXAlignment = Enum.TextXAlignment.Right; val.Parent = c

	local trackBg = Instance.new("Frame"); trackBg.Size = UDim2.new(1, -24, 0, 5); trackBg.Position = UDim2.fromOffset(12, 34)
	trackBg.BackgroundColor3 = Theme.BgAlt; trackBg.BorderSizePixel = 0; trackBg.Parent = c; CreateCorner(trackBg, 3)

	local fill = Instance.new("Frame"); fill.Size = UDim2.fromScale(0, 1); fill.BackgroundColor3 = Theme.Accent
	fill.BorderSizePixel = 0; fill.Parent = trackBg; CreateCorner(fill, 3)

	-- Knob circle
	local knobCircle = Instance.new("Frame"); knobCircle.Size = UDim2.fromOffset(12, 12)
	knobCircle.Position = UDim2.new(0, -6, 0.5, 0); knobCircle.AnchorPoint = Vector2.new(0, 0.5)
	knobCircle.BackgroundColor3 = Theme.Text; knobCircle.BorderSizePixel = 0; knobCircle.Parent = fill
	CreateCorner(knobCircle, 6)

	local dragging = false
	local min, max = opts.Min, opts.Max
	local function upd(pct)
		pct = math.clamp(pct, 0, 1)
		local v = math.floor(min + (max - min) * pct + 0.5)
		fill.Size = UDim2.fromScale(pct, 1); val.Text = tostring(v)
		state:Set(opts.Flag, v); if opts.Callback then opts.Callback(v) end
	end

	trackBg.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			dragging = true; upd((i.Position.X - trackBg.AbsolutePosition.X) / trackBg.AbsoluteSize.X)
		end
	end)
	UserInputService.InputChanged:Connect(function(i)
		if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
			upd((i.Position.X - trackBg.AbsolutePosition.X) / trackBg.AbsoluteSize.X)
		end
	end)
	UserInputService.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = false end
	end)

	local def = opts.Default or min; fill.Size = UDim2.fromScale((def - min) / (max - min), 1); val.Text = tostring(def)
	state:Set(opts.Flag, def)
end

--// ═══════════════════════════════════════════════
--// SECTION: Components — Dropdown (Premium)
--// ═══════════════════════════════════════════════

local function CreateDropdown(tab, opts)
	local state = tab._library._state
	local open = false

	local c = Instance.new("Frame"); c.Size = UDim2.new(1, 0, 0, 36); c.BackgroundColor3 = Theme.Surface
	c.BorderSizePixel = 0; c.ClipsDescendants = true; c.Parent = tab._container
	CreateCorner(c, Theme.RadiusSmall); CreateStroke(c, Theme.Border, 1, 0.7)

	local header = Instance.new("TextButton"); header.Size = UDim2.new(1, 0, 0, 36)
	header.BackgroundTransparency = 1; header.Text = ""; header.Parent = c

	local lbl = Instance.new("TextLabel"); lbl.Size = UDim2.new(1, -90, 1, 0); lbl.Position = UDim2.fromOffset(12, 0)
	lbl.BackgroundTransparency = 1; lbl.Text = opts.Name; lbl.TextColor3 = Theme.Text
	lbl.Font = Theme.Font; lbl.TextSize = 13; lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.Parent = header

	local arrow = Instance.new("TextLabel"); arrow.Size = UDim2.fromOffset(14, 36)
	arrow.Position = UDim2.new(1, -22, 0, 0); arrow.BackgroundTransparency = 1; arrow.Text = "▼"
	arrow.TextColor3 = Theme.TextMuted; arrow.Font = Theme.Font; arrow.TextSize = 9; arrow.Parent = header

	local sel = Instance.new("TextLabel"); sel.Size = UDim2.fromOffset(60, 20)
	sel.Position = UDim2.new(1, -80, 0.5, 0); sel.AnchorPoint = Vector2.new(0, 0.5)
	sel.BackgroundTransparency = 1; sel.Text = opts.Default or "..."; sel.TextColor3 = Theme.Accent
	sel.Font = Theme.Font; sel.TextSize = 12; sel.TextXAlignment = Enum.TextXAlignment.Right; sel.Parent = header

	local listF = Instance.new("Frame"); listF.Size = UDim2.new(1, -12, 0, 0); listF.Position = UDim2.fromOffset(6, 38)
	listF.BackgroundTransparency = 1; listF.Parent = c
	local ll = Instance.new("UIListLayout"); ll.Padding = UDim.new(0, 2); ll.Parent = listF

	for _, item in ipairs(opts.List or {}) do
		local b = Instance.new("TextButton"); b.Size = UDim2.new(1, 0, 0, 28); b.BackgroundColor3 = Theme.BgAlt
		b.BorderSizePixel = 0; b.Text = item; b.TextColor3 = Theme.TextDim; b.Font = Theme.Font; b.TextSize = 12
		b.AutoButtonColor = false; b.Parent = listF; CreateCorner(b, 4)
		b.MouseEnter:Connect(function() Tween(b, { BackgroundColor3 = Theme.SurfaceHover, TextColor3 = Theme.Text }, "Fast") end)
		b.MouseLeave:Connect(function() Tween(b, { BackgroundColor3 = Theme.BgAlt, TextColor3 = Theme.TextDim }, "Fast") end)
		b.MouseButton1Click:Connect(function()
			sel.Text = item; state:Set(opts.Flag, item); if opts.Callback then opts.Callback(item) end
			open = false; Tween(c, { Size = UDim2.new(1, 0, 0, 36) }, "Fast"); arrow.Text = "▼"
		end)
	end

	header.MouseButton1Click:Connect(function()
		open = not open; arrow.Text = open and "▲" or "▼"
		Tween(c, { Size = UDim2.new(1, 0, 0, open and (38 + #(opts.List or {}) * 30 + 4) or 36) }, "Fast")
	end)
	if opts.Default then state:Set(opts.Flag, opts.Default) end
end

--// ═══════════════════════════════════════════════
--// SECTION: Components — TextBox
--// ═══════════════════════════════════════════════

local function CreateTextBoxComp(tab, opts)
	local state = tab._library._state
	local c = Instance.new("Frame"); c.Size = UDim2.new(1, 0, 0, 58); c.BackgroundColor3 = Theme.Surface
	c.BorderSizePixel = 0; c.Parent = tab._container; CreateCorner(c, Theme.RadiusSmall); CreateStroke(c, Theme.Border, 1, 0.7)

	local lbl = Instance.new("TextLabel"); lbl.Size = UDim2.new(1, -16, 0, 18); lbl.Position = UDim2.fromOffset(12, 5)
	lbl.BackgroundTransparency = 1; lbl.Text = opts.Name; lbl.TextColor3 = Theme.Text
	lbl.Font = Theme.Font; lbl.TextSize = 12; lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.Parent = c

	local box = Instance.new("TextBox"); box.Size = UDim2.new(1, -24, 0, 26); box.Position = UDim2.fromOffset(12, 26)
	box.BackgroundColor3 = Theme.BgAlt; box.BorderSizePixel = 0; box.Text = opts.Default or ""
	box.PlaceholderText = opts.Placeholder or "..."; box.PlaceholderColor3 = Theme.TextMuted
	box.TextColor3 = Theme.Text; box.Font = Theme.Font; box.TextSize = 13; box.ClearTextOnFocus = false; box.Parent = c
	CreateCorner(box, 4)

	box.Focused:Connect(function() Tween(c, { BackgroundColor3 = Theme.SurfaceHover }, "Fast") end)
	box.FocusLost:Connect(function()
		Tween(c, { BackgroundColor3 = Theme.Surface }, "Fast")
		state:Set(opts.Flag, box.Text); if opts.Callback then opts.Callback(box.Text) end
	end)
	state:Set(opts.Flag, opts.Default or "")
end

--// ═══════════════════════════════════════════════
--// SECTION: Components — Keybind
--// ═══════════════════════════════════════════════

local function CreateKeybind(tab, opts)
	local state = tab._library._state
	local binding = false

	local c = Instance.new("TextButton"); c.Size = UDim2.new(1, 0, 0, 36); c.BackgroundColor3 = Theme.Surface
	c.BorderSizePixel = 0; c.Text = ""; c.AutoButtonColor = false; c.Parent = tab._container
	CreateCorner(c, Theme.RadiusSmall); CreateStroke(c, Theme.Border, 1, 0.7)

	local lbl = Instance.new("TextLabel"); lbl.Size = UDim2.new(1, -80, 1, 0); lbl.Position = UDim2.fromOffset(12, 0)
	lbl.BackgroundTransparency = 1; lbl.Text = opts.Name; lbl.TextColor3 = Theme.Text
	lbl.Font = Theme.Font; lbl.TextSize = 13; lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.Parent = c

	local badge = Instance.new("TextLabel"); badge.Size = UDim2.fromOffset(60, 22)
	badge.Position = UDim2.new(1, -70, 0.5, 0); badge.AnchorPoint = Vector2.new(0, 0.5)
	badge.BackgroundColor3 = Theme.BgAlt; badge.TextColor3 = Theme.Accent
	badge.Font = Theme.FontBold; badge.TextSize = 11; badge.Parent = c; CreateCorner(badge, 4)

	state:Subscribe(opts.Flag, function(key) badge.Text = key.Name end)
	c.MouseButton1Click:Connect(function() binding = true; badge.Text = "..." end)
	c.MouseEnter:Connect(function() Tween(c, { BackgroundColor3 = Theme.SurfaceHover }, "Fast") end)
	c.MouseLeave:Connect(function() Tween(c, { BackgroundColor3 = Theme.Surface }, "Fast") end)
	UserInputService.InputBegan:Connect(function(i)
		if binding and i.UserInputType == Enum.UserInputType.Keyboard then
			binding = false; state:Set(opts.Flag, i.KeyCode); if opts.Callback then opts.Callback(i.KeyCode) end
		end
	end)
	state:Set(opts.Flag, opts.Default or Enum.KeyCode.RightControl)
end

--// ═══════════════════════════════════════════════
--// SECTION: Components — Label
--// ═══════════════════════════════════════════════

local function CreateLabel(tab, text)
	local lbl = Instance.new("TextLabel"); lbl.Size = UDim2.new(1, 0, 0, 20); lbl.BackgroundTransparency = 1
	lbl.Text = text; lbl.TextColor3 = Theme.TextDim; lbl.Font = Theme.Font; lbl.TextSize = 12
	lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.Parent = tab._container
end

--// ═══════════════════════════════════════════════
--// SECTION: Tab System
--// ═══════════════════════════════════════════════

local Tab = {}; Tab.__index = Tab

function Tab.new(window, name)
	local self = setmetatable({ _window = window, _library = window._library, _name = name }, Tab)
	self:_build(); return self
end

function Tab:_build()
	local tabBtn = Instance.new("TextButton"); tabBtn.Size = UDim2.new(1, 0, 0, 34)
	tabBtn.BackgroundTransparency = 1; tabBtn.BorderSizePixel = 0; tabBtn.Text = self._name
	tabBtn.TextColor3 = Theme.TextDim; tabBtn.Font = Theme.Font; tabBtn.TextSize = 13
	tabBtn.AutoButtonColor = false; tabBtn.Parent = self._window._tabList
	CreateCorner(tabBtn, 6)
	self._tabButton = tabBtn

	local container = Instance.new("ScrollingFrame"); container.Size = UDim2.fromScale(1, 1)
	container.BackgroundTransparency = 1; container.BorderSizePixel = 0; container.ScrollBarThickness = 2
	container.ScrollBarImageColor3 = Theme.Accent; container.CanvasSize = UDim2.fromScale(0, 0)
	container.AutomaticCanvasSize = Enum.AutomaticSize.Y; container.Visible = false
	container.Parent = self._window._contentFrame
	local l = Instance.new("UIListLayout"); l.Padding = UDim.new(0, 5); l.Parent = container
	CreatePadding(container, 6, 6, 8, 8)
	self._container = container

	tabBtn.MouseButton1Click:Connect(function() self._window:SelectTab(self) end)
	tabBtn.MouseEnter:Connect(function()
		if self._window._selectedTab ~= self then Tween(tabBtn, { BackgroundTransparency = 0.85, BackgroundColor3 = Theme.SurfaceHover }, "Fast") end
	end)
	tabBtn.MouseLeave:Connect(function()
		if self._window._selectedTab ~= self then Tween(tabBtn, { BackgroundTransparency = 1 }, "Fast") end
	end)
end

function Tab:Show()
	self._container.Visible = true
	Tween(self._tabButton, { TextColor3 = Theme.Accent, BackgroundTransparency = 0.8, BackgroundColor3 = Theme.SurfaceHover }, "Fast")
end
function Tab:Hide()
	self._container.Visible = false
	Tween(self._tabButton, { TextColor3 = Theme.TextDim, BackgroundTransparency = 1 }, "Fast")
end

function Tab:CreateSection(name) CreateSection(self, name) end
function Tab:CreateButton(opts) CreateButton(self, opts) end
function Tab:CreateToggle(opts) CreateToggle(self, opts) end
function Tab:CreateSlider(opts) CreateSlider(self, opts) end
function Tab:CreateDropdown(opts) CreateDropdown(self, opts) end
function Tab:CreateTextBox(opts) CreateTextBoxComp(self, opts) end
function Tab:CreateKeybind(opts) CreateKeybind(self, opts) end
function Tab:CreateLabel(text) CreateLabel(self, text) end

--// ═══════════════════════════════════════════════
--// SECTION: Footer (Avatar + Stats)
--// ═══════════════════════════════════════════════

local function CreateFooter(gui, mainFrame)
	local footer = Instance.new("Frame")
	footer.Size = UDim2.new(1, 0, 0, 32)
	footer.Position = UDim2.new(0, 0, 1, 2)
	footer.BackgroundColor3 = Theme.Surface; footer.BackgroundTransparency = 0.15; footer.BorderSizePixel = 0
	footer.Parent = mainFrame
	CreateCorner(footer, 8); CreateStroke(footer, Theme.Border, 1, 0.8)

	-- Avatar (round)
	local avatarFrame = Instance.new("Frame"); avatarFrame.Size = UDim2.fromOffset(22, 22)
	avatarFrame.Position = UDim2.fromOffset(6, 5); avatarFrame.BackgroundColor3 = Theme.BgAlt
	avatarFrame.BorderSizePixel = 0; avatarFrame.Parent = footer; CreateCorner(avatarFrame, 11)

	local avatar = Instance.new("ImageLabel"); avatar.Size = UDim2.fromScale(1, 1)
	avatar.BackgroundTransparency = 1; avatar.Parent = avatarFrame; CreateCorner(avatar, 11)
	pcall(function()
		avatar.Image = Players:GetUserThumbnailAsync(Player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
	end)

	-- Username
	local userLabel = Instance.new("TextLabel"); userLabel.Size = UDim2.fromOffset(120, 22)
	userLabel.Position = UDim2.fromOffset(34, 5); userLabel.BackgroundTransparency = 1
	userLabel.Text = "@" .. Player.Name; userLabel.TextColor3 = Theme.TextDim
	userLabel.Font = Theme.Font; userLabel.TextSize = 11; userLabel.TextXAlignment = Enum.TextXAlignment.Left
	userLabel.Parent = footer

	-- Separator
	local sep = Instance.new("TextLabel"); sep.Size = UDim2.fromOffset(10, 22)
	sep.Position = UDim2.fromOffset(152, 5); sep.BackgroundTransparency = 1; sep.Text = "|"
	sep.TextColor3 = Theme.Border; sep.Font = Theme.FontLight; sep.TextSize = 12; sep.Parent = footer

	-- Stats labels
	local fpsL = Instance.new("TextLabel"); fpsL.Size = UDim2.fromOffset(65, 22)
	fpsL.Position = UDim2.fromOffset(168, 5); fpsL.BackgroundTransparency = 1; fpsL.Text = "FPS: --"
	fpsL.TextColor3 = Theme.Success; fpsL.Font = Theme.Font; fpsL.TextSize = 10
	fpsL.TextXAlignment = Enum.TextXAlignment.Left; fpsL.Parent = footer

	local pingL = Instance.new("TextLabel"); pingL.Size = UDim2.fromOffset(80, 22)
	pingL.Position = UDim2.fromOffset(233, 5); pingL.BackgroundTransparency = 1; pingL.Text = "PING: --"
	pingL.TextColor3 = Theme.Warning; pingL.Font = Theme.Font; pingL.TextSize = 10
	pingL.TextXAlignment = Enum.TextXAlignment.Left; pingL.Parent = footer

	-- Real-time updater
	local frameCount, lastTick = 0, tick()
	RunService.Heartbeat:Connect(function()
		frameCount = frameCount + 1
		local now = tick()
		if now - lastTick >= 0.5 then
			local fps = math.floor(frameCount / (now - lastTick))
			fpsL.Text = "FPS: " .. fps
			frameCount = 0; lastTick = now

			pcall(function()
				local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
				pingL.Text = "PING: " .. ping .. "ms"
			end)
		end
	end)

	return footer
end

--// ═══════════════════════════════════════════════
--// SECTION: Window System (Premium)
--// ═══════════════════════════════════════════════

local Window = {}; Window.__index = Window

function Window.new(library, opts)
	local self = setmetatable({ _library = library, _options = opts, _tabs = {}, _selectedTab = nil }, Window)
	self:_build(); return self
end

function Window:_build()
	local gui = CreateGUI("BloxBoxWindow", 50)
	self._gui = gui
	local size = self._options.Size or UDim2.fromOffset(580, 380)

	local main = Instance.new("Frame"); main.Name = "Main"; main.Size = size
	main.Position = self._options.Position or UDim2.fromScale(0.5, 0.5); main.AnchorPoint = Vector2.new(0.5, 0.5)
	main.BackgroundColor3 = Theme.Bg; main.BorderSizePixel = 0; main.Parent = gui
	CreateCorner(main, Theme.Radius); CreateStroke(main, Theme.Border, 1.5, 0.5)
	self._mainFrame = main

	-- Header
	local header = Instance.new("Frame"); header.Size = UDim2.new(1, 0, 0, 38)
	header.BackgroundColor3 = Theme.BgAlt; header.BorderSizePixel = 0; header.Parent = main
	CreateCorner(header, Theme.Radius)
	-- Fix bottom corners
	local fix = Instance.new("Frame"); fix.Size = UDim2.new(1, 0, 0, 12); fix.Position = UDim2.new(0, 0, 1, -12)
	fix.BackgroundColor3 = Theme.BgAlt; fix.BorderSizePixel = 0; fix.Parent = header

	-- Title with accent dot
	local dot = Instance.new("Frame"); dot.Size = UDim2.fromOffset(8, 8); dot.Position = UDim2.fromOffset(14, 15)
	dot.BackgroundColor3 = Theme.Accent; dot.BorderSizePixel = 0; dot.Parent = header; CreateCorner(dot, 4)

	local titleL = Instance.new("TextLabel"); titleL.Size = UDim2.new(1, -100, 1, 0); titleL.Position = UDim2.fromOffset(28, 0)
	titleL.BackgroundTransparency = 1; titleL.Text = self._options.Title or "BloxBox Window"
	titleL.TextColor3 = Theme.Text; titleL.Font = Theme.FontBold; titleL.TextSize = 15
	titleL.TextXAlignment = Enum.TextXAlignment.Left; titleL.Parent = header

	-- Minimize + Close
	local closeBtn = Instance.new("TextButton"); closeBtn.Size = UDim2.fromOffset(26, 26)
	closeBtn.Position = UDim2.new(1, -34, 0.5, 0); closeBtn.AnchorPoint = Vector2.new(0, 0.5)
	closeBtn.BackgroundColor3 = Theme.Error; closeBtn.BackgroundTransparency = 0.85
	closeBtn.Text = "✕"; closeBtn.TextColor3 = Theme.TextDim; closeBtn.Font = Theme.FontBold; closeBtn.TextSize = 12
	closeBtn.BorderSizePixel = 0; closeBtn.AutoButtonColor = false; closeBtn.Parent = header
	CreateCorner(closeBtn, 6)
	closeBtn.MouseEnter:Connect(function() Tween(closeBtn, { BackgroundTransparency = 0.3, TextColor3 = Theme.Text }, "Fast") end)
	closeBtn.MouseLeave:Connect(function() Tween(closeBtn, { BackgroundTransparency = 0.85, TextColor3 = Theme.TextDim }, "Fast") end)
	closeBtn.MouseButton1Click:Connect(function() self:Destroy() end)

	local minBtn = Instance.new("TextButton"); minBtn.Size = UDim2.fromOffset(26, 26)
	minBtn.Position = UDim2.new(1, -64, 0.5, 0); minBtn.AnchorPoint = Vector2.new(0, 0.5)
	minBtn.BackgroundColor3 = Theme.Warning; minBtn.BackgroundTransparency = 0.85
	minBtn.Text = "—"; minBtn.TextColor3 = Theme.TextDim; minBtn.Font = Theme.FontBold; minBtn.TextSize = 12
	minBtn.BorderSizePixel = 0; minBtn.AutoButtonColor = false; minBtn.Parent = header
	CreateCorner(minBtn, 6)
	minBtn.MouseEnter:Connect(function() Tween(minBtn, { BackgroundTransparency = 0.3, TextColor3 = Theme.Text }, "Fast") end)
	minBtn.MouseLeave:Connect(function() Tween(minBtn, { BackgroundTransparency = 0.85, TextColor3 = Theme.TextDim }, "Fast") end)

	-- Sidebar
	local sidebar = Instance.new("Frame"); sidebar.Size = UDim2.new(0, 130, 1, -38)
	sidebar.Position = UDim2.fromOffset(0, 38); sidebar.BackgroundColor3 = Theme.BgAlt
	sidebar.BackgroundTransparency = 0.4; sidebar.BorderSizePixel = 0; sidebar.Parent = main
	local sl = Instance.new("UIListLayout"); sl.Padding = UDim.new(0, 3); sl.Parent = sidebar
	CreatePadding(sidebar, 6, 6, 4, 4)
	self._tabList = sidebar

	-- Sidebar separator line
	local sepLine = Instance.new("Frame"); sepLine.Size = UDim2.new(0, 1, 1, -38)
	sepLine.Position = UDim2.fromOffset(130, 38); sepLine.BackgroundColor3 = Theme.Border
	sepLine.BackgroundTransparency = 0.5; sepLine.BorderSizePixel = 0; sepLine.Parent = main

	-- Content
	local content = Instance.new("Frame"); content.Size = UDim2.new(1, -131, 1, -38)
	content.Position = UDim2.fromOffset(131, 38); content.BackgroundTransparency = 1
	content.BorderSizePixel = 0; content.Parent = main
	self._contentFrame = content

	-- Footer
	CreateFooter(gui, main)

	-- Drag
	MakeDraggable(header, main)

	-- Entrance animation (slow appear from scale)
	main.BackgroundTransparency = 1
	main.Size = UDim2.fromOffset(size.X.Offset - 30, size.Y.Offset - 20)
	titleL.TextTransparency = 1
	Tween(main, { BackgroundTransparency = 0, Size = size }, "Bounce")
	Tween(titleL, { TextTransparency = 0 }, "Slow")
end

function Window:CreateTab(name)
	local tab = Tab.new(self, name)
	table.insert(self._tabs, tab)
	if #self._tabs == 1 then self:SelectTab(tab) end
	return tab
end

function Window:SelectTab(tab)
	for _, t in ipairs(self._tabs) do t:Hide() end
	tab:Show(); self._selectedTab = tab
end

function Window:Destroy()
	if self._gui then
		Tween(self._mainFrame, { BackgroundTransparency = 1, Size = UDim2.fromOffset(
			self._mainFrame.Size.X.Offset - 20, self._mainFrame.Size.Y.Offset - 15
		)}, "Normal")
		task.wait(0.35)
		self._gui:Destroy()
	end
end

--// ═══════════════════════════════════════════════
--// SECTION: Main Library (Public API)
--// ═══════════════════════════════════════════════

local BloxBoxUI = {}; BloxBoxUI.__index = BloxBoxUI

function BloxBoxUI.new()
	local self = setmetatable({}, BloxBoxUI)
	self._theme = Theme
	self._state = StateManager.new()
	return self
end
function BloxBoxUI:SetAccent(color) Theme.Accent = color; Theme.AccentDark = Color3.new(color.R * 0.7, color.G * 0.7, color.B * 0.7) end
function BloxBoxUI:ShowIntro(logoId, callback) ShowIntro(logoId, callback) end
function BloxBoxUI:CreateWindow(opts) return Window.new(self, opts) end
function BloxBoxUI:Notify(opts) ShowNotification(opts) end
function BloxBoxUI:SaveConfig(name) SaveConfig(self._state, name) end
function BloxBoxUI:LoadConfig(name) LoadConfig(self._state, name) end

print("[BloxBox UI] v2.0 Premium loaded")
return BloxBoxUI
