--[[-----------------------------------------------------------------------------
Load the addon first: DebugChatFrame is LoadOnDemand.

# macro 1:
/dump C_AddOns.LoadAddOn('DebugChatFrame')
/run print(GREEN_FONT_COLOR:WrapTextInColorCode('DebugChatFrame') ..'=', tostring(DebugChatFrame))
/run if not DebugChatFrame then print(RED_FONT_COLOR:WrapTextInColorCode('FAILED'), 'to load DebugChatFrame') end

# macro 2:
/dcf testNewTab
--/dcf testLargFont

# misc:
/dump C_AddOns.EnableAddOn('DebugChatFrame', UnitName('player'))
/dump C_AddOns.LoadAddOn('DebugChatFrame')
/dump DebugChatFrame:GetAddonInfo()

Or all in one line:
/run C_AddOns.EnableAddOn('DebugChatFrame', UnitName('player')); C_Timer.After(0.5, function() C_AddOns.LoadAddOn('DebugChatFrame'); print(DebugChatFrame:GetAddonInfoFormatted()) end)

Then run the tests:
/run dcfdev:RunTests()
-------------------------------------------------------------------------------]]

--- @class (partial) Namespace_DebugChatFrame
--- @field Tests DebugChatFrame_Tests
local ns = select(2, ...)

local cfn1 = ns:ColorFn('FFEF02')
local cfn3 = ns:ColorFn(GREEN_FONT_COLOR)
local cfn4 = ns:ColorFn(RED_FONT_COLOR)
local pass, fail = cfn3('PASS'), cfn4('FAIL')
local noChatFrame = fail .. ': New() returned no chat frame'

local libName = 'Tests'
local logName = ns:prefix(libName)

--- Test: right-click the tab > Font Size > pick a size
--- @param chatFrame ChatLogFrameInterface
--- @param fontSize number
local function OnFontSizeChanged(chatFrame, fontSize)
  local msg = 'Font size changed to %s in the %s tab'
  chatFrame:logp(libName, msg:format(fontSize, cfn1(chatFrame:GetTabName())))
end

--- @param name? Name
--- @param fontSize? number
--- @return ChatLogFrameInterface? @nil if Blizzard can't open the window
local function NewDebugChatFrame(name, fontSize)
  --- @type DebugChatFrameOptions
  local opt = {
    chatFrameTabName = name or 'undef',
    --- @see Blizzard Interface/FrameXML/Fonts.xml
    --- @type Font
    font = DCF_ConsoleMonoCondensedSemiBold,
    fontSize = fontSize or 14,
  }

  local cf = DebugChatFrame:New(opt, function(chatFrame)
    chatFrame:logp(libName, 'Chat Frame Tab Created:', name)
    chatFrame:logp(libName, 'Chat Frame:', chatFrame:GetName())
    chatFrame:OnFontSizeChanged(OnFontSizeChanged)
  end)
  if not cf then print(logName, noChatFrame) end
  return cf
end

--- @class DebugChatFrame_Tests
local o = {}; ns.Tests = o

--- Opens a chat tab and checks that print() lands in it.
--- The tab stays the default chat frame.
--- @return ChatLogFrameInterface? @nil if Blizzard can't open the window
function o:TestNewTab()
  local name = 'TestNewTab'
  local cf = NewDebugChatFrame(name)
  if not cf then return end
  local nonNil = ('(%s if non-nil)'):format(pass)
  local prefix = ns:prefix(name)
  -- use print here, not cf to test the 'default chat frame' behavior
  print(prefix, 'DebugChatFrame=', tostring(DebugChatFrame), nonNil)
  print(prefix, 'ChatLogFrame=', tostring(cf), nonNil)
  local redirected = 'If you can read this in the %s tab, print() is redirected (%s)'
  print(prefix, redirected:format(cfn1(name), pass))
  return cf
end

--- Opens a large-font tab and checks its font size.
--- Switches the default chat frame back to ChatFrame1.
function o:TestLargeFont()
  local name, fontSize = 'TestLargeFont', 20
  local cf = NewDebugChatFrame(name, fontSize)
  if not cf then return end
  cf:SetAsDefaultChatFrame(false)
  local prefix = ns:prefix(name)
  cf:logp(name, ('Opened tab %s, font size %s'):format(cf:GetChatFrameTabText(), fontSize))
  local where = "%s if you're seeing this in the %s tab, %s if it's in the %s tab"
  print(prefix, where:format(pass, cfn1('General'), fail, cfn1(name)))
  local _, actualSize = cf:GetFont()
  -- GetFont can return a float (e.g. 19.99)
  local result = math.floor(actualSize + 0.5) == fontSize and pass or fail
  cf:logp(name, ('Font size: expected %s, actual %s (%s)'):format(fontSize, actualSize, result))
  cf:logp(name, ('logp() belongs in this tab: %s if you can read this here'):format(pass))
end

