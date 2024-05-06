function clear_log()
    printh("LOG START : ", "scripts/logs/log")
    --..stat(90).."-"..stat(91).."-"..stat(92).." "..stat(93)..":"..stat(94)..":"..stat(95), "scripts/logs/log", true)
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