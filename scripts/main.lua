global = _ENV

-- Main function
function _init()
    cls()
    
    camera_obj:init()
    flowstate_manager:set_state(splash_fs)
end

-- Update function
function _update()
    g_time += g_dt
    global.g_blink += 1
    camera_obj:update()
    g_obj_manager:update()
    flowstate_manager:update_state()
end

-- Draw function
function _draw()
    cls()
    g_obj_manager:draw()
    flowstate_manager:draw_state()
end
