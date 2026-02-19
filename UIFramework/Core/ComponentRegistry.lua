--!strict
local HttpService = game:GetService("HttpService")

local ComponentRegistry = {
	_components = {},
}

function ComponentRegistry:Register(component: any): string
	local id = HttpService:GenerateGUID(false)
	self._components[id] = component
	return id
end

function ComponentRegistry:Unregister(id: string)
	self._components[id] = nil
end

function ComponentRegistry:GetCount(): number
	local count = 0
	for _ in pairs(self._components) do count += 1 end
	return count
end

return ComponentRegistry
