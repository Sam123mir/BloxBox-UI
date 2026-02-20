-- BloxBox UI: DragSystem (Executor Compatible)
local UserInputService = game:GetService("UserInputService")
local Maid = require(script.Parent.Maid)

local DragSystem = {}

function DragSystem.new(frame, parent)
	local dragging = false
	local dragInput, dragStart, startPos
	local maid = Maid.new()

	local function update(input)
		local delta = input.Position - dragStart
		parent.Position = UDim2.new(
			startPos.X.Scale, 
			startPos.X.Offset + delta.X, 
			startPos.Y.Scale, 
			startPos.Y.Offset + delta.Y
		)
	end

	maid:GiveTask(frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = parent.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end))

	maid:GiveTask(frame.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end))

	maid:GiveTask(UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			update(input)
		end
	end))

	return maid
end

return DragSystem
