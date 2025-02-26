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

-- Define collision layers using bit flags
LAYER_PLAYER        = 0x01 -- 0001 (bit 0)
LAYER_ENEMY         = 0x02 -- 0010 (bit 1)
LAYER_PLAYER_BULLET = 0x04 -- 0100 (bit 2)
LAYER_ENEMY_BULLET  = 0x08 -- 1000 (bit 3)

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
    p_objs = {},

    update = function(_ENV)
        _ENV:delete_inactive()
        foreach(g_objs, function(obj) obj:update() end)
        foreach(p_objs, function(obj) obj:update() end)
    end,

    draw = function(_ENV)
        foreach(g_objs, function(obj) obj:draw() end)
        foreach(p_objs, function(obj) obj:draw() end)
    end,

    delete_inactive = function(_ENV)
        for obj in all(g_objs) do
            if not obj.active then
                del(g_objs, obj)
            end
        end

        for obj in all(p_objs) do
            if not obj.active then
                del(p_objs, obj)
            end
        end
    end,

    clear_all = function (_ENV)
        g_objs = {}
        p_objs = {}
    end
})