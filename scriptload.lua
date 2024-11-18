if _G.HOHO_RAN then return end
_G.HOHO_RAN = true

-- Environment compatibility
local env = getgenv and getgenv() or _G

-- Debug library compatibility
for Index, Value in next, debug do
    if not env[Index] then
        env[Index] = Value
    end
end

-- Compatibility for bit library
env.bit = bit or bit32

-- Compatibility for cloneref
local dummy = Instance.new("Part")
for _, tbl in pairs(getreg()) do
    if type(tbl) == "table" and rawget(tbl, "__mode") == "kvs" then
        for _, inst in pairs(tbl) do
            if inst == dummy then
                env.InstanceList = tbl
                break
            end
        end
    end
end

if not env.cloneref and env.InstanceList then
    env.cloneref = function(ref)
        for k, v in pairs(env.InstanceList) do
            if v == ref then
                env.InstanceList[k] = nil
                return ref
            end
        end
    end
end

-- Compatibility for queue_on_teleport
local queue_teleport = syn and syn.queue_on_teleport or queue_on_teleport or fluxus and fluxus.queue_on_teleport
queue_teleport = queue_teleport or function(script)
    -- Fallback in case it's unsupported
    print("queue_on_teleport is not supported on this executor.")
end

-- Wait for the game to load
repeat wait() until game:IsLoaded() and game.Players.LocalPlayer

-- Notifications
local notify = loadstring(game:HttpGet("https://raw.githubusercontent.com/acsu123/HOHO_H/main/Notification.lua"))()

-- Game-specific script loader
local gameScripts = {
    [994732206] = "https://raw.githubusercontent.com/acsu123/HohoV2/main/BloxFruit/BloxFruitTEST_ONLY.lua",
    -- Add other game IDs and URLs here
}

local currentGame = gameScripts[game.GameId]
if currentGame then
    loadstring(game:HttpGet(currentGame))()
else
    notify.New("This game is not supported by HoHoHub.", 60)
end
