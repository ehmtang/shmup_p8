pbullet_obj = game_object:new({

    init = function (_ENV)
        game_object:init()
        spr_id = 16
        name = "bullet"
        rad = 3
        spr_w = 2
        spr_h = 2
        layer = LAYER_PLAYER_BULLET
        mask = LAYER_ENEMY
        add(g_obj_manager.pbullet_objs, _ENV)
    end,

    update = function(_ENV)
        if pos_y < 0 or pos_y > 128 then
            active = false
        end

        -- update spr pos
        spr_x = pos_x + 2
        spr_y = pos_y +2

        -- update physics
        vel_x += acc_x
        vel_y += acc_y
        pos_x += vel_x
        pos_y += vel_y
    end,

    draw = function(_ENV)
        spr(spr_id + frame, pos_x, pos_y)
    end,

    resolve_collision = function(_ENV, other_obj)
        if other_obj.layer == LAYER_ENEMY then
            active = false
        end
    end
})

e_bullet_obj = pbullet_obj:new({
    layer = LAYER_ENEMY_BULLET,
    mask = LAYER_PLAYER,
    
    init = function (_ENV)
        add(g_obj_manager.ebullet_objs, _ENV)    
    end,

    resolve_collision = function(_ENV, other_obj)
        if other_obj.layer == LAYER_PLAYER then
            active = false
        end
    end
})
