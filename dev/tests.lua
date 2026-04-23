local x = {
  -- manual load
  function()
    -- /dump C_AddOns.EnableAddOn('DebugChatFrame', UnitName('player'))
    -- /dump EnableAddOn('DebugChatFrame', UnitName('player'))
    -- /dump C_AddOns.LoadAddOn('DebugChatFrame')
    -- /run
    (function()
      C_AddOns.LoadAddOn('DebugChatFrame')
      local c = DebugChatFrame; print("DebugChatFrame=", c, 'info=', c:GetAddonInfo())
    end)()
  end,
  -- PreReq: Temporarily set LoadOnDemand: 0
  function()
    -- returns a global 'cf' for chatFrame instance
    -- /run
    (function()
      local dcf = DebugChatFrame; local opt = { chatFrameTabName = 'Test'}; cf = DebugChatFrame:New(opt, function(cf) print('chatFrame:', tostring(cf)); end)
    end)()
  end
}
