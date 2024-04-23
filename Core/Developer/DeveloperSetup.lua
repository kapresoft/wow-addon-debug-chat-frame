--- @type Namespace
local ns = select(2, ...)
local flag = ns.debug.flag
flag.developer = true
flag.createTestChatFrame = true

local libName = 'DeveloperSetup'
ns:log(libName, 'Loaded:', libName)
ns:log(libName, 'developer:', ns.debug:IsDeveloper())
