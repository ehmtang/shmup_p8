menu_fs = flow_state:new({
    levels = { "easy", "normal", "hard" },
    scores = { nil, nil, nil },
    select = 0,

    begin = function(_ENV)
        flowstates = { easy_fs, normal_fs, hard_fs }
        select = 1
    end,

    update = function(_ENV)
        -- Move down
        if btnp(3) then
            select = select % #levels + 1
            -- Move up
        elseif btnp(2) then
            select = (select + #levels - 2) % #levels + 1
            -- Select level
        elseif btnp(5) then
            return flowstates[select]
        end
    end,

    draw = function(_ENV)
        -- fill the center 96x96 portion of the screen
        rectfill(16, 16, 111, 111, 1)

        -- Print Texts
        for i = 1, #levels do
            local txt = levels[i]
            local col = 12
            if select == i then
                txt = txt .. " <"
                col = 14
            end

            local px = 40                -- Center horizontally
            local py = 60 + (i - 1) * 10 -- Space evenly
            print(txt, px, py, col)      --Print level and cursor

            -- High score
            local score_txt = "" .. (flowstates[i].high_score or 0) -- Default to 0 if nil
            local score_x = 90 - (#score_txt * 4)                   -- Align to the right
            print(score_txt, score_x, py, col)                      -- Use the same py
        end
    end,

    finish = function(_ENV)
    end
})
