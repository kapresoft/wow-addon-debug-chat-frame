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
--- @field OnFontSizeChanged fun(self:_ChatLogFrame, handler:fun(chatFrame:_ChatLogFrame, fontSize:number))

--[[-----------------------------------------------------------------------------
Type: DebugChatFrameOptions
-------------------------------------------------------------------------------]]
--- @class _DebugChatFrameOptions
local opt = {
    addon = addon,
    chatFrameTabName = 'dev',
    --- ### See Fonts: [_Fonts.xml](https://github.com/kapresoft/wow-addon-debug-chat-frame/blob/main/Libs/Fonts/_Fonts.xml)
    --- @see Blizzard Interface/FrameXML/Fonts.xml
    --- @type Font
    font = DCF_InconsolataCondensed_SemiBold_Outline,
    fontSize = 16,
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

-- Save the player's pick from the tab's right-click Font Size menu;
-- pass it back as opt.fontSize to New() on the next load.
f:OnFontSizeChanged(function(chatFrame, fontSize)
    MyAddonDB.debugChatFontSize = fontSize
end)
