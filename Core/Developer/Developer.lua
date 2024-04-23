--[[-----------------------------------------------------------------------------
Local Vars
-------------------------------------------------------------------------------]]
--- @type Namespace
local ns = select(2, ...)
local DCF = DebugChatFrame

--[[-----------------------------------------------------------------------------
New Instance
-------------------------------------------------------------------------------]]
local libName = 'Developer'
--- @class Developer
local L = {}
ns:log(libName, 'Loaded...')

--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]
--- @param o Developer
--- @return ChatLogFrame
local function PropsAndMethods(o)

    --- @param name Name
    function o:NewDebugChatFrame(name)

        --- @type DebugChatFrameOptions
        local opt = {
            chatFrameName = name or 'undef',
            --- @see Blizzard Interface/FrameXML/Fonts.xml
            --- @type Font
            font = DCF_ConsoleMonoCondensedSemiBold,
            size = 18,
        }

        return DCF:New(opt, function(chatFrame)
            chatFrame:logp('Chat Frame Tab Created:', name)
            chatFrame:logp('Chat Frame:', chatFrame:GetName())
        end)
    end

end; PropsAndMethods(L); dcfdev = L
--- /run dcfdev:NewDebugChatFrame('mariko sama')

