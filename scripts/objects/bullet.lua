bullet_obj = game_object:new({
    spr_id = 16,
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
    spr_x = 0,
    spr_y = 0,
    spr_w = 2,
    spr_h = 2,
    
    layer = LAYER_PLAYER_BULLET,
    mask = LAYER_ENEMY,

    update = function(_ENV)
        if pos_y < 0 or pos_y > 128 then
            active = false
        end

       -- update spr pos
       spr_x = pos_x +2
       spr_y = pos_y +2

       -- update physics
       vel_x += acc_x
       vel_y += acc_y
       pos_x += vel_x
       pos_y += vel_y
    end,

    draw = function(_ENV)
        rectfill( spr_x, spr_y, spr_x + spr_w, spr_y+spr_h, 8 )
        spr(spr_id + frame, pos_x, pos_y)
    end,
})

e_bullet_obj = bullet_obj:new({
    layer = LAYER_ENEMY_BULLET,
    mask = LAYER_PLAYER,
})