bullet_obj = g_obj:new({
    vel_y = -3,
    sprite_id = 16,
    active = true,
    name = "bullet",
    update = function(_ENV)
        if pos_y < 0 or pos_y > 128 then
            active = false
        end

        g_obj.update(_ENV)
    end,

    draw = function(_ENV)
        g_obj.draw(_ENV)
    end,
})
