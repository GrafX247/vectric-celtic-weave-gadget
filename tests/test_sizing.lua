local luaunit = require("luaunit")
local sizing = require("sizing")

TestSizing = {}

function TestSizing:test_auto_fill_150_by_1800_with_20mm_border_and_6_columns()
  local solved = sizing.solve({
    face_width = 150.0,
    face_height = 1800.0,
    border = 20.0,
    columns = 6,
    row_mode = "auto",
  })

  luaunit.assertAlmostEquals(solved.usable_width, 110.0, 0.001)
  luaunit.assertAlmostEquals(solved.cell_size, 110.0 / 6.0, 0.001)
  luaunit.assertEquals(solved.rows, math.floor((1800.0 - 40.0) / (110.0 / 6.0)))
end

function TestSizing:test_fixed_rows_rejects_pattern_that_overflows_height()
  local solved, err = sizing.solve({
    face_width = 100.0,
    face_height = 120.0,
    border = 20.0,
    columns = 4,
    row_mode = "fixed",
    rows = 8,
  })

  luaunit.assertNil(solved)
  luaunit.assertStrContains(err, "pattern height exceeds usable height")
end
