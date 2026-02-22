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
		if ok and img then
			local s=tostring(img)
			if string.find(s,"rbxassetid") or string.find(s,"http") then return s end
			return "rbxassetid://"..s
		end
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
	Glass2   = Color3.fromRGB(20,22,32),

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

	-- Shadow
	ShadowCol= Color3.fromRGB(5,5,12),

	-- Fonts
	Font     = Enum.Font.GothamMedium,
	FontB    = Enum.Font.GothamBold,
	FontL    = Enum.Font.Gotham,
	FontSB   = Enum.Font.GothamSemibold,
}

-- Drop shadow helper (creates a soft glow/shadow behind a frame)
local function DropShadow(parent,spread,col,transp)
	local sh=Instance.new("ImageLabel")
	sh.Name="Shadow"
	sh.Size=UDim2.new(1,spread*2,1,spread*2)
	sh.Position=UDim2.fromOffset(-spread,-spread+4)
	sh.BackgroundTransparency=1
	sh.Image="rbxassetid://5028857084"
	sh.ImageColor3=col or T.ShadowCol
	sh.ImageTransparency=transp or 0.4
	sh.ScaleType=Enum.ScaleType.Slice
	sh.SliceCenter=Rect.new(24,24,276,276)
	sh.ZIndex=parent.ZIndex-1
	sh.Parent=parent
	return sh
end

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

-- Drag (instant detection - no delay)
local function MakeDrag(h,f)
	local dr,ds,sp=false,nil,nil
	h.InputBegan:Connect(function(i)
		if i.UserInputType==Enum.UserInputType.MouseButton1 or
		   i.UserInputType==Enum.UserInputType.Touch then
			dr=true;ds=i.Position;sp=f.Position
		end
	end)
	h.InputEnded:Connect(function(i)
		if i.UserInputType==Enum.UserInputType.MouseButton1 or
		   i.UserInputType==Enum.UserInputType.Touch then
			dr=false
		end
	end)
	UIS.InputChanged:Connect(function(i)
		if dr and(i.UserInputType==Enum.UserInputType.MouseMovement or
				  i.UserInputType==Enum.UserInputType.Touch)then
			local d=i.Position-ds
			f.Position=UDim2.new(sp.X.Scale,sp.X.Offset+d.X,sp.Y.Scale,sp.Y.Offset+d.Y)
		end
	end)
end

-- Resize handles for main frame
local function MakeResize(main,minW,minH)
	minW=minW or 500; minH=minH or 350
	local rz=Instance.new("TextButton")
	rz.Size=UDim2.fromOffset(22,22)
	rz.Position=UDim2.new(1,-24,1,-24)
	rz.BackgroundColor3=T.BgAlt
	rz.BackgroundTransparency=0.4
	rz.Text=""
	rz.AutoButtonColor=false
	rz.ZIndex=main.ZIndex+5
	rz.Parent=main
	Corner(rz,6)
	Stroke(rz,T.Border,1,0.5)

	-- Resize icon inside
	local rzIc=Instance.new("ImageLabel")
	rzIc.Size=UDim2.fromOffset(14,14)
	rzIc.Position=UDim2.fromOffset(4,4)
	rzIc.BackgroundTransparency=1
	rzIc.ImageColor3=T.TextMut
	rzIc.Image=Icon("aspect_ratio")
	rzIc.Parent=rz

	-- Hover feedback
	rz.MouseEnter:Connect(function()
		Tw(rz,{BackgroundTransparency=0.1},TI.Fast)
		Tw(rzIc,{ImageColor3=T.Accent},TI.Fast)
	end)
	rz.MouseLeave:Connect(function()
		Tw(rz,{BackgroundTransparency=0.4},TI.Fast)
		Tw(rzIc,{ImageColor3=T.TextMut},TI.Fast)
	end)

	local dragging,startPos,startSz=false,nil,nil
	rz.InputBegan:Connect(function(i)
		if i.UserInputType==Enum.UserInputType.MouseButton1 or
		   i.UserInputType==Enum.UserInputType.Touch then
			dragging=true; startPos=i.Position; startSz=main.Size
		end
	end)
	rz.InputEnded:Connect(function(i)
		if i.UserInputType==Enum.UserInputType.MouseButton1 or
		   i.UserInputType==Enum.UserInputType.Touch then
			dragging=false
		end
	end)
	UIS.InputChanged:Connect(function(i)
		if dragging and(i.UserInputType==Enum.UserInputType.MouseMovement or
						  i.UserInputType==Enum.UserInputType.Touch)then
			local d=i.Position-startPos
			local nw=math.max(minW,startSz.X.Offset+d.X)
			local nh=math.max(minH,startSz.Y.Offset+d.Y)
			main.Size=UDim2.fromOffset(nw,nh)
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
	card.Size=UDim2.new(1,0,0,78)
	card.BackgroundColor3=T.BgAlt
	card.BackgroundTransparency=0.02
	card.BorderSizePixel=0
	card.ClipsDescendants=true
	card.Parent=c
	Corner(card,14)
	DropShadow(card,20,T.ShadowCol,0.5)

	-- Subtle tinted inner bg
	local tint=Instance.new("Frame")
	tint.Size=UDim2.fromScale(1,1)
	tint.BackgroundColor3=td.bg
	tint.BackgroundTransparency=0.65
	tint.BorderSizePixel=0
	tint.Parent=card

	local stroke=Stroke(card, col, 1.4, 0.25)

	-- Glass tint inner
	local glassInner=Instance.new("Frame")
	glassInner.Size=UDim2.fromScale(1,1)
	glassInner.BackgroundColor3=td.bg
	glassInner.BackgroundTransparency=0.55
	glassInner.BorderSizePixel=0
	glassInner.Parent=card
	Grad(glassInner,Color3.fromRGB(20,22,34),Color3.fromRGB(10,10,16),170)

	-- Accent left bar (wider + gradient)
	local bar=Instance.new("Frame")
	bar.Size=UDim2.new(0,4,1,-16)
	bar.Position=UDim2.fromOffset(6,8)
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

	-- Entrance animation (slide from right, smooth and slow)
	card.Position=UDim2.fromOffset(320,0)
	card.BackgroundTransparency=0.5
	Tw(card,{Position=UDim2.fromOffset(0,0),BackgroundTransparency=0.04},TweenInfo.new(0.65,Enum.EasingStyle.Quint,Enum.EasingDirection.Out))

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
	bg.BackgroundTransparency=0.4
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
	sub.Text="v3.3 Spaceship"
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

-- SECTION DIVIDER (v3.2 - gradient line with label)
local function CSection(tab,name)
	local f=Instance.new("Frame")
	f.Size=UDim2.new(1,0,0,30)
	f.BackgroundTransparency=1
	f.Parent=tab._ct

	-- Full-width gradient line behind
	local lineB=Instance.new("Frame")
	lineB.Size=UDim2.new(1,0,0,1)
	lineB.Position=UDim2.new(0,0,0.5,0)
	lineB.BackgroundColor3=T.Border
	lineB.BackgroundTransparency=0.3
	lineB.BorderSizePixel=0
	lineB.ZIndex=f.ZIndex
	lineB.Parent=f
	local lGrad=Instance.new("UIGradient")
	lGrad.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(0.4,0.3),NumberSequenceKeypoint.new(1,0.85)})
	lGrad.Parent=lineB

	-- Accent dot
	local acDot=Instance.new("Frame")
	acDot.Size=UDim2.fromOffset(4,4)
	acDot.Position=UDim2.fromOffset(0,13)
	acDot.BackgroundColor3=T.Accent
	acDot.BorderSizePixel=0
	acDot.Parent=f
	Corner(acDot,2)

	-- Section label (uppercase, spaced)
	local lb=Instance.new("TextLabel")
	lb.AutomaticSize=Enum.AutomaticSize.X
	lb.Size=UDim2.new(0,0,0,30)
	lb.Position=UDim2.fromOffset(10,0)
	lb.BackgroundColor3=T.Bg
	lb.BackgroundTransparency=0.1
	lb.Text="  "..string.upper(name).."  "
	lb.TextColor3=T.TextMut
	lb.Font=T.FontB
	lb.TextSize=9
	lb.Parent=f
	Corner(lb,4)
end

-- BUTTON (v3.3 - spaceship floating style)
local function CButton(tab,o)
	local b=Instance.new("TextButton")
	b.Size=UDim2.new(1,0,0,42)
	b.BackgroundColor3=T.Surface
	b.BorderSizePixel=0
	b.Text=""
	b.AutoButtonColor=false
	b.Parent=tab._ct
	b.ClipsDescendants=true
	Corner(b,12)
	local bStroke=Stroke(b,T.Border,1,0.55)

	-- Inner gradient tint (deeper glass)
	local inner=Instance.new("Frame")
	inner.Size=UDim2.fromScale(1,1)
	inner.BackgroundColor3=T.Surface
	inner.BackgroundTransparency=0.45
	inner.BorderSizePixel=0
	inner.ZIndex=b.ZIndex
	inner.Parent=b
	Grad(inner,Color3.fromRGB(28,30,44),Color3.fromRGB(16,16,22),170)

	-- Top shine line
	local btnShine=Instance.new("Frame")
	btnShine.Size=UDim2.new(1,-12,0,1)
	btnShine.Position=UDim2.fromOffset(6,0)
	btnShine.BackgroundColor3=Color3.new(1,1,1)
	btnShine.BackgroundTransparency=0.92
	btnShine.BorderSizePixel=0
	btnShine.ZIndex=b.ZIndex+1
	btnShine.Parent=b

	-- Icon badge (accent ring)
	local icBg=Instance.new("Frame")
	icBg.Size=UDim2.fromOffset(26,26)
	icBg.Position=UDim2.fromOffset(9,8)
	icBg.BackgroundColor3=T.Accent
	icBg.BackgroundTransparency=0.82
	icBg.BorderSizePixel=0
	icBg.Parent=b
	Corner(icBg,8)
	Stroke(icBg,T.AccGlow,1,0.7)

	local ic=Instance.new("ImageLabel")
	ic.Size=UDim2.fromOffset(16,16)
	ic.Position=UDim2.fromOffset(5,5)
	ic.BackgroundTransparency=1
	ic.ImageColor3=T.Accent
	ic.Image=Icon(o.Icon or "play_arrow")
	ic.Parent=icBg

	local lb=Instance.new("TextLabel")
	lb.Size=UDim2.new(1,-80,1,0)
	lb.Position=UDim2.fromOffset(42,0)
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
		Tw(bStroke,{Color=T.AccGlow,Transparency=0.5},TI.Fast)
		Tw(ic,{ImageColor3=T.TextHigh},TI.Fast)
		Tw(icBg,{BackgroundTransparency=0.6},TI.Fast)
		Tw(arrow,{ImageColor3=T.Accent},TI.Fast)
		Tw(lb,{TextColor3=T.TextHigh},TI.Fast)
	end)
	b.MouseLeave:Connect(function()
		Tw(b,{BackgroundColor3=T.Surface},TI.Fast)
		Tw(bStroke,{Color=T.Border,Transparency=0.55},TI.Fast)
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

-- TOGGLE (v3.3 - spaceship floating style)
local function CToggle(tab,o)
	local st=tab._lib._state

	local c=Instance.new("TextButton")
	c.Size=UDim2.new(1,0,0,42)
	c.BackgroundColor3=T.Surface
	c.BorderSizePixel=0
	c.Text=""
	c.AutoButtonColor=false
	c.ClipsDescendants=true
	c.Parent=tab._ct
	Corner(c,12)
	local cStroke=Stroke(c,T.Border,1,0.55)

	local inner=Instance.new("Frame")
	inner.Size=UDim2.fromScale(1,1)
	inner.BackgroundColor3=T.Surface
	inner.BackgroundTransparency=0.45
	inner.BorderSizePixel=0
	inner.Parent=c
	Grad(inner,Color3.fromRGB(28,30,44),Color3.fromRGB(16,16,22),170)

	-- Top shine line
	local tgShine=Instance.new("Frame")
	tgShine.Size=UDim2.new(1,-12,0,1)
	tgShine.Position=UDim2.fromOffset(6,0)
	tgShine.BackgroundColor3=Color3.new(1,1,1)
	tgShine.BackgroundTransparency=0.92
	tgShine.BorderSizePixel=0
	tgShine.ZIndex=c.ZIndex+1
	tgShine.Parent=c

	local lb=Instance.new("TextLabel")
	lb.Size=UDim2.new(1,-100,1,0)
	lb.Position=UDim2.fromOffset(14,0)
	lb.BackgroundTransparency=1
	lb.Text=o.Name
	lb.TextColor3=T.Text
	lb.Font=T.Font
	lb.TextSize=13
	lb.TextXAlignment=Enum.TextXAlignment.Left
	lb.Parent=c

	-- Toggle track (pill shape with inner depth)
	local tk=Instance.new("Frame")
	tk.Size=UDim2.fromOffset(46,24)
	tk.Position=UDim2.new(1,-56,0.5,0)
	tk.AnchorPoint=Vector2.new(0,0.5)
	tk.BackgroundColor3=Color3.fromRGB(30,30,42)
	tk.BorderSizePixel=0
	tk.Parent=c
	Corner(tk,12)
	local tkStroke=Stroke(tk,T.Border,1.2,0.35)

	-- Knob (circle, shadow effect)
	local kn=Instance.new("Frame")
	kn.Size=UDim2.fromOffset(18,18)
	kn.Position=UDim2.fromOffset(3,3)
	kn.BackgroundColor3=Color3.fromRGB(100,100,120)
	kn.BorderSizePixel=0
	kn.Parent=tk
	Corner(kn,9)
	Stroke(kn,Color3.fromRGB(30,30,45),1.5,0.3)

	-- Glow behind knob when ON
	local knGlow=Instance.new("ImageLabel")
	knGlow.Size=UDim2.fromOffset(30,30)
	knGlow.Position=UDim2.fromOffset(-6,-6)
	knGlow.BackgroundTransparency=1
	knGlow.Image="rbxassetid://5028857084"
	knGlow.ImageColor3=T.Accent
	knGlow.ImageTransparency=1
	knGlow.ZIndex=kn.ZIndex-1
	knGlow.Parent=kn

	-- State label
	local stLbl=Instance.new("TextLabel")
	stLbl.Size=UDim2.fromOffset(28,16)
	stLbl.Position=UDim2.new(1,-86,0.5,0)
	stLbl.AnchorPoint=Vector2.new(0,0.5)
	stLbl.BackgroundTransparency=1
	stLbl.Text="OFF"
	stLbl.TextColor3=T.TextMut
	stLbl.Font=T.FontB
	stLbl.TextSize=10
	stLbl.TextXAlignment=Enum.TextXAlignment.Right
	stLbl.Parent=c

	local function upd(v)
		if v then
			Tw(kn,{Position=UDim2.fromOffset(25,3),BackgroundColor3=Color3.new(1,1,1),Size=UDim2.fromOffset(18,18)},TI.Bounce)
			Tw(tk,{BackgroundColor3=T.Accent},TI.Normal)
			Tw(tkStroke,{Color=T.AccGlow,Transparency=0.3},TI.Normal)
			Tw(knGlow,{ImageTransparency=0.4},TI.Normal)
			Tw(stLbl,{TextColor3=T.Accent},TI.Fast)
			Tw(cStroke,{Color=T.AccGlow,Transparency=0.45},TI.Normal)
			stLbl.Text="ON"
		else
			Tw(kn,{Position=UDim2.fromOffset(3,3),BackgroundColor3=Color3.fromRGB(90,90,110),Size=UDim2.fromOffset(18,18)},TI.Bounce)
			Tw(tk,{BackgroundColor3=Color3.fromRGB(30,30,42)},TI.Normal)
			Tw(tkStroke,{Color=T.Border,Transparency=0.35},TI.Normal)
			Tw(knGlow,{ImageTransparency=1},TI.Normal)
			Tw(stLbl,{TextColor3=T.TextMut},TI.Fast)
			Tw(cStroke,{Color=T.Border,Transparency=0.55},TI.Normal)
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

	-- Track background (taller for easier clicking)
	local tbg=Instance.new("Frame")
	tbg.Size=UDim2.new(1,-24,0,8)
	tbg.Position=UDim2.fromOffset(12,28)
	tbg.BackgroundColor3=T.BgAlt
	tbg.BorderSizePixel=0
	tbg.Parent=c
	Corner(tbg,4)
	Stroke(tbg,T.Border,1,0.5)

	-- Filled portion
	local fl=Instance.new("Frame")
	fl.Size=UDim2.fromScale(0,1)
	fl.BackgroundColor3=T.Accent
	fl.BorderSizePixel=0
	fl.Parent=tbg
	Corner(fl,4)
	Grad(fl,T.AccSoft,T.AccDark,180)

	-- Knob (bigger for easy drag)
	local kc=Instance.new("Frame")
	kc.Size=UDim2.fromOffset(18,18)
	kc.Position=UDim2.new(1,-9,0.5,0)
	kc.AnchorPoint=Vector2.new(0.5,0.5)
	kc.BackgroundColor3=T.Text
	kc.BorderSizePixel=0
	kc.Parent=fl
	Corner(kc,9)
	Stroke(kc,T.Accent,2,0.2)

	-- Knob inner dot
	local kdot=Instance.new("Frame")
	kdot.Size=UDim2.fromOffset(6,6)
	kdot.Position=UDim2.fromOffset(6,6)
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
			Tw(kc,{Size=UDim2.fromOffset(22,22)},TI.Fast)
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
				Tw(kc,{Size=UDim2.fromOffset(18,18)},TI.Bounce)
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
	c.Size=UDim2.new(1,0,0,40)
	c.BackgroundColor3=T.Surface
	c.BorderSizePixel=0
	c.ClipsDescendants=true
	c.Parent=tab._ct
	Corner(c,10)
	local cStroke=Stroke(c,T.Border,1,0.65)

	local inner=Instance.new("Frame")
	inner.Size=UDim2.fromScale(1,1)
	inner.BackgroundColor3=T.Surface
	inner.BackgroundTransparency=0.5
	inner.BorderSizePixel=0
	inner.Parent=c
	Grad(inner,Color3.fromRGB(34,34,48),Color3.fromRGB(22,22,30),180)

	local hd=Instance.new("TextButton")
	hd.Size=UDim2.new(1,0,0,40)
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
		b.Size=UDim2.new(1,0,0,32)
		b.BackgroundColor3=T.BgAlt
		b.BackgroundTransparency=0.5
		b.BorderSizePixel=0
		b.Text=""
		b.AutoButtonColor=false
		b.Parent=lf
		Corner(b,8)

		-- Check icon per item
		local bIc=Instance.new("ImageLabel")
		bIc.Size=UDim2.fromOffset(14,14)
		bIc.Position=UDim2.fromOffset(8,9)
		bIc.BackgroundTransparency=1
		bIc.ImageColor3=T.TextMut
		bIc.ImageTransparency=0.4
		bIc.Image=Icon("radio_button_unchecked")
		bIc.Parent=b

		local bLb=Instance.new("TextLabel")
		bLb.Size=UDim2.new(1,-32,1,0)
		bLb.Position=UDim2.fromOffset(28,0)
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
			Tw(bIc,{ImageColor3=T.Accent,ImageTransparency=0},TI.Fast)
		end)
		b.MouseLeave:Connect(function()
			Tw(b,{BackgroundTransparency=0.5},TI.Fast)
			Tw(bLb,{TextColor3=T.TextDim},TI.Fast)
			Tw(bIc,{ImageColor3=T.TextMut,ImageTransparency=0.4},TI.Fast)
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
local TabIcons={"cottage","tune","info","build","star","explore","extension","dashboard","person","code"}
local Tab={};Tab.__index=Tab
function Tab.new(w,name,idx)
	local self=setmetatable({_w=w,_lib=w._lib,_name=name,_idx=idx or 1},Tab)
	self:_build()
	return self
end

function Tab:_build()
	local tb=Instance.new("TextButton")
	tb.Size=UDim2.new(1,-6,0,36)
	tb.Position=UDim2.fromOffset(3,0)
	tb.BackgroundTransparency=1
	tb.BackgroundColor3=T.SurfHov
	tb.BorderSizePixel=0
	tb.Text=""
	tb.AutoButtonColor=false
	tb.Parent=self._w._tl
	Corner(tb,8)
	self._tb=tb

	-- Active indicator bar (left)
	local ind=Instance.new("Frame")
	ind.Size=UDim2.new(0,3,0,22)
	ind.Position=UDim2.fromOffset(0,7)
	ind.BackgroundColor3=T.Accent
	ind.BackgroundTransparency=1
	ind.BorderSizePixel=0
	ind.Parent=tb
	Corner(ind,2)
	self._ind=ind

	-- Icon background circle
	local icBg=Instance.new("Frame")
	icBg.Size=UDim2.fromOffset(26,26)
	icBg.Position=UDim2.fromOffset(8,5)
	icBg.BackgroundColor3=T.Accent
	icBg.BackgroundTransparency=0.88
	icBg.BorderSizePixel=0
	icBg.Parent=tb
	Corner(icBg,13)
	self._icBg=icBg

	-- Icon
	local icName=TabIcons[self._idx] or "circle"
	local ic=Instance.new("ImageLabel")
	ic.Size=UDim2.fromOffset(16,16)
	ic.Position=UDim2.fromOffset(5,5)
	ic.BackgroundTransparency=1
	ic.ImageColor3=T.TextMut
	ic.Image=Icon(icName)
	ic.Parent=icBg
	self._ic=ic

	-- Name
	local nm=Instance.new("TextLabel")
	nm.Size=UDim2.new(1,-44,1,0)
	nm.Position=UDim2.fromOffset(38,0)
	nm.BackgroundTransparency=1
	nm.Text=self._name
	nm.TextColor3=T.TextMut
	nm.Font=T.FontSB
	nm.TextSize=11
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
			Tw(tb,{BackgroundTransparency=0.75},TI.Fast)
			Tw(ic,{ImageColor3=T.TextDim},TI.Fast)
			Tw(icBg,{BackgroundTransparency=0.8},TI.Fast)
		end
	end)
	tb.MouseLeave:Connect(function()
		if self._w._sel~=self then
			Tw(tb,{BackgroundTransparency=1},TI.Fast)
			Tw(ic,{ImageColor3=T.TextMut},TI.Fast)
			Tw(icBg,{BackgroundTransparency=0.88},TI.Fast)
		end
	end)
end

function Tab:Show()
	self._ct.Visible=true
	Tw(self._tb,{BackgroundTransparency=0.65},TI.Normal)
	Tw(self._nm,{TextColor3=T.Accent},TI.Fast)
	Tw(self._ic,{ImageColor3=T.Accent},TI.Fast)
	Tw(self._icBg,{BackgroundTransparency=0.72},TI.Normal)
	Tw(self._ind,{BackgroundTransparency=0},TI.Normal)
end
function Tab:Hide()
	self._ct.Visible=false
	Tw(self._tb,{BackgroundTransparency=1},TI.Normal)
	Tw(self._nm,{TextColor3=T.TextMut},TI.Fast)
	Tw(self._ic,{ImageColor3=T.TextMut},TI.Fast)
	Tw(self._icBg,{BackgroundTransparency=0.88},TI.Normal)
	Tw(self._ind,{BackgroundTransparency=1},TI.Normal)
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
-- ║           FOOTER v3.3                ║
-- ╚══════════════════════════════════════╝
local function MakeFooter(mainF)
	local ft=Instance.new("Frame")
	ft.Size=UDim2.new(1,0,0,50)
	ft.Position=UDim2.new(0,0,1,4)
	ft.BackgroundColor3=T.BgAlt
	ft.BackgroundTransparency=0.04
	ft.BorderSizePixel=0
	ft.Parent=mainF
	Corner(ft,12)
	Stroke(ft,T.Border,1,0.45)
	Grad(ft,Color3.fromRGB(18,18,28),Color3.fromRGB(12,12,18),170)
	DropShadow(ft,16,T.ShadowCol,0.5)

	-- Avatar with ring
	local avRing=Instance.new("Frame")
	avRing.Size=UDim2.fromOffset(36,36)
	avRing.Position=UDim2.fromOffset(10,7)
	avRing.BackgroundColor3=T.Accent
	avRing.BackgroundTransparency=0.6
	avRing.BorderSizePixel=0
	avRing.Parent=ft
	Corner(avRing,18)
	Stroke(avRing,T.AccGlow,1,0.6)

	local av=Instance.new("ImageLabel")
	av.Size=UDim2.fromOffset(28,28)
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
	un.Size=UDim2.fromOffset(90,42)
	un.Position=UDim2.fromOffset(50,4)
	un.BackgroundTransparency=1
	un.Text=P.Name
	un.TextColor3=T.Text
	un.Font=T.FontSB
	un.TextSize=12
	un.TextXAlignment=Enum.TextXAlignment.Left
	un.Parent=ft

	Divider(ft, UDim2.fromOffset(142,12))

	local exIc=Instance.new("ImageLabel")
	exIc.Size=UDim2.fromOffset(14,14)
	exIc.Position=UDim2.fromOffset(150,18)
	exIc.BackgroundTransparency=1
	exIc.ImageColor3=T.TextMut
	exIc.Image=Icon("memory")
	exIc.Parent=ft

	local exL=Instance.new("TextLabel")
	exL.Size=UDim2.fromOffset(85,42)
	exL.Position=UDim2.fromOffset(168,4)
	exL.BackgroundTransparency=1
	exL.Text=DetectExecutor()
	exL.TextColor3=T.TextMut
	exL.Font=T.Font
	exL.TextSize=10
	exL.TextXAlignment=Enum.TextXAlignment.Left
	exL.Parent=ft

	Divider(ft, UDim2.fromOffset(254,12))

	-- FPS (colored dynamically)
	local fpsIc=Instance.new("ImageLabel")
	fpsIc.Size=UDim2.fromOffset(14,14)
	fpsIc.Position=UDim2.fromOffset(262,18)
	fpsIc.BackgroundTransparency=1
	fpsIc.ImageColor3=T.Succ
	fpsIc.Image=Icon("speed")
	fpsIc.Parent=ft

	local fpsTxt=Instance.new("TextLabel")
	fpsTxt.Size=UDim2.fromOffset(55,42)
	fpsTxt.Position=UDim2.fromOffset(280,4)
	fpsTxt.BackgroundTransparency=1
	fpsTxt.Text="-- fps"
	fpsTxt.TextColor3=T.Succ
	fpsTxt.Font=T.FontB
	fpsTxt.TextSize=10
	fpsTxt.TextXAlignment=Enum.TextXAlignment.Left
	fpsTxt.Parent=ft

	Divider(ft, UDim2.fromOffset(336,12))

	-- Ping (colored by latency)
	local pgIc=Instance.new("ImageLabel")
	pgIc.Size=UDim2.fromOffset(14,14)
	pgIc.Position=UDim2.fromOffset(344,18)
	pgIc.BackgroundTransparency=1
	pgIc.ImageColor3=T.Warn
	pgIc.Image=Icon("wifi")
	pgIc.Parent=ft

	local pgTxt=Instance.new("TextLabel")
	pgTxt.Size=UDim2.fromOffset(68,42)
	pgTxt.Position=UDim2.fromOffset(362,4)
	pgTxt.BackgroundTransparency=1
	pgTxt.Text="-- ms"
	pgTxt.TextColor3=T.Warn
	pgTxt.Font=T.FontB
	pgTxt.TextSize=10
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
	local sz=self._o.Size or UDim2.fromOffset(680,480)

	-- ── MINI BAR (minimize state) ─────────────────────────────────────
	local mbar=Instance.new("Frame")
	mbar.Size=UDim2.fromOffset(320,55)
	mbar.Position=UDim2.new(0.5,0,0,8)
	mbar.AnchorPoint=Vector2.new(0.5,0)
	mbar.BackgroundColor3=T.Glass
	mbar.BackgroundTransparency=0.04
	mbar.BorderSizePixel=0
	mbar.Visible=false
	mbar.Parent=gui
	Corner(mbar,14)
	Stroke(mbar,T.BorderAc,1.4,0.3)
	Grad(mbar,Color3.fromRGB(26,26,40),Color3.fromRGB(18,18,28))
	self._mbar=mbar
	MakeDrag(mbar,mbar) -- Entire bar is draggable

	-- Logo in minibar
	local mLogoBg=Instance.new("Frame")
	mLogoBg.Size=UDim2.fromOffset(38,38)
	mLogoBg.Position=UDim2.fromOffset(8,8)
	mLogoBg.BackgroundColor3=T.Accent
	mLogoBg.BackgroundTransparency=0.78
	mLogoBg.BorderSizePixel=0
	mLogoBg.Parent=mbar
	Corner(mLogoBg,10)

	local mLogo=Instance.new("ImageLabel")
	mLogo.Size=UDim2.fromOffset(26,26)
	mLogo.Position=UDim2.fromOffset(6,6)
	mLogo.BackgroundTransparency=1
	mLogo.Image="rbxassetid://74440190043939"
	mLogo.Parent=mLogoBg

	local mBtn=Instance.new("TextButton")
	mBtn.Size=UDim2.fromOffset(140,55)
	mBtn.Position=UDim2.fromOffset(50,0)
	mBtn.BackgroundTransparency=1
	mBtn.Text=self._o.Title or "BloxBox UI"
	mBtn.TextColor3=T.Text
	mBtn.Font=T.FontB
	mBtn.TextSize=14
	mBtn.TextXAlignment=Enum.TextXAlignment.Left
	mBtn.AutoButtonColor=false
	mBtn.Parent=mbar
	mBtn.MouseEnter:Connect(function()Tw(mBtn,{TextColor3=T.Accent},TI.Fast)end)
	mBtn.MouseLeave:Connect(function()Tw(mBtn,{TextColor3=T.Text},TI.Fast)end)

	Divider(mbar,UDim2.fromOffset(195,12))

	-- Move icon (styled box)
	local mDragBg=Instance.new("Frame")
	mDragBg.Size=UDim2.fromOffset(34,34)
	mDragBg.Position=UDim2.fromOffset(206,10)
	mDragBg.BackgroundColor3=T.BgAlt
	mDragBg.BackgroundTransparency=0.3
	mDragBg.BorderSizePixel=0
	mDragBg.Parent=mbar
	Corner(mDragBg,8)
	Stroke(mDragBg,T.Border,1,0.5)

	local mDragIc=Instance.new("ImageLabel")
	mDragIc.Size=UDim2.fromOffset(18,18)
	mDragIc.Position=UDim2.fromOffset(8,8)
	mDragIc.BackgroundTransparency=1
	mDragIc.ImageColor3=T.TextDim
	mDragIc.Image=Icon("open_with")
	mDragIc.Parent=mDragBg

	-- Close button on minibar
	local mClose=Instance.new("TextButton")
	mClose.Size=UDim2.fromOffset(32,32)
	mClose.Position=UDim2.fromOffset(280,12)
	mClose.BackgroundColor3=T.Err
	mClose.BackgroundTransparency=0.75
	mClose.Text=""
	mClose.BorderSizePixel=0
	mClose.AutoButtonColor=false
	mClose.Parent=mbar
	Corner(mClose,16)
	local mCloseIc=Instance.new("ImageLabel")
	mCloseIc.Size=UDim2.fromOffset(16,16)
	mCloseIc.Position=UDim2.fromOffset(8,8)
	mCloseIc.BackgroundTransparency=1
	mCloseIc.ImageColor3=T.Err
	mCloseIc.Image=Icon("close")
	mCloseIc.Parent=mClose
	mClose.MouseEnter:Connect(function()Tw(mClose,{BackgroundTransparency=0.15},TI.Fast);Tw(mCloseIc,{ImageColor3=T.Text},TI.Fast)end)
	mClose.MouseLeave:Connect(function()Tw(mClose,{BackgroundTransparency=0.75},TI.Fast);Tw(mCloseIc,{ImageColor3=T.Err},TI.Fast)end)
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
	Corner(main,16)

	-- ★ FLOATING SHADOW (spaceship effect)
	DropShadow(main,40,T.ShadowCol,0.35)

	-- ★ Outer glow border (accent)
	local glowStroke=Stroke(main,T.AccGlow,1.8,0.55)

	-- ★ Inner subtle border 
	local innerBorderFrame=Instance.new("Frame")
	innerBorderFrame.Size=UDim2.new(1,-4,1,-4)
	innerBorderFrame.Position=UDim2.fromOffset(2,2)
	innerBorderFrame.BackgroundTransparency=1
	innerBorderFrame.BorderSizePixel=0
	innerBorderFrame.ZIndex=main.ZIndex+1
	innerBorderFrame.Parent=main
	Corner(innerBorderFrame,14)
	Stroke(innerBorderFrame,T.Border,1,0.5)

	-- Subtle gradient on main bg
	Grad(main,Color3.fromRGB(14,14,20),Color3.fromRGB(8,8,12),165)
	self._mf=main
	self._mainStroke=glowStroke

	-- ── HEADER (glass cockpit) ───────────────────────────────────────
	local hd=Instance.new("Frame")
	hd.Size=UDim2.new(1,0,0,48)
	hd.BackgroundColor3=T.Glass2
	hd.BackgroundTransparency=0.02
	hd.BorderSizePixel=0
	hd.Parent=main
	Corner(hd,16)
	Grad(hd,Color3.fromRGB(22,24,36),Color3.fromRGB(12,12,18),175)

	-- Fix bottom corners of header
	local hfix=Instance.new("Frame")
	hfix.Size=UDim2.new(1,0,0,16)
	hfix.Position=UDim2.new(0,0,1,-16)
	hfix.BackgroundColor3=T.Glass2
	hfix.BorderSizePixel=0
	hfix.Parent=hd
	Grad(hfix,Color3.fromRGB(22,24,36),Color3.fromRGB(12,12,18),175)

	-- ★ Header top inner shine (glass reflection)
	local hdShine=Instance.new("Frame")
	hdShine.Size=UDim2.new(1,-8,0,1)
	hdShine.Position=UDim2.fromOffset(4,1)
	hdShine.BackgroundColor3=Color3.new(1,1,1)
	hdShine.BackgroundTransparency=0.88
	hdShine.BorderSizePixel=0
	hdShine.Parent=hd
	Corner(hdShine,1)
	local shineGrad=Instance.new("UIGradient")
	shineGrad.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0.7),NumberSequenceKeypoint.new(0.5,0),NumberSequenceKeypoint.new(1,0.7)})
	shineGrad.Parent=hdShine

	-- Header bottom separator (glowing line)
	local hdLine=Instance.new("Frame")
	hdLine.Size=UDim2.new(1,-16,0,1)
	hdLine.Position=UDim2.new(0,8,1,-1)
	hdLine.BackgroundColor3=T.AccGlow
	hdLine.BackgroundTransparency=0.6
	hdLine.BorderSizePixel=0
	hdLine.Parent=hd
	local hdLineGrad=Instance.new("UIGradient")
	hdLineGrad.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0.8),NumberSequenceKeypoint.new(0.3,0),NumberSequenceKeypoint.new(0.7,0),NumberSequenceKeypoint.new(1,0.8)})
	hdLineGrad.Parent=hdLine

	-- Logo image (bigger, with glow bg)
	local hdLogoBg=Instance.new("Frame")
	hdLogoBg.Size=UDim2.fromOffset(32,32)
	hdLogoBg.Position=UDim2.fromOffset(10,8)
	hdLogoBg.BackgroundColor3=T.Accent
	hdLogoBg.BackgroundTransparency=0.85
	hdLogoBg.BorderSizePixel=0
	hdLogoBg.Parent=hd
	Corner(hdLogoBg,10)

	local hdLogo=Instance.new("ImageLabel")
	hdLogo.Size=UDim2.fromOffset(22,22)
	hdLogo.Position=UDim2.fromOffset(5,5)
	hdLogo.BackgroundTransparency=1
	hdLogo.Image="rbxassetid://74440190043939"
	hdLogo.Parent=hdLogoBg

	local ttl=Instance.new("TextLabel")
	ttl.Size=UDim2.new(1,-140,1,0)
	ttl.Position=UDim2.fromOffset(48,0)
	ttl.BackgroundTransparency=1
	ttl.Text=self._o.Title or "BloxBox"
	ttl.TextColor3=T.Text
	ttl.Font=T.FontB
	ttl.TextSize=15
	ttl.TextXAlignment=Enum.TextXAlignment.Left
	ttl.Parent=hd
	self._ttl=ttl

	-- Window controls container
	local ctrlsFrame=Instance.new("Frame")
	ctrlsFrame.Size=UDim2.fromOffset(76,48)
	ctrlsFrame.Position=UDim2.new(1,-80,0,0)
	ctrlsFrame.BackgroundTransparency=1
	ctrlsFrame.Parent=hd

	-- Close button
	local cls=Instance.new("TextButton")
	cls.Size=UDim2.fromOffset(28,28)
	cls.Position=UDim2.fromOffset(44,10)
	cls.BackgroundColor3=T.Err
	cls.BackgroundTransparency=0.78
	cls.Text=""
	cls.BorderSizePixel=0
	cls.AutoButtonColor=false
	cls.Parent=ctrlsFrame
	Corner(cls,14)
	Stroke(cls,T.ErrDark,1,0.4)

	local clsIc=Instance.new("ImageLabel")
	clsIc.Size=UDim2.fromOffset(14,14)
	clsIc.Position=UDim2.fromOffset(7,7)
	clsIc.BackgroundTransparency=1
	clsIc.ImageColor3=T.Err
	clsIc.Image=Icon("close")
	clsIc.Parent=cls
	cls.MouseEnter:Connect(function()Tw(cls,{BackgroundTransparency=0.1},TI.Fast);Tw(clsIc,{ImageColor3=T.Text},TI.Fast)end)
	cls.MouseLeave:Connect(function()Tw(cls,{BackgroundTransparency=0.78},TI.Fast);Tw(clsIc,{ImageColor3=T.Err},TI.Fast)end)
	cls.MouseButton1Click:Connect(function()self:Destroy()end)

	-- Minimize button
	local mn=Instance.new("TextButton")
	mn.Size=UDim2.fromOffset(28,28)
	mn.Position=UDim2.fromOffset(10,10)
	mn.BackgroundColor3=T.Warn
	mn.BackgroundTransparency=0.78
	mn.Text=""
	mn.BorderSizePixel=0
	mn.AutoButtonColor=false
	mn.Parent=ctrlsFrame
	Corner(mn,14)
	Stroke(mn,T.WarnDark,1,0.4)

	local mnIc=Instance.new("ImageLabel")
	mnIc.Size=UDim2.fromOffset(14,14)
	mnIc.Position=UDim2.fromOffset(7,7)
	mnIc.BackgroundTransparency=1
	mnIc.ImageColor3=T.Warn
	mnIc.Image=Icon("remove")
	mnIc.Parent=mn
	mn.MouseEnter:Connect(function()Tw(mn,{BackgroundTransparency=0.1},TI.Fast);Tw(mnIc,{ImageColor3=T.Text},TI.Fast)end)
	mn.MouseLeave:Connect(function()Tw(mn,{BackgroundTransparency=0.78},TI.Fast);Tw(mnIc,{ImageColor3=T.Warn},TI.Fast)end)
	mn.MouseButton1Click:Connect(function()self:Minimize()end)

	-- ── SIDEBAR ──────────────────────────────────────────────────────
	local sb=Instance.new("Frame")
	sb.Size=UDim2.new(0,140,1,-48)
	sb.Position=UDim2.fromOffset(0,48)
	sb.BackgroundColor3=T.BgAlt
	sb.BackgroundTransparency=0.05
	sb.BorderSizePixel=0
	sb.Parent=main
	Corner(sb,0)
	Grad(sb,Color3.fromRGB(14,14,20),Color3.fromRGB(9,9,13),175)
	Stroke(sb,T.Border,1,0.45)

	-- Sidebar right accent border (gradient line)
	local sbBorder=Instance.new("Frame")
	sbBorder.Size=UDim2.new(0,1,1,-8)
	sbBorder.Position=UDim2.new(1,-1,0,4)
	sbBorder.BackgroundColor3=T.BorderAc
	sbBorder.BackgroundTransparency=0.45
	sbBorder.BorderSizePixel=0
	sbBorder.Parent=sb
	local sbBorderGrad=Instance.new("UIGradient")
	sbBorderGrad.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0.8),NumberSequenceKeypoint.new(0.3,0),NumberSequenceKeypoint.new(0.7,0),NumberSequenceKeypoint.new(1,0.8)})
	sbBorderGrad.Rotation=90
	sbBorderGrad.Parent=sbBorder

	-- NAVIGATION label with icon
	local navIc=Instance.new("ImageLabel")
	navIc.Size=UDim2.fromOffset(11,11)
	navIc.Position=UDim2.fromOffset(10,10)
	navIc.BackgroundTransparency=1
	navIc.ImageColor3=T.TextMut
	navIc.Image=Icon("menu")
	navIc.Parent=sb

	local sbLbl=Instance.new("TextLabel")
	sbLbl.Size=UDim2.new(1,-28,0,14)
	sbLbl.Position=UDim2.fromOffset(24,9)
	sbLbl.BackgroundTransparency=1
	sbLbl.Text="NAVIGATION"
	sbLbl.TextColor3=T.TextMut
	sbLbl.Font=T.FontB
	sbLbl.TextSize=8
	sbLbl.TextXAlignment=Enum.TextXAlignment.Left
	sbLbl.Parent=sb

	-- Divider below label (styled with gradient)
	local sbDiv=Instance.new("Frame")
	sbDiv.Size=UDim2.new(1,-16,0,1)
	sbDiv.Position=UDim2.fromOffset(8,26)
	sbDiv.BackgroundColor3=T.Border
	sbDiv.BackgroundTransparency=0.3
	sbDiv.BorderSizePixel=0
	sbDiv.Parent=sb
	Corner(sbDiv,1)
	local sbDivGrad=Instance.new("UIGradient")
	sbDivGrad.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(1,1)})
	sbDivGrad.Parent=sbDiv

	local tlc=Instance.new("Frame")
	tlc.Size=UDim2.new(1,-10,1,-36)
	tlc.Position=UDim2.fromOffset(5,32)
	tlc.BackgroundTransparency=1
	tlc.Parent=sb
	local sl=Instance.new("UIListLayout")
	sl.Padding=UDim.new(0,3)
	sl.Parent=tlc
	self._tl=tlc

	-- Content area
	local cf=Instance.new("Frame")
	cf.Size=UDim2.new(1,-141,1,-48)
	cf.Position=UDim2.fromOffset(141,48)
	cf.BackgroundTransparency=1
	cf.BorderSizePixel=0
	cf.Parent=main
	self._cf=cf

	MakeFooter(main)
	MakeDrag(hd,main)
	MakeResize(main,520,380)

	-- Entrance animation
	main.BackgroundTransparency=1
	main.Size=UDim2.fromOffset(sz.X.Offset-30,sz.Y.Offset-22)
	ttl.TextTransparency=1
	Tw(main,{BackgroundTransparency=0,Size=sz},TI.Bounce)
	Tw(ttl,{TextTransparency=0},TI.Slow)
end

function Win:Minimize()
	-- Save current size before minimizing
	self._savedSize=self._mf.Size
	self._mbar.Visible=true
	self._mbar.BackgroundTransparency=0
	Tw(self._mf,{BackgroundTransparency=1,
		Size=UDim2.fromOffset(self._mf.Size.X.Offset-22,self._mf.Size.Y.Offset-12)},TI.Normal)
	task.wait(0.3)
	self._mf.Visible=false
end

function Win:Restore()
	self._mf.Visible=true
	-- Use saved size (user may have resized) or default
	local sz=self._savedSize or self._o.Size or UDim2.fromOffset(680,480)
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

print("[BloxBox UI] v3.3 Spaceship loaded ✓ | Floating aesthetic")
return BB