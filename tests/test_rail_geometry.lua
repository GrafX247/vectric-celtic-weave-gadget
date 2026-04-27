local luaunit = require("luaunit")
local sizing = require("sizing")
local topology = require("topology")
local rail_geometry = require("rail_geometry")
local dialog_state = require("dialog_state")
local dialog_controller = require("dialog_controller")

TestRailGeometry = {}

function TestRailGeometry:test_build_returns_polyline_like_segments()
  local solved = sizing.solve({
    face_width = 150.0,
    face_height = 300.0,
    border = 20.0,
    columns = 3,
    row_mode = "fixed",
    rows = 3,
  })

  local grid = topology.new(3, 3)
  local rails = rail_geometry.build(solved, grid)

  luaunit.assertTrue(#rails > 0)
  luaunit.assertEquals(type(rails[1].points), "table")
  luaunit.assertTrue(#rails[1].points >= 2)
end

function TestRailGeometry:test_single_crossing_change_changes_output_shape()
  local solved = sizing.solve({
    face_width = 150.0,
    face_height = 300.0,
    border = 20.0,
    columns = 2,
    row_mode = "fixed",
    rows = 2,
  })

  local grid_a = topology.new(2, 2)
  local grid_b = topology.new(2, 2)
  grid_b:cycle(1, 1)

  local rails_a = rail_geometry.build(solved, grid_a)
  local rails_b = rail_geometry.build(solved, grid_b)

  luaunit.assertNotEquals(#rails_a[1].points, #rails_b[1].points)
end

function TestRailGeometry:test_rail_points_stay_inside_pattern_bounds()
  local solved = sizing.solve({
    face_width = 150.0,
    face_height = 300.0,
    border = 20.0,
    columns = 3,
    row_mode = "fixed",
    rows = 3,
  })

  local grid = topology.new(3, 3)
  local rails = rail_geometry.build(solved, grid)
  local tolerance = 0.000001

  for _, rail in ipairs(rails) do
    for _, pt in ipairs(rail.points) do
      luaunit.assertTrue(pt.x >= solved.border - tolerance)
      luaunit.assertTrue(pt.y >= solved.border - tolerance)
      luaunit.assertTrue(pt.x <= solved.border + solved.pattern_width + tolerance)
      luaunit.assertTrue(pt.y <= solved.border + solved.pattern_height + tolerance)
    end
  end
end

function TestRailGeometry:test_dialog_state_builds_default_request()
  local state = dialog_state.default_state()
  luaunit.assertEquals(state.row_mode, "auto")
  luaunit.assertEquals(state.columns, 6)
  luaunit.assertEquals(state.cross_section_preset, "fancy")
end

function TestRailGeometry:test_dialog_controller_builds_default_preview()
  local preview = dialog_controller.build_preview(dialog_state.default_state())
  luaunit.assertEquals(preview.solved.columns, 6)
  luaunit.assertTrue(preview.solved.rows > 0)
  luaunit.assertEquals(#preview.rails, preview.solved.columns * preview.solved.rows)
end
