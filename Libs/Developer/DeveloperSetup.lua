--- @type Namespace_DebugChatFrame
local ns = select(2, ...)
local flag = ns.debug.flag
flag.developer = true

local libName = 'DeveloperSetup'
ns:log(libName, 'developer:', ns.debug:IsDeveloper())
