-- BloxBox UI: Maid (Executor Compatible)
local Maid = {}
Maid.__index = Maid

function Maid.new()
	return setmetatable({
		_tasks = {}
	}, Maid)
end

function Maid:GiveTask(task)
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
		elseif typeof(task) == "table" and task.Destroy then
			task:Destroy()
		elseif typeof(task) == "table" and task.Disconnect then
			task:Disconnect()
		elseif typeof(task) == "Instance" then
			task:Destroy()
		end
	end
	self._tasks = {}
end

function Maid:Destroy()
	self:DoCleaning()
end

return Maid
