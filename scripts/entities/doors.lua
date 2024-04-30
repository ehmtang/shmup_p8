doors_obj=g_obj:new({
    openness = 1.0,
    open_dir = 0,
    h = 0.0,
    moving=false,
    use = false,

    update=function(_ENV)
        if (use) then
            openness+=open_dir*0.04
            if (open_dir==1) then
                if (openness > 1.0) then
                    openness=1.0
                    open_dir=0
                    use=false
                end
            elseif (open_dir==0) then
                if (moving) then
                    h+=0.02
                    if (h>1.0) then
                        h=0.0
                        open_dir=1
                        moving=false
                    end
                end
            elseif(open_dir==-1) then
                if(openness<0.0) then
                    openness=0.0
                    open_dir=0
                    moving = true
                end
            end
        end
    end,

    draw=function(_ENV)
        if (moving) then
            local y_dark = -128 + h*256
            rectfill(60,0,68,128, 15)
            rectfill(60,y_dark,68,y_dark+128, 1)
        end
        local x=-64*openness
        rectfill(x,0,x+63,127, 5)
        rectfill(x,2,x+61,125, 6)
        
        rectfill(127-x,0,127-(x+63),127, 5)
        rectfill(127-x,2,127-(x+61),125, 6)
        spr(137,x+32, 40, 4, 4)       
        spr(141, 127-(x+63), 40,3,4)
    end,

    transition=function(_ENV)
        h=0.0
        openness=1.0
        open_dir=-1
        use=true
    end,

    onclose=function(_ENV)

    end
})