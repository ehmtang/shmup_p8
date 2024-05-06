test_fs = level_fs:new({
    elevator_doors = { { 1, 2 }, {}, {}, { 1, 2 } },
    allowed_targets = { { 2 }, { 1 }, {}, {} },
    spawn_rate_0 = 3,
    spawn_rate_increase_per_wave = 2.0,
    cat_rate_0 = 0,
    cat_rate_increase_per_wave = 0.0,
    time_per_wave = 15.0,
    time_per_cat_wave = 20.0,
    title = "level1"
})