-- BloxBox UI: ComponentRegistry (Executor Compatible)
local HttpService = game:GetService("HttpService")

local ComponentRegistry = {
	_components = {},
}

function ComponentRegistry:Register(component)
	local id = HttpService:GenerateGUID(false)
	self._components[id] = component
	return id
end

function ComponentRegistry:Unregister(id)
	self._components[id] = nil
end

function ComponentRegistry:GetCount()
	local count = 0
	for _ in pairs(self._components) do count = count + 1 end
	return count
end

return ComponentRegistry
