-- Base class from all objects are derived from
class       = setmetatable(
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



-- Define collision masks
eBullet = { layer = LAYER_ENEMY_BULLET, mask = LAYER_PLAYER } -- Enemy Bullets hit Player


g_obj_manager = class:new({
    g_objs = {},

    update = function(_ENV)
        _ENV:delete_inactive()
        foreach(g_objs, function(obj) obj:update() end)
    end,

    -- check_collision = function(_ENV)
    --     local filter = {}
    --     for i = 1, #g_objs do
    --         if g_objs[i].layer then
    --             add(filter, g_objs[i])
    --         end
    --     end

    --     for i = 1, #filter do
    --         local g_objA = filter[i]
    --         for j = i + 1, #filter do
    --             local g_objB = filter[j]

    --             if canCollide(g_objA, g_objB) and circleCollide(g_objA, g_objB) then
    --                 add(collisions, { a = g_objA, b = g_objB })
    --             end
    --         end
    --     end
    -- end,

--     resolve_collision = function(_ENV)
--         for _, collision in ipairs(collisions) do
--             local a, b = collision.a, collision.b

--             -- Enemy Bullet hits Player
--             if (a.layer == LAYER_ENEMY_BULLET and b.layer == LAYER_PLAYER) or
--             (a.layer == LAYER_PLAYER and b.layer == LAYER_ENEMY_BULLET) then
--                 b.lives -= 1
--                 a.active = false

--                 -- Player Bullet hits Enemy
--             elseif a.layer == LAYER_PLAYER_BULLET and b.layer == LAYER_ENEMY then
--                 b.lives -= 1
--                 a.active = false
--                 stop(a.layer .. " and " .. b.layer, 0, 64, 7)
--             end
--         end
--         collisions = {}
--     end,

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

-- -- Symmetry in Collision Map: The collision_map now uses a single function for cases like the 
-- -- bullet hitting the player, regardless of the order (player or bullet being a or b). 
-- -- For example, if a is the player and b is the bullet, it will call 
-- -- handle_player_bullet_collision(a, b). If a is the bullet and b is the player, 
--  -- it calls handle_player_bullet_collision(b, a). This removes duplication.

-- --     Helper Functions: The helper functions like handle_player_bullet_collision are used to 
-- -- encapsulate specific logic, making it reusable and avoiding repetitive code.
    
-- --     Simplified Collision Resolution: The resolve_collision function no longer needs separate 
-- -- checks for (a, b) and (b, a). It simply checks the map for the correct behavior and calls it.

-- -- Collision handler map: Maps layer pair collisions to behavior functions

-- collision_map = {
--     [LAYER_PLAYER] = {
--         [LAYER_ENEMY_BULLET] = function(a, b)
--             -- Both cases (a is player, b is enemy bullet) or (a is enemy bullet, b is player)
--             handle_player_bullet_collision(a, b)
--         end,
--         [LAYER_ENEMY] = function(a, b)  -- Player vs Enemy
--             handle_player_enemy_collision(a, b)
--         end
--     },
--     [LAYER_ENEMY_BULLET] = {
--         [LAYER_PLAYER] = function(a, b)
--             -- Reuse the same function as the previous case, just swap a and b
--             handle_player_bullet_collision(b, a)  -- b is player, a is bullet
--         end
--     },
--     [LAYER_PLAYER_BULLET] = {
--         [LAYER_ENEMY] = function(a, b)
--             -- Player Bullet vs Enemy
--             handle_player_bullet_collision(a, b)
--         end
--     }
-- }

-- -- Handle player bullet collision (both directions)
-- function handle_player_bullet_collision(player, bullet)
--     player.lives = player.lives - 1  -- Player takes damage
--     bullet.active = false  -- Bullet becomes inactive
-- end

-- -- Handle player and enemy collision (both directions)
-- function handle_player_enemy_collision(player, enemy)
--     player.lives = player.lives - 1  -- Player takes damage
--     enemy.lives = enemy.lives - 1  -- Enemy takes damage (if desired)
-- end

-- -- resolve_collision = function(_ENV)
-- --     for _, collision in ipairs(collisions) do
-- --         local a, b = collision.a, collision.b

-- --         -- Check if a handler exists for the collision pair (regardless of order)
-- --         if collision_map[a.layer] and collision_map[a.layer][b.layer] then
-- --             -- Call the appropriate handler function
-- --             collision_map[a.layer][b.layer](a, b)
-- --             print(a.layer .. " and " .. b.layer, 0, 64, 7)  -- Debugging output
-- --             stop()  -- Optional: Stop for debugging
-- --         end
-- --     end
-- --     collisions = {}  -- Clear the list of collisions after processing
-- -- end
