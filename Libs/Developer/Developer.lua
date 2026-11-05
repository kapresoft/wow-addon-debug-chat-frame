--[[-----------------------------------------------------------------------------
Local Vars
-------------------------------------------------------------------------------]]
--- @type Namespace_DebugChatFrame
local ns = select(2, ...)

local DCF = DebugChatFrame
local AceEvent = LibStub('AceEvent-3.0')
local Tests = ns.Tests
local libName = 'Developer'

--[[-----------------------------------------------------------------------------
New Instance
-------------------------------------------------------------------------------]]
--- @class DebugChatFrame_Developer : AceEvent-3.0
local o = AceEvent:Embed({}); dcfdev = o

--[[-----------------------------------------------------------------------------
# Load On Demand
/run (function()
  local lao = C_AddOns.LoadAddOn; lao('DebugChatFrame');
  print('DebugChatFrame=', DebugChatFrame);
end)()
/run (function()
  local lao = C_AddOns.LoadAddOn; lao('DebugChatFrame');
  print('DebugChatFrame::'); DevTools_Dump(DebugChatFrame);
end)()

/dcf testLargeFont
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
  local dcf = DebugChatFrame; local opt = { chatFrameTabName = 'Test'};
  cf = DebugChatFrame:New(opt, function(cf) print('chatFrame:', tostring(cf)); end)
end)()
-------------------------------------------------------------------------------]]

--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]

--- Runs the dev tests in Tests.lua; load DebugChatFrame first.
--- ### Example:
--- ```lua
--- dcfdev:RunTests()
--- ```
function o:RunTests()
  Tests:TestNewTab()
  Tests:TestLargeFont()
end

--[[-----------------------------------------------------------------------------
Support Functions
-------------------------------------------------------------------------------]]

--- @type DebugChatFrameOptions
local testChatFrameOptions = {
  addon = ns.name,
  chatFrameTabName = 'dcf',
  font = DCF_InconsolataExtraCondensed_SemiBold_Outline,
  --[[
  font                 = DCF_InconsolataCondensed_Regular_Outline,
  font                 = DCF_InconsolataExtraCondensed_SemiBold_Outline,
  font                 = DCF_InconsolataUltraCondensed_SemiBold_Outline,
  font                 = DCF_Inconsolata_SemiBold_Outline,
  font                 = DCF_NotoSansMono_zhCN_Outline,
  font                 = DCF_RobotoMono_Medium_Outline,
  font                 = DCF_NotoSansMono_Regular_Outline,
  ]]
  fontSize = 14,
  windowAlpha = 1.0,
  maxLines = 100,
  makeDefaultChatFrame = true,
}

--- @param addonName Name
function o:OnAddonLoaded(_, addonName)
  if addonName ~= ns.name then return end
  self:UnregisterEvent('ADDON_LOADED')
  self:RegisterSlashCommand()
  self:PrintInstructions()
end

function o:RegisterSlashCommand()
  SLASH_DCF_DEV1 = '/dcf'
  SlashCmdList.DCF_DEV = function(msg) self:OnSlashCommand(msg) end
end

-- Keys are lowercase so commands match in any case
local commands = {
  tests = function() o:RunTests() end,
  testnewtab = function() Tests:TestNewTab() end,
  testlargefont = function() Tests:TestLargeFont() end,
}
commands.tnt = commands.testnewtab
commands.tlf = commands.testlargefont

--- ### Example:
--- ```
--- /dcf
--- /dcf tests
--- /dcf testLargeFont
--- /dcf tlf
--- ```
--- @param msg string
function o:OnSlashCommand(msg)
  local command = commands[strtrim(msg):lower()]
  if command then return command() end
  self:PrintInstructions()
end

local yellow = ns:ColorFn(YELLOW_THREAT_COLOR)
local blue = ns:ColorFn(LIGHTBLUE_FONT_COLOR)

-- Padding stays outside the color codes to keep columns aligned
local usage = {
  yellow('Usage:') .. ' /dcf [command]',
  '  Commands:',
  '    ' .. blue('tests') .. '                Run the dev tests (same as /run dcfdev:RunTests())',
  '    ' .. blue('testNewTab') .. ', ' .. blue('tnt') .. '      Open a tab and check print() lands in it',
  '    ' .. blue('testLargeFont') .. ', ' .. blue('tlf') .. '   Open a tab in a large font',
  '    ' .. blue('(none)') .. '               Show this help',
  '',
  '  Global Variables:',
  '    ' .. blue('dcfdev') .. '               The DebugChatFrame Developer instance',
}

function o:PrintInstructions()
  print('::', blue(ns.name .. ' Console Commands'), '::')
  for _, line in ipairs(usage) do print(line) end
end

--- /run dcfdev:NewTestChatFrame()
function o:NewTestChatFrame()
  return DCF:New(testChatFrameOptions, function(chatFrame)
    ns.chatFrame = chatFrame
    ns:log(libName, 'chatFrame:', chatFrame:GetName())
    ns:log(libName, 'options:', { 1, 2, 3 })
    ns:log(libName, 'tab-name:', chatFrame:GetTabName())
  end)
end

--[[-----------------------------------------------------------------------------
Event Hooks
-------------------------------------------------------------------------------]]
-- LoadOnDemand loads after login, so PLAYER_LOGIN never fires
o:RegisterEvent('ADDON_LOADED', 'OnAddonLoaded')
