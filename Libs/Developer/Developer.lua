--[[-----------------------------------------------------------------------------
Local Vars
-------------------------------------------------------------------------------]]
--- @type Namespace_DebugChatFrame
local ns = select(2, ...)
local DCF = DebugChatFrame
local AceEvent = LibStub('AceEvent-3.0')
local libName = 'Developer'

--[[-----------------------------------------------------------------------------
New Instance
-------------------------------------------------------------------------------]]
--- @class DebugChatFrame_Developer : AceEvent-3.0
local o = AceEvent:Embed({}); dcfdev = o

--[[-----------------------------------------------------------------------------
# Predefine
/run (function()
  C_AddOns.LoadAddOn('DebugChatFrame');
  print('DebugChatFrame::'); DevTools_Dump(DebugChatFrame);
end)()
/run dcfdev:NewDebugChatFrame('Mariko Sama')
/dump DebugChatFrame.SelectDefaultChatFrame

# Print Some Info
/run (function()
  local c=DebugChatFrame
  if not c then return print('ERROR:: DebugChatFrame not loaded') end
  print("DebugChatFrame=", c, 'info=', c:GetAddonInfo())
end)()

# Create New Tab
/run (
  function()
  local dcf = DebugChatFrame;
  local opt = { chatFrameTabName = 'Test'};
  cf = DebugChatFrame:New(opt, function(cf) print('chatFrame:', tostring(cf)); end)
end)()
-------------------------------------------------------------------------------]]

--[[-----------------------------------------------------------------------------
Support Functions
-------------------------------------------------------------------------------]]

--- @type DebugChatFrameOptions
local testChatFrameOptions = {
  addon                = ns.name,
  chatFrameTabName     = 'dcf',
  font                 = DCF_InconsolataExtraCondensed_SemiBold_Outline,
--[[
  font                 = DCF_InconsolataCondensed_Regular_Outline,
  font                 = DCF_InconsolataExtraCondensed_SemiBold_Outline,
  font                 = DCF_InconsolataUltraCondensed_SemiBold_Outline,
  font                 = DCF_Inconsolata_SemiBold_Outline,
  font                 = DCF_NotoSansMono_zhCN_Outline,
  font                 = DCF_RobotoMono_Medium_Outline,
  font                 = DCF_NotoSansMono_Regular_Outline,
  ]]
  fontSize             = 14,
  windowAlpha          = 1.0,
  maxLines             = 100,
  makeDefaultChatFrame = true,
}

function o:OnPlayerLogin()
  self:UnregisterEvent('PLAYER_LOGIN')
  self:NewTestChatFrame()
end
--o:RegisterEvent('PLAYER_LOGIN', 'OnPlayerLogin')


--- /run dcfdev:NewTestChatFrame()
function o:NewTestChatFrame()
  return DCF:New(testChatFrameOptions, function(chatFrame)
    ns.chatFrame = chatFrame
    ns:log(libName, 'chatFrame:', chatFrame:GetName())
    ns:log(libName, 'options:', {1, 2, 3})
    ns:log(libName, 'tab-name:', chatFrame:GetTabName())
  end)
end

--[[-----------------------------------------------------------------------------
Font Size Changed Listener
Test: right-click the tab > Font Size > pick a size
-------------------------------------------------------------------------------]]
function o:RegisterOnFontSizeChanged()
  ns.chatFrame:OnFontSizeChanged(function(chatFrame, fontSize)
   print(ns.addon, libName, 'OnFontSizeChanged', 'tab=', chatFrame:GetTabName(), 'fs=', fontSize)
  end)
end

--- /run dcfdev:NewDebugChatFrame('Mariko Sama')
--- @param name Name
function o:NewDebugChatFrame(name)

  --- @type DebugChatFrameOptions
  local opt = {
    chatFrameTabName = name or 'undef',
    --- @see Blizzard Interface/FrameXML/Fonts.xml
    --- @type Font
    font = DCF_ConsoleMonoCondensedSemiBold,
    size = 27,
  }

  return DCF:New(opt, function(chatFrame)
    chatFrame:logp('Chat Frame Tab Created:', name)
    chatFrame:logp('Chat Frame:', chatFrame:GetName())
    chatFrame:OnFontSizeChanged(OnFontSizeChanged)
  end)
end

--- /dump dcfdev:TestSelect()
function o:TestSelect()
  local cf = self:NewDebugChatFrame('Test')
  cf:SelectDefaultChatFrame()
  local txt = cf:GetChatFrameTabText()
  print('txt=', txt)
  return txt
end

--- /dump dcfdev:TestChatFrameTabText()
function o:TestChatFrameTabText()
  local cf = self:NewDebugChatFrame('Test')
  return cf:GetChatFrameTabText(), type(DebugChatFrame)
end
