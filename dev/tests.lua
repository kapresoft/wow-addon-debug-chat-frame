local x = {
  -- manual load
  function()
    -- /dump C_AddOns.EnableAddOn('DebugChatFrame', UnitName('player'))
    -- /dump C_AddOns.LoadAddOn('DebugChatFrame')
    -- /run
      (function()
        DCF = 'DebugChatFrame'; CA=C_AddOns EA = CA.EnableAddOn
        EA(DCF, UnitName('player'))
        C_Timer.After(0.5, function()
          CA.LoadAddOn(DCF); print(DCF, _G[DCF])
        end)
      end)()
    -- /dump DebugChatFrame
    -- Setup
    -- /run
     (function()
       DCF = 'DebugChatFrame'; CA=C_AddOns EA = CA.EnableAddOn
       function _ver() local c = _G[DCF]; print(DCF, 'Loaded:', c and c:GetAddonInfo()) end
       function _load() CA.LoadAddOn(DCF) C_Timer.After(0.5, _ver) end
     end)()
    -- /run
    (function() EA(DCF, UnitName('player')); _load()
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
