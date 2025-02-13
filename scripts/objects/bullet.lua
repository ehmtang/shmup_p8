bullet_obj = game_object:new({
    sprite_id = 16,
    pos_x = 0,
    pos_y = 0,
    vel_x = 0,
    vel_y = -3,
    acc_x = 0,
    acc_y = 0,
    frame = 0,
    frame_pos = 0,
    anim_speed = 0,
    nframes = 0,
    name ="bullet",
    active = true,
    rad = 3,
    off_x = 0,
    off_y = 0,
    spr_x = 0,
    spr_y = 0,
    spr_w = 0,
    spr_h = 0,
    
    layer = LAYER_PLAYER_BULLET,
    mask = LAYER_ENEMY,

    update = function(_ENV)
        if pos_y < 0 or pos_y > 128 then
            active = false
        end

        vel_x += acc_x
        vel_y += acc_y
        pos_x += vel_x
        pos_y += vel_y
    end,

    draw = function(_ENV)
        circfill(pos_x+off_x, pos_y+off_y, rad, 8)
        spr(sprite_id + frame, pos_x, pos_y)
    end,
})

e_bullet_obj = bullet_obj:new({
    layer = LAYER_ENEMY_BULLET,
    mask = LAYER_PLAYER,
})