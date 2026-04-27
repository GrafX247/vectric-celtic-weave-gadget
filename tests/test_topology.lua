local luaunit = require("luaunit")
local topology = require("topology")

TestTopology = {}

function TestTopology:test_new_grid_defaults_every_crossing_to_both()
  local grid = topology.new(3, 2)
  luaunit.assertEquals(grid:state_at(1, 1), "both")
  luaunit.assertEquals(grid:state_at(3, 2), "both")
end

function TestTopology:test_cycle_rotates_both_horizontal_vertical_then_back()
  local grid = topology.new(1, 1)
  grid:cycle(1, 1)
  luaunit.assertEquals(grid:state_at(1, 1), "horizontal")
  grid:cycle(1, 1)
  luaunit.assertEquals(grid:state_at(1, 1), "vertical")
  grid:cycle(1, 1)
  luaunit.assertEquals(grid:state_at(1, 1), "both")
end
