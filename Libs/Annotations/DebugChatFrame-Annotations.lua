-- Interface Definitions
-- This file is not needed to run the addon.
-- Copy and paste this anywhere in your IDE for Emmy Lua to detect

--- @alias ChatFrameTab Button
--- @alias DebugChatFrameCallbackFn fun(chatFrame:ChatLogFrameInterface)

--- @class DebugChatFrameOptionsInterface
--- @field addon? string                 @Shown in log prefixes
--- @field chatFrameTabName? string      @Case-insensitive
--- @field font? Font                    @A Font object, not a font name
--- @field fontSize? number              @Overrides the font's own size
--- @field windowAlpha? number           @Not applied yet
--- @field maxLines? number
--- @field makeDefaultChatFrame? boolean @Take over DEFAULT_CHAT_FRAME

--- @class ChatLogFrameInterface
--- @field options DebugChatFrameOptionsInterface
--- @field log fun(self:ChatLogFrameInterface, ...:any)
--- @field logp fun(self:ChatLogFrameInterface, module:string, ...:any)         @Prefixes the message with addon and module
--- @field IsSelected fun(self:ChatLogFrameInterface): boolean
--- @field IsTabShown fun(self:ChatLogFrameInterface): boolean
--- @field StartFlash fun(self:ChatLogFrameInterface)
--- @field GetTab fun(self:ChatLogFrameInterface): ChatFrameTab
--- @field GetTabName fun(self:ChatLogFrameInterface): string?
--- @field GetChatFrameTabText fun(self:ChatLogFrameInterface): string          @Tab text plus frame name
--- @field SelectInDock fun(self:ChatLogFrameInterface)
--- @field SelectDefaultChatFrame fun(self:ChatLogFrameInterface)
--- @field InitialTabSelection fun(self:ChatLogFrameInterface, selectDebugFrameInDock:boolean)
--- @field CloseTab fun(self:ChatLogFrameInterface)
--- @field RestoreChatFrame fun(self:ChatLogFrameInterface, selectInDock?:boolean)
--- @field RestoreDefaultChatFrame fun(self:ChatLogFrameInterface)
--- @field SetAsDefaultChatFrame fun(self:ChatLogFrameInterface, state:boolean) @true makes this the DEFAULT_CHAT_FRAME
--- @field SetAsDefaultChatFrameIfConfigured fun(self:ChatLogFrameInterface)
--- @field OnFontSizeChanged fun(self:ChatLogFrameInterface, handler:fun(chatFrame:ChatLogFrameInterface, fontSize:number))

--- @class DebugChatFrameMessages
--- @field FontSizeChanged string @Payload: chatFrame, fontSize

--- @class DebugChatFrameInterface
--- @field Message DebugChatFrameMessages                                                                                                           @AceEvent-3.0 message names
--- @field New fun(self:DebugChatFrameInterface, opt?:DebugChatFrameOptionsInterface, callbackFn?:DebugChatFrameCallbackFn): ChatLogFrameInterface? @nil if Blizzard can't open the window
--- @field GetChatFrameTab fun(self:DebugChatFrameInterface, chatFrame:ChatFrame): ChatFrameTab
--- @field GetChatFrameTabText fun(self:DebugChatFrameInterface, chatFrame:ChatFrame): string
--- @field GetVersion fun(self:DebugChatFrameInterface): string
--- @field GetLastUpdate fun(self:DebugChatFrameInterface): string?                                                                                 @ISO 8601 date
--- @field GetAddonInfo fun(self:DebugChatFrameInterface): string?, string?, string?, string?, string?, number?                                     @version, curseForge, issues, repo, lastUpdate, interface
--- @field GetAddonInfoFormatted fun(self:DebugChatFrameInterface): string
--- @field Info fun(self:DebugChatFrameInterface)                                                                                                   @Prints GetAddonInfoFormatted()

--[[-----------------------------------------------------------------------------
Font Objects
-------------------------------------------------------------------------------]]
--- @type FontObject
DCF_Inconsolata_Regular_Outline = {}
--- @type FontObject
DCF_Inconsolata_SemiBold_Outline = {}
--- @type FontObject
DCF_InconsolataCondensed_SemiBold_Outline = {}
--- @type FontObject
DCF_InconsolataExtraCondensed_SemiBold_Outline = {}
--- @type FontObject
DCF_InconsolataUltraCondensed_SemiBold_Outline = {}
--- @type FontObject
DCF_RobotoMono_Medium_Outline = {}
--- @type FontObject
DCF_NotoSansMono_Regular_Outline = {}

-- Named by GetLocale()
--- @type FontObject
DCF_RobotoMono_ruRU_Outline = {}
--- @type FontObject
DCF_NotoSansMono_zhCN_Outline = {}
--- @type FontObject
DCF_NotoSansMono_zhTW_Outline = {}
--- @type FontObject
DCF_NotoSansMono_koKR_Outline = {}
