floors={1,2,3,4}

floorcols = {12, 11, 10, 8}
--r_elevators={}
customer=g_obj:new({
    init=function(_ENV, _elevators, _allowed_targets)
        r_elevators=_elevators
        current_floor=rnd(floors)
        while #_allowed_targets[current_floor] == 0 do
            current_floor=rnd(floors)
        end
        target_floor=rnd(_allowed_targets[current_floor])
        
        y=floory[current_floor]

        local side = flr(rnd(2))
        if side==0 then --spawn on left
            x=0-rnd(20)
            dir=1
        else
            x=128+rnd(20)
            dir=-1
        end
        patience=120
        spr_id=flr(rnd(13))+1
        state="enter"
        spd=0.5
    end,

    update=function(_ENV)
        if (state=="enter") then
            x+=dir*spd
            if not (x>=127 or x<=0) then
                state="normal"
            end
        elseif (state=="normal") then
            x+=dir*spd
            if (x>120) then
                x=120
                dir=-dir
            elseif (x<0) then
                x=0
                dir=-dir
            elseif (flr(rnd(30))==1) then
                    dir=-dir
            end 
            
            
            
            patience-=0.2
            if(patience<1) then
                state="strop"
                ui_obj:hit_tag(x,y,-1)
                strop_time=0.0
            elseif (patience<40) then
                spd=1.5
            elseif (patience<80) then
                spd=1.0 
            end
            local target_lift=0

            local best_dist=64.0
            for elevator in all(r_elevators) do
                local dist=elevator.pos_x - (x+4)
                if (elevator:is_elevator_open_on_floor(current_floor)) then
                    if (abs(dist)<2.0) then
                        _ENV:enter_lift(elevator)
                        break
                    end
                    if(abs(dist)<best_dist) then
                        best_dist=dist
                        dir=dist/abs(dist)
                    end
                end
            end

        elseif (state=="strop") then
            strop_time+=0.10743
            y=floory[current_floor]+min(cos(strop_time),0)*10
            --camera(cos(strop_time)*2,sin(strop_time)*2)
        elseif (state=="lift") then
        elseif (state=="party") then
            x+=0.5*dir
            y=floory[current_floor]-abs(cos(x*0.1))*8
            if (x>127) or (x<0) then
                state="success"
            end
        end
    end,

    draw=function(_ENV)
        if (state=="normal" or state=="strop" or state=="party") then
            spr(spr_id + (flr(time()*8*spd)%2)*32 + ((dir/2.0)+0.5)*16,x,y) --
            
            local x_=x+1
            local y_=y-7
            print(target_floor, x_, y_+1, 7)
            print(target_floor, x_+2, y_+1, 7)
            print(target_floor, x_+1, y_, 7)
            print(target_floor, x_+1, y_+2, 7)
            local num_col=0
            if (state=="strop") then
                num_col=8
            end
            
            print(target_floor, x_+1, y_+1, num_col)
            local patience_col=3
            if(patience<80) then 
                patience_col=10
            end
            if(patience<40) then
                patience_col=8
            end
            y_=y_
            local h=5-flr(5*(patience%40)/40 +1)
            if (patience>0) then
                line(x_+4,y_,x_+4,y_+6,7)
                line(x_+5,y_,x_+5,y_+6,7)
                line(x_+5,y_+1,x_+5,y_+5,0)
                line(x_+6,y_+1,x_+6,y_+5,7)
                line(x_+5,y_+1+h,x_+5,y_+5,patience_col)
            end
        end
    end,

    enter_lift=function(self, elevator)
        if (#elevator.customer_in_elevator<elevator.max_capacity) then
            add(elevator.customer_in_elevator, self)
            self.state="lift"
        end
    end,

    strop_time=0.0,
    get_strop=function(_ENV)
        return (strop_time>0)
    end,

    arrive=function(_ENV, floor)
        current_floor=floor
        y=floory[current_floor]

        if (current_floor==target_floor) then
            state="party"
            dir=(x-64)
            if (dir==0) then
                dir=1
            else
                dir=dir/abs(dir)
            end
        else
            state="normal"
            dir=rnd({-1,1})
        end
    end
})