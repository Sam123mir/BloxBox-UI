-- [[ BLOXBOX UI: LOADER v1.02.0 ]]
-- Carga el framework completo desde GitHub con un solo loadstring()
-- No necesita ModuleScripts ni require() — compatible con TODOS los executors

local BloxBoxUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Sam123mir/BloxBox-UI/master/Source.lua" .. "?v=" .. os.time()))()

return BloxBoxUI
