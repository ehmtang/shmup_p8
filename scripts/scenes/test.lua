test_fs=flow_state:new({
    customers={},
    cam=camera_obj:new(),

    timer=0,
    begin=function(_ENV)
        local new_cust=customer:new()
        new_cust:init()
        add(customers, new_cust)
    end,

    update=function(_ENV)
        local strop_count=0
        timer+=1
        if (timer >= 120) then
            timer=0
            local new_cust=customer:new()
            new_cust:init()
            add(customers, new_cust)
        end
        for i=1, #customers do
            customers[i]:update()
            if (customers[i]:get_strop()) then
                strop_count+=1
            end
        end

        cam:set_shake(strop_count*0.2, time()*50.0)
        cam:update()
    end,

    draw=function(_ENV)
        map(0,0,0,0,16,16)
        for i=1,#customers do
            customers[i]:draw()
        end
    end
})