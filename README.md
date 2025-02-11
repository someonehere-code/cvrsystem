Created by: `someonehere.`

## CVR System Documentation

### Overview:
The **CVR System** is a modular and interactive system designed to simulate the operation of a device (referred to as "CVR") that records and logs messages. The system tracks the CVR's health, status, and interactions with players within a game environment, with a particular focus on recording messages based on proximity to players and other in-game events such as the CVR falling or hitting the ground.

### Modules:

#### **Module: CVRSystem**
The **CVRSystem** module contains the core logic for creating and managing CVR devices. This module provides functions to initialize CVR devices, manage message logs, track health and battery, and control the recording state.

##### Functions:

1. **CVRSystem.CreateNewCVR(id, CVRModel, distanceToCapture)**
   - Creates a new CVR instance.
   - Parameters:
     - `id`: Unique identifier for the CVR.
     - `CVRModel`: The model that represents the CVR in the game world.
     - `distanceToCapture`: The distance within which the CVR will start recording messages from players.
   - Returns:
     - A new CVR object containing the following properties and methods:
       - `Id`: The unique ID of the CVR.
       - `messageLog`: A list of all recorded messages.
       - `CVRModel`: The model of the CVR.
       - `distanceToCapture`: The recording range of the CVR.
       - `isRecording`: A boolean indicating if the CVR is currently recording.
       - `health`: The health percentage of the CVR (between 0 and 100).
       - `battery`: The battery percentage of the CVR.
     - Methods available to the CVR object:
       - **AddMessage(sender, msg)**: Adds a message to the message log. If the sender is not "system", the message may be corrupted based on the CVR's health.
       - **AdjustHealth(amount)**: Adjusts the health of the CVR, with warnings sent when health drops below certain thresholds.
       - **StartRecording()**: Starts the recording of messages.
       - **StopRecording(customMessage)**: Stops the recording and optionally provides a custom message.
   
2. **CVRSystem.GetCreatedCVR(id)**
   - Retrieves a CVR instance by its unique ID.
   - Parameters:
     - `id`: The ID of the CVR to retrieve.
   - Returns:
     - The CVR object corresponding to the given ID.

3. **checkAndSendMessage(player, message)**
   - Checks if a player is within range of a CVR and sends a message to the CVR's log.
   - Parameters:
     - `player`: The player sending the message.
     - `message`: The message being sent.

#### **ServerScript**
The server-side script is responsible for creating a CVR instance, managing the CVR's state (e.g., recording, health, fall detection), and interacting with players.

##### Functions:

1. **MyCVR.StartRecording()**
   - Starts the recording process for the created CVR.
   
2. **RunService.Heartbeat**
   - A continuous check that monitors the CVR model's velocity. It detects if the CVR has fallen or hit the ground and adjusts its health accordingly, logging appropriate system messages.

3. **script.Parent.ClickDetector.MouseClick**
   - When a player clicks on the CVR, a UI is generated displaying the message log of the CVR.
   - The messages are displayed in a scrolling frame within the player's GUI.

### System Behavior:

- **Recording Messages**: Players can send messages to the CVR when within the distance specified (`distanceToCapture`). The messages are logged based on the player's proximity to the CVR, with more detailed logs when closer to the CVR.
  
- **Health and Corruption**: The CVR’s health affects the integrity of the messages. As the CVR's health deteriorates, the messages are more likely to become corrupted, represented by random characters being replaced with dashes.

- **Falling and Impact**: If the CVR falls or hits the ground, its health decreases and system messages are generated, simulating the impact.

### Example Usage:

```lua
local CVRSystem = require(game.ReplicatedStorage.CVRSystem)

local distanceToRecord = 50
local MyCVR = CVRSystem.CreateNewCVR(math.random(1, 10000), script.Parent, distanceToRecord)

MyCVR.StartRecording()

-- Handle player interactions
game.Players.PlayerAdded:Connect(function(player)
    player.Chatted:Connect(function(message)
        checkAndSendMessage(player, message)
    end)
end)
```
