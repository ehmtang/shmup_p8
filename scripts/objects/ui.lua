ui_obj = g_obj:new({
    tags = {},
    mult = 1,
    rage = 0,
    max_rage = 5,
    total_score = 0,
    init = function(_ENV)
        mult = 1
        total_score = 0
    end,

    update = function(_ENV)

    end,

    draw = function(_ENV)
    end,

    hit_tag = function(_ENV)
    end,

    sound_event = function(_ENV)
    end
})