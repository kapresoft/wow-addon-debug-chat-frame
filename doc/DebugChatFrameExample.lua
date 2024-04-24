--[[-----------------------------------------------------------------------------
DebugChatFrame Usage
-------------------------------------------------------------------------------]]
local addon, ns = ...
local module = 'DebugChatFrameExample'

--[[-----------------------------------------------------------------------------
Type: ChatLogFrame
-------------------------------------------------------------------------------]]
--- @class _ChatLogFrame
--- @field log fun(self:_ChatLogFrame, ...)
--- @field logp fun(self:_ChatLogFrame, name:string, ...)

--[[-----------------------------------------------------------------------------
Type: DebugChatFrameOptions
-------------------------------------------------------------------------------]]
--- @class _DebugChatFrameOptions
local opt = {
    addon = addon,
    chatFrameName = 'dev',
    --- ### See Fonts: [_Fonts.xml](https://github.com/kapresoft/wow-addon-debug-chat-frame/blob/a0d3dca2d410198b9da1c9821e5b97c12f774cfc/Core/Fonts/_Fonts.xml)    font = DCF_ConsoleMonoCondensedSemiBold,
    --- @see Blizzard Interface/FrameXML/Fonts.xml
    --- @type Font
    font = DCF_ConsoleMonoCondensedSemiBold,
    size = 16,
    windowAlpha = 1.0,
    maxLines = 100,
}

--[[-----------------------------------------------------------------------------
Type: DebugChatFrame Interface
-------------------------------------------------------------------------------]]
--- @alias DebugChatFrameCallbackFn fun(chatFrame:_ChatLogFrame) | "function(chatFrame) chatFrame:log('hello') end"
---
--- @class _DebugChatFrame
--- @field New fun(self:_DebugChatFrame, opt:DebugChatFrameOptions, callbackFn:DebugChatFrameCallbackFn) : _ChatLogFrame

--- interface
--- @type _DebugChatFrame
local DebugChatFrame = {}

--[[-----------------------------------------------------------------------------
Main Code
-------------------------------------------------------------------------------]]

local f = DebugChatFrame:New(opt, function(chatFrame)
    chatFrame:log(module, 'chatFrame:', chatFrame:GetName())
    chatFrame:log(module, 'options:', {1, 2, 3})
    chatFrame:log(module, 'tab-name:', chatFrame:GetTabName())
end);
ns.chatFrame = f

-- standard logging
-- output: Hello World
f:log('Hello', 'World')

-- By Lua Module
-- Output: {{ Addon::Module }}: Loading...
f:logp(module, 'Loading...')

-- define a global function c()
--- @vararg any
function c(...)
    if ns.chatFrame then return ns.chatFrame:log(...) end
    print(...)
end

-- Usage
-- Output: MainModule:: Hello There
c('MainModule::', 'Hello There')
