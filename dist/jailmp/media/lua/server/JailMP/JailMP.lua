local ____exports = {}
local jailPlayer, createJail, unjailPlayer, removeJail
local ____pipewrench = require('lua_modules/@asledgehammer/pipewrench/PipeWrench')
local IsoThumpable = ____pipewrench.IsoThumpable
local getOnlinePlayers = ____pipewrench.getOnlinePlayers
local getWorld = ____pipewrench.getWorld
local isServer = ____pipewrench.isServer
local Events = require('lua_modules/@asledgehammer/pipewrench-events/PipeWrench-Events')
Events.onClientCommand:addListener(function(module, command, player, args)
    if module ~= "HungerGames" then
        return
    end
    if not isServer() then
        return
    end
    if command == "ping" then
        local access_level = player:getAccessLevel()
        if args.command == "jail" then
            if access_level == "Admin" then
                jailPlayer(nil, args.username)
            end
        end
        if args.command == "unjail" then
            if access_level == "Admin" then
                unjailPlayer(nil, args.username)
            end
        end
    end
end)
local function createWall(____, x, y, z, wallname, player)
    if not isServer() then
        return
    end
    local cell = getWorld():getCell()
    local square = cell:getGridSquare(x, y, z)
    local wall = IsoThumpable.new(
        cell,
        square,
        wallname,
        false,
        {}
    )
    local wall_name = ("prison" .. "_") .. player:getUsername()
    wall:setName(wall_name)
    wall:setIsThumpable(false)
    square:AddSpecialObject(wall)
    wall:transmitCompleteItemToClients()
end
local function removeWall(____, x, y, z, player)
    local cell = getWorld():getCell()
    local square = cell:getGridSquare(x, y, z)
    local new_cell = square:getCell()
    local object_list = new_cell:getObjectList()
    local wall = square:getThumpableWall(true)
    if wall == nil then
        return
    end
    local wallName = wall:getName()
    if wallName == ("prison" .. "_") .. player:getUsername() then
        square:transmitRemoveItemFromSquareOnServer(wall)
        square:transmitRemoveItemFromSquare(wall)
        wall:removeFromWorld()
        wall:removeFromSquare()
        square:transmitRemoveItemFromSquareOnServer(wall)
        square:transmitRemoveItemFromSquare(wall)
    end
end
jailPlayer = function(____, username)
    local users = getOnlinePlayers()
    do
        local i = 0
        while i < users:size() do
            local user = users:get(i)
            if user:getUsername() == username then
                createJail(nil, user)
            end
            i = i + 1
        end
    end
end
createJail = function(____, player)
    local playerX = player:getX()
    local playerY = player:getY()
    local playerZ = player:getZ()
    createWall(
        nil,
        playerX,
        playerY,
        playerZ,
        "fencing_01_92",
        player
    )
    createWall(
        nil,
        playerX + 1,
        playerY,
        playerZ,
        "fencing_01_90",
        player
    )
    createWall(
        nil,
        playerX,
        playerY + 1,
        playerZ,
        "fencing_01_89",
        player
    )
end
unjailPlayer = function(____, username)
    local users = getOnlinePlayers()
    do
        local i = 0
        while i < users:size() do
            local user = users:get(i)
            if user:getUsername() == username then
                removeJail(nil, user)
            end
            i = i + 1
        end
    end
end
removeJail = function(____, player)
    local playerX = player:getX()
    local playerY = player:getY()
    local playerZ = player:getZ()
    local player_name = player:getUsername()
    local cell = player:getCell()
    local objectList = cell:getProcessIsoObjects()
    do
        local i = 0
        while i < objectList:size() do
            local obj = objectList:get(i)
            if obj:getName() == ("prison" .. "_") .. player_name then
                local square = cell:getGridSquare(
                    obj:getX(),
                    obj:getY(),
                    obj:getZ()
                )
                square:transmitRemoveItemFromSquareOnServer(obj)
                square:transmitRemoveItemFromSquare(obj)
                obj:removeFromWorld()
                obj:removeFromSquare()
                square:transmitRemoveItemFromSquareOnServer(obj)
                square:transmitRemoveItemFromSquare(obj)
            end
            i = i + 1
        end
    end
end

-- PIPEWRENCH --
if _G.Events.OnPipeWrenchBoot == nil then
  _G.triggerEvent('OnPipeWrenchBoot', false)
end
_G.Events.OnPipeWrenchBoot.Add(function(____flag____)
  if ____flag____ ~= true then return end
  IsoThumpable = ____pipewrench.IsoThumpable
getOnlinePlayers = ____pipewrench.getOnlinePlayers
getWorld = ____pipewrench.getWorld
isServer = ____pipewrench.isServer
end)
----------------

return ____exports
