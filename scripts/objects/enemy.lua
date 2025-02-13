DEFAULT = 0
HOMING = 1
SINE_WAVE = 2
TELEPORT = 3


enemy_obj = game_object:new({
    sprite_id = 21,
    pos_x = 0,
    pos_y = 0,
    vel_x = 0,
    vel_y = 0,
    acc_x = 0,
    acc_y = 0,
    frame = 0,
    frame_pos = 0,
    anim_spd = 0.2,
    nframes = 4,
    name = "enemy",
    active = true,
    rad = 10,
    off_x = 4,
    off_y = 4,
    spr_x = 0,
    spr_y = 0,
    spr_w = 8,
    spr_h = 8,

    max_vel = 1,

    vel_decay = 0.05,
    acc_decay = 0.1,

    fire_time = 0,
    fire_rate = 0.3,
    lives = 1,

    layer = LAYER_ENEMY,
    mask = LAYER_PLAYER | LAYER_PLAYER_BULLET,

    pattern = DEFAULT,

    init = function(_ENV)

    end,

    update = function(_ENV)
        fire_time += g_dt

        -- clamp velocities
        if ssqr(vel_x, vel_y) > max_vel * max_vel then
            local nvel_x, nvel_y = norm(vel_x, vel_y)
            vel_x = nvel_x * max_vel
            vel_y = nvel_y * max_vel
        end

        -- exhaust animation
        frame_pos += anim_spd
        if (frame_pos > 1) then
            frame += 1
            frame_pos -= 1

            if frame >= nframes then
                frame = 0
            end
        end

        if lives <= 0 then
            active = false
        end

        vel_x += acc_x
        vel_y += acc_y
        pos_x += vel_x
        pos_y += vel_y
    end,

    draw = function(_ENV)
        spr_x = pos_x
        spr_y = pos_y
        rectfill(spr_x, spr_y, spr_x + spr_w, spr_y + spr_h, 8)

        spr(sprite_id + frame, pos_x, pos_y)
    end,

    shoot_bullet = function(_ENV)
        sfx(0)
        add(g_obj_manager.g_objs, e_bullet_obj:new({ pos_x = pos_x, pos_y = pos_y - 2 }))
        fire_time = 0
    end,

})
