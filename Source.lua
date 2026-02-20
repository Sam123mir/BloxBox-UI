--[[ BLOXBOX UI v3.0 PREMIUM | by Samir & Team | Single-File | Material Icons | REDESIGNED ]]

local TS=game:GetService("TweenService")
local UIS=game:GetService("UserInputService")
local HTTP=game:GetService("HttpService")
local Players=game:GetService("Players")
local RS=game:GetService("RunService")
local Stats=game:GetService("Stats")
local P=Players.LocalPlayer

-- ╔══════════════════════════════════════╗
-- ║         NEBULA ICONS LOADER          ║
-- ╚══════════════════════════════════════╝
local Icons=nil
pcall(function() Icons=loadstring(game:HttpGet("https://raw.nebulasoftworks.xyz/nebula-icon-library-loader"))() end)
local function Icon(name)
	if Icons then
		local ok,img=pcall(function()return Icons:GetIcon(name,"Material")end)
		if ok and img then return img end
	end
	return ""
end

-- ╔══════════════════════════════════════╗
-- ║              SIGNAL                  ║
-- ╚══════════════════════════════════════╝
local Signal={};Signal.__index=Signal
function Signal.new()return setmetatable({_c={}},Signal)end
function Signal:Connect(fn)
	local c={_h=fn}
	c.Disconnect=function(s)
		for i,v in ipairs(self._c)do if v==s then table.remove(self._c,i)break end end
	end
	table.insert(self._c,c)
	return c
end
function Signal:Fire(...)for _,c in ipairs(self._c)do task.spawn(c._h,...)end end

-- ╔══════════════════════════════════════╗
-- ║            TWEEN CONFIGS             ║
-- ╚══════════════════════════════════════╝
local TI={
	Instant  = TweenInfo.new(0.05, Enum.EasingStyle.Quad,  Enum.EasingDirection.Out),
	Fast     = TweenInfo.new(0.14, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
	Normal   = TweenInfo.new(0.28, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
	Slow     = TweenInfo.new(0.50, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
	Bounce   = TweenInfo.new(0.55, Enum.EasingStyle.Back,  Enum.EasingDirection.Out),
	Spring   = TweenInfo.new(0.40, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out),
	Smooth   = TweenInfo.new(0.35, Enum.EasingStyle.Sine,  Enum.EasingDirection.InOut),
}
local function Tw(i,p,pr)
	local t=TS:Create(i,typeof(pr)=="TweenInfo"and pr or TI[pr or"Normal"],p)
	t:Play()
	return t
end

-- ╔══════════════════════════════════════╗
-- ║           THEME PALETTE              ║
-- ╚══════════════════════════════════════╝
local T={
	-- Backgrounds
	Bg       = Color3.fromRGB(10,10,14),
	BgAlt    = Color3.fromRGB(16,16,22),
	BgDeep   = Color3.fromRGB(7,7,10),
	Surface  = Color3.fromRGB(22,22,30),
	SurfHov  = Color3.fromRGB(32,32,44),
	SurfAct  = Color3.fromRGB(40,40,56),
	Glass    = Color3.fromRGB(26,26,36),

	-- Accent Colors
	Accent   = Color3.fromRGB(100,140,255),
	AccDark  = Color3.fromRGB(60,90,200),
	AccGlow  = Color3.fromRGB(80,120,255),
	AccSoft  = Color3.fromRGB(140,170,255),

	-- Text
	Text     = Color3.fromRGB(240,240,248),
	TextDim  = Color3.fromRGB(150,150,175),
	TextMut  = Color3.fromRGB(80,80,108),
	TextHigh = Color3.fromRGB(255,255,255),

	-- Semantic
	Succ     = Color3.fromRGB(72,210,120),
	SuccDark = Color3.fromRGB(45,150,85),
	Warn     = Color3.fromRGB(255,195,60),
	WarnDark = Color3.fromRGB(200,145,30),
	Err      = Color3.fromRGB(240,70,70),
	ErrDark  = Color3.fromRGB(180,40,40),
	Info     = Color3.fromRGB(100,200,255),

	-- Borders
	Border   = Color3.fromRGB(40,40,58),
	BorderHi = Color3.fromRGB(60,60,85),
	BorderAc = Color3.fromRGB(80,110,220),

	-- Fonts
	Font     = Enum.Font.GothamMedium,
	FontB    = Enum.Font.GothamBold,
	FontL    = Enum.Font.Gotham,
	FontSB   = Enum.Font.GothamSemibold,
}

-- ╔══════════════════════════════════════╗
-- ║          HELPER FUNCTIONS            ║
-- ╚══════════════════════════════════════╝
local function Corner(p,r)
	local c=Instance.new("UICorner")
	c.CornerRadius=UDim.new(0,r or 8)
	c.Parent=p
	return c
end

-- UPGRADED: Multi-layer border with glow support
local function Stroke(p,col,th,tr,style)
	local s=Instance.new("UIStroke")
	s.Color=col or T.Border
	s.Thickness=th or 1
	s.Transparency=tr or 0.6
	s.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
	if style=="Inner" then s.ApplyStrokeMode=Enum.ApplyStrokeMode.Contextual end
	s.Parent=p
	return s
end

-- NEW: Outer glow frame (simulated using negative padded ImageLabel)
local function GlowBorder(parent, color, size)
	local glow=Instance.new("ImageLabel")
	glow.Name="GlowBorder"
	glow.Size=UDim2.new(1, size or 16, 1, size or 16)
	glow.Position=UDim2.new(0, -(size or 8), 0, -(size or 8))
	glow.BackgroundTransparency=1
	glow.Image="rbxassetid://5028857084"
	glow.ImageColor3=color or T.Accent
	glow.ImageTransparency=0.88
	glow.ZIndex=parent.ZIndex-1
	glow.Parent=parent
	return glow
end

local function Pad(p,t,b,l,r)
	local u=Instance.new("UIPadding")
	u.PaddingTop=UDim.new(0,t or 0)
	u.PaddingBottom=UDim.new(0,b or 0)
	u.PaddingLeft=UDim.new(0,l or 0)
	u.PaddingRight=UDim.new(0,r or 0)
	u.Parent=p
end

local function MakeGUI(n,o)
	local g=Instance.new("ScreenGui")
	g.Name=n
	g.ResetOnSpawn=false
	g.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
	g.DisplayOrder=o or 1
	pcall(function()g.Parent=game:GetService("CoreGui")end)
	if not g.Parent then g.Parent=P:WaitForChild("PlayerGui")end
	return g
end

-- UPGRADED: Gradient with multiple stops
local function Grad(parent,c1,c2,rot,c3)
	local g=Instance.new("UIGradient")
	if c3 then
		g.Color=ColorSequence.new({
			ColorSequenceKeypoint.new(0,c1),
			ColorSequenceKeypoint.new(0.5,c3),
			ColorSequenceKeypoint.new(1,c2),
		})
	else
		g.Color=ColorSequence.new(c1,c2)
	end
	g.Rotation=rot or 135
	g.Parent=parent
	return g
end

-- UPGRADED: Divider with fade gradient
local function Divider(parent,pos,w)
	local d=Instance.new("Frame")
	d.Size=UDim2.new(0,w or 1,0,20)
	d.Position=pos
	d.BackgroundColor3=T.Border
	d.BackgroundTransparency=0.2
	d.BorderSizePixel=0
	d.Parent=parent
	Corner(d,1)
	local g=Instance.new("UIGradient")
	g.Color=ColorSequence.new({
		ColorSequenceKeypoint.new(0,Color3.new(1,1,1)),
		ColorSequenceKeypoint.new(0.5,Color3.new(1,1,1)),
		ColorSequenceKeypoint.new(1,Color3.new(0,0,0)),
	})
	g.Transparency=NumberSequence.new({
		NumberSequenceKeypoint.new(0,1),
		NumberSequenceKeypoint.new(0.15,0),
		NumberSequenceKeypoint.new(0.85,0),
		NumberSequenceKeypoint.new(1,1),
	})
	g.Rotation=90
	g.Parent=d
	return d
end

-- Executor Detection
local function DetectExecutor()
	local n="Unknown"
	pcall(function()
		if identifyexecutor then n=identifyexecutor()
		elseif getexecutorname then n=getexecutorname()
		elseif syn then n="Synapse X"
		elseif fluxus then n="Fluxus"
		elseif KRNL_LOADED then n="KRNL"
		end
	end)
	return n
end

-- ╔══════════════════════════════════════╗
-- ║          RIPPLE EFFECT               ║
-- ╚══════════════════════════════════════╝
local function MakeRipple(button, color)
	button.ClipsDescendants = true
	button.InputBegan:Connect(function(inp)
		if inp.UserInputType ~= Enum.UserInputType.MouseButton1 and
		   inp.UserInputType ~= Enum.UserInputType.Touch then return end

		local abs = button.AbsolutePosition
		local sz  = button.AbsoluteSize
		local relX = inp.Position.X - abs.X
		local relY = inp.Position.Y - abs.Y

		local ripple = Instance.new("Frame")
		ripple.Name = "Ripple"
		ripple.Size = UDim2.fromOffset(0,0)
		ripple.Position = UDim2.fromOffset(relX, relY)
		ripple.AnchorPoint = Vector2.new(0.5,0.5)
		ripple.BackgroundColor3 = color or Color3.new(1,1,1)
		ripple.BackgroundTransparency = 0.75
		ripple.BorderSizePixel = 0
		ripple.ZIndex = button.ZIndex + 10
		ripple.Parent = button
		Corner(ripple, 999)

		local maxSz = math.max(sz.X, sz.Y) * 2.2
		Tw(ripple, {Size=UDim2.fromOffset(maxSz,maxSz), BackgroundTransparency=0.95}, TI.Slow)
		task.delay(0.55, function() ripple:Destroy() end)
	end)
end

-- ╔══════════════════════════════════════╗
-- ║         STATE MANAGER                ║
-- ╚══════════════════════════════════════╝
local SM={};SM.__index=SM
function SM.new()return setmetatable({_s={},_sub={}},SM)end
function SM:Set(f,v)
	if self._s[f]==v then return end
	self._s[f]=v
	if self._sub[f]then self._sub[f]:Fire(v)end
end
function SM:Get(f,d)local v=self._s[f];return v==nil and d or v end
function SM:Sub(f,fn)
	if not self._sub[f]then self._sub[f]=Signal.new()end
	return self._sub[f]:Connect(fn)
end

-- Config
local function SaveCfg(s,n)
	pcall(function()
		if writefile then
			if not isfolder("BloxBox")then makefolder("BloxBox")end
			writefile("BloxBox/"..n..".json",HTTP:JSONEncode(s._s))
		end
	end)
end
local function LoadCfg(s,n)
	pcall(function()
		if readfile and isfile and isfile("BloxBox/"..n..".json")then
			local d=HTTP:JSONDecode(readfile("BloxBox/"..n..".json"))
			if d then for k,v in pairs(d)do s:Set(k,v)end end
		end
	end)
end

-- Drag
local function MakeDrag(h,f)
	local dr,ds,sp=false,nil,nil
	h.InputBegan:Connect(function(i)
		if i.UserInputType==Enum.UserInputType.MouseButton1 or
		   i.UserInputType==Enum.UserInputType.Touch then
			dr=true;ds=i.Position;sp=f.Position
			i.Changed:Connect(function()
				if i.UserInputState==Enum.UserInputState.End then dr=false end
			end)
		end
	end)
	UIS.InputChanged:Connect(function(i)
		if dr and(i.UserInputType==Enum.UserInputType.MouseMovement or
				  i.UserInputType==Enum.UserInputType.Touch)then
			local d=i.Position-ds
			Tw(f,{Position=UDim2.new(sp.X.Scale,sp.X.Offset+d.X,sp.Y.Scale,sp.Y.Offset+d.Y)},TI.Instant)
		end
	end)
end

-- ╔══════════════════════════════════════╗
-- ║        NOTIFICATIONS v3.0            ║
-- ╚══════════════════════════════════════╝
local NC=nil
local function GetNC()
	if NC and NC.Parent then return NC end
	local g=MakeGUI("BBN",200)
	local c=Instance.new("Frame")
	c.Size=UDim2.new(0,310,1,-20)
	c.Position=UDim2.new(1,-320,0,10)
	c.BackgroundTransparency=1
	c.Parent=g
	local l=Instance.new("UIListLayout")
	l.Padding=UDim.new(0,8)
	l.VerticalAlignment=Enum.VerticalAlignment.Top
	l.SortOrder=Enum.SortOrder.LayoutOrder
	l.Parent=c
	NC=c
	return c
end

local function Notif(o)
	local c=GetNC()
	local typeData={
		Info    ={color=T.Accent,  icon="info",         bg=Color3.fromRGB(20,28,55)},
		Success ={color=T.Succ,    icon="check_circle",  bg=Color3.fromRGB(15,40,28)},
		Warning ={color=T.Warn,    icon="warning",       bg=Color3.fromRGB(50,38,10)},
		Error   ={color=T.Err,     icon="error",         bg=Color3.fromRGB(50,14,14)},
	}
	local td=typeData[o.Type or"Info"] or typeData.Info
	local col=td.color

	-- Outer card
	local card=Instance.new("Frame")
	card.Name="Notif"
	card.Size=UDim2.new(1,0,0,72)
	card.BackgroundColor3=T.BgAlt
	card.BackgroundTransparency=0.04
	card.BorderSizePixel=0
	card.ClipsDescendants=true
	card.Parent=c
	Corner(card,12)

	-- Subtle tinted inner bg
	local tint=Instance.new("Frame")
	tint.Size=UDim2.fromScale(1,1)
	tint.BackgroundColor3=td.bg
	tint.BackgroundTransparency=0.65
	tint.BorderSizePixel=0
	tint.Parent=card

	-- Colored border stroke (full)
	local stroke=Stroke(card, col, 1.2, 0.3)

	-- Accent left bar (wider + gradient)
	local bar=Instance.new("Frame")
	bar.Size=UDim2.new(0,4,1,-14)
	bar.Position=UDim2.fromOffset(5,7)
	bar.BackgroundColor3=col
	bar.BorderSizePixel=0
	bar.Parent=card
	Corner(bar,3)
	Grad(bar, col, T.AccDark, 180)

	-- Icon background circle
	local icBg=Instance.new("Frame")
	icBg.Size=UDim2.fromOffset(28,28)
	icBg.Position=UDim2.fromOffset(16,22)
	icBg.BackgroundColor3=col
	icBg.BackgroundTransparency=0.75
	icBg.BorderSizePixel=0
	icBg.Parent=card
	Corner(icBg,14)

	local ic=Instance.new("ImageLabel")
	ic.Size=UDim2.fromOffset(16,16)
	ic.Position=UDim2.fromOffset(6,6)
	ic.BackgroundTransparency=1
	ic.ImageColor3=col
	ic.Image=Icon(td.icon)
	ic.Parent=icBg

	-- Title
	local tt=Instance.new("TextLabel")
	tt.Size=UDim2.new(1,-66,0,20)
	tt.Position=UDim2.fromOffset(52,10)
	tt.BackgroundTransparency=1
	tt.Text=o.Title or ""
	tt.TextColor3=T.TextHigh
	tt.Font=T.FontB
	tt.TextSize=13
	tt.TextXAlignment=Enum.TextXAlignment.Left
	tt.Parent=card

	-- Body
	local bd=Instance.new("TextLabel")
	bd.Size=UDim2.new(1,-66,0,30)
	bd.Position=UDim2.fromOffset(52,30)
	bd.BackgroundTransparency=1
	bd.Text=o.Content or ""
	bd.TextColor3=T.TextDim
	bd.Font=T.FontL
	bd.TextSize=11
	bd.TextXAlignment=Enum.TextXAlignment.Left
	bd.TextWrapped=true
	bd.Parent=card

	-- Progress bar at bottom (drains over duration)
	local pbg=Instance.new("Frame")
	pbg.Size=UDim2.new(1,0,0,2)
	pbg.Position=UDim2.new(0,0,1,-2)
	pbg.BackgroundColor3=T.BgDeep
	pbg.BackgroundTransparency=0.3
	pbg.BorderSizePixel=0
	pbg.Parent=card

	local pfl=Instance.new("Frame")
	pfl.Size=UDim2.fromScale(1,1)
	pfl.BackgroundColor3=col
	pfl.BackgroundTransparency=0.2
	pfl.BorderSizePixel=0
	pfl.Parent=pbg
	Corner(pfl,1)

	-- Close button (X)
	local xBtn=Instance.new("TextButton")
	xBtn.Size=UDim2.fromOffset(18,18)
	xBtn.Position=UDim2.new(1,-22,0,8)
	xBtn.BackgroundColor3=T.Surface
	xBtn.BackgroundTransparency=0.5
	xBtn.Text="×"
	xBtn.TextColor3=T.TextMut
	xBtn.Font=T.FontB
	xBtn.TextSize=14
	xBtn.BorderSizePixel=0
	xBtn.AutoButtonColor=false
	xBtn.Parent=card
	Corner(xBtn,9)

	-- Entrance animation (slide from right)
	card.Position=UDim2.fromOffset(320,0)
	Tw(card,{Position=UDim2.fromOffset(0,0)},TI.Bounce)

	local dur=o.Duration or 4
	local dismissed=false

	local function Dismiss()
		if dismissed then return end
		dismissed=true
		Tw(card,{Position=UDim2.fromOffset(320,0),BackgroundTransparency=1},TI.Normal)
		task.delay(0.32,function()card:Destroy()end)
	end

	xBtn.MouseButton1Click:Connect(Dismiss)
	card.InputBegan:Connect(function(inp)
		if inp.UserInputType==Enum.UserInputType.MouseButton1 then Dismiss()end
	end)

	-- Drain progress bar then dismiss
	Tw(pfl,{Size=UDim2.fromScale(0,1)},TweenInfo.new(dur,Enum.EasingStyle.Linear))
	task.delay(dur,Dismiss)
end

-- ╔══════════════════════════════════════╗
-- ║         INTRO SCREEN v3.0            ║
-- ╚══════════════════════════════════════╝
local function ShowIntro(logoId,cb)
	local gui=MakeGUI("BBI",999)

	local bg=Instance.new("Frame")
	bg.Size=UDim2.fromScale(1,1)
	bg.BackgroundColor3=Color3.fromRGB(6,6,10)
	bg.BorderSizePixel=0
	bg.Parent=gui

	-- Radial ambient glow
	local glow=Instance.new("ImageLabel")
	glow.Size=UDim2.fromOffset(500,400)
	glow.Position=UDim2.fromScale(0.5,0.5)
	glow.AnchorPoint=Vector2.new(0.5,0.5)
	glow.BackgroundTransparency=1
	glow.Image="rbxassetid://5028857084"
	glow.ImageColor3=T.Accent
	glow.ImageTransparency=0.88
	glow.Parent=bg

	-- Card
	local card=Instance.new("Frame")
	card.Size=UDim2.fromOffset(270,168)
	card.Position=UDim2.fromScale(0.5,0.5)
	card.AnchorPoint=Vector2.new(0.5,0.5)
	card.BackgroundColor3=T.Surface
	card.BackgroundTransparency=0.08
	card.BorderSizePixel=0
	card.Parent=bg
	Corner(card,16)
	Stroke(card,T.AccGlow,1.4,0.4)
	Grad(card,Color3.fromRGB(30,30,44),Color3.fromRGB(18,18,26))

	-- Shimmer line across top
	local shimmer=Instance.new("Frame")
	shimmer.Size=UDim2.new(0,0,0,1)
	shimmer.Position=UDim2.fromOffset(0,0)
	shimmer.BackgroundColor3=T.AccSoft
	shimmer.BackgroundTransparency=0.2
	shimmer.BorderSizePixel=0
	shimmer.ZIndex=10
	shimmer.Parent=card
	Corner(shimmer,1)

	local logo=Instance.new("ImageLabel")
	logo.Size=UDim2.fromOffset(52,52)
	logo.Position=UDim2.new(0.5,0,0,16)
	logo.AnchorPoint=Vector2.new(0.5,0)
	logo.BackgroundTransparency=1
	logo.Image=logoId or ""
	logo.ImageTransparency=1
	logo.Parent=card

	local ttl=Instance.new("TextLabel")
	ttl.Size=UDim2.new(1,0,0,24)
	ttl.Position=UDim2.new(0.5,0,0,74)
	ttl.AnchorPoint=Vector2.new(0.5,0)
	ttl.BackgroundTransparency=1
	ttl.Text="BloxBox UI"
	ttl.TextColor3=T.Text
	ttl.Font=T.FontB
	ttl.TextSize=18
	ttl.TextTransparency=1
	ttl.Parent=card

	local sub=Instance.new("TextLabel")
	sub.Size=UDim2.new(1,0,0,14)
	sub.Position=UDim2.new(0.5,0,0,100)
	sub.AnchorPoint=Vector2.new(0.5,0)
	sub.BackgroundTransparency=1
	sub.Text="v3.0 Premium"
	sub.TextColor3=T.Accent
	sub.Font=T.FontSB
	sub.TextSize=11
	sub.TextTransparency=1
	sub.Parent=card

	-- Progress bar container
	local barBg=Instance.new("Frame")
	barBg.Size=UDim2.new(0.65,0,0,4)
	barBg.Position=UDim2.new(0.5,0,0,130)
	barBg.AnchorPoint=Vector2.new(0.5,0)
	barBg.BackgroundColor3=T.Border
	barBg.BackgroundTransparency=0.5
	barBg.BorderSizePixel=0
	barBg.Parent=card
	Corner(barBg,3)

	local fill=Instance.new("Frame")
	fill.Size=UDim2.fromScale(0,1)
	fill.BackgroundColor3=T.Accent
	fill.BorderSizePixel=0
	fill.Parent=barBg
	Corner(fill,3)
	Grad(fill,T.AccSoft,T.AccDark,180)

	-- Fill shine on progress bar
	local fillShine=Instance.new("Frame")
	fillShine.Size=UDim2.fromOffset(8,4)
	fillShine.Position=UDim2.new(1,-4,0,0)
	fillShine.BackgroundColor3=Color3.new(1,1,1)
	fillShine.BackgroundTransparency=0.6
	fillShine.BorderSizePixel=0
	fillShine.Parent=fill
	Corner(fillShine,3)

	-- Loading text
	local loadLbl=Instance.new("TextLabel")
	loadLbl.Size=UDim2.new(1,0,0,12)
	loadLbl.Position=UDim2.new(0.5,0,0,144)
	loadLbl.AnchorPoint=Vector2.new(0.5,0)
	loadLbl.BackgroundTransparency=1
	loadLbl.Text="Cargando..."
	loadLbl.TextColor3=T.TextMut
	loadLbl.Font=T.Font
	loadLbl.TextSize=9
	loadLbl.TextTransparency=1
	loadLbl.Parent=card

	task.spawn(function()
		Tw(card,{BackgroundTransparency=0.04},TI.Slow)
		task.wait(0.25)
		Tw(logo,{ImageTransparency=0},TI.Slow)
		task.wait(0.3)
		Tw(ttl,{TextTransparency=0},TI.Normal)
		task.wait(0.15)
		Tw(sub,{TextTransparency=0},TI.Normal)
		task.wait(0.15)
		Tw(loadLbl,{TextTransparency=0},TI.Normal)

		-- Shimmer animation
		Tw(shimmer,{Size=UDim2.new(1,0,0,1)},TweenInfo.new(0.6,Enum.EasingStyle.Sine))

		-- Progress fill
		local fillTween=Tw(fill,{Size=UDim2.fromScale(1,1)},TweenInfo.new(2.6,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut))
		fillTween.Completed:Wait()
		loadLbl.Text="¡Listo!"
		task.wait(0.4)

		-- Fade out
		Tw(card,{BackgroundTransparency=1},TI.Normal)
		Tw(logo,{ImageTransparency=1},TI.Normal)
		Tw(ttl,{TextTransparency=1},TI.Normal)
		Tw(sub,{TextTransparency=1},TI.Normal)
		Tw(loadLbl,{TextTransparency=1},TI.Normal)
		Tw(barBg,{BackgroundTransparency=1},TI.Normal)
		Tw(glow,{ImageTransparency=1},TI.Normal)
		task.wait(0.28)
		Tw(bg,{BackgroundTransparency=1},TI.Normal)
		task.wait(0.45)
		gui:Destroy()
		if cb then cb()end
	end)
end

-- ╔══════════════════════════════════════╗
-- ║           COMPONENTS v3.0           ║
-- ╚══════════════════════════════════════╝

-- SECTION DIVIDER (improved pill style)
local function CSection(tab,name)
	local f=Instance.new("Frame")
	f.Size=UDim2.new(1,0,0,28)
	f.BackgroundTransparency=1
	f.Parent=tab._ct

	local pill=Instance.new("Frame")
	pill.Size=UDim2.new(0,0,0,18)
	pill.AutomaticSize=Enum.AutomaticSize.X
	pill.Position=UDim2.fromOffset(0,5)
	pill.BackgroundColor3=T.Surface
	pill.BackgroundTransparency=0.3
	pill.BorderSizePixel=0
	pill.Parent=f
	Corner(pill,9)
	Stroke(pill,T.Border,1,0.5)

	local dot=Instance.new("Frame")
	dot.Size=UDim2.fromOffset(5,5)
	dot.Position=UDim2.fromOffset(8,6)
	dot.BackgroundColor3=T.Accent
	dot.BorderSizePixel=0
	dot.Parent=pill
	Corner(dot,3)

	local lb=Instance.new("TextLabel")
	lb.AutomaticSize=Enum.AutomaticSize.X
	lb.Size=UDim2.new(0,0,0,18)
	lb.Position=UDim2.fromOffset(19,0)
	lb.BackgroundTransparency=1
	lb.Text=name.."  "
	lb.TextColor3=T.TextDim
	lb.Font=T.FontSB
	lb.TextSize=10
	lb.Parent=pill

	local ln=Instance.new("Frame")
	ln.Size=UDim2.new(1,0,0,1)
	ln.Position=UDim2.new(0,0,1,-1)
	ln.BackgroundColor3=T.Border
	ln.BackgroundTransparency=0.55
	ln.BorderSizePixel=0
	ln.Parent=f
end

-- BUTTON (redesigned with ripple + gradient + icon ring)
local function CButton(tab,o)
	local b=Instance.new("TextButton")
	b.Size=UDim2.new(1,0,0,36)
	b.BackgroundColor3=T.Surface
	b.BorderSizePixel=0
	b.Text=""
	b.AutoButtonColor=false
	b.Parent=tab._ct
	b.ClipsDescendants=true
	Corner(b,8)
	Stroke(b,T.Border,1,0.7)

	-- Inner gradient tint
	local inner=Instance.new("Frame")
	inner.Size=UDim2.fromScale(1,1)
	inner.BackgroundColor3=T.Surface
	inner.BackgroundTransparency=0.5
	inner.BorderSizePixel=0
	inner.ZIndex=b.ZIndex
	inner.Parent=b
	Grad(inner,Color3.fromRGB(36,36,50),Color3.fromRGB(22,22,30),180)

	-- Icon badge
	local icBg=Instance.new("Frame")
	icBg.Size=UDim2.fromOffset(22,22)
	icBg.Position=UDim2.fromOffset(8,7)
	icBg.BackgroundColor3=T.Accent
	icBg.BackgroundTransparency=0.82
	icBg.BorderSizePixel=0
	icBg.Parent=b
	Corner(icBg,6)

	local ic=Instance.new("ImageLabel")
	ic.Size=UDim2.fromOffset(14,14)
	ic.Position=UDim2.fromOffset(4,4)
	ic.BackgroundTransparency=1
	ic.ImageColor3=T.Accent
	ic.Image=Icon(o.Icon or "play_arrow")
	ic.Parent=icBg

	local lb=Instance.new("TextLabel")
	lb.Size=UDim2.new(1,-80,1,0)
	lb.Position=UDim2.fromOffset(38,0)
	lb.BackgroundTransparency=1
	lb.Text=o.Name
	lb.TextColor3=T.Text
	lb.Font=T.Font
	lb.TextSize=13
	lb.TextXAlignment=Enum.TextXAlignment.Left
	lb.Parent=b

	-- Right arrow indicator
	local arrow=Instance.new("ImageLabel")
	arrow.Size=UDim2.fromOffset(12,12)
	arrow.Position=UDim2.new(1,-18,0.5,0)
	arrow.AnchorPoint=Vector2.new(0,0.5)
	arrow.BackgroundTransparency=1
	arrow.ImageColor3=T.TextMut
	arrow.Image=Icon("chevron_right")
	arrow.Parent=b

	MakeRipple(b, T.Accent)

	b.MouseEnter:Connect(function()
		Tw(b,{BackgroundColor3=T.SurfHov},TI.Fast)
		Tw(ic,{ImageColor3=T.TextHigh},TI.Fast)
		Tw(icBg,{BackgroundTransparency=0.6},TI.Fast)
		Tw(arrow,{ImageColor3=T.Accent},TI.Fast)
		Tw(lb,{TextColor3=T.TextHigh},TI.Fast)
	end)
	b.MouseLeave:Connect(function()
		Tw(b,{BackgroundColor3=T.Surface},TI.Fast)
		Tw(ic,{ImageColor3=T.Accent},TI.Fast)
		Tw(icBg,{BackgroundTransparency=0.82},TI.Fast)
		Tw(arrow,{ImageColor3=T.TextMut},TI.Fast)
		Tw(lb,{TextColor3=T.Text},TI.Fast)
	end)
	b.MouseButton1Down:Connect(function()
		Tw(b,{BackgroundColor3=T.SurfAct},TI.Instant)
	end)
	b.MouseButton1Up:Connect(function()
		Tw(b,{BackgroundColor3=T.SurfHov},TI.Fast)
	end)
	b.MouseButton1Click:Connect(function()
		if o.Callback then o.Callback()end
	end)
end

-- TOGGLE (redesigned with pill + glow indicator)
local function CToggle(tab,o)
	local st=tab._lib._state

	local c=Instance.new("TextButton")
	c.Size=UDim2.new(1,0,0,36)
	c.BackgroundColor3=T.Surface
	c.BorderSizePixel=0
	c.Text=""
	c.AutoButtonColor=false
	c.ClipsDescendants=true
	c.Parent=tab._ct
	Corner(c,8)
	Stroke(c,T.Border,1,0.72)

	local inner=Instance.new("Frame")
	inner.Size=UDim2.fromScale(1,1)
	inner.BackgroundColor3=T.Surface
	inner.BackgroundTransparency=0.55
	inner.BorderSizePixel=0
	inner.Parent=c
	Grad(inner,Color3.fromRGB(34,34,48),Color3.fromRGB(22,22,30),180)

	local lb=Instance.new("TextLabel")
	lb.Size=UDim2.new(1,-70,1,0)
	lb.Position=UDim2.fromOffset(12,0)
	lb.BackgroundTransparency=1
	lb.Text=o.Name
	lb.TextColor3=T.Text
	lb.Font=T.Font
	lb.TextSize=13
	lb.TextXAlignment=Enum.TextXAlignment.Left
	lb.Parent=c

	-- Toggle track (wider, rounder)
	local tk=Instance.new("Frame")
	tk.Size=UDim2.fromOffset(38,20)
	tk.Position=UDim2.new(1,-48,0.5,0)
	tk.AnchorPoint=Vector2.new(0,0.5)
	tk.BackgroundColor3=Color3.fromRGB(45,45,60)
	tk.BorderSizePixel=0
	tk.Parent=c
	Corner(tk,10)
	Stroke(tk,T.Border,1,0.5)

	-- Track inner shine
	local tkShine=Instance.new("Frame")
	tkShine.Size=UDim2.new(1,0,0,8)
	tkShine.BackgroundColor3=Color3.new(1,1,1)
	tkShine.BackgroundTransparency=0.9
	tkShine.BorderSizePixel=0
	tkShine.Parent=tk
	Corner(tkShine,10)

	-- Knob
	local kn=Instance.new("Frame")
	kn.Size=UDim2.fromOffset(14,14)
	kn.Position=UDim2.fromOffset(3,3)
	kn.BackgroundColor3=T.TextMut
	kn.BorderSizePixel=0
	kn.Parent=tk
	Corner(kn,7)

	-- Knob inner glow dot
	local knDot=Instance.new("Frame")
	knDot.Size=UDim2.fromOffset(6,6)
	knDot.Position=UDim2.fromOffset(4,4)
	knDot.BackgroundColor3=Color3.new(1,1,1)
	knDot.BackgroundTransparency=1
	knDot.BorderSizePixel=0
	knDot.Parent=kn
	Corner(knDot,3)

	-- State label (ON/OFF)
	local stLbl=Instance.new("TextLabel")
	stLbl.Size=UDim2.fromOffset(26,14)
	stLbl.Position=UDim2.new(1,-76,0.5,0)
	stLbl.AnchorPoint=Vector2.new(0,0.5)
	stLbl.BackgroundTransparency=1
	stLbl.Text="OFF"
	stLbl.TextColor3=T.TextMut
	stLbl.Font=T.FontB
	stLbl.TextSize=9
	stLbl.TextXAlignment=Enum.TextXAlignment.Right
	stLbl.Parent=c

	local function upd(v)
		if v then
			Tw(kn,{Position=UDim2.fromOffset(21,3),BackgroundColor3=Color3.new(1,1,1)},TI.Fast)
			Tw(tk,{BackgroundColor3=T.Accent},TI.Fast)
			Tw(knDot,{BackgroundTransparency=0.6},TI.Fast)
			Tw(stLbl,{TextColor3=T.Accent},TI.Fast)
			stLbl.Text="ON"
		else
			Tw(kn,{Position=UDim2.fromOffset(3,3),BackgroundColor3=T.TextMut},TI.Fast)
			Tw(tk,{BackgroundColor3=Color3.fromRGB(45,45,60)},TI.Fast)
			Tw(knDot,{BackgroundTransparency=1},TI.Fast)
			Tw(stLbl,{TextColor3=T.TextMut},TI.Fast)
			stLbl.Text="OFF"
		end
	end

	st:Sub(o.Flag,function(v)upd(v);if o.Callback then o.Callback(v)end end)
	c.MouseButton1Click:Connect(function()
		st:Set(o.Flag,not st:Get(o.Flag,false))
	end)
	c.MouseEnter:Connect(function()Tw(c,{BackgroundColor3=T.SurfHov},TI.Fast)end)
	c.MouseLeave:Connect(function()Tw(c,{BackgroundColor3=T.Surface},TI.Fast)end)
	st:Set(o.Flag,o.Default==true)
end

-- SLIDER v3.0 (redesigned with value bubble + tick marks)
local function CSlider(tab,o)
	local st=tab._lib._state

	local c=Instance.new("Frame")
	c.Size=UDim2.new(1,0,0,54)
	c.BackgroundColor3=T.Surface
	c.BorderSizePixel=0
	c.Parent=tab._ct
	Corner(c,8)
	Stroke(c,T.Border,1,0.72)

	local inner=Instance.new("Frame")
	inner.Size=UDim2.fromScale(1,1)
	inner.BackgroundColor3=T.Surface
	inner.BackgroundTransparency=0.5
	inner.BorderSizePixel=0
	inner.Parent=c
	Grad(inner,Color3.fromRGB(34,34,48),Color3.fromRGB(22,22,30),180)

	-- Name label
	local lb=Instance.new("TextLabel")
	lb.Size=UDim2.new(1,-72,0,18)
	lb.Position=UDim2.fromOffset(12,5)
	lb.BackgroundTransparency=1
	lb.Text=o.Name
	lb.TextColor3=T.Text
	lb.Font=T.Font
	lb.TextSize=13
	lb.TextXAlignment=Enum.TextXAlignment.Left
	lb.Parent=c

	-- Min / Max labels
	local minL=Instance.new("TextLabel")
	minL.Size=UDim2.fromOffset(30,12)
	minL.Position=UDim2.fromOffset(12,38)
	minL.BackgroundTransparency=1
	minL.Text=tostring(o.Min)
	minL.TextColor3=T.TextMut
	minL.Font=T.Font
	minL.TextSize=9
	minL.TextXAlignment=Enum.TextXAlignment.Left
	minL.Parent=c

	local maxL=Instance.new("TextLabel")
	maxL.Size=UDim2.fromOffset(30,12)
	maxL.Position=UDim2.new(1,-42,0,38)
	maxL.BackgroundTransparency=1
	maxL.Text=tostring(o.Max)
	maxL.TextColor3=T.TextMut
	maxL.Font=T.Font
	maxL.TextSize=9
	maxL.TextXAlignment=Enum.TextXAlignment.Right
	maxL.Parent=c

	-- Value badge (pill)
	local vBg=Instance.new("Frame")
	vBg.Size=UDim2.fromOffset(52,20)
	vBg.Position=UDim2.new(1,-62,0,4)
	vBg.BackgroundColor3=T.Accent
	vBg.BackgroundTransparency=0.75
	vBg.BorderSizePixel=0
	vBg.Parent=c
	Corner(vBg,10)
	Stroke(vBg,T.Accent,1,0.5)

	local vl=Instance.new("TextLabel")
	vl.Size=UDim2.fromScale(1,1)
	vl.BackgroundTransparency=1
	vl.Text=tostring(o.Default or o.Min)
	vl.TextColor3=T.AccSoft
	vl.Font=T.FontB
	vl.TextSize=12
	vl.Parent=vBg

	-- Track background
	local tbg=Instance.new("Frame")
	tbg.Size=UDim2.new(1,-24,0,5)
	tbg.Position=UDim2.fromOffset(12,26)
	tbg.BackgroundColor3=T.BgAlt
	tbg.BorderSizePixel=0
	tbg.Parent=c
	Corner(tbg,3)
	Stroke(tbg,T.Border,1,0.6)

	-- Filled portion
	local fl=Instance.new("Frame")
	fl.Size=UDim2.fromScale(0,1)
	fl.BackgroundColor3=T.Accent
	fl.BorderSizePixel=0
	fl.Parent=tbg
	Corner(fl,3)
	Grad(fl,T.AccSoft,T.AccDark,180)

	-- Knob
	local kc=Instance.new("Frame")
	kc.Size=UDim2.fromOffset(14,14)
	kc.Position=UDim2.new(1,-7,0.5,0)
	kc.AnchorPoint=Vector2.new(0.5,0.5)
	kc.BackgroundColor3=T.Text
	kc.BorderSizePixel=0
	kc.Parent=fl
	Corner(kc,7)
	Stroke(kc,T.Accent,1.5,0.3)

	-- Knob inner dot
	local kdot=Instance.new("Frame")
	kdot.Size=UDim2.fromOffset(5,5)
	kdot.Position=UDim2.fromOffset(4,4)
	kdot.BackgroundColor3=T.Accent
	kdot.BackgroundTransparency=0.1
	kdot.BorderSizePixel=0
	kdot.Parent=kc
	Corner(kdot,3)

	local dg=false
	local mn,mx=o.Min,o.Max

	local function upd(p)
		p=math.clamp(p,0,1)
		local v=math.floor(mn+(mx-mn)*p+0.5)
		fl.Size=UDim2.fromScale(p,1)
		vl.Text=tostring(v)
		st:Set(o.Flag,v)
		if o.Callback then o.Callback(v)end
	end

	tbg.InputBegan:Connect(function(i)
		if i.UserInputType==Enum.UserInputType.MouseButton1 or
		   i.UserInputType==Enum.UserInputType.Touch then
			dg=true
			Tw(kc,{Size=UDim2.fromOffset(18,18)},TI.Fast)
			upd((i.Position.X-tbg.AbsolutePosition.X)/tbg.AbsoluteSize.X)
		end
	end)
	UIS.InputChanged:Connect(function(i)
		if dg and(i.UserInputType==Enum.UserInputType.MouseMovement or
				  i.UserInputType==Enum.UserInputType.Touch)then
			upd((i.Position.X-tbg.AbsolutePosition.X)/tbg.AbsoluteSize.X)
		end
	end)
	UIS.InputEnded:Connect(function(i)
		if i.UserInputType==Enum.UserInputType.MouseButton1 or
		   i.UserInputType==Enum.UserInputType.Touch then
			if dg then
				dg=false
				Tw(kc,{Size=UDim2.fromOffset(14,14)},TI.Bounce)
			end
		end
	end)

	local def=o.Default or mn
	fl.Size=UDim2.fromScale((def-mn)/(mx-mn),1)
	vl.Text=tostring(def)
	st:Set(o.Flag,def)
end

-- DROPDOWN (improved with search and animated chevron)
local function CDropdown(tab,o)
	local st=tab._lib._state
	local op=false

	local c=Instance.new("Frame")
	c.Size=UDim2.new(1,0,0,36)
	c.BackgroundColor3=T.Surface
	c.BorderSizePixel=0
	c.ClipsDescendants=true
	c.Parent=tab._ct
	Corner(c,8)
	Stroke(c,T.Border,1,0.72)

	local inner=Instance.new("Frame")
	inner.Size=UDim2.fromScale(1,1)
	inner.BackgroundColor3=T.Surface
	inner.BackgroundTransparency=0.5
	inner.BorderSizePixel=0
	inner.Parent=c
	Grad(inner,Color3.fromRGB(34,34,48),Color3.fromRGB(22,22,30),180)

	local hd=Instance.new("TextButton")
	hd.Size=UDim2.new(1,0,0,36)
	hd.BackgroundTransparency=1
	hd.Text=""
	hd.Parent=c

	-- Icon
	local hdIcBg=Instance.new("Frame")
	hdIcBg.Size=UDim2.fromOffset(22,22)
	hdIcBg.Position=UDim2.fromOffset(8,7)
	hdIcBg.BackgroundColor3=T.Accent
	hdIcBg.BackgroundTransparency=0.82
	hdIcBg.BorderSizePixel=0
	hdIcBg.Parent=hd
	Corner(hdIcBg,6)

	local hdIc=Instance.new("ImageLabel")
	hdIc.Size=UDim2.fromOffset(14,14)
	hdIc.Position=UDim2.fromOffset(4,4)
	hdIc.BackgroundTransparency=1
	hdIc.ImageColor3=T.Accent
	hdIc.Image=Icon("list")
	hdIc.Parent=hdIcBg

	local lb=Instance.new("TextLabel")
	lb.Size=UDim2.new(1,-110,1,0)
	lb.Position=UDim2.fromOffset(38,0)
	lb.BackgroundTransparency=1
	lb.Text=o.Name
	lb.TextColor3=T.Text
	lb.Font=T.Font
	lb.TextSize=13
	lb.TextXAlignment=Enum.TextXAlignment.Left
	lb.Parent=hd

	-- Selected value pill
	local selBg=Instance.new("Frame")
	selBg.Size=UDim2.fromOffset(60,18)
	selBg.Position=UDim2.new(1,-88,0.5,0)
	selBg.AnchorPoint=Vector2.new(0,0.5)
	selBg.BackgroundColor3=T.BgAlt
	selBg.BackgroundTransparency=0.3
	selBg.BorderSizePixel=0
	selBg.Parent=hd
	Corner(selBg,9)
	Stroke(selBg,T.Border,1,0.5)

	local sl=Instance.new("TextLabel")
	sl.Size=UDim2.fromScale(1,1)
	sl.BackgroundTransparency=1
	sl.Text=o.Default or "..."
	sl.TextColor3=T.Accent
	sl.Font=T.FontSB
	sl.TextSize=10
	sl.Parent=selBg

	local arIc=Instance.new("ImageLabel")
	arIc.Size=UDim2.fromOffset(14,14)
	arIc.Position=UDim2.new(1,-20,0.5,0)
	arIc.AnchorPoint=Vector2.new(0,0.5)
	arIc.BackgroundTransparency=1
	arIc.ImageColor3=T.TextMut
	arIc.Image=Icon("expand_more")
	arIc.Parent=hd

	-- Separator line before list
	local sepLine=Instance.new("Frame")
	sepLine.Size=UDim2.new(1,-16,0,1)
	sepLine.Position=UDim2.fromOffset(8,37)
	sepLine.BackgroundColor3=T.Border
	sepLine.BackgroundTransparency=0.4
	sepLine.BorderSizePixel=0
	sepLine.Parent=c

	local lf=Instance.new("Frame")
	lf.Size=UDim2.new(1,-10,0,0)
	lf.Position=UDim2.fromOffset(5,40)
	lf.BackgroundTransparency=1
	lf.Parent=c

	local ll=Instance.new("UIListLayout")
	ll.Padding=UDim.new(0,2)
	ll.Parent=lf
	Pad(lf,4,4,0,0)

	for _,item in ipairs(o.List or{})do
		local b=Instance.new("TextButton")
		b.Size=UDim2.new(1,0,0,28)
		b.BackgroundColor3=T.BgAlt
		b.BackgroundTransparency=0.5
		b.BorderSizePixel=0
		b.Text=""
		b.AutoButtonColor=false
		b.Parent=lf
		Corner(b,6)

		local bDot=Instance.new("Frame")
		bDot.Size=UDim2.fromOffset(5,5)
		bDot.Position=UDim2.fromOffset(8,11)
		bDot.BackgroundColor3=T.TextMut
		bDot.BackgroundTransparency=0.5
		bDot.BorderSizePixel=0
		bDot.Parent=b
		Corner(bDot,3)

		local bLb=Instance.new("TextLabel")
		bLb.Size=UDim2.new(1,-22,1,0)
		bLb.Position=UDim2.fromOffset(20,0)
		bLb.BackgroundTransparency=1
		bLb.Text=item
		bLb.TextColor3=T.TextDim
		bLb.Font=T.Font
		bLb.TextSize=12
		bLb.TextXAlignment=Enum.TextXAlignment.Left
		bLb.Parent=b

		b.MouseEnter:Connect(function()
			Tw(b,{BackgroundTransparency=0.1},TI.Fast)
			Tw(bLb,{TextColor3=T.Text},TI.Fast)
			Tw(bDot,{BackgroundColor3=T.Accent,BackgroundTransparency=0},TI.Fast)
		end)
		b.MouseLeave:Connect(function()
			Tw(b,{BackgroundTransparency=0.5},TI.Fast)
			Tw(bLb,{TextColor3=T.TextDim},TI.Fast)
			Tw(bDot,{BackgroundColor3=T.TextMut,BackgroundTransparency=0.5},TI.Fast)
		end)
		b.MouseButton1Click:Connect(function()
			sl.Text=item
			st:Set(o.Flag,item)
			if o.Callback then o.Callback(item)end
			op=false
			Tw(c,{Size=UDim2.new(1,0,0,36)},TI.Fast)
			Tw(arIc,{Rotation=0},TI.Fast)
		end)
	end

	hd.MouseEnter:Connect(function()Tw(c,{BackgroundColor3=T.SurfHov},TI.Fast)end)
	hd.MouseLeave:Connect(function()Tw(c,{BackgroundColor3=T.Surface},TI.Fast)end)
	hd.MouseButton1Click:Connect(function()
		op=not op
		Tw(arIc,{Rotation=op and 180 or 0},TI.Fast)
		local newH=op and(40+#(o.List or{})*30+12)or 36
		Tw(c,{Size=UDim2.new(1,0,0,newH)},TI.Fast)
	end)

	if o.Default then st:Set(o.Flag,o.Default)end
end

-- TEXTBOX (improved focus ring)
local function CTextBox(tab,o)
	local st=tab._lib._state

	local c=Instance.new("Frame")
	c.Size=UDim2.new(1,0,0,58)
	c.BackgroundColor3=T.Surface
	c.BorderSizePixel=0
	c.Parent=tab._ct
	Corner(c,8)
	local borderStroke=Stroke(c,T.Border,1,0.72)

	local inner=Instance.new("Frame")
	inner.Size=UDim2.fromScale(1,1)
	inner.BackgroundColor3=T.Surface
	inner.BackgroundTransparency=0.5
	inner.BorderSizePixel=0
	inner.Parent=c
	Grad(inner,Color3.fromRGB(34,34,48),Color3.fromRGB(22,22,30),180)

	local lb=Instance.new("TextLabel")
	lb.Size=UDim2.new(1,-16,0,16)
	lb.Position=UDim2.fromOffset(12,5)
	lb.BackgroundTransparency=1
	lb.Text=o.Name
	lb.TextColor3=T.TextDim
	lb.Font=T.FontSB
	lb.TextSize=10
	lb.TextXAlignment=Enum.TextXAlignment.Left
	lb.Parent=c

	-- Input field with icon
	local boxBg=Instance.new("Frame")
	boxBg.Size=UDim2.new(1,-22,0,26)
	boxBg.Position=UDim2.fromOffset(11,26)
	boxBg.BackgroundColor3=T.BgAlt
	boxBg.BorderSizePixel=0
	boxBg.Parent=c
	Corner(boxBg,6)
	Stroke(boxBg,T.Border,1,0.6)

	local bx=Instance.new("TextBox")
	bx.Size=UDim2.new(1,-10,1,0)
	bx.Position=UDim2.fromOffset(8,0)
	bx.BackgroundTransparency=1
	bx.Text=o.Default or ""
	bx.PlaceholderText=o.Placeholder or "Escribe aquí..."
	bx.PlaceholderColor3=T.TextMut
	bx.TextColor3=T.Text
	bx.Font=T.Font
	bx.TextSize=12
	bx.ClearTextOnFocus=false
	bx.Parent=boxBg

	bx.Focused:Connect(function()
		Tw(borderStroke,{Transparency=0.2,Color=T.Accent},TI.Fast)
		Tw(boxBg,{BackgroundColor3=T.SurfHov},TI.Fast)
	end)
	bx.FocusLost:Connect(function()
		Tw(borderStroke,{Transparency=0.72,Color=T.Border},TI.Fast)
		Tw(boxBg,{BackgroundColor3=T.BgAlt},TI.Fast)
		st:Set(o.Flag,bx.Text)
		if o.Callback then o.Callback(bx.Text)end
	end)
	st:Set(o.Flag,o.Default or "")
end

-- KEYBIND (improved pill badge)
local function CKeybind(tab,o)
	local st=tab._lib._state
	local bd=false

	local c=Instance.new("TextButton")
	c.Size=UDim2.new(1,0,0,36)
	c.BackgroundColor3=T.Surface
	c.BorderSizePixel=0
	c.Text=""
	c.AutoButtonColor=false
	c.ClipsDescendants=true
	c.Parent=tab._ct
	Corner(c,8)
	Stroke(c,T.Border,1,0.72)

	local inner=Instance.new("Frame")
	inner.Size=UDim2.fromScale(1,1)
	inner.BackgroundColor3=T.Surface
	inner.BackgroundTransparency=0.5
	inner.BorderSizePixel=0
	inner.Parent=c
	Grad(inner,Color3.fromRGB(34,34,48),Color3.fromRGB(22,22,30),180)

	local lb=Instance.new("TextLabel")
	lb.Size=UDim2.new(1,-90,1,0)
	lb.Position=UDim2.fromOffset(12,0)
	lb.BackgroundTransparency=1
	lb.Text=o.Name
	lb.TextColor3=T.Text
	lb.Font=T.Font
	lb.TextSize=13
	lb.TextXAlignment=Enum.TextXAlignment.Left
	lb.Parent=c

	local kbBg=Instance.new("Frame")
	kbBg.Size=UDim2.fromOffset(68,22)
	kbBg.Position=UDim2.new(1,-78,0.5,0)
	kbBg.AnchorPoint=Vector2.new(0,0.5)
	kbBg.BackgroundColor3=T.BgAlt
	kbBg.BackgroundTransparency=0.2
	kbBg.BorderSizePixel=0
	kbBg.Parent=c
	Corner(kbBg,6)
	Stroke(kbBg,T.Border,1,0.5)

	local kbLbl=Instance.new("TextLabel")
	kbLbl.Size=UDim2.fromScale(1,1)
	kbLbl.BackgroundTransparency=1
	kbLbl.TextColor3=T.Accent
	kbLbl.Font=T.FontB
	kbLbl.TextSize=10
	kbLbl.Parent=kbBg

	-- Listening state indicator
	local pulse=Instance.new("Frame")
	pulse.Size=UDim2.fromOffset(6,6)
	pulse.Position=UDim2.fromOffset(5,8)
	pulse.BackgroundColor3=T.Accent
	pulse.BackgroundTransparency=1
	pulse.BorderSizePixel=0
	pulse.Parent=kbBg
	Corner(pulse,3)

	st:Sub(o.Flag,function(k)
		kbLbl.Text=k.Name
		bd=false
		Tw(kbBg,{BackgroundTransparency=0.2},TI.Fast)
		Tw(pulse,{BackgroundTransparency=1},TI.Fast)
	end)

	c.MouseButton1Click:Connect(function()
		bd=true
		kbLbl.Text="..."
		Tw(kbBg,{BackgroundTransparency=0},TI.Fast)
		Tw(pulse,{BackgroundTransparency=0.2},TI.Fast)
	end)
	c.MouseEnter:Connect(function()Tw(c,{BackgroundColor3=T.SurfHov},TI.Fast)end)
	c.MouseLeave:Connect(function()Tw(c,{BackgroundColor3=T.Surface},TI.Fast)end)

	UIS.InputBegan:Connect(function(i)
		if bd and i.UserInputType==Enum.UserInputType.Keyboard then
			bd=false
			st:Set(o.Flag,i.KeyCode)
			if o.Callback then o.Callback(i.KeyCode)end
		end
	end)
	st:Set(o.Flag,o.Default or Enum.KeyCode.RightControl)
end

-- LABEL (improved with left accent)
local function CLabel(tab,txt)
	local f=Instance.new("Frame")
	f.Size=UDim2.new(1,0,0,20)
	f.BackgroundTransparency=1
	f.Parent=tab._ct

	local bar=Instance.new("Frame")
	bar.Size=UDim2.fromOffset(2,12)
	bar.Position=UDim2.fromOffset(0,4)
	bar.BackgroundColor3=T.Accent
	bar.BackgroundTransparency=0.5
	bar.BorderSizePixel=0
	bar.Parent=f
	Corner(bar,1)

	local l=Instance.new("TextLabel")
	l.Size=UDim2.new(1,-10,1,0)
	l.Position=UDim2.fromOffset(8,0)
	l.BackgroundTransparency=1
	l.Text=txt
	l.TextColor3=T.TextDim
	l.Font=T.Font
	l.TextSize=11
	l.TextXAlignment=Enum.TextXAlignment.Left
	l.Parent=f
end

-- NEW: PROGRESS BAR component
local function CProgress(tab,o)
	local st=tab._lib._state

	local c=Instance.new("Frame")
	c.Size=UDim2.new(1,0,0,46)
	c.BackgroundColor3=T.Surface
	c.BorderSizePixel=0
	c.Parent=tab._ct
	Corner(c,8)
	Stroke(c,T.Border,1,0.72)

	local inner=Instance.new("Frame")
	inner.Size=UDim2.fromScale(1,1)
	inner.BackgroundColor3=T.Surface
	inner.BackgroundTransparency=0.5
	inner.BorderSizePixel=0
	inner.Parent=c
	Grad(inner,Color3.fromRGB(34,34,48),Color3.fromRGB(22,22,30),180)

	local lb=Instance.new("TextLabel")
	lb.Size=UDim2.new(1,-70,0,16)
	lb.Position=UDim2.fromOffset(12,5)
	lb.BackgroundTransparency=1
	lb.Text=o.Name
	lb.TextColor3=T.Text
	lb.Font=T.Font
	lb.TextSize=12
	lb.TextXAlignment=Enum.TextXAlignment.Left
	lb.Parent=c

	local pct=Instance.new("TextLabel")
	pct.Size=UDim2.fromOffset(48,16)
	pct.Position=UDim2.new(1,-56,0,5)
	pct.BackgroundTransparency=1
	pct.Text="0%"
	pct.TextColor3=T.Accent
	pct.Font=T.FontB
	pct.TextSize=12
	pct.TextXAlignment=Enum.TextXAlignment.Right
	pct.Parent=c

	local trackBg=Instance.new("Frame")
	trackBg.Size=UDim2.new(1,-24,0,6)
	trackBg.Position=UDim2.fromOffset(12,28)
	trackBg.BackgroundColor3=T.BgAlt
	trackBg.BorderSizePixel=0
	trackBg.Parent=c
	Corner(trackBg,4)
	Stroke(trackBg,T.Border,1,0.55)

	local fill=Instance.new("Frame")
	fill.Size=UDim2.fromScale(0,1)
	fill.BackgroundColor3=o.Color or T.Accent
	fill.BorderSizePixel=0
	fill.Parent=trackBg
	Corner(fill,4)
	Grad(fill, o.Color or T.AccSoft, o.ColorEnd or T.AccDark, 180)

	-- Animated shimmer on fill
	local shimmer=Instance.new("Frame")
	shimmer.Size=UDim2.fromOffset(20,6)
	shimmer.BackgroundColor3=Color3.new(1,1,1)
	shimmer.BackgroundTransparency=0.75
	shimmer.BorderSizePixel=0
	shimmer.Parent=fill
	Corner(shimmer,4)
	Grad(shimmer,Color3.new(1,1,1),Color3.new(0,0,0),180)

	-- Shimmer animation loop
	task.spawn(function()
		while fill and fill.Parent do
			shimmer.Position=UDim2.fromScale(-0.3,0)
			Tw(shimmer,{Position=UDim2.fromScale(1.1,0)},TweenInfo.new(1.8,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut))
			task.wait(2.0)
		end
	end)

	-- API: returned object
	local prog={}
	function prog:Set(value)
		local p=math.clamp((value-(o.Min or 0))/((o.Max or 100)-(o.Min or 0)),0,1)
		Tw(fill,{Size=UDim2.fromScale(p,1)},TI.Smooth)
		pct.Text=math.floor(p*100).."%"
		if o.Flag then st:Set(o.Flag,value)end
	end
	function prog:SetInstant(value)
		local p=math.clamp((value-(o.Min or 0))/((o.Max or 100)-(o.Min or 0)),0,1)
		fill.Size=UDim2.fromScale(p,1)
		pct.Text=math.floor(p*100).."%"
	end

	prog:SetInstant(o.Default or o.Min or 0)
	return prog
end

-- ╔══════════════════════════════════════╗
-- ║           TAB v3.0                   ║
-- ╚══════════════════════════════════════╝
local TabIcons={"home","settings","info","build","star","explore","extension","dashboard","person","code"}
local Tab={};Tab.__index=Tab
function Tab.new(w,name,idx)
	local self=setmetatable({_w=w,_lib=w._lib,_name=name,_idx=idx or 1},Tab)
	self:_build()
	return self
end

function Tab:_build()
	local tb=Instance.new("TextButton")
	tb.Size=UDim2.new(1,0,0,34)
	tb.BackgroundTransparency=1
	tb.BackgroundColor3=T.SurfHov
	tb.BorderSizePixel=0
	tb.Text=""
	tb.AutoButtonColor=false
	tb.Parent=self._w._tl
	Corner(tb,7)
	self._tb=tb

	-- Active indicator bar (left)
	local ind=Instance.new("Frame")
	ind.Size=UDim2.new(0,3,0,20)
	ind.Position=UDim2.fromOffset(0,7)
	ind.BackgroundColor3=T.Accent
	ind.BackgroundTransparency=1
	ind.BorderSizePixel=0
	ind.Parent=tb
	Corner(ind,2)
	self._ind=ind

	-- Icon
	local icName=TabIcons[self._idx] or "circle"
	local ic=Instance.new("ImageLabel")
	ic.Size=UDim2.fromOffset(16,16)
	ic.Position=UDim2.fromOffset(13,9)
	ic.BackgroundTransparency=1
	ic.ImageColor3=T.TextMut
	ic.Image=Icon(icName)
	ic.Parent=tb
	self._ic=ic

	-- Name
	local nm=Instance.new("TextLabel")
	nm.Size=UDim2.new(1,-36,1,0)
	nm.Position=UDim2.fromOffset(34,0)
	nm.BackgroundTransparency=1
	nm.Text=self._name
	nm.TextColor3=T.TextMut
	nm.Font=T.Font
	nm.TextSize=12
	nm.TextXAlignment=Enum.TextXAlignment.Left
	nm.Parent=tb
	self._nm=nm

	-- Content area
	local ct=Instance.new("ScrollingFrame")
	ct.Size=UDim2.fromScale(1,1)
	ct.BackgroundTransparency=1
	ct.BorderSizePixel=0
	ct.ScrollBarThickness=2
	ct.ScrollBarImageColor3=T.Accent
	ct.ScrollBarImageTransparency=0.4
	ct.CanvasSize=UDim2.fromScale(0,0)
	ct.AutomaticCanvasSize=Enum.AutomaticSize.Y
	ct.Visible=false
	ct.Parent=self._w._cf

	local l=Instance.new("UIListLayout")
	l.Padding=UDim.new(0,5)
	l.Parent=ct
	Pad(ct,8,10,8,8)
	self._ct=ct

	tb.MouseButton1Click:Connect(function()self._w:SelectTab(self)end)
	tb.MouseEnter:Connect(function()
		if self._w._sel~=self then
			Tw(tb,{BackgroundTransparency=0.78},TI.Fast)
			Tw(ic,{ImageColor3=T.TextDim},TI.Fast)
		end
	end)
	tb.MouseLeave:Connect(function()
		if self._w._sel~=self then
			Tw(tb,{BackgroundTransparency=1},TI.Fast)
			Tw(ic,{ImageColor3=T.TextMut},TI.Fast)
		end
	end)
end

function Tab:Show()
	self._ct.Visible=true
	Tw(self._tb,{BackgroundTransparency=0.72},TI.Fast)
	Tw(self._nm,{TextColor3=T.Accent},TI.Fast)
	Tw(self._ic,{ImageColor3=T.Accent},TI.Fast)
	Tw(self._ind,{BackgroundTransparency=0},TI.Fast)
end
function Tab:Hide()
	self._ct.Visible=false
	Tw(self._tb,{BackgroundTransparency=1},TI.Fast)
	Tw(self._nm,{TextColor3=T.TextMut},TI.Fast)
	Tw(self._ic,{ImageColor3=T.TextMut},TI.Fast)
	Tw(self._ind,{BackgroundTransparency=1},TI.Fast)
end

function Tab:CreateSection(n)CSection(self,n)end
function Tab:CreateButton(o)CButton(self,o)end
function Tab:CreateToggle(o)CToggle(self,o)end
function Tab:CreateSlider(o)CSlider(self,o)end
function Tab:CreateDropdown(o)CDropdown(self,o)end
function Tab:CreateTextBox(o)CTextBox(self,o)end
function Tab:CreateKeybind(o)CKeybind(self,o)end
function Tab:CreateLabel(t)CLabel(self,t)end
function Tab:CreateProgress(o)return CProgress(self,o)end

-- ╔══════════════════════════════════════╗
-- ║           FOOTER v3.0                ║
-- ╚══════════════════════════════════════╝
local function MakeFooter(mainF)
	local ft=Instance.new("Frame")
	ft.Size=UDim2.new(1,0,0,36)
	ft.Position=UDim2.new(0,0,1,2)
	ft.BackgroundColor3=T.BgAlt
	ft.BackgroundTransparency=0.04
	ft.BorderSizePixel=0
	ft.Parent=mainF
	Corner(ft,8)
	Stroke(ft,T.Border,1,0.5)
	Grad(ft,Color3.fromRGB(20,20,30),Color3.fromRGB(16,16,22))

	-- Avatar with ring
	local avRing=Instance.new("Frame")
	avRing.Size=UDim2.fromOffset(30,30)
	avRing.Position=UDim2.fromOffset(7,3)
	avRing.BackgroundColor3=T.Accent
	avRing.BackgroundTransparency=0.7
	avRing.BorderSizePixel=0
	avRing.Parent=ft
	Corner(avRing,15)

	local av=Instance.new("ImageLabel")
	av.Size=UDim2.fromOffset(26,26)
	av.Position=UDim2.fromOffset(2,2)
	av.BackgroundColor3=T.BgAlt
	av.BorderSizePixel=0
	av.Parent=avRing
	Corner(av,13)
	pcall(function()
		av.Image=Players:GetUserThumbnailAsync(
			P.UserId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size48x48)
	end)

	local un=Instance.new("TextLabel")
	un.Size=UDim2.fromOffset(88,32)
	un.Position=UDim2.fromOffset(40,2)
	un.BackgroundTransparency=1
	un.Text=P.Name
	un.TextColor3=T.Text
	un.Font=T.FontSB
	un.TextSize=10
	un.TextXAlignment=Enum.TextXAlignment.Left
	un.Parent=ft

	Divider(ft, UDim2.fromOffset(128,8))

	local exIc=Instance.new("ImageLabel")
	exIc.Size=UDim2.fromOffset(13,13)
	exIc.Position=UDim2.fromOffset(136,11)
	exIc.BackgroundTransparency=1
	exIc.ImageColor3=T.TextMut
	exIc.Image=Icon("memory")
	exIc.Parent=ft

	local exL=Instance.new("TextLabel")
	exL.Size=UDim2.fromOffset(75,32)
	exL.Position=UDim2.fromOffset(152,2)
	exL.BackgroundTransparency=1
	exL.Text=DetectExecutor()
	exL.TextColor3=T.TextMut
	exL.Font=T.Font
	exL.TextSize=9
	exL.TextXAlignment=Enum.TextXAlignment.Left
	exL.Parent=ft

	Divider(ft, UDim2.fromOffset(228,8))

	-- FPS (colored dynamically)
	local fpsIc=Instance.new("ImageLabel")
	fpsIc.Size=UDim2.fromOffset(12,12)
	fpsIc.Position=UDim2.fromOffset(236,12)
	fpsIc.BackgroundTransparency=1
	fpsIc.ImageColor3=T.Succ
	fpsIc.Image=Icon("speed")
	fpsIc.Parent=ft

	local fpsTxt=Instance.new("TextLabel")
	fpsTxt.Size=UDim2.fromOffset(52,32)
	fpsTxt.Position=UDim2.fromOffset(252,2)
	fpsTxt.BackgroundTransparency=1
	fpsTxt.Text="-- fps"
	fpsTxt.TextColor3=T.Succ
	fpsTxt.Font=T.FontB
	fpsTxt.TextSize=9
	fpsTxt.TextXAlignment=Enum.TextXAlignment.Left
	fpsTxt.Parent=ft

	Divider(ft, UDim2.fromOffset(305,8))

	-- Ping (colored by latency)
	local pgIc=Instance.new("ImageLabel")
	pgIc.Size=UDim2.fromOffset(12,12)
	pgIc.Position=UDim2.fromOffset(312,12)
	pgIc.BackgroundTransparency=1
	pgIc.ImageColor3=T.Warn
	pgIc.Image=Icon("wifi")
	pgIc.Parent=ft

	local pgTxt=Instance.new("TextLabel")
	pgTxt.Size=UDim2.fromOffset(60,32)
	pgTxt.Position=UDim2.fromOffset(328,2)
	pgTxt.BackgroundTransparency=1
	pgTxt.Text="-- ms"
	pgTxt.TextColor3=T.Warn
	pgTxt.Font=T.FontB
	pgTxt.TextSize=9
	pgTxt.TextXAlignment=Enum.TextXAlignment.Left
	pgTxt.Parent=ft

	local fc,lt=0,tick()
	RS.Heartbeat:Connect(function()
		fc=fc+1
		local now=tick()
		if now-lt>=0.5 then
			local fps=math.floor(fc/(now-lt))
			fpsTxt.Text=fps.." fps"
			-- Color fps by performance
			if fps>=55 then fpsTxt.TextColor3=T.Succ
			elseif fps>=30 then fpsTxt.TextColor3=T.Warn
			else fpsTxt.TextColor3=T.Err end
			fpsIc.ImageColor3=fpsTxt.TextColor3
			fc=0;lt=now
			pcall(function()
				local ping=math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
				pgTxt.Text=ping.." ms"
				-- Color ping by latency
				if ping<80 then pgTxt.TextColor3=T.Succ
				elseif ping<200 then pgTxt.TextColor3=T.Warn
				else pgTxt.TextColor3=T.Err end
				pgIc.ImageColor3=pgTxt.TextColor3
			end)
		end
	end)
end

-- ╔══════════════════════════════════════╗
-- ║            WINDOW v3.0              ║
-- ╚══════════════════════════════════════╝
local Win={};Win.__index=Win
function Win.new(lib,o)
	local self=setmetatable({_lib=lib,_o=o,_tabs={},_sel=nil},Win)
	self:_build()
	return self
end

function Win:_build()
	local gui=MakeGUI("BBW",50)
	self._gui=gui
	local sz=self._o.Size or UDim2.fromOffset(590,410)

	-- ── MINI BAR (minimize state) ─────────────────────────────────────
	local mbar=Instance.new("Frame")
	mbar.Size=UDim2.fromOffset(248,40)
	mbar.Position=UDim2.new(0.5,0,0,8)
	mbar.AnchorPoint=Vector2.new(0.5,0)
	mbar.BackgroundColor3=T.Glass
	mbar.BackgroundTransparency=0.04
	mbar.BorderSizePixel=0
	mbar.Visible=false
	mbar.Parent=gui
	Corner(mbar,12)
	Stroke(mbar,T.BorderAc,1.2,0.35)
	Grad(mbar,Color3.fromRGB(28,28,42),Color3.fromRGB(20,20,30))
	self._mbar=mbar

	local mLogoBg=Instance.new("Frame")
	mLogoBg.Size=UDim2.fromOffset(28,28)
	mLogoBg.Position=UDim2.fromOffset(6,6)
	mLogoBg.BackgroundColor3=T.Accent
	mLogoBg.BackgroundTransparency=0.78
	mLogoBg.BorderSizePixel=0
	mLogoBg.Parent=mbar
	Corner(mLogoBg,8)

	local mLogo=Instance.new("ImageLabel")
	mLogo.Size=UDim2.fromOffset(18,18)
	mLogo.Position=UDim2.fromOffset(5,5)
	mLogo.BackgroundTransparency=1
	mLogo.Image=self._o.Logo or ""
	mLogo.Parent=mLogoBg

	local mBtn=Instance.new("TextButton")
	mBtn.Size=UDim2.fromOffset(110,40)
	mBtn.Position=UDim2.fromOffset(38,0)
	mBtn.BackgroundTransparency=1
	mBtn.Text=self._o.Title or "BloxBox UI"
	mBtn.TextColor3=T.Text
	mBtn.Font=T.FontB
	mBtn.TextSize=12
	mBtn.TextXAlignment=Enum.TextXAlignment.Left
	mBtn.AutoButtonColor=false
	mBtn.Parent=mbar
	mBtn.MouseEnter:Connect(function()Tw(mBtn,{TextColor3=T.Accent},TI.Fast)end)
	mBtn.MouseLeave:Connect(function()Tw(mBtn,{TextColor3=T.Text},TI.Fast)end)

	Divider(mbar,UDim2.fromOffset(154,10))

	local mDragBg=Instance.new("Frame")
	mDragBg.Size=UDim2.fromOffset(30,28)
	mDragBg.Position=UDim2.fromOffset(162,6)
	mDragBg.BackgroundColor3=T.BgAlt
	mDragBg.BackgroundTransparency=0.35
	mDragBg.BorderSizePixel=0
	mDragBg.Parent=mbar
	Corner(mDragBg,7)
	Stroke(mDragBg,T.Border,1,0.6)

	local mDragIc=Instance.new("ImageLabel")
	mDragIc.Size=UDim2.fromOffset(18,18)
	mDragIc.Position=UDim2.fromOffset(6,5)
	mDragIc.BackgroundTransparency=1
	mDragIc.ImageColor3=T.TextDim
	mDragIc.Image=Icon("open_with")
	mDragIc.Parent=mDragBg
	MakeDrag(mDragBg,mbar)

	-- Restore close for mini bar
	local mClose=Instance.new("TextButton")
	mClose.Size=UDim2.fromOffset(24,24)
	mClose.Position=UDim2.new(1,-30,0.5,0)
	mClose.AnchorPoint=Vector2.new(0,0.5)
	mClose.BackgroundColor3=T.Err
	mClose.BackgroundTransparency=0.78
	mClose.Text="×"
	mClose.TextColor3=T.TextMut
	mClose.Font=T.FontB
	mClose.TextSize=14
	mClose.BorderSizePixel=0
	mClose.AutoButtonColor=false
	mClose.Parent=mbar
	Corner(mClose,12)
	mClose.MouseEnter:Connect(function()Tw(mClose,{BackgroundTransparency=0.15,TextColor3=T.Text},TI.Fast)end)
	mClose.MouseLeave:Connect(function()Tw(mClose,{BackgroundTransparency=0.78,TextColor3=T.TextMut},TI.Fast)end)
	mClose.MouseButton1Click:Connect(function()self:Destroy()end)

	mBtn.MouseButton1Click:Connect(function()self:Restore()end)
	mLogoBg.InputBegan:Connect(function(i)
		if i.UserInputType==Enum.UserInputType.MouseButton1 then self:Restore()end
	end)

	-- ── MAIN FRAME ────────────────────────────────────────────────────
	local main=Instance.new("Frame")
	main.Name="Main"
	main.Size=sz
	main.Position=self._o.Position or UDim2.fromScale(0.5,0.5)
	main.AnchorPoint=Vector2.new(0.5,0.5)
	main.BackgroundColor3=T.Bg
	main.BorderSizePixel=0
	main.Parent=gui
	Corner(main,14)

	-- Primary border stroke (accent)
	local mainStroke=Stroke(main,T.Border,1.4,0.4)

	-- Subtle gradient on main bg
	Grad(main,Color3.fromRGB(15,15,22),Color3.fromRGB(10,10,14),180)
	self._mf=main
	self._mainStroke=mainStroke

	-- ── HEADER ───────────────────────────────────────────────────────
	local hd=Instance.new("Frame")
	hd.Size=UDim2.new(1,0,0,40)
	hd.BackgroundColor3=T.BgAlt
	hd.BorderSizePixel=0
	hd.Parent=main
	Corner(hd,14)
	Grad(hd,Color3.fromRGB(24,24,34),Color3.fromRGB(16,16,24),180)

	-- Fix bottom corners of header
	local hfix=Instance.new("Frame")
	hfix.Size=UDim2.new(1,0,0,14)
	hfix.Position=UDim2.new(0,0,1,-14)
	hfix.BackgroundColor3=T.BgAlt
	hfix.BorderSizePixel=0
	hfix.Parent=hd
	Grad(hfix,Color3.fromRGB(24,24,34),Color3.fromRGB(16,16,24),180)

	-- Header bottom separator line
	local hdLine=Instance.new("Frame")
	hdLine.Size=UDim2.new(1,0,0,1)
	hdLine.Position=UDim2.new(0,0,1,-1)
	hdLine.BackgroundColor3=T.Border
	hdLine.BackgroundTransparency=0.3
	hdLine.BorderSizePixel=0
	hdLine.Parent=hd

	-- Logo dot (accent indicator)
	local dot=Instance.new("Frame")
	dot.Size=UDim2.fromOffset(7,7)
	dot.Position=UDim2.fromOffset(14,17)
	dot.BackgroundColor3=T.Accent
	dot.BorderSizePixel=0
	dot.Parent=hd
	Corner(dot,4)

	-- Pulse animation on dot
	task.spawn(function()
		while dot and dot.Parent do
			Tw(dot,{BackgroundTransparency=0.6},TI.Slow)
			task.wait(0.7)
			Tw(dot,{BackgroundTransparency=0},TI.Slow)
			task.wait(0.7)
		end
	end)

	local ttl=Instance.new("TextLabel")
	ttl.Size=UDim2.new(1,-120,1,0)
	ttl.Position=UDim2.fromOffset(26,0)
	ttl.BackgroundTransparency=1
	ttl.Text=self._o.Title or "BloxBox"
	ttl.TextColor3=T.Text
	ttl.Font=T.FontB
	ttl.TextSize=14
	ttl.TextXAlignment=Enum.TextXAlignment.Left
	ttl.Parent=hd
	self._ttl=ttl

	-- Window controls container
	local ctrlsFrame=Instance.new("Frame")
	ctrlsFrame.Size=UDim2.fromOffset(70,40)
	ctrlsFrame.Position=UDim2.new(1,-74,0,0)
	ctrlsFrame.BackgroundTransparency=1
	ctrlsFrame.Parent=hd

	-- Close button
	local cls=Instance.new("TextButton")
	cls.Size=UDim2.fromOffset(24,24)
	cls.Position=UDim2.fromOffset(42,8)
	cls.BackgroundColor3=T.Err
	cls.BackgroundTransparency=0.80
	cls.Text=""
	cls.BorderSizePixel=0
	cls.AutoButtonColor=false
	cls.Parent=ctrlsFrame
	Corner(cls,12)
	Stroke(cls,T.ErrDark,1,0.5)

	local clsIc=Instance.new("ImageLabel")
	clsIc.Size=UDim2.fromOffset(13,13)
	clsIc.Position=UDim2.fromOffset(5,5)
	clsIc.BackgroundTransparency=1
	clsIc.ImageColor3=T.Err
	clsIc.BackgroundTransparency=1
	clsIc.Image=Icon("close")
	clsIc.Parent=cls
	cls.MouseEnter:Connect(function()Tw(cls,{BackgroundTransparency=0.1},TI.Fast);Tw(clsIc,{ImageColor3=T.Text},TI.Fast)end)
	cls.MouseLeave:Connect(function()Tw(cls,{BackgroundTransparency=0.80},TI.Fast);Tw(clsIc,{ImageColor3=T.Err},TI.Fast)end)
	cls.MouseButton1Click:Connect(function()self:Destroy()end)

	-- Minimize button
	local mn=Instance.new("TextButton")
	mn.Size=UDim2.fromOffset(24,24)
	mn.Position=UDim2.fromOffset(14,8)
	mn.BackgroundColor3=T.Warn
	mn.BackgroundTransparency=0.80
	mn.Text=""
	mn.BorderSizePixel=0
	mn.AutoButtonColor=false
	mn.Parent=ctrlsFrame
	Corner(mn,12)
	Stroke(mn,T.WarnDark,1,0.5)

	local mnIc=Instance.new("ImageLabel")
	mnIc.Size=UDim2.fromOffset(13,13)
	mnIc.Position=UDim2.fromOffset(5,5)
	mnIc.BackgroundTransparency=1
	mnIc.ImageColor3=T.Warn
	mnIc.Image=Icon("remove")
	mnIc.Parent=mn
	mn.MouseEnter:Connect(function()Tw(mn,{BackgroundTransparency=0.1},TI.Fast);Tw(mnIc,{ImageColor3=T.Text},TI.Fast)end)
	mn.MouseLeave:Connect(function()Tw(mn,{BackgroundTransparency=0.80},TI.Fast);Tw(mnIc,{ImageColor3=T.Warn},TI.Fast)end)
	mn.MouseButton1Click:Connect(function()self:Minimize()end)

	-- ── SIDEBAR ──────────────────────────────────────────────────────
	local sb=Instance.new("Frame")
	sb.Size=UDim2.new(0,132,1,-40)
	sb.Position=UDim2.fromOffset(0,40)
	sb.BackgroundColor3=T.BgAlt
	sb.BackgroundTransparency=0.15
	sb.BorderSizePixel=0
	sb.Parent=main
	Grad(sb,Color3.fromRGB(18,18,26),Color3.fromRGB(12,12,18),180)

	-- Sidebar right border
	local sbBorder=Instance.new("Frame")
	sbBorder.Size=UDim2.new(0,1,1,0)
	sbBorder.Position=UDim2.new(1,-1,0,0)
	sbBorder.BackgroundColor3=T.Border
	sbBorder.BackgroundTransparency=0.3
	sbBorder.BorderSizePixel=0
	sbBorder.Parent=sb

	local sbLbl=Instance.new("TextLabel")
	sbLbl.Size=UDim2.new(1,-10,0,14)
	sbLbl.Position=UDim2.fromOffset(10,10)
	sbLbl.BackgroundTransparency=1
	sbLbl.Text="NAVIGATION"
	sbLbl.TextColor3=T.TextMut
	sbLbl.Font=T.FontB
	sbLbl.TextSize=8
	sbLbl.TextXAlignment=Enum.TextXAlignment.Left
	sbLbl.Parent=sb

	local sbDiv=Instance.new("Frame")
	sbDiv.Size=UDim2.new(1,-16,0,1)
	sbDiv.Position=UDim2.fromOffset(8,26)
	sbDiv.BackgroundColor3=T.Border
	sbDiv.BackgroundTransparency=0.4
	sbDiv.BorderSizePixel=0
	sbDiv.Parent=sb
	Corner(sbDiv,1)

	local tlc=Instance.new("Frame")
	tlc.Size=UDim2.new(1,-8,1,-34)
	tlc.Position=UDim2.fromOffset(4,30)
	tlc.BackgroundTransparency=1
	tlc.Parent=sb
	local sl=Instance.new("UIListLayout")
	sl.Padding=UDim.new(0,3)
	sl.Parent=tlc
	self._tl=tlc

	-- Content area
	local cf=Instance.new("Frame")
	cf.Size=UDim2.new(1,-133,1,-40)
	cf.Position=UDim2.fromOffset(133,40)
	cf.BackgroundTransparency=1
	cf.BorderSizePixel=0
	cf.Parent=main
	self._cf=cf

	MakeFooter(main)
	MakeDrag(hd,main)

	-- Entrance animation
	main.BackgroundTransparency=1
	main.Size=UDim2.fromOffset(sz.X.Offset-30,sz.Y.Offset-22)
	ttl.TextTransparency=1
	Tw(main,{BackgroundTransparency=0,Size=sz},TI.Bounce)
	Tw(ttl,{TextTransparency=0},TI.Slow)
end

function Win:Minimize()
	self._mbar.Visible=true
	self._mbar.BackgroundTransparency=0
	Tw(self._mf,{BackgroundTransparency=1,
		Size=UDim2.fromOffset(self._mf.Size.X.Offset-22,self._mf.Size.Y.Offset-12)},TI.Normal)
	task.wait(0.3)
	self._mf.Visible=false
end

function Win:Restore()
	self._mf.Visible=true
	local sz=self._o.Size or UDim2.fromOffset(590,410)
	self._mf.Size=UDim2.fromOffset(sz.X.Offset-30,sz.Y.Offset-22)
	Tw(self._mf,{BackgroundTransparency=0,Size=sz},TI.Bounce)
	Tw(self._mbar,{BackgroundTransparency=1},TI.Fast)
	task.wait(0.22)
	self._mbar.Visible=false
	self._mbar.BackgroundTransparency=0.04
end

function Win:CreateTab(n)
	local idx=#self._tabs+1
	local tab=Tab.new(self,n,idx)
	table.insert(self._tabs,tab)
	if idx==1 then self:SelectTab(tab)end
	return tab
end

function Win:SelectTab(tab)
	for _,t in ipairs(self._tabs)do t:Hide()end
	tab:Show()
	self._sel=tab
end

function Win:Destroy()
	if self._gui then
		Tw(self._mf,{BackgroundTransparency=1,Size=UDim2.fromOffset(
			self._mf.Size.X.Offset-20,self._mf.Size.Y.Offset-10)},TI.Normal)
		task.wait(0.32)
		self._gui:Destroy()
	end
end

-- ╔══════════════════════════════════════╗
-- ║              PUBLIC API              ║
-- ╚══════════════════════════════════════╝
local BB={};BB.__index=BB
function BB.new()
	return setmetatable({_theme=T,_state=SM.new()},BB)
end
function BB:SetAccent(c)
	T.Accent=c
	T.AccDark=Color3.new(c.R*0.65,c.G*0.65,c.B*0.65)
	T.AccSoft=Color3.new(math.min(c.R+0.2,1),math.min(c.G+0.2,1),math.min(c.B+0.2,1))
end
function BB:ShowIntro(logo,cb) ShowIntro(logo,cb) end
function BB:CreateWindow(o) return Win.new(self,o) end
function BB:Notify(o) Notif(o) end
function BB:SaveConfig(n) SaveCfg(self._state,n) end
function BB:LoadConfig(n) LoadCfg(self._state,n) end

print("[BloxBox UI] v3.0 Premium loaded ✓ | Redesigned components")
return BB