-- checkpoint_lib.lua
local Checkpoint = {}

Checkpoint.list = {}
Checkpoint.nextId = 1
Checkpoint.isInitialized = false

function Checkpoint.create(x, y, z, label)
    local id = Checkpoint.nextId
    Checkpoint.nextId = Checkpoint.nextId + 1
    
    local marker = createMarker(x, y, z, "checkpoint", 2.0, 255, 0, 0, 150)
    
    Checkpoint.list[id] = {
        id = id,
        marker = marker,
        pos = {x = x, y = y, z = z},
        label = label or "",
        created = os.time()
    }
    
    if label and label ~= "" then
        Checkpoint.list[id].textlabel = create3DTextLabel(label, 0xFF0000FF, x, y, z + 2.0, 20.0, 0, true)
    end
    
    return id
end

function Checkpoint.remove(id)
    if Checkpoint.list[id] then
        if isElement(Checkpoint.list[id].marker) then
            destroyElement(Checkpoint.list[id].marker)
        end
        if Checkpoint.list[id].textlabel and isElement(Checkpoint.list[id].textlabel) then
            destroyElement(Checkpoint.list[id].textlabel)
        end
        Checkpoint.list[id] = nil
        return true
    end
    return false
end

function Checkpoint.clearAll()
    for id in pairs(Checkpoint.list) do
        Checkpoint.remove(id)
    end
    Checkpoint.nextId = 1
end

function Checkpoint.count()
    local count = 0
    for _ in pairs(Checkpoint.list) do count = count + 1 end
    return count
end

function Checkpoint.init()
    Checkpoint.isInitialized = true
end

return Checkpoint