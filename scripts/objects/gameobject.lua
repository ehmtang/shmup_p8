-- Base class from all objects are derived from
class               = setmetatable(
    {
        new = function(_ENV, tbl)
            tbl = tbl or {}
            setmetatable(tbl, { __index = _ENV })
            return tbl
        end,
        init = function() end
    }, { __index = _ENV }
)

-- Base gameobject class
game_object         = class:new({
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



-- Define collision masks
eBullet             = { layer = LAYER_ENEMY_BULLET, mask = LAYER_PLAYER }  -- Enemy Bullets hit Player


g_obj_manager = class:new({
    g_objs = {},
    collisions = {},

    update = function(_ENV)
        foreach(g_objs, function(obj) obj:update() end)
        _ENV:delete_inactive()
    end,

    check_collision = function(_ENV)
        for i, g_objA in ipairs(g_objs) do
            for j = i + 1, #g_objs do
                local g_objB = g_objs[j]

                if canCollide(g_objA, g_objB) and circleCollide(g_objA, g_objB) then
                    add(collisions, { a = g_objA, b = g_objB })
                end
            end
        end
    end,

    resolve_collision = function(_ENV)
        for _, collision in ipairs(collisions) do
            local a, b = collision.a, collision.b

            -- Example: Enemy Bullet hits Player
            if a.layer == LAYER_ENEMY_BULLET and b.layer == LAYER_PLAYER then
                b.health = b.health - 1
                a.destroyed = true
            elseif a.layer == LAYER_PLAYER_BULLET and b.layer == LAYER_ENEMY then
                b.health = b.health - 1
                a.destroyed = true
            end
        end
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
