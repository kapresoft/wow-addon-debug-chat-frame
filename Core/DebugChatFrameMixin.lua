--[[-----------------------------------------------------------------------------
Local Vars
-------------------------------------------------------------------------------]]
--- @type string
local addon
--- @type Namespace
local ns
addon, ns = ...

local K = ns.Kapresoft_LibUtil
local KO = K.Objects
local pformat = ns.Kapresoft_LibUtil.pformat

local shallow_copy = KO.Table.shallow_copy
local sformat, strlower = string.format, string.lower

local GITHUB_LAST_CHANGED_DATE = 'X-Github-Project-Last-Changed-Date'
local GITHUB_REPO = 'X-Github-Repo'
local GITHUB_ISSUES = 'X-Github-Issues'
local CURSE_FORGE = 'X-CurseForge'

--[[-----------------------------------------------------------------------------
New Instance
-------------------------------------------------------------------------------]]
local libShortName = 'DCF'
--- @class DebugChatFrame : DebugChatFrameInterface
local L = {}; DebugChatFrame = L

--- @class DebugChatFrameOptions : DebugChatFrameOptionsInterface
local debugConsoleOptionsDefault = {
    addon         = addon,
    --- The name is case-insensitive
    chatFrameTabName = 'dcf',
    --- @see Blizzard Interface/FrameXML/Fonts.xml
    --- @type Font
    font          = DCF_ConsoleMonoCondensedSemiBold,
    fontSize      = 14,
    windowAlpha   = 1.0,
    maxLines      = 200,
    makeDefaultChatFrame = true,
}

--[[-----------------------------------------------------------------------------
Support Functions
-------------------------------------------------------------------------------]]
--- @param color Color
--- @return fun(arg:any) : string The string wrapped in color code
local function NewFormatterFromColor(color)
    --- @param arg any
    return function(arg) return color:WrapTextInColorCode(tostring(arg)) end
end

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

local c1 = NewFormatterFromColor(FACTION_ORANGE_COLOR)
local c2 = NewFormatterFromColor(BLUE_FONT_COLOR)
local c3 = NewFormatterFromColor(YELLOW_FONT_COLOR)
local c4 = NewFormatterFromColor(RED_FONT_COLOR)

--[[-----------------------------------------------------------------------------
Methods
/dump DEFAULT_CHAT_FRAME.name
/dump ChatFrame1.name
-------------------------------------------------------------------------------]]
--- @alias ChatLogFrame __ChatLogFrame | ChatLogFrameInterface | ChatFrame

--- @class __ChatLogFrame
--- @field options DebugChatFrameOptions
local ChatLogFrameMixin = {}
---@param o __ChatLogFrame | ChatLogFrame
local function ChatLogFrameMixin_PropsAndMethods(o)

    --- @private
    --- @return string
    --- @param module string
    function o:prefix(module)
        assert(module, 'Module:string is required.')
        local name = (self.options and self.options.addon) or addon
        local nameColor   = c1(name)
        local moduleColor = c3(module)
        return sformat('{{%s::%s}}:', nameColor, moduleColor)
    end

    --- @vararg
    function o:log(...)
        local args = {...}  -- Collect all arguments into a table
        local texts = {}
        for i, v in ipairs(args) do
            if type(v) == "table" then texts[i] = pformat(v)
            else texts[i] = tostring(v) end
        end
        local message = table.concat(texts, " ")
        self:StartFlash()
        self:AddMessage(message)
    end

    --- @vararg
    --- @param module string
    function o:logp(module, ...)
        self:log(self:prefix(module), ...)
    end

    --- @return boolean
    function o:IsSelected() return FCFDock_GetSelectedWindow(GENERAL_CHAT_DOCK) == self end

    --- @return boolean
    function o:IsTabShown()
        local tab = self:GetTab()
        return tab ~= nil and tab:IsShown()
    end

    function o:StartFlash()
        if self:IsSelected() then return FCF_StopAlertFlash(self) end
        FCF_StartAlertFlash(self)
    end

    function o:GetTabName()
        local tab = self:GetTab()
        return (tab and tab.GetText and tab:GetText()) or nil
    end

    --- @return ChatFrameTab
    function o:GetTab() return _G[self:GetName() .. "Tab"] end

    function o:SelectInDock() FCF_SelectDockFrame(self) end
    function o:SelectDefaultChatFrame() return ChatFrame1 and FCF_SelectDockFrame(ChatFrame1) end

    --- @param selectDebugFrameInDock boolean
    function o:InitialTabSelection(selectDebugFrameInDock)
        if selectDebugFrameInDock then return self:SelectInDock() end
        self:SelectDefaultChatFrame()
    end

    function o:CloseTab()
        self:RestoreDefaultChatFrame()
        FCF_Close(self)
    end

    function o:RestoreDefaultChatFrame() DEFAULT_CHAT_FRAME = ChatFrame1 end

    -- Note: There will be start-drag errors when replacing the entire
    -- DEFAULT_CHAT_FRAME, i.e. when the debug console is active.
    -- TODO: how to solve?
    function o:SetAsDefaultChatFrameIfConfigured()
        if self.options.makeDefaultChatFrame ~= true then return end
        DEFAULT_CHAT_FRAME = self
    end

    ---@param selectInDock boolean|nil An optional parameter to select in dock
    function o:RestoreChatFrame(selectInDock)
        if self:IsVisible() then return end
        self:SetAsDefaultChatFrameIfConfigured()

        FCF_DockFrame(self, 100)
        -- Ensure it's visible
        if selectInDock ~= true then return end
        self:Show()
        self:SelectInDock()
    end

end; ChatLogFrameMixin_PropsAndMethods(ChatLogFrameMixin)

--- @param o DebugChatFrame
local function PropsAndMethods(o)

    --- @param opt DebugChatFrameOptions
    --- @param callbackFn fun(chatFrame:ChatLogFrame) | "function(chatFrame) end" | "Set additional settings in the callbackFn"
    function o:New(opt, callbackFn)
        local def = debugConsoleOptionsDefault
        opt = opt or def
        opt.makeDefaultChatFrame = opt.makeDefaultChatFrame ~= nil or def.makeDefaultChatFrame
        local name = opt.chatFrameTabName or def.chatFrameTabName
        assert(name, 'Chat frame name is required')

        --- @see Interface/FrameXML/ChatFrame.lua
        --- @type ChatLogFrame
        local chatFrame = FCF_OpenTemporaryWindow('CHANNEL20', 'player', nil, true)
        if not chatFrame then print(addon, c4('Failed to create temporary chat frame.')) return end

        FCF_SetWindowName(chatFrame, opt.chatFrameTabName)

        chatFrame.options = opt
        Mixin(chatFrame, ChatLogFrameMixin)

        local maxLines = opt.maxLines or def.maxLines
        local font = opt.font or def.font
        local f, size, flags = font:GetFont()
        if opt.fontSize then size = opt.fontSize end
        chatFrame:SetFont(f, size, flags)
        chatFrame:SetMaxLines(maxLines)

        if ns.gameVersion == 'classic' then
            chatFrame:SetScript("OnMouseWheel", function(self, delta)
                if delta > 0 then self:ScrollUp() else self:ScrollDown() end
            end)
        end

        -- other settings:
        -- shadow offset
        -- chatFrame:GetFontObject():SetShadowOffset(1.5, -1)

        chatFrame:SetAsDefaultChatFrameIfConfigured()
        if callbackFn then callbackFn(chatFrame) end

        C_Timer.After(1, function()
            FCF_StopAlertFlash(chatFrame)
        end)

        return chatFrame
    end

    --- @return string The addon version string. Example: 2024.3.1
    function o:GetVersion()
        local versionText = GetAddOnMetadata(addon, 'Version')
        --@do-not-package@
        if ns.debug:IsDeveloper() then
            versionText = '1.0.0.dev'
        end
        --@end-do-not-package@
        return versionText
    end

    --- @return string The time in ISO Date Format. Example: 2024-03-22T17:34:00Z
    function o:GetLastUpdate()
        local lastUpdate = GetAddOnMetadata(addon, GITHUB_LAST_CHANGED_DATE)
        --@do-not-package@
        if ns.debug:IsDeveloper() then
            lastUpdate = ns:KO().TimeUtil:TimeToISODate()
        end
        --@end-do-not-package@
        return lastUpdate
    end

    ---#### Example
    ---```
    ---local version, curseForge, issues, repo, lastUpdate, useKeyDown, wowInterfaceVersion = GC:GetAddonInfo()
    ---```
    --- /dump DebugChatFrame:GetAddonInfo()
    --- @return string, string, string, string, string, string, string
    function o:GetAddonInfo()
        local lastUpdate = self:GetLastUpdate()
        local versionText = self:GetVersion()
        local wowInterfaceVersion = select(4, GetBuildInfo())

        return versionText, GetAddOnMetadata(addon, CURSE_FORGE), GetAddOnMetadata(addon, GITHUB_ISSUES),
                GetAddOnMetadata(addon, GITHUB_REPO), lastUpdate, wowInterfaceVersion
    end

    --- /run print(DebugChatFrame:GetAddonInfoFormatted())
    --- @return string
    function o:GetAddonInfoFormatted()
        local version, curseForge, issues, repo, lastUpdate, wowInterfaceVersion = self:GetAddonInfo()
        local fmt = '%s|cfdeab676: %s|r'
        return sformat("%s:\n%s\n%s\n%s\n%s\n%s\n%s\n%s",
                       'Addon Info',
                       sformat(fmt, 'Version', version),
                       sformat(fmt, 'Curse-Forge', curseForge),
                       sformat(fmt, 'Bugs', issues),
                       sformat(fmt, 'Repo', repo),
                       sformat(fmt, 'Last-Update', lastUpdate),
                       sformat(fmt, 'Interface-Version', wowInterfaceVersion),
                       sformat(fmt, 'Game-Version', ns.gameVersion)
        )
    end

    --- /run DebugChatFrame:Info()
    function o:Info() print(self:GetAddonInfoFormatted()) end

end; PropsAndMethods(L)

--@do-not-package@
if not ns.debug:CreateTestChatFrame() then return end

--- @type DebugChatFrameOptions
local opt = shallow_copy(debugConsoleOptionsDefault)
opt.fontSize = 16
opt.maxLines = 100
L:New(opt, function(chatFrame)
    ns.chatFrame = chatFrame
    ns:log(libShortName, 'chatFrame:', chatFrame:GetName())
    ns:log(libShortName, 'options:', {1, 2, 3})
    ns:log(libShortName, 'tab-name:', chatFrame:GetTabName())
    ns:log(libShortName, 'gaveVersion:', ns.gameVersion)
end)
--@end-do-not-package@
