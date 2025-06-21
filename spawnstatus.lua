-- spawnstatus.lua
-- Library to detect and track player spawn status in SAMP with lib.samp.events
-- Usage:
--   local spawnstatus = require('spawnstatus')
--   if spawnstatus.isPlayerSpawned() then ... end
--   spawnstatus.onSpawn(function() print("Player spawned!") end)

local sampev = require('lib.samp.events')

local M = {}

local isSpawned = false
local listeners = {}

-- Internal function to update spawn status once player spawned detected
local function setSpawned()
    if not isSpawned then
        isSpawned = true
        -- Notify all listeners
        for _, cb in ipairs(listeners) do
            local ok, err = pcall(cb)
            if not ok then
                print("spawnstatus listener error: "..tostring(err))
            end
        end
    end
end

--- Returns true if player has spawned
function M.isPlayerSpawned()
    return isSpawned
end

--- Register callback function to be called once on spawn event
-- Callback signature: function()
function M.onSpawn(callback)
    if type(callback) ~= "function" then
        error("spawnstatus.onSpawn expected a function argument")
    end

    if isSpawned then
        -- Already spawned, call immediately
        local ok, err = pcall(callback)
        if not ok then
            print("spawnstatus callback error: "..tostring(err))
        end
    else
        -- Register listener
        table.insert(listeners, callback)
    end
end

-- Event handler for onPlayerSpawn (primary event)
function sampev.onPlayerSpawn()
    setSpawned()
end

-- Some servers/libs may use onPlayerReady as alternative
if not sampev.onPlayerReady then
    sampev.onPlayerReady = function()
        setSpawned()
    end
end

-- Fallback: Polling-based detection (optional)
-- Define function to be called periodically to detect spawn status using sampfuncs or other means
-- This can be customized if needed.
-- Example: check if player ID is valid or player is active, then setSpawned().

-- Export module
return M
