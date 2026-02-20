--!strict
local Utils = script.Parent.Parent.Utils
local Maid = require(Utils.Maid)
local Core = script.Parent.Parent.Core
local ComponentRegistry = require(Core.ComponentRegistry)

local BaseComponent = {}
BaseComponent.__index = BaseComponent

function BaseComponent.new(library: any)
	local self = setmetatable({
		Library = library,
		Maid = Maid.new(),
		_id = nil,
	}, BaseComponent)
	
	self._id = ComponentRegistry:Register(self)
	return self
end

function BaseComponent:_init() end
function BaseComponent:_mount() end
function BaseComponent:_update() end

function BaseComponent:Destroy()
	if self._id then
		ComponentRegistry:Unregister(self._id)
	end
	self.Maid:Destroy()
end

return BaseComponent
