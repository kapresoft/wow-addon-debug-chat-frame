local x = {
  -- manual load
  function()
    -- /dump EnableAddOn('DebugChatFrame', UnitName('player'))
    -- /dump LoadAddOn('DebugChatFrame')
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
