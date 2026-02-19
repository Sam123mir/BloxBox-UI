--!strict
local HttpService = game:GetService("HttpService")

local ConfigManager = {}
ConfigManager.__index = ConfigManager

function ConfigManager.new(stateManager: any)
	return setmetatable({
		_state = stateManager,
		_folder = "SaaS_UI_Configs"
	}, ConfigManager)
end

function ConfigManager:Save(name: string)
	local data = HttpService:JSONEncode(self._state._states)
	local success, err = pcall(function()
		if (writefile :: any) then
			if not (isfolder :: any)(self._folder) then 
				(makefolder :: any)(self._folder) 
			end
			(writefile :: any)(self._folder .. "/" .. name .. ".json", data)
		end
	end)
	return success, err
end

function ConfigManager:Load(name: string)
	local success, result = pcall(function()
		if (readfile :: any) and (isfile :: any)(self._folder .. "/" .. name .. ".json") then
			local data = (readfile :: any)(self._folder .. "/" .. name .. ".json")
			local decoded = HttpService:JSONDecode(data)
			
			if decoded and typeof(decoded) == "table" then
				for flag, value in pairs(decoded) do
					self._state:Set(flag, value)
				end
				return true
			end
		end
		return false
	end)
	return success and result
end

return ConfigManager
