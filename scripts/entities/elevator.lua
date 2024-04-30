floory = {112, 80, 48, 16}
delta_time = 0.033

elevator_obj = g_obj:new({
    floors = {},
    pos_x = 0,
    bkg_sprite = 0,
    current_floor_idx = 1,
    target_floor_idx = 1,
    current_floor = 1,
    target_floor = 1,

    timer = 0,

    is_selected = false,
    max_capacity = 2,
    sprite_offset_x = -8,
    sprite_offset_y = -8,
    light_offset_x = -4,
    light_offset_y = -4,

    open = true,
    opening = 0,

    move_timer = 0,
    move_duration = 0,
    open_timer = 3,

    open_timer_speed = 0.5,
    state = "stop",

    init = function(_ENV, _x, _floors, _bkg_sprite)
        pos_x = _x
        floors = _floors

        -- Initialize current_floor to the bottommost floor
        current_floor_idx = 1
        current_floor = floors[current_floor_idx]
        target_floor_idx = current_floor_idx
        target_floor = floors[target_floor_idx]
        customer_in_elevator = {}
        bkg_sprite = _bkg_sprite
        -- for i = 1, #_floory_positions do
        --     if _floory_positions[i] ~= nil then
        --         self.current_floor_idx = i
        --         self.current_floor = _floory_positions[i]
        --         break
        --     end
        -- end
        opening = 0
        is_selected = false
        -- is_door_open = { false, false, false, false }
    end,

    update = function(_ENV)
        if state == "moving" then
            if open_timer > 0 then
                open_timer =open_timer-open_timer_speed --closing door
            end
            if open_timer <=0 then
                open_timer=0
                open = false
                move_timer += 0.033
            end
            if (move_timer >= move_duration) then
                _ENV:arrive()
            end
        elseif state == "stop" or state=="arrive" then
            open_timer += opening * open_timer_speed
            if open_timer >= 3 and opening > 0 then
                open = true
                opening = 0
                open_timer = 3
            elseif open_timer < 0 then
                opening = 0
                open_timer = 0.1
            end
            if state=="arrive" then
                if (open) then
                    local i=0
                    for _customer in all(customer_in_elevator) do
                        del(customer_in_elevator,_customer)
                        _customer:arrive(current_floor)
                        _customer.x=pos_x+i*8-8
                        i+=1
                    end
                    open_timer=5
                    state="stop"
                    _ENV:close_door()
                end
            end
        end
    end,

    draw = function(_ENV)
        -- print(floors[1],0,120,0)
        for i = 1, #floors do
            local floor_it = floors[i]

            local sprite_id = 65 --closed
            local light_id= 64
            if i == current_floor_idx then
                light_id = 80
                sprite_id = 65 + 2 * flr(min(open_timer,3))
            end
            spr(bkg_sprite, pos_x + sprite_offset_x, floory[floor_it] + sprite_offset_y, 2, 2)
            
            for i = 1, #customer_in_elevator do
                spr(customer_in_elevator[i].spr_id, pos_x - 11 + i * 5, floory[floor_it])
            end
            
            --            print(sprite_offset_y,64,8,0)
            --   print(pos_x,96,8,0)
            spr(sprite_id, pos_x + sprite_offset_x, floory[floor_it] + sprite_offset_y, 2, 2)
            spr(light_id, pos_x + light_offset_x, floory[floor_it] + light_offset_y - 6)
        end
        if state == "moving" then
            local p = move_timer / move_duration
            local pos_y = floory[floors[current_floor_idx]] * (1 - p) + floory[floors[target_floor_idx]] * p
            circfill(pos_x, pos_y, 3, 8)
        end
    end,


    open_door = function(_ENV)
        if state == "stop" and not open then
            opening = 1
            sfx(15)
        end
    end,

    close_door = function(_ENV)
        if state == "stop" and open then
            opening = -1
            open = false
            sfx(15)
        end
    end,

    go_up = function(_ENV)
        if current_floor_idx < #floors and state == "stop" then
            target_floor_idx = current_floor_idx + 1
            state = "moving"
            move_timer = 0
            move_duration = _ENV:get_moving_time()
            sfx(16)
        end

        -- while self.current_floor_idx < #self.floory_positions do
        --     self.current_floor_idx = self.current_floor_idx + 1
        --     self.current_floor = self.floory_positions[self.current_floor_idx]

        --     -- If a non-nil current floor value is found, break the loop
        --     if self.current_floor then
        --         break
        --     end
        -- end

        -- TODO: Move customers up to floory_positions[current + 1]
    end,

    go_down = function(_ENV)
        if current_floor_idx > 1 and state == "stop" then
            target_floor_idx = current_floor_idx - 1
            state = "moving"
            move_timer = 0
            move_duration = _ENV:get_moving_time()
            sfx(17)
        end

        -- local i = self.current_floor_idx - 1
        -- while i >= 1 do
        --     -- Check if the floor position is not nil
        --     if self.floory_positions[i] ~= nil then
        --         -- Update the current floor index and value
        --         self.current_floor_idx = i
        --         self.current_floor = self.floory_positions[i]
        --         break -- Exit the loop once a non-nil floor position is found
        --     end
        --     i = i - 1
        -- end

        --TODO customer positions go down to floory_positions[current - 1]
    end,

    arrive=function(_ENV)
        move_timer=0
        move_duration=0
        current_floor_idx=target_floor_idx
        current_floor=floors[current_floor_idx]
        target_floor=current_floor

        if #customer_in_elevator > 0 then
            local perfect = 0 -- 0 is a miss, 1 is good, 2 is perfect
            for i=1, #customer_in_elevator do
                if customer_in_elevator[i].target_floor==current_floor then
                    perfect+=1
                end
            end
            ui_obj:hit_tag(pos_x, floory[current_floor], perfect)
            state="arrive"
            opening=1
        else
            state="stop"
            opening=0
        end
    end,

    toggle_door = function(self)
        self.is_door_open[self.current_floor_idx] = not self.is_door_open[self.current_floor_idx]
    end,

    add_customer = function(self, customer)
        if #self.customer_in_elevator <= self.max_capacity then
            add(self.customer_in_elevator, customer)
        end
    end,

    remove_customer = function(self, customer)
        del(self.customer_in_elevator, customer)
    end,

    -- return waiting time based on number of elevator capacity
    get_moving_time = function(_ENV)
        local base_waiting_time = 0.5
        local wait_time_tbl = { 0.5, 1.0, 2.0 }

        local distance = abs(floors[current_floor_idx] - floors[target_floor_idx])
        local additional_time = distance * base_waiting_time

        if #customer_in_elevator > 0 then
            return wait_time_tbl[#customer_in_elevator] + additional_time
        else
            return additional_time
        end
    end,

    is_elevator_open_on_floor = function(_ENV, _floor)
        print(floors[current_floor_idx], 8, 8, 0)
        print(_floor, 8, 8, 0)
        --stop()
        return floors[current_floor_idx] == _floor and open and #customer_in_elevator < max_capacity
    end
})