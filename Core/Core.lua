--[[-----------------------------------------------------------------------------
Type: Namespace
-------------------------------------------------------------------------------]]
--- @class Namespace : Kapresoft_Base_Namespace
--- @field gameVersion GameVersion

--- @type string
local addon
--- @type Namespace
local ns
addon, ns = ...

local K = ns.Kapresoft_LibUtil
local c1 = K:cf(RARE_BLUE_COLOR)
local c2 = K:cf(YELLOW_THREAT_COLOR)
--local AceEvent = K.Objects.AceLibrary.O.AceEvent
--print('AceEvent:', AceEvent)
---@param o Namespace
local function NamespaceMixin(o)

    o.addon = addon
    o.addonPretty = c1(o.addon)
    o.sformat = string.format
    o.pformat = K.pformat

    --- @param module Name
    function o:prefix(module)
        assert(type(module) == 'string', 'Namespace:prefix(module): module should be a string.')
        return self.sformat('{{%s::%s}}:', self.addonPretty, c2(module))
    end

    function ns:K() return K end
    function ns:KO() return self:K().Objects end

    --- @param module Name
    --- @vararg
    function ns:log(module, ...)
        if ns.chatFrame then return ns.chatFrame:logp(module, ...) end

        local args = {...}  -- Collect all arguments into a table
        local texts = {}
        for i, v in ipairs(args) do
            if type(v) == "table" then texts[i] = pformat(v)
            else texts[i] = tostring(v) end
        end
        local message = table.concat(texts, " ")
        print(self:prefix(module), message)
    end

end; NamespaceMixin(ns)

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
    local o = {
        flag = flag,
    }
    function o:IsDeveloper() return self.flag.developer == true  end
    function o:CreateTestChatFrame() return self:IsDeveloper() and self.flag.createTestChatFrame == true end
    return o;
end

ns.debug = debug()
