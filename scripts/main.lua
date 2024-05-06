--main

function _init()
    clear_log()
    cls()
    music(0)
    flow_state_manager:set_state(splash_fs)
  
    _global=_ENV --allows global access inside tables
    palt(7, true) -- white color as transparency is true
    palt(0, false) -- black color as transparency is false
end
    
function _update()
    flow_state_manager:update_state()
end

function _draw()
    cls()
    flow_state_manager:draw_state()
end