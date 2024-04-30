player_obj = g_obj:new({
    sprite_id = 73,
    elevator_idx = 0,
    pos_x = 0,
    pos_y = 0,
    elevators = {},
    sprite_offset_x = -8,
    sprite_offset_y = -7,

    elevator_x_pos={},

    init = function(_ENV, _elevators)

        elevator_x_pos={}

        elevators = _elevators
        for i=1,#_elevators do
            if #_elevators[i].floors>0 then
                add(elevator_x_pos,i)
            end
        end
        --current_elevator = _elevators[elevator_idx]
        if (#elevators>0) then
            elevator_idx=elevator_x_pos[1]
        end
        --pos_x = current_elevator.pos_x
        --pos_y = floory[current_elevator.current_floor_idx]
    end,

    update = function(_ENV)
        _ENV:player_ctrls()

        -- Update player position based on selected elevator
        -- if self.current_elevator then
        --     self.pos_x = self.current_elevator.pos_x
        --     self.pos_y = self.current_elevator.pos_y
        -- end
    end,

    draw = function(_ENV)
        local pos_x=elevators[elevator_x_pos[elevator_idx]].pos_x

        local line_top=floory[4]-4
        local line_bottom=floory[1]+8 
        line(pos_x-8,line_bottom, pos_x-8,line_top,7)
        line(pos_x+7,line_bottom, pos_x+7,line_top,7)

        local pos_y=floory[elevators[elevator_x_pos[elevator_idx]].current_floor_idx]


        -- if elevators[elevator_idx] then
        --     spr(sprite_id, pos_x, pos_y + sprite_offset_y, 2, 2)
        --     print(self.current_elevator.current_floor, 5, 5)
        -- end
    end,

    player_ctrls = function(_ENV)
        --toggle between elevators
        if btnp(1) and elevator_idx<#elevator_x_pos then
            elevator_idx+=1

        elseif btnp(0) and elevator_idx>1 then
            elevator_idx -= 1
        end

        --move elevator up and down
        if btnp(2) then
            elevators[elevator_x_pos[elevator_idx]]:go_up()

        elseif btnp(3) then
            elevators[elevator_x_pos[elevator_idx]]:go_down()
        end

        if btnp(5) then
            if elevators[elevator_x_pos[elevator_idx]] then
                if (elevators[elevator_x_pos[elevator_idx]].open) then
                    elevators[elevator_x_pos[elevator_idx]]:close_door()
                else
                    elevators[elevator_x_pos[elevator_idx]]:open_door()
                end
            end
        end
    end
})