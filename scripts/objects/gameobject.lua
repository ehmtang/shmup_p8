-- Base class from all objects are derived from
class = setmetatable(
    {
        new = function(_ENV, tbl)
            tbl = tbl or {}
            setmetatable(tbl, { __index = _ENV })

            -- Call init() if it exists
            if tbl.init then tbl:init() end
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
    p_objs = {},
    friend_objs = {},
    pbullet_objs = {},
    enemy_objs = {},
    ebullet_objs = {},

    update = function(_ENV)
        _ENV:delete_inactive(p_objs)
        _ENV:delete_inactive(friend_objs)
        _ENV:delete_inactive(pbullet_objs)
        _ENV:delete_inactive(enemy_objs)
        _ENV:delete_inactive(ebullet_objs)

        foreach(p_objs, function(obj) obj:update() end)
        foreach(friend_objs, function(obj) obj:update() end)


        stop(#p_objs)


        foreach(pbullet_objs, function(obj) obj:update() end)
        foreach(enemy_objs, function(obj) obj:update() end)
        foreach(ebullet_objs, function(obj) obj:update() end)
        --_ENV:resolve_collision()
    end,

    draw = function(_ENV)
        foreach(p_objs, function(obj) obj:draw() end)
        foreach(friend_objs, function(obj) obj:draw() end)
        foreach(pbullet_objs, function(obj) obj:draw() end)
        foreach(enemy_objs, function(obj) obj:draw() end)
        foreach(ebullet_objs, function(obj) obj:draw() end)
    end,

    delete_inactive = function(_ENV, tbl)
        for i = #tbl, 1, -1 do 
            if not tbl[i].active then
                del(tbl, tbl[i])
            end
        end
    end,

    clear_all = function (_ENV)
        p_objs = {}
        friend_objs = {}
        pbullet_objs = {}
        enemy_objs = {}
        ebullet_objs = {}
    end,

    resolve_collision = function(_ENV)
        -- Player bullets vs Enemies
        for _, bullet in ipairs(pbullet_objs) do
            if bullet.active then
                for _, enemy in ipairs(enemy_objs) do
                    if enemy.active and canCollide(bullet.mask, enemy.layer) and aabb_intersect(bullet, enemy) then
                        stop()
                        bullet:resolve_collision(enemy)
                        enemy:resolve_collision(bullet)
                    end
                end
            end
        end
    
        -- Enemy bullets vs Friendly objects
        for _, bullet in ipairs(ebullet_objs) do
            if bullet.active then
                for _, friend in ipairs(friend_objs) do
                    if friend.active and canCollide(bullet.mask, friend.layer) and aabb_intersect(bullet, friend) then
                        bullet:resolve_collision(friend)
                        friend:resolve_collision(bullet)
                    end
                end
            end
        end
    
        -- Enemies vs Friendly objects
        for _, enemy in ipairs(enemy_objs) do
            if enemy.active then
                for _, friend in ipairs(friend_objs) do
                    if friend.active and canCollide(enemy.mask, friend.layer) and aabb_intersect(enemy, friend) then
                        enemy:resolve_collision(friend)
                        friend:resolve_collision(enemy)
                    end
                end
            end
        end
    end
    
    
})