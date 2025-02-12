global = _ENV

-- Main function
function _init()
    cls()
    flowstate_manager:set_state(splash_fs)
end

-- Update function
function _update()
    g_time += g_dt
    g_obj_manager:update()
    ui_obj:update()
    flowstate_manager:update_state()
end

-- Draw function
function _draw()
    cls()
    g_obj_manager:draw()
    ui_obj:draw()
    flowstate_manager:draw_state()
end
