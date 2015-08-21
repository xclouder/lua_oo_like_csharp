-- Class
__classes = {}

Class = {}
Class.Create = function (options)
    local parentCls = options.parentClass or nil

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
            local _call_ctor = function (c, ... )
                if (c.parentClass and c.parentClass._ctor) then
                    c.parentClass._ctor(newObj, ...)
                end

                if (ctor) then
                    ctor(newObj, ...)
                end
            end
            _call_ctor(newClass, ...)
        end

        setmetatable(newObj, {__index = newClass})
        return newObj
    end

    -- cache here
    __classes[newClass] = {}

    return newClass
end

-- Object = {

--     ToString = function (self, ...)
--         return "object"
--     end
--     ,

--     New = function ( ... )
--        local o = {}
--        setmetatable(o, {__index = Object})
--        return o
--     end
-- }

Object = Class.Create({
                    ctor = function(self, x, y)
                        self.x = x
                        self.y = y
                    end
                      })

function Object:ToString ()
    return 'object[' .. tostring(self) .. ']'
end

-- My Usage Demo
obj1 = Object.New(33,44)
print(obj1.x .. " " .. obj1.y)
print(obj1.ToString(obj1))

obj2 = Object.New()
assert(obj1 ~= obj2)

-- Create Custom Class
Animal = Class.Create({
                    parentClass = Object,
                    ctor = function (self, ... )
                        print('animal construct')
                    end
                      })
Dog = Class.Create({parentClass = Animal,
                    ctor = function (self, ... )
                        print('dog construct')
                    end
                    })
dog = Dog.New()
dog.ToString()


-- Get Class
-- local ObjClass = anObj.GetClass()

-- assert(ObjClass == Object)

aa = [[
-- create class
Animal = Class.Create(Object)
Weather = Class.Create()  -- Create(parent)  parent == null => parent is Object class

-- extends
Dog = Class.Create(Animal)
Sunshine = Class.Create(Weather)

-- create Instance
aDog = Dog.New()
aWeather = Sunshine.New()
]]