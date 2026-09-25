local GVM = LibStub('Kapresoft-GameVersionMixin-2-0')
local colorFormatter = LibStub('Kapresoft-ColorFormatter-2-0')

local addon, xns = ...

--- @class Namespace_DebugChatFrame : Kapresoft_Base_Namespace, Kapresoft-GameVersionMixin-2-0
--- @field name Name The addon name
--- @field debug DebugSettings
--- @field chatFrame ChatLogFrame @developer mode only
local ns = xns
ns.name = addon

Mixin(ns, GVM)

--- @param rgbHex RGBHex?     @Optional
--- @return cfFn, colorRGBA?
function ns:ColorFn(rgbHex) return colorFormatter:ColorFn(rgbHex) end
--- @return Kapresoft-TimeUtil-2-0
function ns:TimeUtil() return LibStub('Kapresoft-TimeUtil-2-0') end
--- @return AceLocale-3.0
function ns:AceLocale() return LibStub("AceLocale-3.0") end
--- @return table<string, string>
function ns:GetLocale() return self:AceLocale():GetLocale(self.name) end

local c1 = ns:ColorFn(RARE_BLUE_COLOR)
local c2 = ns:ColorFn(YELLOW_THREAT_COLOR)

ns.dcfmt = LibPrettyPrint:Formatter({
  show_all = true, depth_limit = 3
}); if not dcfmt then dcfmt = ns.dcfmt end

local o = ns

o.addon = addon
o.addonPretty = c1(o.addon)
o.sformat = string.format

--- @param module Name
function o:prefix(module)
    assert(type(module) == 'string', 'Namespace:prefix(module): module should be a string.')
    return self.sformat('{{%s::%s}}:', self.addonPretty, c2(module))
end

--- @param module Name
--- @vararg
function ns:log(module, ...)
    if ns.chatFrame then return ns.chatFrame:logp(module, ...) end
    local args = {...}  -- Collect all arguments into a table
    local texts = {}
    for i, v in ipairs(args) do
        if type(v) == "table" then texts[i] = ns.dcfmt(v)
        else texts[i] = tostring(v) end
    end
    local message = table.concat(texts, " ")
    print(self:prefix(module), message)
end

--[[-----------------------------------------------------------------------------
Type: DebugSettingsFlag
-------------------------------------------------------------------------------]]
--- @class DebugSettingsFlag
--- @see DeveloperSetup
local flag = {
    developer = false,
    createTestChatFrame = false,
}

--[[-----------------------------------------------------------------------------
Type: DebugSettings
--- Make sure to match this structure in GlobalDeveloper (which is not packaged in releases)
-------------------------------------------------------------------------------]]

--- @return DebugSettings
local function debug()
    --- @class DebugSettings
    local ds = { flag = flag }
    function ds:IsDeveloper() return self.flag.developer == true  end
    function ds:CreateTestChatFrame() return self:IsDeveloper() and self.flag.createTestChatFrame == true end
    return ds;
end

ns.debug = debug()
DCF_NS = ns
