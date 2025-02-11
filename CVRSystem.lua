local CVRSystem = {}

local createdCVR = {}


function CVRSystem.CreateNewCVR(id, CVRModel, distanceToCapture)
	local newCVR = {
		Id = id,
		messageLog = {},
		CVRModel = CVRModel,
		distanceToCapture = distanceToCapture,
		isRecording = false,
		health = 100,
		battery = 100
	}

	newCVR["AddMessage"] = function(sender, msg)
		if string.lower(sender) == 'system' then
			table.insert(newCVR.messageLog, "["..sender.."] "..msg)
		else
			local corruptedMessage = ""

			for i = 1, #msg do
				local char = msg:sub(i, i)
				if math.random(100) <= newCVR.health then
					corruptedMessage = corruptedMessage .. char
				else
					corruptedMessage = corruptedMessage .. "-"
				end
			end

			table.insert(newCVR.messageLog, "["..sender.."] "..corruptedMessage)
		end
	end

	newCVR["AdjustHealth"] = function(amount)
		newCVR.health = math.clamp(newCVR.health + amount, 0, 100)

		if newCVR.health <= 75 then
			newCVR.AddMessage('SYSTEM', 'Warning: CVR Minor Damage, Corruption may occur.')
		elseif newCVR.health <= 50 then
			newCVR.AddMessage('SYSTEM', 'Warning: CVR Severe Damage, Corruption will occur.')
		elseif newCVR.health <= 35 then
			newCVR.AddMessage('SYSTEM', 'Warning: CVR Extreme Damage, Corruption will occur.')
		end
	end

	newCVR["StartRecording"] = function()
		task.spawn(function()
			newCVR.AddMessage("SYSTEM", "CVR Start Tape")
			newCVR.isRecording = true
		end)
	end

	newCVR["StopRecording"] = function(customMessage)
		task.spawn(function()
			if customMessage then
				newCVR.AddMessage("SYSTEM", customMessage)
			else
				newCVR.AddMessage("SYSTEM", "CVR End Tape")
			end
			newCVR.isRecording = false
		end)
	end

	table.insert(createdCVR, newCVR)

	return newCVR
end

function CVRSystem.GetCreatedCVR(id)
	for i, v in pairs(createdCVR) do
		if v.Id == id then
			return v
		end
	end
end


function checkAndSendMessage(player, message)
	for _, cvr in pairs(createdCVR) do
		task.spawn(function()
			print(cvr)
			if cvr.isRecording == false then return end
			local char = player.Character or player.CharacterAdded:Wait()
			local distance = (cvr.CVRModel.PrimaryPart.Position - char.PrimaryPart.Position).Magnitude

			local unidentifiableDistance = cvr.distanceToCapture / 2


			if distance <= cvr.distanceToCapture then
				if distance >= unidentifiableDistance then
					cvr.AddMessage("Unknown", message, cvr.Id)
				else
					cvr.AddMessage(player.Name, message, cvr.Id)
				end
			end
		end)
	end
end

game.Players.PlayerAdded:Connect(function(player: Player)
	task.spawn(function()
		local character = player.Character or player.CharacterAdded:Wait()
		player.Chatted:Connect(function(message: string)
			checkAndSendMessage(player, message)
		end)

		character:FindFirstChildOfClass('Humanoid').Died:Connect(function()
			if math.random(1, 2) == math.random(1, 2) then
				checkAndSendMessage(player, '(Screaming)')
			end
		end)
	end)
end)

return CVRSystem