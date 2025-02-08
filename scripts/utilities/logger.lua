function clear_log()
    printh("LOG START : ", "scripts/logs/log")
end

function log(value)
    printh(value, "scripts/logs/log")
end

function _draw()
    cls()

    if btn(5) then
        printh("test", "scripts/logs/log")
    end
end