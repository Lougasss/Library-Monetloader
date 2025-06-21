-- playerrecorder.lua - Monetloader library for auto recording player names by ID

local playerrecorder = {}

-- Internal storage table: playerID -> playerName
local playerNames = {}

-- Record or update a player's name by ID
function playerrecorder.recordPlayerName(playerId, playerName)
    if type(playerId) ~= "number" then
        error("recordPlayerName: playerId must be a number")
    end
    if type(playerName) ~= "string" or playerName == "" then
        error("recordPlayerName: playerName must be a non-empty string")
    end

    if playerNames[playerId] ~= playerName then
        playerNames[playerId] = playerName
        playerrecorder.log(string.format("Recorded playerId %d with name '%s'", playerId, playerName))
    end
end

-- Get the recorded player name by ID, returns nil if not found
function playerrecorder.getPlayerName(playerId)
    return playerNames[playerId]
end

-- Get the entire player names table (copy) for iteration or debugging
function playerrecorder.getAllPlayers()
    local copy = {}
    for id, name in pairs(playerNames) do
        copy[id] = name
    end
    return copy
end

-- Clear recorded data (optional utility)
function playerrecorder.clearAll()
    playerNames = {}
    playerrecorder.log("Cleared all recorded player data")
end

-- Simple logging helper for console output
function playerrecorder.log(msg)
    -- Monetloader environment usually supports print
    -- Can be enhanced with timestamp or formatted output as needed
    print("[PlayerRecorder] " .. tostring(msg))
end

return playerrecorder
