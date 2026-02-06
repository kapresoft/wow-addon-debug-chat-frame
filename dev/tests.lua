local x = {
  -- manual load
  function()
    -- /dump EnableAddOn('DebugChatFrame', UnitName('player'))
    -- /dump LoadAddOn('DebugChatFrame')
  end,
  -- PreReq: Temporarily set LoadOnDemand: 0
  function()
    -- /run
    (function()
      local dcf = DebugChatFrame; local opt = { chatFrameTabName = 'Test'}; DebugChatFrame:New(opt, function(cf) print('chatFrame:', tostring(cf)) end)
    end)()
  end
}
