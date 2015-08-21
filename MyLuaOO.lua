-- Class
local __classes = {}

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
            return newObj
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

-- My Usage Demo
obj1 = Object.New(33,44)
print(obj1.x .. " " .. obj1.y)
print(obj1:ToString())

obj2 = Object.New()
assert(obj1 ~= obj2)

-- Create Custom Class
Animal = Class.Create({
                    parentClass = Object,
                    ctor = function (self, ... )
                        print('animal construct')
                    end
                      })

LactationAnimal = Class.Create({parentClass = Animal})

Dog = Class.Create({parentClass = LactationAnimal,
                    ctor = function (self, ... )
                        print('dog construct')
                    end
                    })


animal = Animal.New()
animal:ToString()

lactationAnim = LactationAnimal.New()
lactationAnim:ToString()

dog = Dog.New()
dog:ToString()

dog2 = Dog.New()

-- Get Class
local dogClass = dog.GetClass()
local dog2Class = dog2.GetClass()
assert(dogClass == Dog)
assert(dogClass == dog2Class)


-- -- create class
-- Animal = Class.Create(Object)
-- Weather = Class.Create()  -- Create(parent)  parent == null => parent is Object class

-- -- extends
-- Dog = Class.Create(Animal)
-- Sunshine = Class.Create(Weather)

-- -- create Instance
-- aDog = Dog.New()
-- aWeather = Sunshine.New()
