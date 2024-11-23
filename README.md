# Dependencies

- [qb-target](https://github.com/BerkieBb/qb-target)
- [qb-core](https://github.com/qbcore-framework/qb-core)
- [progressbar](https://github.com/P4ScriptsFivem/pappu-progressbarEchoRP)

# Preview 
- [video](https://youtu.be/PPjt6Dp8_J8)

## Installation

- Install all dependencies
- Drag and drop resource in your resources list 
- Make sure script is loaded after all dependencies

- A new Item need to be added with it's image :
```lua
    ["gold"]  = {["name"] = "gold",   ["label"] = "Gold",      ["weight"] = 100, ["type"] = "item", 		["image"] = "gold.png",   ["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false, ["combinable"] = nil,   ["description"] = "Ore"},
    ["diamond"]  = {["name"] = "diamond",   ["label"] = "Diamond",      ["weight"] = 100, ["type"] = "item", 		["image"] = "diamond.png",   ["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false, ["combinable"] = nil,   ["description"] = "Ore"},
    ["iron"]  = {["name"] = "iron",   ["label"] = "Iron Ore",      ["weight"] = 100, ["type"] = "item", 		["image"] = "iron.png",   ["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false, ["combinable"] = nil,   ["description"] = "Ore"},
    ["pickaxe"]  = {["name"] = "pickaxe",   ["label"] = "Pickaxe",      ["weight"] = 1000, ["type"] = "item", 		["image"] = "pickaxe.png",   ["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false, ["combinable"] = nil,   ["description"] = "Tool for mining"},
```