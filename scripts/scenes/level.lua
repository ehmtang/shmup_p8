base_level_fs = flow_state:new({
    spawn_rate_0 = 5,

    spawn = function(_ENV)
        local a = 0  -- Ensure 'a' is local if it's not meant to be global
    end,

    begin = function(_ENV)
        state = "intro"

        -- Initialize player and UI if required
        -- _ENV:spawn()  -- Uncomment if needed

        -- player = player_obj:new()
        -- player:init(elevators)  -- Ensure 'elevators' is properly defined

        -- ui_obj:init()  -- Uncomment if `ui_obj` needs initialization
    end,

    update = function(_ENV)
        -- Ensure `player` and `ui_obj` exist before calling their methods
        if player then player:update() end
        if ui_obj then ui_obj:update() end
    end,

    draw = function(_ENV)
        cls()
        map(0, 0, 0, 0, 16, 16)

        if ui_obj then ui_obj:draw() end

        if state == "run" then
            -- Ensure `player` exists before drawing
            if player then player:draw() end
        end
    end
})
