camera_obj = g_obj:new({
    x = 0,
    y = 0,
    offX = 0,
    offY = 0,
    update = function(_ENV)
        camera(x + offX, y + offY)
    end,

    set_shake = function(_ENV, amplitude, angle)
        offX = amplitude * cos(angle)
        offY = amplitude * sin(angle)
    end
})