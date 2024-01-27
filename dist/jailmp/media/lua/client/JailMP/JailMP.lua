local ____lualib = require('lualib_bundle')
local __TS__StringIncludes = ____lualib.__TS__StringIncludes
local __TS__StringSplit = ____lualib.__TS__StringSplit
local ____exports = {}
local ____pipewrench = require('lua_modules/@asledgehammer/pipewrench/PipeWrench')
local getPlayer = ____pipewrench.getPlayer
local isClient = ____pipewrench.isClient
local sendClientCommand = ____pipewrench.sendClientCommand
local Events = require('lua_modules/@asledgehammer/pipewrench-events/PipeWrench-Events')
Events.onAddMessage:addListener(function(chatMessage, tab)
    if isClient() then
        if __TS__StringIncludes(
            chatMessage:getText(),
            "!jail"
        ) then
            local username = __TS__StringSplit(
                chatMessage:getText(),
                " "
            )[2]
            sendClientCommand(
                getPlayer(),
                "HungerGames",
                "ping",
                {command = "jail", username = username}
            )
        end
        if __TS__StringIncludes(
            chatMessage:getText(),
            "!unjail"
        ) then
            local username = __TS__StringSplit(
                chatMessage:getText(),
                " "
            )[2]
            sendClientCommand(
                getPlayer(),
                "HungerGames",
                "ping",
                {command = "unjail", username = username}
            )
        end
    end
end)

-- PIPEWRENCH --
if _G.Events.OnPipeWrenchBoot == nil then
  _G.triggerEvent('OnPipeWrenchBoot', false)
end
_G.Events.OnPipeWrenchBoot.Add(function(____flag____)
  if ____flag____ ~= true then return end
  getPlayer = ____pipewrench.getPlayer
isClient = ____pipewrench.isClient
sendClientCommand = ____pipewrench.sendClientCommand
end)
----------------

return ____exports
