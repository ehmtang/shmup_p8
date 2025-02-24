camera_obj = class:new({
    x = 0,
    y = 0,
    offX = 0,
    offY = 0,
    name = "cam",
    
    cx1 = {},
    cx2 = {},
    cx3 = {},

    cy1 = {},
    cy2 = {},
    cy3 = {},

    shake_time = 0,  -- Timer for how long shake lasts
    shake_amplitude = 0,
    timer = 0,

    init = function (_ENV)
        _ENV:set_rnd_coeffs()
    end,

    update = function(_ENV)
        if shake_time > 0 then
            shake_time = shake_time - g_dt  -- Decrease shake time

            local fx1 = cx1[1] * sin(cx1[2] * g_time + cx1[3])
            local fx2 = cx2[1] * sin(cx2[2] * g_time + cx2[3])
            local fx3 = cx3[1] * sin(cx3[2] * g_time + cx3[3])
            offX = (fx1 + fx2 + fx3) * shake_amplitude
            
            local fy1 = cy1[1] * sin(cy1[2] * g_time + cy1[3])
            local fy2 = cy2[1] * sin(cy2[2] * g_time + cy2[3])
            local fy3 = cy3[1] * sin(cy3[2] * g_time + cy3[3])
            offY = (fy1 + fy2 + fy3) * shake_amplitude
        else
            offX, offY = 0, 0
        end
        
        camera(x + offX, y + offY)
    end,

    set_rnd_coeffs = function (_ENV)
        for i = 1, 3 do
            cx1[i] = rnd()*rnd(10) - 5
            cx2[i] = rnd()*rnd(10) - 5
            cx3[i] = rnd()*rnd(10) - 5
            cy1[i] = rnd()*rnd(10) - 5
            cy2[i] = rnd()*rnd(10) - 5
            cy3[i] = rnd()*rnd(10) - 5
        end
    end,

    set_shake = function(_ENV, amplitude, duration)
        shake_amplitude = amplitude
        shake_time = duration
    end
})
