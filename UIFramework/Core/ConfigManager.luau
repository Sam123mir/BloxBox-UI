-- BloxBox UI: ConfigManager (Executor Compatible)
local HttpService = game:GetService("HttpService")

local ConfigManager = {}
ConfigManager.__index = ConfigManager

function ConfigManager.new(stateManager)
	return setmetatable({
		_state = stateManager,
		_folder = "SaaS_UI_Configs"
	}, ConfigManager)
end

function ConfigManager:Save(name)
	local data = HttpService:JSONEncode(self._state._states)
	local success, err = pcall(function()
		if writefile then
			if not isfolder(self._folder) then 
				makefolder(self._folder) 
			end
			writefile(self._folder .. "/" .. name .. ".json", data)
		end
	end)
	return success, err
end

function ConfigManager:Load(name)
	local success, result = pcall(function()
		if readfile and isfile and isfile(self._folder .. "/" .. name .. ".json") then
			local data = readfile(self._folder .. "/" .. name .. ".json")
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
