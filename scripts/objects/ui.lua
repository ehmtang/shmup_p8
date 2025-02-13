ui_obj = class:new({
    tags = {},
    mult = 1,
    --score = 0,
    name = "ui",
    init = function(_ENV)
        mult = 1
        total_score = 0
    end,

    update = function(_ENV)

    end,

    draw = function(_ENV)

        for index, value in ipairs(g_obj_manager.g_objs) do
            print(index..": "..value.name)
            
        end


        --print("score: " .. level_fs.score, 0, 1, 7)
        for i = 1, 4 do
            if level_fs.player.lives >= i then
                spr(level_fs.player.full_heart_spr, g_scrn[1] - i * 9, 1)
            else
                spr(level_fs.player.empty_heart_spr, g_scrn[1] - i * 9, 1)
            end
        end
    end,

    hit_tag = function(_ENV)
    end,

    sound_event = function(_ENV)
    end
})
