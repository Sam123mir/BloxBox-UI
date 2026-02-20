-- BloxBox UI: Signal (Executor Compatible)
local Signal = {}
Signal.__index = Signal

function Signal.new()
	return setmetatable({
		_connections = {},
	}, Signal)
end

function Signal:Connect(handler)
	local connection = {
		_signal = self,
		_handler = handler,
	}
	connection.Disconnect = function(conn)
		for i, c in ipairs(self._connections) do
			if c == conn then
				table.remove(self._connections, i)
				break
			end
		end
	end
	table.insert(self._connections, connection)
	return connection
end

function Signal:Fire(...)
	for _, connection in ipairs(self._connections) do
		task.spawn(connection._handler, ...)
	end
end

function Signal:Wait()
	local thread = coroutine.running()
	local connection
	connection = self:Connect(function(...)
		connection:Disconnect()
		task.spawn(thread, ...)
	end)
	return coroutine.yield()
end

function Signal:Destroy()
	for _, conn in ipairs(self._connections) do
		conn:Disconnect()
	end
	self._connections = {}
end

return Signal
