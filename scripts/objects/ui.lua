ui_obj = class:new({
    tags = {},
    mult = 1,
    --score = 0,
    name="ui",
    init = function(_ENV)
        mult = 1
        total_score = 0
    end,

    update = function(_ENV)

    end,

    draw = function(_ENV)
        print("score: "..level_fs.score,8,8,7)

    end,

    hit_tag = function(_ENV)
    end,

    sound_event = function(_ENV)
    end
})