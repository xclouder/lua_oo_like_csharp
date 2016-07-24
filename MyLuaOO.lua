-- Class
local __classes = {}

Class = {}
Class.Create = function (options)
    local parentCls = options.parentClass or nil

    if (Object ~= nil and parentCls == nil) then
        parentCls = Object
    end

    local ctor = options.ctor or nil
    if (ctor ~= nil and type(ctor) ~= 'function') then
        ctor = nil
        print("Error: constructor(ctor) should be a func")
    end

    local newClass = {
        -- parentClass field
        parentClass = parentCls,

        --constructor
        _ctor = ctor
    }

    -- New func
    newClass.New = function (...)
        local newObj = {}

        do
            local _call_ctor
            _call_ctor = function (c, ... )
                if (c.parentClass) then
                    _call_ctor(c.parentClass, ...)
                end

                if (c._ctor) then
                    c._ctor(newObj, ...)
                end
            end
            _call_ctor(newClass, ...)
        end

        function newObj:GetClass()
            return newClass
        end

        setmetatable(newObj, {__index = __classes[newClass]})
        return newObj
    end

    local override_table = {}
    -- cache here
    __classes[newClass] = override_table

    setmetatable(newClass, {__newindex=
        function(table,k,v)
            override_table[k]=v
        end
    })

    if parentCls then
        setmetatable(override_table, {__index=
            function(table,k)
                local ret = __classes[parentCls][k]
                override_table[k]=ret
                return ret
            end
        })
    end

    return newClass
end

-- create root class
Object = Class.Create({
                    ctor = function(self, x, y)
                        self.x = x
                        self.y = y
                    end
                      })

function Object:ToString ()
    return 'object[' .. tostring(self) .. ']'
end
