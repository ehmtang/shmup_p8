-- Splash Screen 
splash_fs = flow_state:new({
    begin = function(_ENV)
        print("Splash Screen Begin")
    end,

    update = function(_ENV)
        print("Splash Screen Update")
    end,

    draw = function(_ENV)
        print("Splash Screen Draw")
        print("this is pico-8", 37, 70, 14)
    end
})
