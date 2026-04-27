package.path = "./vectric-celtic-weave-gadget/src/?.lua"
  .. ";./vectric-celtic-weave-gadget/tests/vendor/?.lua"
  .. ";./vectric-celtic-weave-gadget/tests/?.lua"
  .. ";" .. package.path

local luaunit = require("luaunit")

require("test_sizing")
require("test_topology")
require("test_rail_geometry")
require("test_cross_section")

os.exit(luaunit.LuaUnit.run())
