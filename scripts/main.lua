-- Main function
function _init()
    cls()  -- Clear the screen
    --music(0)  -- Start playing music (track 0)
  
    -- Ensure splash_fs is defined as a flow state before using it
    flow_state_manager:set_state(splash_fs)
  
    _global=_ENV --allows global access inside tables

    --palt(7, true)  -- Make color 7 (white) transparent
    --palt(0, false)  -- Make color 0 (black) non-transparent
end

-- Update function (called every frame)
function _update()
    flow_state_manager:update_state()  -- Update the current state
end

-- Draw function (called every frame)
function _draw()
    cls()  -- Clear the screen
    flow_state_manager:draw_state()  -- Draw the current state
end
