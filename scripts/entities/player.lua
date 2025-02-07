player_obj = g_obj:new({
    sprite_id = 73,
    pos_x = 0,
    pos_y = 0,

    init = function(_ENV)
        --pos_y = floory[current_elevator.current_floor_idx]
    end,

    update = function(_ENV)
        player_ctrls()
        --     self.pos_x = self.current_elevator.pos_x
        --     self.pos_y = self.current_elevator.pos_y
        -- end
    end,

    draw = function(_ENV)
        circ( pos_x, pos_y)

    end,

    player_ctrls = function(_ENV)
        if btnp(0) then self.pos_x -= 1 end  -- Move left
        if btnp(1) then self.pos_x += 1 end  -- Move right
        if btnp(2) then self.pos_y -= 1 end  -- Move up
        if btnp(3) then self.pos_y += 1 end  -- Move down
end
})