-- definition for generic game objects

flow_state={
    new=function(self,tbl)
        tbl=tbl or {}
        setmetatable(tbl, {__index=self})
        return tbl
    end,

    begin=function(_ENV)

    end,

    update=function(_ENV) --_ENV in the argument means internal values in the table are accessed without "self." saving tokens
        return nil
    end,

    draw=function(_ENV)

    end,

    finish=function(_ENV)

    end
}

setmetatable(flow_state, {__index=_ENV}) --this makes gives access to globals where needed via index

flow_state_manager={
    fstate=flow_state:new(),
    new_state=nil,

    update_state=function(_ENV)
        if (doors_obj.use) then
            doors_obj:update()
            if (doors_obj.h>0.5 and new_state!=nil) then
                _ENV:set_state(new_state)
                new_state=nil
            end
        else
            new_state=fstate:update()
            if (new_state!=nil) then
                doors_obj:transition()
            end
        end 
    end,
    
    draw_state=function(_ENV)
        fstate:draw()
        if(doors_obj.use) then
            doors_obj:draw()
        end
    end,

    set_state=function(_ENV, fs)
        fstate:finish()
        fstate=fs
        fstate:begin()
    end
}
setmetatable(flow_state_manager, {__index=_ENV})
-- to inherit from this class do this

--new_obj=new g_obj({x=5, update=function(_ENV){
--  x++}})

--for global assignment inside class use 