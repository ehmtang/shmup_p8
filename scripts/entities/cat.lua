cat_obj=g_obj:new({

    init=function(_ENV, _elevators, _allowed_targets)
        r_elevators=_elevators
        current_floor=rnd(floors)
        while #_allowed_targets[current_floor] == 0 do
            current_floor=rnd(floors)
        end
        target_floor=-1
        y=floory[current_floor]
        x=128
        dir=-1
        spr_id=flr(rnd(2))+14
        state="enter"
        spd=0.4
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
        end
    end,

    draw=function(_ENV)
        if (state=="normal") then
            spr(spr_id + (flr(time()*8*spd)%2)*32 + ((dir/2.0)+0.5)*16,x,y)
        end
    end,

    enter_lift=function(self, elevator)
        if (#elevator.customer_in_elevator<elevator.max_capacity) then
            add(elevator.customer_in_elevator, self)
            self.state="lift"
        end
    end,

    arrive=function(_ENV, floor)
        current_floor=floor
        y=floory[current_floor]
        state="normal"
    end
    
})