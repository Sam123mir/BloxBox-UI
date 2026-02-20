-- BloxBox UI: WindowManager (Executor Compatible)
local HttpService = game:GetService("HttpService")

local WindowManager = {
	_windows = {},
	_stack = {},
	_baseDisplayOrder = 10,
}

function WindowManager:Register(window)
	local id = HttpService:GenerateGUID(false)
	self._windows[id] = window
	table.insert(self._stack, id)
	self:SetFocus(id)
	return id
end

function WindowManager:SetFocus(id)
	local index = table.find(self._stack, id)
	if index then
		table.remove(self._stack, index)
		table.insert(self._stack, id)
	end
	self:_updateDisplayOrders()
end

function WindowManager:_updateDisplayOrders()
	for i, id in ipairs(self._stack) do
		local window = self._windows[id]
		if window and window.Instance then
			window.Instance.DisplayOrder = self._baseDisplayOrder + i
		end
	end
end

function WindowManager:Unregister(id)
	self._windows[id] = nil
	local index = table.find(self._stack, id)
	if index then table.remove(self._stack, index) end
	self:_updateDisplayOrders()
end

return WindowManager
