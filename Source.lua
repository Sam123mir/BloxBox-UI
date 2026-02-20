--[[ BLOXBOX UI v2.1 PREMIUM | by Samir & Team | Single-File ]]

-- Services
local TS = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local HTTP = game:GetService("HttpService")
local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local Stats = game:GetService("Stats")
local P = Players.LocalPlayer

-- Signal
local Signal = {}; Signal.__index = Signal
function Signal.new() return setmetatable({_c={}}, Signal) end
function Signal:Connect(fn) local c={_h=fn}; c.Disconnect=function(s) for i,v in ipairs(self._c) do if v==s then table.remove(self._c,i) break end end end; table.insert(self._c,c); return c end
function Signal:Fire(...) for _,c in ipairs(self._c) do task.spawn(c._h,...) end end
function Signal:Destroy() self._c={} end

-- Tween Presets
local TI={
	Instant=TweenInfo.new(0.06,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),
	Fast=TweenInfo.new(0.16,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),
	Normal=TweenInfo.new(0.3,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),
	Slow=TweenInfo.new(0.55,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),
	Smooth=TweenInfo.new(0.45,Enum.EasingStyle.Exponential,Enum.EasingDirection.Out),
	Bounce=TweenInfo.new(0.5,Enum.EasingStyle.Back,Enum.EasingDirection.Out),
}
local function Tw(inst,props,p) local t=TS:Create(inst,typeof(p)=="TweenInfo"and p or TI[p or"Normal"],props); t:Play(); return t end

-- Helpers
local function Corner(p,r) local c=Instance.new("UICorner");c.CornerRadius=UDim.new(0,r or 8);c.Parent=p end
local function Stroke(p,col,th,tr) local s=Instance.new("UIStroke");s.Color=col;s.Thickness=th or 1;s.Transparency=tr or 0.6;s.Parent=p;return s end
local function Pad(p,t,b,l,r) local u=Instance.new("UIPadding");u.PaddingTop=UDim.new(0,t or 0);u.PaddingBottom=UDim.new(0,b or 0);u.PaddingLeft=UDim.new(0,l or 0);u.PaddingRight=UDim.new(0,r or 0);u.Parent=p end
local function MakeGUI(n,o) local g=Instance.new("ScreenGui");g.Name=n;g.ResetOnSpawn=false;g.ZIndexBehavior=Enum.ZIndexBehavior.Sibling;g.DisplayOrder=o or 1;pcall(function()g.Parent=game:GetService("CoreGui")end);if not g.Parent then g.Parent=P:WaitForChild("PlayerGui")end;return g end

-- Theme
local T={
	Bg=Color3.fromRGB(14,14,18), BgAlt=Color3.fromRGB(20,20,26), Surface=Color3.fromRGB(28,28,36),
	SurfHov=Color3.fromRGB(36,36,46), Accent=Color3.fromRGB(88,128,255), AccDark=Color3.fromRGB(55,85,200),
	Text=Color3.fromRGB(235,235,242), TextDim=Color3.fromRGB(130,130,155), TextMut=Color3.fromRGB(80,80,105),
	Border=Color3.fromRGB(45,45,62), Succ=Color3.fromRGB(75,200,115), Warn=Color3.fromRGB(255,185,55),
	Err=Color3.fromRGB(235,65,65), Font=Enum.Font.GothamMedium, FontB=Enum.Font.GothamBold, FontL=Enum.Font.Gotham,
}

-- State
local SM={}; SM.__index=SM
function SM.new() return setmetatable({_s={},_sub={}},SM) end
function SM:Set(f,v) if self._s[f]==v then return end; self._s[f]=v; if self._sub[f] then self._sub[f]:Fire(v) end end
function SM:Get(f,d) local v=self._s[f]; return v==nil and d or v end
function SM:Sub(f,fn) if not self._sub[f] then self._sub[f]=Signal.new() end; return self._sub[f]:Connect(fn) end

-- Config
local function SaveCfg(s,n) pcall(function() if writefile then if not isfolder("BloxBox")then makefolder("BloxBox")end;writefile("BloxBox/"..n..".json",HTTP:JSONEncode(s._s))end end) end
local function LoadCfg(s,n) pcall(function() if readfile and isfile and isfile("BloxBox/"..n..".json")then local d=HTTP:JSONDecode(readfile("BloxBox/"..n..".json"));if d then for k,v in pairs(d)do s:Set(k,v)end end end end) end

-- Drag
local function MakeDrag(handle,frame)
	local dr,ds,sp=false,nil,nil
	handle.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dr=true;ds=i.Position;sp=frame.Position;i.Changed:Connect(function()if i.UserInputState==Enum.UserInputState.End then dr=false end end)end end)
	UIS.InputChanged:Connect(function(i) if dr and(i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch)then local d=i.Position-ds;Tw(frame,{Position=UDim2.new(sp.X.Scale,sp.X.Offset+d.X,sp.Y.Scale,sp.Y.Offset+d.Y)},"Instant")end end)
end

-- Notifications (TOP)
local NC=nil
local function GetNC() if NC and NC.Parent then return NC end; local g=MakeGUI("BBNotifs",200); local c=Instance.new("Frame");c.Size=UDim2.new(0,310,1,-20);c.Position=UDim2.new(1,-320,0,10);c.BackgroundTransparency=1;c.Parent=g; local l=Instance.new("UIListLayout");l.Padding=UDim.new(0,6);l.VerticalAlignment=Enum.VerticalAlignment.Top;l.Parent=c; NC=c; return c end

local function Notif(o)
	local c=GetNC(); local cols={Info=T.Accent,Success=T.Succ,Warning=T.Warn,Error=T.Err}; local col=cols[o.Type or"Info"]or T.Accent
	local card=Instance.new("Frame");card.Size=UDim2.new(1,0,0,64);card.BackgroundColor3=T.Surface;card.BackgroundTransparency=0.05;card.BorderSizePixel=0;card.ClipsDescendants=true;card.Parent=c;Corner(card,10);Stroke(card,col,1.2,0.35)
	local bar=Instance.new("Frame");bar.Size=UDim2.new(0,3,1,-10);bar.Position=UDim2.fromOffset(5,5);bar.BackgroundColor3=col;bar.BorderSizePixel=0;bar.Parent=card;Corner(bar,2)
	local tt=Instance.new("TextLabel");tt.Size=UDim2.new(1,-22,0,20);tt.Position=UDim2.fromOffset(16,7);tt.BackgroundTransparency=1;tt.Text=o.Title or"";tt.TextColor3=T.Text;tt.Font=T.FontB;tt.TextSize=13;tt.TextXAlignment=Enum.TextXAlignment.Left;tt.Parent=card
	local bd=Instance.new("TextLabel");bd.Size=UDim2.new(1,-22,0,26);bd.Position=UDim2.fromOffset(16,29);bd.BackgroundTransparency=1;bd.Text=o.Content or"";bd.TextColor3=T.TextDim;bd.Font=T.FontL;bd.TextSize=11;bd.TextXAlignment=Enum.TextXAlignment.Left;bd.TextWrapped=true;bd.Parent=card
	card.Position=UDim2.fromOffset(320,0); Tw(card,{Position=UDim2.fromOffset(0,0)},"Bounce")
	task.delay(o.Duration or 4,function() Tw(card,{Position=UDim2.fromOffset(320,0)},"Normal");task.wait(0.35);card:Destroy()end)
end

-- Intro (Compact + Clean)
local function ShowIntro(logoId,cb)
	local gui=MakeGUI("BBIntro",999)
	local bg=Instance.new("Frame");bg.Size=UDim2.fromScale(1,1);bg.BackgroundColor3=Color3.fromRGB(6,6,10);bg.BorderSizePixel=0;bg.Parent=gui

	local card=Instance.new("Frame");card.Size=UDim2.fromOffset(220,140);card.Position=UDim2.fromScale(0.5,0.5);card.AnchorPoint=Vector2.new(0.5,0.5)
	card.BackgroundColor3=T.Surface;card.BackgroundTransparency=0.15;card.BorderSizePixel=0;card.Parent=bg;Corner(card,12);Stroke(card,T.Accent,1,0.6)

	-- Glow behind card
	local glow=Instance.new("ImageLabel");glow.Size=UDim2.fromOffset(320,220);glow.Position=UDim2.fromScale(0.5,0.5);glow.AnchorPoint=Vector2.new(0.5,0.5)
	glow.BackgroundTransparency=1;glow.Image="rbxassetid://5028857084";glow.ImageColor3=T.Accent;glow.ImageTransparency=0.92;glow.Parent=bg

	local logo=Instance.new("ImageLabel");logo.Size=UDim2.fromOffset(42,42);logo.Position=UDim2.new(0.5,0,0,18);logo.AnchorPoint=Vector2.new(0.5,0)
	logo.BackgroundTransparency=1;logo.Image=logoId or"";logo.ImageTransparency=1;logo.Parent=card

	local ttl=Instance.new("TextLabel");ttl.Size=UDim2.new(1,0,0,20);ttl.Position=UDim2.new(0.5,0,0,66);ttl.AnchorPoint=Vector2.new(0.5,0)
	ttl.BackgroundTransparency=1;ttl.Text="BloxBox UI";ttl.TextColor3=T.Text;ttl.Font=T.FontB;ttl.TextSize=16;ttl.TextTransparency=1;ttl.Parent=card

	local sub=Instance.new("TextLabel");sub.Size=UDim2.new(1,0,0,14);sub.Position=UDim2.new(0.5,0,0,88);sub.AnchorPoint=Vector2.new(0.5,0)
	sub.BackgroundTransparency=1;sub.Text="v2.1 Premium";sub.TextColor3=T.TextMut;sub.Font=T.FontL;sub.TextSize=10;sub.TextTransparency=1;sub.Parent=card

	local barBg=Instance.new("Frame");barBg.Size=UDim2.new(0.65,0,0,3);barBg.Position=UDim2.new(0.5,0,0,115);barBg.AnchorPoint=Vector2.new(0.5,0)
	barBg.BackgroundColor3=T.Border;barBg.BackgroundTransparency=1;barBg.BorderSizePixel=0;barBg.Parent=card;Corner(barBg,2)
	local fill=Instance.new("Frame");fill.Size=UDim2.fromScale(0,1);fill.BackgroundColor3=T.Accent;fill.BorderSizePixel=0;fill.Parent=barBg;Corner(fill,2)

	task.spawn(function()
		Tw(card,{BackgroundTransparency=0.05},"Slow");task.wait(0.3)
		Tw(logo,{ImageTransparency=0},"Slow");task.wait(0.35)
		Tw(ttl,{TextTransparency=0},"Normal");task.wait(0.2)
		Tw(sub,{TextTransparency=0},"Normal");task.wait(0.25)
		Tw(barBg,{BackgroundTransparency=0.4},"Normal");task.wait(0.1)
		Tw(fill,{Size=UDim2.fromScale(1,1)},TweenInfo.new(2.8,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut)).Completed:Wait()
		task.wait(0.5)
		Tw(card,{BackgroundTransparency=1},"Normal");Tw(logo,{ImageTransparency=1},"Normal")
		Tw(ttl,{TextTransparency=1},"Normal");Tw(sub,{TextTransparency=1},"Normal")
		Tw(barBg,{BackgroundTransparency=1},"Normal");Tw(glow,{ImageTransparency=1},"Normal")
		task.wait(0.3);Tw(bg,{BackgroundTransparency=1},"Normal");task.wait(0.5)
		gui:Destroy();if cb then cb()end
	end)
end

-- Components
local function CSection(tab,name)
	local f=Instance.new("Frame");f.Size=UDim2.new(1,0,0,26);f.BackgroundTransparency=1;f.Parent=tab._ct
	local ln=Instance.new("Frame");ln.Size=UDim2.new(1,0,0,1);ln.Position=UDim2.new(0,0,0.5,0);ln.BackgroundColor3=T.Border;ln.BackgroundTransparency=0.5;ln.BorderSizePixel=0;ln.Parent=f
	local lb=Instance.new("TextLabel");lb.AutomaticSize=Enum.AutomaticSize.X;lb.Size=UDim2.new(0,0,0,16);lb.Position=UDim2.fromOffset(8,5);lb.BackgroundColor3=T.Bg;lb.Text="  "..name.."  ";lb.TextColor3=T.TextMut;lb.Font=T.FontB;lb.TextSize=10;lb.Parent=f
end

local function CButton(tab,o)
	local b=Instance.new("TextButton");b.Size=UDim2.new(1,0,0,34);b.BackgroundColor3=T.Surface;b.BorderSizePixel=0;b.Text="";b.AutoButtonColor=false;b.Parent=tab._ct;Corner(b,T and 6);Stroke(b,T.Border,1,0.75)
	local ic=Instance.new("TextLabel");ic.Size=UDim2.fromOffset(18,34);ic.Position=UDim2.fromOffset(10,0);ic.BackgroundTransparency=1;ic.Text="▸";ic.TextColor3=T.Accent;ic.Font=T.Font;ic.TextSize=12;ic.Parent=b
	local lb=Instance.new("TextLabel");lb.Size=UDim2.new(1,-36,1,0);lb.Position=UDim2.fromOffset(28,0);lb.BackgroundTransparency=1;lb.Text=o.Name;lb.TextColor3=T.Text;lb.Font=T.Font;lb.TextSize=13;lb.TextXAlignment=Enum.TextXAlignment.Left;lb.Parent=b
	b.MouseEnter:Connect(function()Tw(b,{BackgroundColor3=T.SurfHov},"Fast");Tw(ic,{TextColor3=T.Text},"Fast")end)
	b.MouseLeave:Connect(function()Tw(b,{BackgroundColor3=T.Surface},"Fast");Tw(ic,{TextColor3=T.Accent},"Fast")end)
	b.MouseButton1Click:Connect(function()Tw(b,{BackgroundColor3=T.AccDark},"Instant");task.wait(0.07);Tw(b,{BackgroundColor3=T.SurfHov},"Fast");if o.Callback then o.Callback()end end)
end

local function CToggle(tab,o)
	local st=tab._lib._state
	local c=Instance.new("TextButton");c.Size=UDim2.new(1,0,0,34);c.BackgroundColor3=T.Surface;c.BorderSizePixel=0;c.Text="";c.AutoButtonColor=false;c.Parent=tab._ct;Corner(c,6);Stroke(c,T.Border,1,0.75)
	local lb=Instance.new("TextLabel");lb.Size=UDim2.new(1,-56,1,0);lb.Position=UDim2.fromOffset(12,0);lb.BackgroundTransparency=1;lb.Text=o.Name;lb.TextColor3=T.Text;lb.Font=T.Font;lb.TextSize=13;lb.TextXAlignment=Enum.TextXAlignment.Left;lb.Parent=c
	local tk=Instance.new("Frame");tk.Size=UDim2.fromOffset(34,16);tk.Position=UDim2.new(1,-44,0.5,0);tk.AnchorPoint=Vector2.new(0,0.5);tk.BackgroundColor3=Color3.fromRGB(50,50,60);tk.BorderSizePixel=0;tk.Parent=c;Corner(tk,8)
	local kn=Instance.new("Frame");kn.Size=UDim2.fromOffset(12,12);kn.Position=UDim2.fromOffset(2,2);kn.BackgroundColor3=T.TextDim;kn.BorderSizePixel=0;kn.Parent=tk;Corner(kn,6)
	local function upd(v) if v then Tw(kn,{Position=UDim2.fromOffset(20,2),BackgroundColor3=Color3.new(1,1,1)},"Fast");Tw(tk,{BackgroundColor3=T.Accent},"Fast") else Tw(kn,{Position=UDim2.fromOffset(2,2),BackgroundColor3=T.TextDim},"Fast");Tw(tk,{BackgroundColor3=Color3.fromRGB(50,50,60)},"Fast")end end
	st:Sub(o.Flag,function(v) upd(v);if o.Callback then o.Callback(v)end end)
	c.MouseButton1Click:Connect(function()st:Set(o.Flag,not st:Get(o.Flag,false))end)
	c.MouseEnter:Connect(function()Tw(c,{BackgroundColor3=T.SurfHov},"Fast")end)
	c.MouseLeave:Connect(function()Tw(c,{BackgroundColor3=T.Surface},"Fast")end)
	st:Set(o.Flag,o.Default==true)
end

local function CSlider(tab,o)
	local st=tab._lib._state
	local c=Instance.new("Frame");c.Size=UDim2.new(1,0,0,48);c.BackgroundColor3=T.Surface;c.BorderSizePixel=0;c.Parent=tab._ct;Corner(c,6);Stroke(c,T.Border,1,0.75)
	local lb=Instance.new("TextLabel");lb.Size=UDim2.new(1,-60,0,20);lb.Position=UDim2.fromOffset(12,4);lb.BackgroundTransparency=1;lb.Text=o.Name;lb.TextColor3=T.Text;lb.Font=T.Font;lb.TextSize=13;lb.TextXAlignment=Enum.TextXAlignment.Left;lb.Parent=c
	local vl=Instance.new("TextLabel");vl.Size=UDim2.fromOffset(45,20);vl.Position=UDim2.new(1,-55,0,4);vl.BackgroundTransparency=1;vl.Text=tostring(o.Default or o.Min);vl.TextColor3=T.Accent;vl.Font=T.FontB;vl.TextSize=12;vl.TextXAlignment=Enum.TextXAlignment.Right;vl.Parent=c
	local tbg=Instance.new("Frame");tbg.Size=UDim2.new(1,-24,0,4);tbg.Position=UDim2.fromOffset(12,32);tbg.BackgroundColor3=T.BgAlt;tbg.BorderSizePixel=0;tbg.Parent=c;Corner(tbg,2)
	local fl=Instance.new("Frame");fl.Size=UDim2.fromScale(0,1);fl.BackgroundColor3=T.Accent;fl.BorderSizePixel=0;fl.Parent=tbg;Corner(fl,2)
	local kc=Instance.new("Frame");kc.Size=UDim2.fromOffset(10,10);kc.Position=UDim2.new(1,-5,0.5,0);kc.AnchorPoint=Vector2.new(0,0.5);kc.BackgroundColor3=T.Text;kc.BorderSizePixel=0;kc.Parent=fl;Corner(kc,5)
	local dg=false;local mn,mx=o.Min,o.Max
	local function upd(p) p=math.clamp(p,0,1);local v=math.floor(mn+(mx-mn)*p+0.5);fl.Size=UDim2.fromScale(p,1);vl.Text=tostring(v);st:Set(o.Flag,v);if o.Callback then o.Callback(v)end end
	tbg.InputBegan:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dg=true;upd((i.Position.X-tbg.AbsolutePosition.X)/tbg.AbsoluteSize.X)end end)
	UIS.InputChanged:Connect(function(i)if dg and(i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch)then upd((i.Position.X-tbg.AbsolutePosition.X)/tbg.AbsoluteSize.X)end end)
	UIS.InputEnded:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dg=false end end)
	local def=o.Default or mn;fl.Size=UDim2.fromScale((def-mn)/(mx-mn),1);vl.Text=tostring(def);st:Set(o.Flag,def)
end

local function CDropdown(tab,o)
	local st=tab._lib._state;local op=false
	local c=Instance.new("Frame");c.Size=UDim2.new(1,0,0,34);c.BackgroundColor3=T.Surface;c.BorderSizePixel=0;c.ClipsDescendants=true;c.Parent=tab._ct;Corner(c,6);Stroke(c,T.Border,1,0.75)
	local hd=Instance.new("TextButton");hd.Size=UDim2.new(1,0,0,34);hd.BackgroundTransparency=1;hd.Text="";hd.Parent=c
	local lb=Instance.new("TextLabel");lb.Size=UDim2.new(1,-80,1,0);lb.Position=UDim2.fromOffset(12,0);lb.BackgroundTransparency=1;lb.Text=o.Name;lb.TextColor3=T.Text;lb.Font=T.Font;lb.TextSize=13;lb.TextXAlignment=Enum.TextXAlignment.Left;lb.Parent=hd
	local ar=Instance.new("TextLabel");ar.Size=UDim2.fromOffset(12,34);ar.Position=UDim2.new(1,-18,0,0);ar.BackgroundTransparency=1;ar.Text="▾";ar.TextColor3=T.TextMut;ar.Font=T.Font;ar.TextSize=10;ar.Parent=hd
	local sl=Instance.new("TextLabel");sl.Size=UDim2.fromOffset(55,18);sl.Position=UDim2.new(1,-72,0.5,0);sl.AnchorPoint=Vector2.new(0,0.5);sl.BackgroundTransparency=1;sl.Text=o.Default or"...";sl.TextColor3=T.Accent;sl.Font=T.Font;sl.TextSize=11;sl.TextXAlignment=Enum.TextXAlignment.Right;sl.Parent=hd
	local lf=Instance.new("Frame");lf.Size=UDim2.new(1,-10,0,0);lf.Position=UDim2.fromOffset(5,36);lf.BackgroundTransparency=1;lf.Parent=c
	local ll=Instance.new("UIListLayout");ll.Padding=UDim.new(0,2);ll.Parent=lf
	for _,item in ipairs(o.List or{})do
		local b=Instance.new("TextButton");b.Size=UDim2.new(1,0,0,26);b.BackgroundColor3=T.BgAlt;b.BorderSizePixel=0;b.Text=item;b.TextColor3=T.TextDim;b.Font=T.Font;b.TextSize=11;b.AutoButtonColor=false;b.Parent=lf;Corner(b,4)
		b.MouseEnter:Connect(function()Tw(b,{BackgroundColor3=T.SurfHov,TextColor3=T.Text},"Fast")end)
		b.MouseLeave:Connect(function()Tw(b,{BackgroundColor3=T.BgAlt,TextColor3=T.TextDim},"Fast")end)
		b.MouseButton1Click:Connect(function()sl.Text=item;st:Set(o.Flag,item);if o.Callback then o.Callback(item)end;op=false;Tw(c,{Size=UDim2.new(1,0,0,34)},"Fast");ar.Text="▾"end)
	end
	hd.MouseButton1Click:Connect(function()op=not op;ar.Text=op and"▴"or"▾";Tw(c,{Size=UDim2.new(1,0,0,op and(36+#(o.List or{})*28+4)or 34)},"Fast")end)
	if o.Default then st:Set(o.Flag,o.Default)end
end

local function CTextBox(tab,o)
	local st=tab._lib._state
	local c=Instance.new("Frame");c.Size=UDim2.new(1,0,0,56);c.BackgroundColor3=T.Surface;c.BorderSizePixel=0;c.Parent=tab._ct;Corner(c,6);Stroke(c,T.Border,1,0.75)
	local lb=Instance.new("TextLabel");lb.Size=UDim2.new(1,-16,0,16);lb.Position=UDim2.fromOffset(12,5);lb.BackgroundTransparency=1;lb.Text=o.Name;lb.TextColor3=T.Text;lb.Font=T.Font;lb.TextSize=12;lb.TextXAlignment=Enum.TextXAlignment.Left;lb.Parent=c
	local bx=Instance.new("TextBox");bx.Size=UDim2.new(1,-22,0,24);bx.Position=UDim2.fromOffset(11,25);bx.BackgroundColor3=T.BgAlt;bx.BorderSizePixel=0;bx.Text=o.Default or"";bx.PlaceholderText=o.Placeholder or"...";bx.PlaceholderColor3=T.TextMut;bx.TextColor3=T.Text;bx.Font=T.Font;bx.TextSize=12;bx.ClearTextOnFocus=false;bx.Parent=c;Corner(bx,4)
	bx.FocusLost:Connect(function()st:Set(o.Flag,bx.Text);if o.Callback then o.Callback(bx.Text)end end);st:Set(o.Flag,o.Default or"")
end

local function CKeybind(tab,o)
	local st=tab._lib._state;local bd=false
	local c=Instance.new("TextButton");c.Size=UDim2.new(1,0,0,34);c.BackgroundColor3=T.Surface;c.BorderSizePixel=0;c.Text="";c.AutoButtonColor=false;c.Parent=tab._ct;Corner(c,6);Stroke(c,T.Border,1,0.75)
	local lb=Instance.new("TextLabel");lb.Size=UDim2.new(1,-76,1,0);lb.Position=UDim2.fromOffset(12,0);lb.BackgroundTransparency=1;lb.Text=o.Name;lb.TextColor3=T.Text;lb.Font=T.Font;lb.TextSize=13;lb.TextXAlignment=Enum.TextXAlignment.Left;lb.Parent=c
	local bg=Instance.new("TextLabel");bg.Size=UDim2.fromOffset(56,20);bg.Position=UDim2.new(1,-66,0.5,0);bg.AnchorPoint=Vector2.new(0,0.5);bg.BackgroundColor3=T.BgAlt;bg.TextColor3=T.Accent;bg.Font=T.FontB;bg.TextSize=10;bg.Parent=c;Corner(bg,4)
	st:Sub(o.Flag,function(k)bg.Text=k.Name end)
	c.MouseButton1Click:Connect(function()bd=true;bg.Text="..."end)
	c.MouseEnter:Connect(function()Tw(c,{BackgroundColor3=T.SurfHov},"Fast")end)
	c.MouseLeave:Connect(function()Tw(c,{BackgroundColor3=T.Surface},"Fast")end)
	UIS.InputBegan:Connect(function(i)if bd and i.UserInputType==Enum.UserInputType.Keyboard then bd=false;st:Set(o.Flag,i.KeyCode);if o.Callback then o.Callback(i.KeyCode)end end end)
	st:Set(o.Flag,o.Default or Enum.KeyCode.RightControl)
end

local function CLabel(tab,txt)
	local l=Instance.new("TextLabel");l.Size=UDim2.new(1,0,0,18);l.BackgroundTransparency=1;l.Text=txt;l.TextColor3=T.TextDim;l.Font=T.Font;l.TextSize=11;l.TextXAlignment=Enum.TextXAlignment.Left;l.Parent=tab._ct
end

-- Tab
local Tab={};Tab.__index=Tab
function Tab.new(w,name)
	local self=setmetatable({_w=w,_lib=w._lib,_name=name},Tab);self:_build();return self
end
function Tab:_build()
	local tb=Instance.new("TextButton");tb.Size=UDim2.new(1,0,0,32);tb.BackgroundTransparency=1;tb.BorderSizePixel=0;tb.Text=self._name;tb.TextColor3=T.TextDim;tb.Font=T.Font;tb.TextSize=12;tb.AutoButtonColor=false;tb.Parent=self._w._tl;Corner(tb,5)
	self._tb=tb
	local ct=Instance.new("ScrollingFrame");ct.Size=UDim2.fromScale(1,1);ct.BackgroundTransparency=1;ct.BorderSizePixel=0;ct.ScrollBarThickness=2;ct.ScrollBarImageColor3=T.Accent;ct.CanvasSize=UDim2.fromScale(0,0);ct.AutomaticCanvasSize=Enum.AutomaticSize.Y;ct.Visible=false;ct.Parent=self._w._cf
	local l=Instance.new("UIListLayout");l.Padding=UDim.new(0,4);l.Parent=ct;Pad(ct,6,6,8,8)
	self._ct=ct
	tb.MouseButton1Click:Connect(function()self._w:SelectTab(self)end)
	tb.MouseEnter:Connect(function()if self._w._sel~=self then Tw(tb,{BackgroundTransparency=0.85,BackgroundColor3=T.SurfHov},"Fast")end end)
	tb.MouseLeave:Connect(function()if self._w._sel~=self then Tw(tb,{BackgroundTransparency=1},"Fast")end end)
end
function Tab:Show() self._ct.Visible=true;Tw(self._tb,{TextColor3=T.Accent,BackgroundTransparency=0.8,BackgroundColor3=T.SurfHov},"Fast")end
function Tab:Hide() self._ct.Visible=false;Tw(self._tb,{TextColor3=T.TextDim,BackgroundTransparency=1},"Fast")end
function Tab:CreateSection(n) CSection(self,n) end
function Tab:CreateButton(o) CButton(self,o) end
function Tab:CreateToggle(o) CToggle(self,o) end
function Tab:CreateSlider(o) CSlider(self,o) end
function Tab:CreateDropdown(o) CDropdown(self,o) end
function Tab:CreateTextBox(o) CTextBox(self,o) end
function Tab:CreateKeybind(o) CKeybind(self,o) end
function Tab:CreateLabel(t) CLabel(self,t) end

-- Footer
local function MakeFooter(mainF)
	local ft=Instance.new("Frame");ft.Size=UDim2.new(1,0,0,30);ft.Position=UDim2.new(0,0,1,2);ft.BackgroundColor3=T.Surface;ft.BackgroundTransparency=0.1;ft.BorderSizePixel=0;ft.Parent=mainF;Corner(ft,8);Stroke(ft,T.Border,1,0.8)

	local av=Instance.new("ImageLabel");av.Size=UDim2.fromOffset(20,20);av.Position=UDim2.fromOffset(6,5);av.BackgroundColor3=T.BgAlt;av.BorderSizePixel=0;av.Parent=ft;Corner(av,10)
	pcall(function()av.Image=Players:GetUserThumbnailAsync(P.UserId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size48x48)end)

	local un=Instance.new("TextLabel");un.Size=UDim2.fromOffset(100,20);un.Position=UDim2.fromOffset(30,5);un.BackgroundTransparency=1;un.Text="@"..P.Name;un.TextColor3=T.TextDim;un.Font=T.Font;un.TextSize=10;un.TextXAlignment=Enum.TextXAlignment.Left;un.Parent=ft

	local s1=Instance.new("TextLabel");s1.Size=UDim2.fromOffset(8,20);s1.Position=UDim2.fromOffset(130,5);s1.BackgroundTransparency=1;s1.Text="│";s1.TextColor3=T.Border;s1.Font=T.FontL;s1.TextSize=11;s1.Parent=ft

	local fps=Instance.new("TextLabel");fps.Size=UDim2.fromOffset(55,20);fps.Position=UDim2.fromOffset(142,5);fps.BackgroundTransparency=1;fps.Text="FPS: --";fps.TextColor3=T.Succ;fps.Font=T.Font;fps.TextSize=9;fps.TextXAlignment=Enum.TextXAlignment.Left;fps.Parent=ft

	local s2=Instance.new("TextLabel");s2.Size=UDim2.fromOffset(8,20);s2.Position=UDim2.fromOffset(197,5);s2.BackgroundTransparency=1;s2.Text="│";s2.TextColor3=T.Border;s2.Font=T.FontL;s2.TextSize=11;s2.Parent=ft

	local pg=Instance.new("TextLabel");pg.Size=UDim2.fromOffset(70,20);pg.Position=UDim2.fromOffset(208,5);pg.BackgroundTransparency=1;pg.Text="PING: --";pg.TextColor3=T.Warn;pg.Font=T.Font;pg.TextSize=9;pg.TextXAlignment=Enum.TextXAlignment.Left;pg.Parent=ft

	local s3=Instance.new("TextLabel");s3.Size=UDim2.fromOffset(8,20);s3.Position=UDim2.fromOffset(278,5);s3.BackgroundTransparency=1;s3.Text="│";s3.TextColor3=T.Border;s3.Font=T.FontL;s3.TextSize=11;s3.Parent=ft

	local gn=Instance.new("TextLabel");gn.Size=UDim2.fromOffset(100,20);gn.Position=UDim2.fromOffset(290,5);gn.BackgroundTransparency=1;gn.Text="";gn.TextColor3=T.TextMut;gn.Font=T.Font;gn.TextSize=9;gn.TextXAlignment=Enum.TextXAlignment.Left;gn.Parent=ft
	pcall(function()gn.Text=game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name end)

	local fc,lt=0,tick()
	RS.Heartbeat:Connect(function()fc=fc+1;local now=tick();if now-lt>=0.5 then fps.Text="FPS: "..math.floor(fc/(now-lt));fc=0;lt=now;pcall(function()pg.Text="PING: "..math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()).."ms"end)end end)
end

-- Window
local Win={};Win.__index=Win
function Win.new(lib,o)
	local self=setmetatable({_lib=lib,_o=o,_tabs={},_sel=nil,_min=false},Win);self:_build();return self
end

function Win:_build()
	local gui=MakeGUI("BBWindow",50);self._gui=gui
	local sz=self._o.Size or UDim2.fromOffset(560,370)

	-- Minimize bar (hidden initially)
	local mbar=Instance.new("Frame");mbar.Size=UDim2.fromOffset(200,30);mbar.Position=UDim2.new(0.5,0,0,6);mbar.AnchorPoint=Vector2.new(0.5,0)
	mbar.BackgroundColor3=T.Surface;mbar.BackgroundTransparency=0.05;mbar.BorderSizePixel=0;mbar.Visible=false;mbar.Parent=gui;Corner(mbar,8);Stroke(mbar,T.Border,1,0.5)
	self._mbar=mbar

	-- Mini bar logo
	local mLogo=Instance.new("ImageLabel");mLogo.Size=UDim2.fromOffset(20,20);mLogo.Position=UDim2.fromOffset(6,5);mLogo.BackgroundColor3=T.Accent;mLogo.BackgroundTransparency=0.85;mLogo.BorderSizePixel=0;mLogo.Parent=mbar;Corner(mLogo,5)
	mLogo.Image=self._o.Logo or""

	-- Mini bar name
	local mName=Instance.new("TextButton");mName.Size=UDim2.fromOffset(100,30);mName.Position=UDim2.fromOffset(30,0);mName.BackgroundTransparency=1;mName.Text="BloxBox UI";mName.TextColor3=T.Text;mName.Font=T.FontB;mName.TextSize=12;mName.TextXAlignment=Enum.TextXAlignment.Left;mName.AutoButtonColor=false;mName.Parent=mbar

	-- Mini bar separator
	local mSep=Instance.new("TextLabel");mSep.Size=UDim2.fromOffset(10,30);mSep.Position=UDim2.fromOffset(128,0);mSep.BackgroundTransparency=1;mSep.Text="│";mSep.TextColor3=T.Border;mSep.Font=T.FontL;mSep.TextSize=12;mSep.Parent=mbar

	-- Mini bar drag icon (✥ cross arrows)
	local mDrag=Instance.new("TextLabel");mDrag.Size=UDim2.fromOffset(20,30);mDrag.Position=UDim2.fromOffset(142,0);mDrag.BackgroundTransparency=1;mDrag.Text="✥";mDrag.TextColor3=T.TextDim;mDrag.Font=T.FontB;mDrag.TextSize=14;mDrag.Parent=mbar
	MakeDrag(mDrag,mbar)

	-- Click logo/name to restore
	mName.MouseButton1Click:Connect(function() self:Restore() end)
	mLogo.InputBegan:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseButton1 then self:Restore()end end)

	-- Main frame
	local main=Instance.new("Frame");main.Name="Main";main.Size=sz;main.Position=self._o.Position or UDim2.fromScale(0.5,0.5);main.AnchorPoint=Vector2.new(0.5,0.5)
	main.BackgroundColor3=T.Bg;main.BorderSizePixel=0;main.Parent=gui;Corner(main,10);Stroke(main,T.Border,1.2,0.45)
	self._mf=main

	-- Shadow/glow behind window
	local shadow=Instance.new("ImageLabel");shadow.Size=UDim2.new(1,30,1,30);shadow.Position=UDim2.fromScale(0.5,0.5);shadow.AnchorPoint=Vector2.new(0.5,0.5)
	shadow.BackgroundTransparency=1;shadow.Image="rbxassetid://5028857084";shadow.ImageColor3=Color3.new(0,0,0);shadow.ImageTransparency=0.7;shadow.ZIndex=0;shadow.Parent=main
	self._shadow=shadow

	-- Header
	local hd=Instance.new("Frame");hd.Size=UDim2.new(1,0,0,36);hd.BackgroundColor3=T.BgAlt;hd.BorderSizePixel=0;hd.Parent=main;Corner(hd,10)
	local hfix=Instance.new("Frame");hfix.Size=UDim2.new(1,0,0,10);hfix.Position=UDim2.new(0,0,1,-10);hfix.BackgroundColor3=T.BgAlt;hfix.BorderSizePixel=0;hfix.Parent=hd

	-- Title dot
	local dot=Instance.new("Frame");dot.Size=UDim2.fromOffset(7,7);dot.Position=UDim2.fromOffset(12,14);dot.BackgroundColor3=T.Accent;dot.BorderSizePixel=0;dot.Parent=hd;Corner(dot,4)

	local ttl=Instance.new("TextLabel");ttl.Size=UDim2.new(1,-100,1,0);ttl.Position=UDim2.fromOffset(24,0);ttl.BackgroundTransparency=1;ttl.Text=self._o.Title or"BloxBox";ttl.TextColor3=T.Text;ttl.Font=T.FontB;ttl.TextSize=14;ttl.TextXAlignment=Enum.TextXAlignment.Left;ttl.Parent=hd
	self._ttl=ttl

	-- Close (circle style)
	local cls=Instance.new("TextButton");cls.Size=UDim2.fromOffset(22,22);cls.Position=UDim2.new(1,-30,0.5,0);cls.AnchorPoint=Vector2.new(0,0.5)
	cls.BackgroundColor3=T.Err;cls.BackgroundTransparency=0.8;cls.Text="✕";cls.TextColor3=T.TextMut;cls.Font=T.FontB;cls.TextSize=10;cls.BorderSizePixel=0;cls.AutoButtonColor=false;cls.Parent=hd;Corner(cls,11)
	cls.MouseEnter:Connect(function()Tw(cls,{BackgroundTransparency=0.2,TextColor3=T.Text},"Fast")end)
	cls.MouseLeave:Connect(function()Tw(cls,{BackgroundTransparency=0.8,TextColor3=T.TextMut},"Fast")end)
	cls.MouseButton1Click:Connect(function()self:Destroy()end)

	-- Minimize (circle style)
	local mn=Instance.new("TextButton");mn.Size=UDim2.fromOffset(22,22);mn.Position=UDim2.new(1,-56,0.5,0);mn.AnchorPoint=Vector2.new(0,0.5)
	mn.BackgroundColor3=T.Warn;mn.BackgroundTransparency=0.8;mn.Text="—";mn.TextColor3=T.TextMut;mn.Font=T.FontB;mn.TextSize=10;mn.BorderSizePixel=0;mn.AutoButtonColor=false;mn.Parent=hd;Corner(mn,11)
	mn.MouseEnter:Connect(function()Tw(mn,{BackgroundTransparency=0.2,TextColor3=T.Text},"Fast")end)
	mn.MouseLeave:Connect(function()Tw(mn,{BackgroundTransparency=0.8,TextColor3=T.TextMut},"Fast")end)
	mn.MouseButton1Click:Connect(function()self:Minimize()end)

	-- Sidebar
	local sb=Instance.new("Frame");sb.Size=UDim2.new(0,120,1,-36);sb.Position=UDim2.fromOffset(0,36);sb.BackgroundColor3=T.BgAlt;sb.BackgroundTransparency=0.35;sb.BorderSizePixel=0;sb.Parent=main
	local sl=Instance.new("UIListLayout");sl.Padding=UDim.new(0,2);sl.Parent=sb;Pad(sb,6,6,4,4)
	self._tl=sb

	local sep=Instance.new("Frame");sep.Size=UDim2.new(0,1,1,-36);sep.Position=UDim2.fromOffset(120,36);sep.BackgroundColor3=T.Border;sep.BackgroundTransparency=0.4;sep.BorderSizePixel=0;sep.Parent=main

	local cf=Instance.new("Frame");cf.Size=UDim2.new(1,-121,1,-36);cf.Position=UDim2.fromOffset(121,36);cf.BackgroundTransparency=1;cf.BorderSizePixel=0;cf.Parent=main
	self._cf=cf

	MakeFooter(main)
	MakeDrag(hd,main)

	-- Entrance
	main.BackgroundTransparency=1;main.Size=UDim2.fromOffset(sz.X.Offset-20,sz.Y.Offset-15);ttl.TextTransparency=1
	Tw(main,{BackgroundTransparency=0,Size=sz},"Bounce");Tw(ttl,{TextTransparency=0},"Slow")
end

function Win:Minimize()
	self._min=true;self._mbar.Visible=true
	Tw(self._mf,{BackgroundTransparency=1,Size=UDim2.fromOffset(self._mf.Size.X.Offset-20,self._mf.Size.Y.Offset-10)},"Normal")
	task.wait(0.3);self._mf.Visible=false
end

function Win:Restore()
	self._min=false;self._mf.Visible=true
	local sz=self._o.Size or UDim2.fromOffset(560,370)
	self._mf.Size=UDim2.fromOffset(sz.X.Offset-20,sz.Y.Offset-15)
	Tw(self._mf,{BackgroundTransparency=0,Size=sz},"Bounce")
	Tw(self._mbar,{BackgroundTransparency=1},"Fast")
	task.wait(0.2);self._mbar.Visible=false;self._mbar.BackgroundTransparency=0.05
end

function Win:CreateTab(name) local tab=Tab.new(self,name);table.insert(self._tabs,tab);if #self._tabs==1 then self:SelectTab(tab)end;return tab end
function Win:SelectTab(tab) for _,t in ipairs(self._tabs)do t:Hide()end;tab:Show();self._sel=tab end
function Win:Destroy() if self._gui then Tw(self._mf,{BackgroundTransparency=1},"Normal");task.wait(0.3);self._gui:Destroy()end end

-- API
local BB={};BB.__index=BB
function BB.new() return setmetatable({_theme=T,_state=SM.new()},BB) end
function BB:SetAccent(c) T.Accent=c;T.AccDark=Color3.new(c.R*0.7,c.G*0.7,c.B*0.7) end
function BB:ShowIntro(logo,cb) ShowIntro(logo,cb) end
function BB:CreateWindow(o) return Win.new(self,o) end
function BB:Notify(o) Notif(o) end
function BB:SaveConfig(n) SaveCfg(self._state,n) end
function BB:LoadConfig(n) LoadCfg(self._state,n) end

print("[BloxBox UI] v2.1 Premium loaded")
return BB
