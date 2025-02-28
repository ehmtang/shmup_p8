-- Stars derived from gameobject
local star = game_object:new({
    spd = .5,
    rad = 0,
    clr = 7,

    init = function (_ENV)
        add(g_obj_manager.p_objs, _ENV)
    end,

    update = function(_ENV)
        pos_y += spd

        if pos_y - rad > 137 then
            pos_y = -rad
        end
    end,

    draw = function(_ENV)
        circfill(pos_x, pos_y, rad, clr)
    end
})

local far_star = star:new({
    spd = .25,
    rad = 0
})

local near_star = star:new({
    spd = .75,
    rad = 1,

    new = function(self, tbl)
        tbl = star.new(self, tbl)
        tbl.spd = tbl.spd + rnd(.5)
        return tbl
    end
})