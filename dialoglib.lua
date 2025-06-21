local dialogHandlers = {}
local lastHandled = {}

function regDialogHandler(id, func)
    dialogHandlers[id] = func
    lastHandled[id] = false
end

function checkDialog()
    for id, func in pairs(dialogHandlers) do
        if not lastHandled[id] then
            local result, button, list, input = sampHasDialogRespond(id)
            if result then
                lastHandled[id] = true
                func(id, button, list, input)
                lua_thread.create(function()
                    wait(500)
                    lastHandled[id] = false
                end)
            end
        end
    end
end