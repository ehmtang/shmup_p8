-- Base flowstate class 
flowstate = class:new({

    begin = function(_ENV)
    end,

    update = function(_ENV)
        return nil
    end,

    draw = function(_ENV)
    end,

    finish = function(_ENV)
    end
})

flowstate_manager = class:new({
    fstate = flowstate:new(),
    new_state = nil,

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
})