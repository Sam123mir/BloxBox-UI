-- BloxBox UI: StateManager (Executor Compatible)
local Signal = require(script.Parent.Parent.Utils.Signal)

local StateManager = {}
StateManager.__index = StateManager

function StateManager.new(instanceId)
	return setmetatable({
		_id = instanceId,
		_states = {},
		_subscribers = {},
	}, StateManager)
end

function StateManager:Set(flag, value)
	if self._states[flag] == value then return end
	self._states[flag] = value
	
	if self._subscribers[flag] then
		self._subscribers[flag]:Fire(value)
	end
end

function StateManager:Get(flag, fallback)
	local val = self._states[flag]
	if val == nil then return fallback end
	return val
end

function StateManager:Subscribe(flag, handler)
	if not self._subscribers[flag] then
		self._subscribers[flag] = Signal.new()
	end
	return self._subscribers[flag]:Connect(handler)
end

return StateManager
