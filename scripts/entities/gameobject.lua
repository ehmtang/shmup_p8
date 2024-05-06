-- definition for generic game objects
g_obj = {
    new = function(self, tbl)
        tbl = tbl or {}
        setmetatable(tbl, { __index = self })
        return tbl
    end,

    init = function(_ENV)
    end,

    update = function(_ENV)
        --_ENV in the argument means internal values in the table are accessed without "self." saving tokens
        log("draw not implemented for object")
        --will help id when a gobj update is called when undefined. could be stripped
        stop("draw not implemented for object")
    end,

    draw = function(_ENV)
        log("draw not implemented for object")
        stop("draw not implemented for object")
    end
}

setmetatable(g_obj, { __index = _ENV }) --this makes gives access to globals where needed via index

-- to inherit from this class do this

--new_obj=g_obj:new({x=5, update=function(_ENV){
--  x++}})

--for global assignment inside class use