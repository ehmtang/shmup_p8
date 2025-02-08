bullet_obj = g_obj:new({
    vel_y = -3,
    sprite_id = 16,

    update = function(_ENV)
        g_obj.update(_ENV)
    end,

    draw = function(_ENV)
        g_obj.draw(_ENV)
    end,
})
