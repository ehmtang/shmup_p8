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
    name ="",
    active = true,

    new = function(self, tbl)
        tbl = tbl or {}
        setmetatable(tbl, { __index = self })
        add(g_obj_manager.g_objs, tbl)
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

g_obj_manager = {
    g_objs = {},

    update = function(_ENV)
        foreach(g_objs, function(obj) obj:update() end)
        _ENV:delete_inactive()
    end,

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

}

setmetatable(g_obj_manager, { __index = _ENV }) -- Allow access to globals if needed
-- to inherit from this class do this

--new_obj=g_obj:new({
--  x=5, 
--  update=function(_ENV)
--  {
--      x++}
--  })

--for global assignment inside class use
