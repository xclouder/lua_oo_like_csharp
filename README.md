示例

```

-- My Usage Demo
obj1 = Object.New(33,44)
print(obj1.x .. " " .. obj1.y)
print(obj1:ToString())

obj2 = Object.New()
assert(obj1 ~= obj2)

-- Create Custom Class
Animal = Class.Create({
                    -- parentClass = Object,
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
local dogClass = dog:GetClass()
local dog2Class = dog2:GetClass()
assert(dogClass == Dog)
assert(dogClass == dog2Class)


-- create class
Animal = Class.Create(Object)
Weather = Class.Create()  -- Create(parent)  parent == null => parent is Object class

-- extends
Dog = Class.Create(Animal)
Sunshine = Class.Create(Weather)

-- create Instance
aDog = Dog.New()
aWeather = Sunshine.New()

for idx, value in pairs(_G) do print(idx, type(value)) end


```
