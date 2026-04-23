--[[-----------------------------------------------------------------------------
Local Vars
-------------------------------------------------------------------------------]]
--- @type Namespace_DebugChatFrame
local ns = select(2, ...)
local DCF = DebugChatFrame

--[[-----------------------------------------------------------------------------
New Instance
-------------------------------------------------------------------------------]]
--- @class DebugChatFrame_Developer
local o = {}; dcfdev = o

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

--- /run dcfdev:NewDebugChatFrame('Mariko Sama')
--- @param name Name
function o:NewDebugChatFrame(name)

  --- @type DebugChatFrameOptions
  local opt = {
    chatFrameTabName = name or 'undef',
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

