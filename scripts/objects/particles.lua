particle_object = game_object:new({

    clr = 0,
    age = 0,
    max_age = 30,
    rad_inc = 0,

    update = function(_ENV)
        rad += rad_inc

        age += 1
        if age > max_age then
            active = false
        end

        -- update physics
        vel_x += acc_x
        vel_y += acc_y
        pos_x += vel_x
        pos_y += vel_y
    end,

    draw = function(_ENV)
        if clear then
            circ(pos_x, pos_y, rad, clr)
        else
            circfill(pos_x, pos_y, rad, clr)
        end
    end
})

function explosion_particles(n, pos_x, pos_y)
    local colours = { 8, 9, 10, 11, 12, 13, 14, 15 }
    for i = 1, n + rnd(n) do
        local particle = particle_object:new({
            pos_x = pos_x + 4 + rnd(4),
            pos_y = pos_y + 4 + rnd(4),
            vel_x = rnd() - 0.5,
            vel_y = rnd() - 0.5,
            clr = rnd(colours),
            rad = rnd() * 3,
            age = rnd() * 5,
            rad_inc = 0.01
        })
        add(g_obj_manager.p_objs, particle)
    end
end

function spark_particles(n, pos_x, pos_y)
    for i = 1, n + rnd(n) do
        local particle = particle_object:new({
            pos_x = pos_x + 4,
            pos_y = pos_y + 4,
            vel_x = rnd() - 0.5,
            vel_y = rnd() - 0.5,
            clr = 7,
            rad = 0,
        })
        add(g_obj_manager.p_objs, particle)
    end
end

function shockwave_particles(pos_x, pos_y, _rad, _age)
    local particle = particle_object:new({
        pos_x = pos_x + 4,
        pos_y = pos_y + 4,
        clr = 7,
        rad = _rad,
        rad_inc = 0.2,
        clear = true,
        age = _age
    })
    add(g_obj_manager.p_objs, particle)
end
