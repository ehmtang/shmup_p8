-- Definition for generic game objects
flow_state = {
    new = function(self, tbl)
        tbl = tbl or {}
        setmetatable(tbl, { __index = self })
        return tbl
    end,

    begin = function(_ENV)
    end,

    update = function(_ENV)
        -- _ENV in the argument allows internal values to be accessed without "self."
        return nil  -- Return nil by default, but this can be overridden
    end,

    draw = function(_ENV)
    end,

    finish = function(_ENV)
    end
}

flow_state_manager = {
    fstate = flow_state:new(),  -- Current state
    new_state = nil,  -- State that might be switched to

    update_state = function(_ENV)
        -- Allow state transitions based on the current state's update
        new_state = fstate:update()
        if new_state then
            --_ENV:set_state(new_state)
        end
    end,

    draw_state = function(_ENV)
        fstate:draw()
    end,

    set_state = function(_ENV, fs)
        fstate:finish()
        fstate=fs
        fstate:begin()
    end
}

setmetatable(flow_state_manager, { __index = _ENV })  -- Allow access to globals if needed
