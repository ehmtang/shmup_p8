level2_fs=level_fs:new({
    elevator_doors={{1,2,3},{2,3},{},{1,2}},
    allowed_targets = {{2},{1,3},{2},{}},
    spawn_rate_0=5,
    spawn_rate_increase_per_wave=2.0,
    cat_rate_0 =1,
    cat_rate_increase_per_wave=1.5,
    time_per_wave=15.0,
    time_per_cat_wave=20.0,
    title="level2",
})