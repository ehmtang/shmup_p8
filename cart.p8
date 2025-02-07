pico-8 cartridge // http://www.pico-8.com
version 42
__lua__

-- @ehmtang
--⬅️➡️⬆️⬇️ ❎🅾️
-- game states and objects
#include scripts/entities/gameobject.lua
#include scripts/scenes/flowState.lua
--#include scripts/entities/camera.lua
--#include scripts/entities/ui.lua

-- scenes
#include scripts/scenes/level.lua
#include scripts/scenes/menu.lua
#include scripts/scenes/splash.lua

-- entities
#include scripts/entities/player.lua

-- utilities
--#include scripts/utilities/logon.lua
#include scripts/utilities/globals.lua

--main
#include scripts/main.lua