-- BloxBox UI: AnimationEngine (Executor Compatible)
local TweenService = game:GetService("TweenService")

local Presets = {
	Fast = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
	Normal = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
	Slow = TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
}

local AnimationEngine = {}

function AnimationEngine:Tween(instance, properties, presetOrInfo)
	local info
	if typeof(presetOrInfo) == "TweenInfo" then
		info = presetOrInfo
	else
		info = Presets[presetOrInfo or "Normal"]
	end
	local tween = TweenService:Create(instance, info, properties)
	tween:Play()
	return tween
end

return AnimationEngine
