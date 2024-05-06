-- Splash Screen 
splash_fs = flow_state:new({
    begin = function(_ENV)
        doors_obj.openness = 0.0
        doors_obj.splash = true
    end;

    update = function(_ENV)
        if btnp(5) then
            return menu_fs
        end
    end;

    draw = function(_ENV)
        doors_obj:draw()
        print_bold_r_aligned("@broccolly", 126, 98, 11, 0)
        print_bold_r_aligned("@ehmtang", 126, 106, 11, 0)
        print_bold_r_aligned("music @jemh2k", 126, 114, 11, 0)
    end
})