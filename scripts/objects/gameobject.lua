-- definition for generic game objects
g_obj = {
    sprite_id = 0,
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

    new = function(self, tbl)
        tbl = tbl or {}
        setmetatable(tbl, { __index = self })
        return tbl
    end,

    init = function(_ENV)
    end,

    update = function(_ENV)
        vel_x += acc_x
        vel_y += acc_y
        pos_x += vel_x
        pos_y += vel_y

        _ENV:update_anim()
    end,

    update_anim = function(_ENV)
        frame_pos += anim_speed
        if (frame_pos > 1) then
            frame += 1
            frame_pos -= 1

            if frame > nframes then
                frame = 0
            end
        end
    end,

    draw = function(_ENV)
        spr(sprite_id + frame, pos_x, pos_y)
    end
}

setmetatable(g_obj, { __index = _ENV }) --this makes gives access to globals where needed via index

-- to inherit from this class do this

--new_obj=g_obj:new({
--  x=5, 
--  update=function(_ENV)
--  {
--      x++}
--  })

--for global assignment inside class use
