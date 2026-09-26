--[[-----------------------------------------------------------------------------
DebugChatFrame Usage
Types: Libs/Annotations/DebugChatFrame-Annotations.lua
-------------------------------------------------------------------------------]]
local addon, ns = ...
local module = 'DebugChatFrameExample'

--- @type DebugChatFrameOptionsInterface
local opt = {
    addon = addon,
    chatFrameTabName = 'dev',
    --- See [Available Font Names](https://github.com/kapresoft/wow-addon-debug-chat-frame#available-font-names)
    font = DCF_InconsolataCondensed_SemiBold_Outline,
    fontSize = 16,
    maxLines = 100,
}

--- @type DebugChatFrameInterface
local dcf = DebugChatFrame

--[[-----------------------------------------------------------------------------
Main Code
-------------------------------------------------------------------------------]]

--- @type ChatLogFrameInterface
local f = dcf:New(opt, function(chatFrame)
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
