--!strict
local Maid = {}
Maid.__index = Maid

export type Task = (() -> ()) | { Destroy: (any) -> () } | { disconnect: (any) -> () } | RBXScriptConnection

function Maid.new()
	return setmetatable({
		_tasks = {}
	}, Maid)
end

function Maid:GiveTask(task: Task): number
	local id = #self._tasks + 1
	self._tasks[id] = task
	return id
end

function Maid:DoCleaning()
	for _, task in ipairs(self._tasks) do
		if typeof(task) == "function" then
			task()
		elseif typeof(task) == "RBXScriptConnection" then
			task:Disconnect()
		elseif (task :: any).Destroy then
			(task :: any):Destroy()
		elseif (task :: any).Disconnect then
			(task :: any):Disconnect()
		elseif (task :: any).disconnect then
			(task :: any):disconnect()
		end
	end
	self._tasks = {}
end

function Maid:Destroy()
	self:DoCleaning()
end

return Maid
