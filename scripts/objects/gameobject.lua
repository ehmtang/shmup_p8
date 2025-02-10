-- Base class from all objects are derived from
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
    active = true,

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