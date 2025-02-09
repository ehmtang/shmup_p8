-- Definition for generic game objects
flow_state = {
    new = function(self, tbl)
        tbl = tbl or {}
        setmetatable(tbl, { __index = self })
        return tbl
    end,

    begin = function(_ENV)

    end,

    update = function(_ENV) --_ENV in the argument means internal values in the table are accessed without "self." saving tokens
        return nil
    end,

    draw = function(_ENV)

    end,

    finish = function(_ENV)

    end
}

setmetatable(flow_state, { __index = _ENV }) --this makes gives access to globals where needed via index

flow_state_manager = {
    fstate = flow_state:new(), -- Current state
    new_state = nil,           -- State that might be switched to

    update_state = function(_ENV)
        -- Allow state transitions based on the current state's update
        new_state = fstate:update()
        if (new_state ~= nil) then
            _ENV:set_state(new_state)
            new_state = nil
        end
    end,

    draw_state = function(_ENV)
        fstate:draw()
    end,

    set_state = function(_ENV, fs)
        fstate:finish()
        fstate = fs
        fstate:begin()
    end
}

setmetatable(flow_state_manager, { __index = _ENV }) -- Allow access to globals if needed
