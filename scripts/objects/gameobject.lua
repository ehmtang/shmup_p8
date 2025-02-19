-- Base class from all objects are derived from
class = setmetatable(
    {
        new = function(_ENV, tbl)
            tbl = tbl or {}
            setmetatable(tbl, { __index = _ENV })

            -- Call init() if it exists
            if tbl.init then
                tbl:init()
            end

            return tbl
        end,
        init = function() end
    }, { __index = _ENV }
)

-- Base gameobject class
game_object = class:new({
    spr_id = 0,
    pos_x = 0,
    pos_y = 0,
    vel_x = 0,
    vel_y = 0,
    acc_x = 0,
    acc_y = 0,
    frame = 0,
    frame_pos = 0,
    anim_speed = 0,
    nframes = 0,
    name = "",
    active = true,

    rad = 0,
    
    spr_x = 0,
    spr_y = 0,
    spr_w = 0,
    spr_h = 0,

    layer = 0,
    mask = 0,

    init = function(_ENV)
    end,

    update = function(_ENV)
    end,

    draw = function(_ENV)
    end
})


g_obj_manager = class:new({
    g_objs = {},

    update = function(_ENV)
        _ENV:delete_inactive()
        foreach(g_objs, function(obj) obj:update() end)
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