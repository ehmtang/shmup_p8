pico-8 cartridge // http://www.pico-8.com
version 42
__lua__

pal(0, 129, 1) -- turn black to dark blue

-- START MAIN
function _init()
    flowstate_manager:set_state(splash_fs)
end

function _update()
    flowstate_manager:update_state()
end

function _draw()
    cls()
    flowstate_manager:draw_state()
end
-- END MAIN

-- Base class from all objects are derived from
global = _ENV

class = setmetatable(
    {
        new = function(_ENV, tbl)
            tbl = tbl or {}
            setmetatable(tbl, { __index = _ENV })
            return tbl
        end, init = function() end
    }, { __index = _ENV }
)

-- Base gameobject class
game_object = class:new({
    x = 0,
    y = 0,
    active = true,

    init = function(_ENV)
    end,

    update = function(_ENV)
    end,

    draw = function(_ENV)
    end
})

-- Stars derived from gameobject
star = game_object:new({
    spd = .5,
    rad = 0,
    clr = 13,

    update = function(_ENV)
        y += spd

        if y - rad > 137 then
            y = -rad
            splash_fs.score += 1
        end
    end,

    draw = function(_ENV)
        circfill(x, y, rad, clr)
    end
})

far_star = star:new({
    clr = 1,
    spd = .25,
    rad = 0
})

near_star = star:new({
    clr = 7,
    spd = .75,
    rad = 1,

    new = function(self, tbl)
        tbl = star.new(self, tbl)
        tbl.spd = tbl.spd + rnd(.5)
        return tbl
    end
})

-------------------------------------------

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

splash_fs = flowstate:new({
    begin = function(_ENV)
        local STAR_COUNT = 50

        score = 0
        stars = {}
        star_types = { star, near_star, far_star }
    
        for i = 1, STAR_COUNT do
            local star_type = rnd(star_types)
            add(stars, star_type:new({ x = rnd(127), y = rnd(127) }))
        end
    end,

    update = function(_ENV)
        foreach(stars, function(star) star:update() end)
        return nil
    end,

    draw = function(_ENV)
        foreach(stars, function(star) star:draw() end)
        print("score: " .. score, 8, 8, 7)

        local txt = "splash screen"
        print(txt, 64 - (#txt * 2), 60, 12)
        txt = "press ❎ to start"
        print(txt, 64 - (#txt * 2), 68, 12)
        
        print(#stars, 120, 5, 7)

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

g_obj_manager = class:new({
    g_objs = {},

    update = function(_ENV)
        foreach(g_objs, function(obj) obj:update() end)
        _ENV:delete_inactive()
    end,

    draw = function(_ENV)
        foreach(g_objs, function(obj) obj:draw() end)
    end,

    delete_inactive = function(_ENV)
        for obj in all(g_objs) do
            if not obj.active then
                del(g_objs, obj)
            end
        end
    end,
})