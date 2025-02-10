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
        spr(sprite_id + frame, pos_x, pos_y)
    end,
})
