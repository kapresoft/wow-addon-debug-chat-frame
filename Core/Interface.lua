-- Interface Definitions
-- This file is not needed to run the addon.
-- Copy and paste this anywhere in your IDE for Emmy Lua to detect

--- @alias ChatLogFrame ChatLogFrameInterface | ChatFrame
--- @alias ChatFrameTab Button

--- @class DebugChatFrameOptionsInterface
--- @field addon string The addon name
--- @field chatFrameTabName string The name of the chat frame tab
--- @field font Font The blizzard font instance name
--- @field fontSize number
--- @field windowAlpha number
--- @field maxLines number
--- @field makeDefaultChatFrame boolean|nil

--- @class ChatLogFrameInterface
--- @field options DebugChatFrameOptionsInterface
--- @field prefix fun(self:ChatLogFrameInterface, module: string): string
--- @field log fun(self:ChatLogFrameInterface, ...: any)
--- @field logp fun(self:ChatLogFrameInterface, module: string, ...: any)
--- @field InitialTabSelection fun(self:ChatLogFrameInterface, selectDebugFrameInDock:boolean): void
--- @field IsSelected fun(self:ChatLogFrameInterface): boolean
--- @field IsTabShown fun(self:ChatLogFrameInterface): boolean
--- @field StartFlash fun(self:ChatLogFrameInterface, ...) : void
--- @field GetTab fun(self:ChatLogFrameInterface): ChatFrameTab
--- @field GetTabName fun(self:ChatLogFrameInterface): string
--- @field SelectInDock fun(self:ChatLogFrameInterface): void
--- @field SelectDefaultChatFrame fun(self:ChatLogFrameInterface): void
--- @field CloseTab fun(self:ChatLogFrameInterface): void
--- @field RestoreChatFrame fun(self:ChatLogFrameInterface, selectInDock:boolean): void

--- @class DebugChatFrameInterface
--- @field New fun(self:DebugChatFrameInterface, ...:any) : ChatLogFrameInterface
