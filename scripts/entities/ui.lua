ui_obj = g_obj:new({
    tags={},
    mult=1,
    rage=0,
    max_rage=5,
    total_score=0,
    init = function(_ENV)
        mult=1
        total_score=0
        rage=0
        tags={}
    end,

    update = function(_ENV)
        i=1
        c=#tags
        while i <= c do
            local tag=tags[i]
            tag.t+=0.033
            if tags[i].t < 0.8 then
                --stop()
                tag.y-=0.25
            elseif tag.t < 1.5 then
                tag.x += (124 - tag.x)*0.1               
                tag.y += (  2 - tag.y)*0.1
            else
                if (tag.p==-1) then
                    rage+=1
                else
                    total_score+=mult*tag.p*tag.p
                end

                --mult
                if (tag.p==0) then
                    mult=1
                elseif (tag.p==0) then
                    mult=1
                elseif (tag.p==1) then
                elseif (tag.p==2) then
                    mult=min(mult+1,10)
                end
                deli(tags,i)
                i-=1
                c-=1
            end
            i+=1
        end
    end,

    draw = function(_ENV)
        --rectfill(128-24,0,128,16,0)
        local txt=tostr(total_score)
        print(txt, 124-#txt*4-1,2,0)
        print(txt, 124-#txt*4+1,2,0)
        print(txt, 124-#txt*4,2+1,0)
        print(txt, 124-#txt*4,2-1,0)
        print(txt, 124-#txt*4,2,7)

        txt="x"..mult
        print(txt, 124-#txt*4-1,10,0)
        print(txt, 124-#txt*4+1,10,0)
        print(txt, 124-#txt*4,10+1,0)
        print(txt, 124-#txt*4,10-1,0)
        print(txt, 124-#txt*4,10,12)

        txt=rage.."/"..max_rage
        print(txt, 124-#txt*4-1,18,0)
        print(txt, 124-#txt*4+1,18,0)
        print(txt, 124-#txt*4,18+1,0)
        print(txt, 124-#txt*4,18-1,0)
        print(txt, 124-#txt*4,18,8)

        for tag in all(tags) do
            if tag.t < 0.8 then
                local col
                local txt_tag=""
                if (tag.p==-1) then
                    txt_tag="rage!"
                    col=8
                elseif (tag.p==0) then
                    txt_tag="miss"
                    col=8
                elseif (tag.p==1) then
                    txt_tag="good"
                    col=11
                elseif (tag.p==2) then
                    txt_tag="perfect"
                    col=2
                end
                if(flr(tag.t/0.1)%2==0) then
                    col=7
                end

                local tmp_x = tag.x-(#txt_tag/2)*4
                local tmp_y=tag.y
                print(txt_tag, tmp_x+1, tmp_y, 0)
                print(txt_tag, tmp_x-1, tmp_y, 0)
                print(txt_tag, tmp_x, tmp_y+1, 0)
                print(txt_tag, tmp_x, tmp_y-1, 0)
                print(txt_tag, tmp_x, tmp_y, col)
            elseif tag.t<1.5 then
                if (tag.p==0) then
                    col=8
                elseif (tag.p==1) then
                    col=11
                elseif (tag.p==2) then
                    col=2
                end
                if(flr(tag.t/0.1)%2==0) then
                    col=7
                end
                circfill(tag.x, tag.y,3,0)
                circfill(tag.x, tag.y,2,col)
            end
        end
    end,

    hit_tag=function(_ENV, _x, _y, _perfect_level)
        add(tags, {x=_x,y=_y-6,p=_perfect_level,t=0})
        _ENV:sound_event(_perfect_level)
    end,

    sound_event = function(_ENV, _perfect_level)
        -- -1 rage
        if(_perfect_level == -1) then
            sfx(18) 
        -- 0 miss
        elseif(_perfect_level == 0) then
            sfx(19) 
        -- 1 good
        elseif(_perfect_level == 1) then
            sfx(20)
        -- 2 perfect
        elseif(_perfect_level == 2) then
            sfx(21)
        end
    end
})