local ____exports = {}
local ____pipewrench = require('lua_modules/@asledgehammer/pipewrench/PipeWrench')
local ISUIElement = ____pipewrench.ISUIElement
local Events = require('lua_modules/@asledgehammer/pipewrench-events/PipeWrench-Events')
---
-- @param object The object to stringify.
-- @returns A string of the object's name, x, y, and z coordinates.
function ____exports.isoObjectToString(object)
    return ((((((("{name: " .. object:getObjectName()) .. ", x: ") .. tostring(object:getX())) .. ", y: ") .. tostring(object:getY())) .. ", z: ") .. tostring(object:getZ())) .. "}"
end
--- Adds a red square element to the UI using the example ISUI typings.
function ____exports.addRedSquare()
    local element = ISUIElement:new(512, 256, 256, 256)
    element:initialise()
    element:instantiate()
    element:addToUIManager()
    element:setVisible(true)
    element.render = function()
        element:drawRect(
            512,
            256,
            256,
            256,
            1,
            1,
            0,
            0
        )
    end
end
---
-- @param player The player to greet.
function ____exports.greetPlayer(player)
    print(("Hello, " .. player:getFullName()) .. "!")
end
--- Registers the 'OnObjectAdded' Lua event and prints objects that are added to the world.
function ____exports.alertObjectsAdded()
    Events.onObjectAdded:addListener(function(object)
        if object ~= nil then
            print("IsoObject added: " .. ____exports.isoObjectToString(object))
        end
    end)
end

-- PIPEWRENCH --
if _G.Events.OnPipeWrenchBoot == nil then
  _G.triggerEvent('OnPipeWrenchBoot', false)
end
_G.Events.OnPipeWrenchBoot.Add(function(____flag____)
  if ____flag____ ~= true then return end
  ISUIElement = ____pipewrench.ISUIElement
end)
----------------

return ____exports
