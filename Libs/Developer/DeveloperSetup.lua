--- @type Namespace
local ns = select(2, ...)
local flag = ns.debug.flag
flag.developer = true
flag.createTestChatFrame = false

local libName = 'DeveloperSetup'
ns:log(libName, 'developer:', ns.debug:IsDeveloper())
