--local kch = LibStub('Kapresoft-ColorUtil-1.0')
--print('kch:', kch)

--[[-----------------------------------------------------------------------------
Local Vars
-------------------------------------------------------------------------------]]
--- @type string
local addon
--- @type CoreNamespace
local ns
addon, ns = ...

local KO = ns.Kapresoft_LibUtil.Objects
local ch = KO.ColorUtil

local sformat, strlower = string.format, string.lower
local c1 = ch:NewFormatterFromRGB(0.9, 0.2, 0.2, 1.0)
local c2 = ch:NewFormatterFromColor(BLUE_FONT_COLOR)
local c3 = ch:NewFormatterFromColor(YELLOW_FONT_COLOR)
local c4 = ch:NewFormatterFromColor(RED_FONT_COLOR)
--[[-----------------------------------------------------------------------------
New Instance
-------------------------------------------------------------------------------]]
local libName = 'DeveloperConsoleFrameMixin'
local libShortName = 'DCFM'
--- @class DeveloperConsoleFrameMixin
local L = {}; KO[libName] = L; ns.DeveloperConsoleFrameMixin = L

--- @class DebugConsoleOptions
local debugConsoleOptionsDefault = {
    --- The name is case-insensitive
    chatFrameName = 'dev',
    --- @see Blizzard Interface/FrameXML/Fonts.xml
    --- @type Font
    font = SystemFont_Outline_Small,
    size = 14,
    windowAlpha = 1.0,
    maxLines = 100,
}

--[[-----------------------------------------------------------------------------
Support Functions
-------------------------------------------------------------------------------]]
---@param name Name
function GetFrameByName(name)
    assert(type(name) == 'string', "ChatFrame string name is required")
    for i = 1, NUM_CHAT_WINDOWS do
        --- @type Frame
        local frame = _G["ChatFrame" .. i]
        if frame then
            --- @type Name
            local n = FCF_GetChatWindowInfo(i)
            if n and strlower(name) == strlower(n) then return frame end
        end
    end
end
--[[-----------------------------------------------------------------------------
Methods
/dump DEFAULT_CHAT_FRAME.name
/dump ChatFrame1.name
-------------------------------------------------------------------------------]]
--- @alias ChatLogFrame __ChatLogFrame | ScrollingMessageFrame

--- @class __ChatLogFrame
local ChatLogFrameMixin = {}
---@param o __ChatLogFrame | ChatLogFrame
local function ChatLogFrameMixin_PropsAndMethods(o)

    --- @vararg
    function o:log(...)
        local args = {...}  -- Collect all arguments into a table
        local texts = {}
        local pformat = pformat or ns.pformat or tostring
        for i, v in ipairs(args) do
            if type(v) == "table" then texts[i] = pformat(v)
            else texts[i] = tostring(v) end
        end
        local message = table.concat(texts, " ")
        self:StartFlash()
        self:AddMessage(message)
    end

    function o:IsSelected()
        return FCFDock_GetSelectedWindow(GENERAL_CHAT_DOCK) == self
    end

    function o:StartFlash()
        if self:IsSelected() then return FCF_StopAlertFlash(self) end
        FCF_StartAlertFlash(self)
    end

    function o:SelectInDock() FCF_SelectDockFrame(self) end

end; ChatLogFrameMixin_PropsAndMethods(ChatLogFrameMixin)

--- @param o DeveloperConsoleFrameMixin
local function PropsAndMethods(o)

    local nameColor = c1(addon)
    local libNameColor = c3(libShortName)
    o.prefix = sformat('{{%s::%s}}:', nameColor, libNameColor)

    --- @param opt DebugConsoleOptions
    --- @param callbackFn fun(chatFrame:ChatFrame) | "function(chatFrame) end"
    function o:InitChatFrame(opt, callbackFn)
        local def = debugConsoleOptionsDefault
        local name = opt.chatFrameName or def.chatFrameName
        assert(name, 'Chat frame name is required')

        --- @see Interface/FrameXML/ChatFrame.lua
        --- @type ChatLogFrame
        local chatFrame = FCF_OpenTemporaryWindow('CHANNEL20', 'player', nil, true)
        if not chatFrame then print(self.prefix, c4('Failed to create temporary chat frame.')) return end

        FCF_SetWindowName(chatFrame, opt.chatFrameName)

        Mixin(chatFrame, ChatLogFrameMixin)

        local font = opt.font or def.font
        local f, size, flags = font:GetFont()
        if opt.size then size = opt.size end
        chatFrame:SetFont(f, size, flags)
        chatFrame:SetMaxLines(opt.maxLines)

        if ns.gameVersion == 'classic' then
            chatFrame:SetScript("OnMouseWheel", function(self, delta)
                if delta > 0 then self:ScrollUp() else self:ScrollDown() end
            end)
        end
        -- other settings:
        -- shadow offset
        -- chatFrame:GetFontObject():SetShadowOffset(1.5, -1)
        if callbackFn then callbackFn(chatFrame) end

        C_Timer.After(1, function() FCF_StopAlertFlash(chatFrame) end)

        return chatFrame
    end

end; PropsAndMethods(L)
