local CVRSystem = require(game.ReplicatedStorage.CVRSystem)

local distanceToRecord = script.DistanceToRecord.Value
local MyCVR = CVRSystem.CreateNewCVR(math.random(1, 10000), script.Parent, distanceToRecord)

MyCVR.StartRecording()

local model = script.Parent
local runService = game:GetService("RunService")

local hasFallen = false
local hasHitGround = false
local previousVelocityY = 0

runService.Heartbeat:Connect(function()
	if model.PrimaryPart then
		local velocity = model.PrimaryPart.AssemblyLinearVelocity
		local velocityY = velocity.Y

		if velocityY < -5 and hasFallen == false then 
			hasFallen = true
			MyCVR.AddMessage('SYSTEM', 'Wind gushing sounds, similar to falling out the sky.')
			MyCVR.AdjustHealth(-math.random(1, 5))
		end

		local deceleration = previousVelocityY - velocityY
		
		if hasHitGround == false and deceleration > 15 then 
			hasHitGround = true
			MyCVR.AdjustHealth(-math.random(5, 15))
			MyCVR.AddMessage('SYSTEM', 'Loud noise similar to hitting the ground.')
			MyCVR.StopRecording()
		end

		previousVelocityY = velocityY
	end
end)

script.Parent.ClickDetector.MouseClick:Connect(function(player)
	local ui = script.ScreenGui:Clone()

	for _, message in ipairs(MyCVR.messageLog) do
		task.spawn(function()
			local text = script.Message:Clone()
			text.Parent = ui.Frame.ScrollingFrame
			text.Message.Text = message
		end)
	end

	ui.Name = tostring(MyCVR.Id)
	ui.Parent = player.PlayerGui
end)