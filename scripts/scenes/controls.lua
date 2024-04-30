controls_fs=flow_state({
    t=0
    update = function(_ENV)
        t+=elapsed_time
    end

    draw = function(_ENV)
        disp_text("welcome to lift summoner deluxe 1997 : deluxe edition!", 64, 32, 7)
        disp_text("can you summon the lifts to the right places at the right time?", 64, 38, 7)

        disp_text("press z to continue or x to return to menu", 64, 120)
    end


})

controls2_fs=flow_state({

})

function disp_text(txt, x, y, c)
    print(txt,x-(#txt/2)*4, y, c)
end