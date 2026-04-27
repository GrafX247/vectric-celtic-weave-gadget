# Vectric Aspire V9 Celtic Weave Gadget Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a standalone Aspire V9 gadget that generates Celtic weave rail vectors and optional preset cross-section vectors for bordered post-face panels without distorting the square weave geometry.

**Architecture:** Keep the gadget itself thin. Put sizing math, topology state, and geometry generation into pure Lua modules that can be tested outside Aspire, then add a small Aspire-facing UI/controller layer that binds those modules to the gadget dialog and vector-creation APIs. Use Aspire only for integration and workflow validation, not as the place where core math lives.

**Tech Stack:** Lua 5.1-compatible modules, Aspire V9 gadget APIs, HTML-based Vectric gadget dialogs, LuaUnit for pure-logic tests, and a manual packaging step that zips the gadget folder for Aspire installation.

---

## File Structure

This repo is not a Vectric gadget project today, so this plan creates a self-contained gadget workspace under `vectric-celtic-weave-gadget/` rather than mixing Lua into the existing TypeScript server code.

- Create: `vectric-celtic-weave-gadget/CelticWeaveCreator.lua`
- Create: `vectric-celtic-weave-gadget/CelticWeaveCreator.htm`
- Create: `vectric-celtic-weave-gadget/src/config.lua`
- Create: `vectric-celtic-weave-gadget/src/sizing.lua`
- Create: `vectric-celtic-weave-gadget/src/topology.lua`
- Create: `vectric-celtic-weave-gadget/src/preview_grid.lua`
- Create: `vectric-celtic-weave-gadget/src/rail_geometry.lua`
- Create: `vectric-celtic-weave-gadget/src/cross_section.lua`
- Create: `vectric-celtic-weave-gadget/src/aspire_vectors.lua`
- Create: `vectric-celtic-weave-gadget/src/dialog_state.lua`
- Create: `vectric-celtic-weave-gadget/src/dialog_controller.lua`
- Create: `vectric-celtic-weave-gadget/tests/vendor/luaunit.lua`
- Create: `vectric-celtic-weave-gadget/tests/test_sizing.lua`
- Create: `vectric-celtic-weave-gadget/tests/test_topology.lua`
- Create: `vectric-celtic-weave-gadget/tests/test_rail_geometry.lua`
- Create: `vectric-celtic-weave-gadget/tests/test_cross_section.lua`
- Create: `vectric-celtic-weave-gadget/tests/run.lua`
- Create: `vectric-celtic-weave-gadget/README.md`

### Task 1: Scaffold the standalone gadget project

**Files:**
- Create: `vectric-celtic-weave-gadget/CelticWeaveCreator.lua`
- Create: `vectric-celtic-weave-gadget/CelticWeaveCreator.htm`
- Create: `vectric-celtic-weave-gadget/src/config.lua`
- Create: `vectric-celtic-weave-gadget/README.md`
- Test: `vectric-celtic-weave-gadget/tests/run.lua`

- [ ] **Step 1: Write the failing project smoke test**

```lua
-- vectric-celtic-weave-gadget/tests/run.lua
package.path = package.path
  .. ";./vectric-celtic-weave-gadget/src/?.lua"
  .. ";./vectric-celtic-weave-gadget/tests/vendor/?.lua"
  .. ";./vectric-celtic-weave-gadget/tests/?.lua"

local luaunit = require("luaunit")

require("test_sizing")
require("test_topology")
require("test_rail_geometry")
require("test_cross_section")

os.exit(luaunit.LuaUnit.run())
```

- [ ] **Step 2: Run test to verify it fails**

Run: `lua vectric-celtic-weave-gadget/tests/run.lua`
Expected: FAIL with `module 'test_sizing' not found`

- [ ] **Step 3: Create the minimal gadget scaffold**

```lua
-- vectric-celtic-weave-gadget/CelticWeaveCreator.lua
function main(script_path)
  package.path = package.path .. ";" .. script_path .. "\\src\\?.lua"

  local config = require("config")
  local job = VectricJob()
  if not job.Exists then
    DisplayMessageBox("No job open.")
    return false
  end

  local html_path = "file:" .. script_path .. "\\CelticWeaveCreator.htm"
  local dialog = HTML_Dialog(false, html_path, 640, 480, config.app_name)
  dialog:AddLabelField("GadgetTitle", config.app_name)
  dialog:AddLabelField("GadgetVersion", config.version)

  if not dialog:ShowDialog() then
    return false
  end

  return true
end
```

```lua
-- vectric-celtic-weave-gadget/src/config.lua
return {
  app_name = "Celtic Weave Creator",
  version = "0.1.0",
}
```

```html
<!-- vectric-celtic-weave-gadget/CelticWeaveCreator.htm -->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN"
  "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <title>Celtic Weave Creator</title>
</head>
<body bgcolor="#efefef">
  <h1><span id="GadgetTitle">Celtic Weave Creator</span></h1>
  <p>Version <span id="GadgetVersion">0.1.0</span></p>
  <input class="FormButton" type="button" value="Close" id="CloseButton">
</body>
</html>
```

```md
# Celtic Weave Creator

Standalone Aspire V9 gadget workspace for a modernized Celtic weave generator.
```

- [ ] **Step 4: Add scaffold tests that load cleanly but fail on assertions**

```lua
-- vectric-celtic-weave-gadget/tests/test_sizing.lua
local luaunit = require("luaunit")

TestSizingScaffold = {}

function TestSizingScaffold:test_scaffold_failure()
  luaunit.assertEquals(false, true)
end
```

```lua
-- vectric-celtic-weave-gadget/tests/test_topology.lua
local luaunit = require("luaunit")

TestTopologyScaffold = {}

function TestTopologyScaffold:test_scaffold_failure()
  luaunit.assertEquals(false, true)
end
```

```lua
-- vectric-celtic-weave-gadget/tests/test_rail_geometry.lua
local luaunit = require("luaunit")

TestRailGeometryScaffold = {}

function TestRailGeometryScaffold:test_scaffold_failure()
  luaunit.assertEquals(false, true)
end
```

```lua
-- vectric-celtic-weave-gadget/tests/test_cross_section.lua
local luaunit = require("luaunit")

TestCrossSectionScaffold = {}

function TestCrossSectionScaffold:test_scaffold_failure()
  luaunit.assertEquals(false, true)
end
```

- [ ] **Step 5: Run test to verify the scaffold now executes and fails in the tests**

Run: `lua vectric-celtic-weave-gadget/tests/run.lua`
Expected: FAIL with four failing scaffold assertions

- [ ] **Step 6: Commit**

```bash
git add vectric-celtic-weave-gadget docs/superpowers/plans/2026-04-27-vectric-celtic-weave-gadget.md
git commit -m "chore: scaffold Aspire Celtic weave gadget project"
```

### Task 2: Build and verify the sizing engine

**Files:**
- Modify: `vectric-celtic-weave-gadget/src/config.lua`
- Create: `vectric-celtic-weave-gadget/src/sizing.lua`
- Modify: `vectric-celtic-weave-gadget/tests/test_sizing.lua`
- Test: `vectric-celtic-weave-gadget/tests/run.lua`

- [ ] **Step 1: Write the failing sizing tests**

```lua
-- vectric-celtic-weave-gadget/tests/test_sizing.lua
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
```

- [ ] **Step 2: Run test to verify it fails**

Run: `lua vectric-celtic-weave-gadget/tests/run.lua`
Expected: FAIL with `module 'sizing' not found`

- [ ] **Step 3: Implement the minimal sizing module**

```lua
-- vectric-celtic-weave-gadget/src/sizing.lua
local M = {}

local function positive(name, value)
  if value == nil or value <= 0 then
    return nil, name .. " must be greater than zero"
  end
  return value
end

function M.solve(input)
  local face_width, err = positive("face width", input.face_width)
  if not face_width then return nil, err end

  local face_height
  face_height, err = positive("face height", input.face_height)
  if not face_height then return nil, err end

  local border
  border, err = positive("border", input.border)
  if not border then return nil, err end

  local columns
  columns, err = positive("columns", input.columns)
  if not columns then return nil, err end

  local usable_width = face_width - (border * 2.0)
  local usable_height = face_height - (border * 2.0)
  if usable_width <= 0 then
    return nil, "usable width must be greater than zero"
  end
  if usable_height <= 0 then
    return nil, "usable height must be greater than zero"
  end

  local cell_size = usable_width / columns
  local rows = input.rows

  if input.row_mode == "auto" then
    rows = math.floor(usable_height / cell_size)
    if rows < 1 then
      return nil, "auto-fill height does not fit even one row"
    end
  elseif input.row_mode == "fixed" then
    rows, err = positive("rows", rows)
    if not rows then return nil, err end
    local pattern_height = rows * cell_size
    if pattern_height > usable_height then
      return nil, "pattern height exceeds usable height"
    end
  else
    return nil, "row_mode must be 'auto' or 'fixed'"
  end

  return {
    face_width = face_width,
    face_height = face_height,
    border = border,
    columns = columns,
    rows = rows,
    usable_width = usable_width,
    usable_height = usable_height,
    cell_size = cell_size,
    pattern_width = columns * cell_size,
    pattern_height = rows * cell_size,
  }
end

return M
```

- [ ] **Step 4: Run test to verify it passes**

Run: `lua vectric-celtic-weave-gadget/tests/run.lua`
Expected: PASS for `TestSizing`, FAIL for remaining scaffold tests

- [ ] **Step 5: Commit**

```bash
git add vectric-celtic-weave-gadget/src/config.lua vectric-celtic-weave-gadget/src/sizing.lua vectric-celtic-weave-gadget/tests/test_sizing.lua
git commit -m "feat: add weave panel sizing engine"
```

### Task 3: Implement the crossing topology model

**Files:**
- Create: `vectric-celtic-weave-gadget/src/topology.lua`
- Modify: `vectric-celtic-weave-gadget/tests/test_topology.lua`
- Test: `vectric-celtic-weave-gadget/tests/run.lua`

- [ ] **Step 1: Write the failing topology tests**

```lua
-- vectric-celtic-weave-gadget/tests/test_topology.lua
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
```

- [ ] **Step 2: Run test to verify it fails**

Run: `lua vectric-celtic-weave-gadget/tests/run.lua`
Expected: FAIL with `module 'topology' not found`

- [ ] **Step 3: Implement the topology module**

```lua
-- vectric-celtic-weave-gadget/src/topology.lua
local M = {}
local cycle_order = { both = "horizontal", horizontal = "vertical", vertical = "both" }

local Grid = {}
Grid.__index = Grid

function Grid:state_at(column, row)
  return self.cells[row][column]
end

function Grid:cycle(column, row)
  local current = self.cells[row][column]
  self.cells[row][column] = cycle_order[current]
  return self.cells[row][column]
end

function M.new(columns, rows)
  local cells = {}
  for row = 1, rows do
    cells[row] = {}
    for column = 1, columns do
      cells[row][column] = "both"
    end
  end

  return setmetatable({
    columns = columns,
    rows = rows,
    cells = cells,
  }, Grid)
end

return M
```

- [ ] **Step 4: Run test to verify it passes**

Run: `lua vectric-celtic-weave-gadget/tests/run.lua`
Expected: PASS for `TestSizing` and `TestTopology`, FAIL for remaining scaffold tests

- [ ] **Step 5: Commit**

```bash
git add vectric-celtic-weave-gadget/src/topology.lua vectric-celtic-weave-gadget/tests/test_topology.lua
git commit -m "feat: add crossing topology state model"
```

### Task 4: Generate deterministic rail geometry from sizing and topology

**Files:**
- Create: `vectric-celtic-weave-gadget/src/preview_grid.lua`
- Create: `vectric-celtic-weave-gadget/src/rail_geometry.lua`
- Modify: `vectric-celtic-weave-gadget/tests/test_rail_geometry.lua`
- Test: `vectric-celtic-weave-gadget/tests/run.lua`

- [ ] **Step 1: Write the failing geometry tests**

```lua
-- vectric-celtic-weave-gadget/tests/test_rail_geometry.lua
local luaunit = require("luaunit")
local sizing = require("sizing")
local topology = require("topology")
local rail_geometry = require("rail_geometry")

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
```

- [ ] **Step 2: Run test to verify it fails**

Run: `lua vectric-celtic-weave-gadget/tests/run.lua`
Expected: FAIL with `module 'rail_geometry' not found`

- [ ] **Step 3: Implement the minimal geometry builder**

```lua
-- vectric-celtic-weave-gadget/src/preview_grid.lua
local M = {}

function M.crossing_center(solved, column, row)
  local x0 = solved.border
  local y0 = solved.border
  return {
    x = x0 + ((column - 0.5) * solved.cell_size),
    y = y0 + ((row - 0.5) * solved.cell_size),
  }
end

return M
```

```lua
-- vectric-celtic-weave-gadget/src/rail_geometry.lua
local preview_grid = require("preview_grid")

local M = {}

local function segment_for_state(center, cell_size, state)
  if state == "horizontal" then
    return {
      { x = center.x - (cell_size * 0.5), y = center.y },
      { x = center.x },
      { x = center.x + (cell_size * 0.5), y = center.y },
    }
  elseif state == "vertical" then
    return {
      { x = center.x, y = center.y - (cell_size * 0.5) },
      { x = center.x },
      { x = center.x, y = center.y + (cell_size * 0.5) },
    }
  end

  return {
    { x = center.x - (cell_size * 0.5), y = center.y },
    { x = center.x },
    { x = center.x + (cell_size * 0.5), y = center.y },
    { x = center.x, y = center.y - (cell_size * 0.5) },
    { x = center.x },
    { x = center.x, y = center.y + (cell_size * 0.5) },
  }
end

function M.build(solved, grid)
  local rails = {}

  for row = 1, grid.rows do
    for column = 1, grid.columns do
      local center = preview_grid.crossing_center(solved, column, row)
      rails[#rails + 1] = {
        column = column,
        row = row,
        state = grid:state_at(column, row),
        points = segment_for_state(center, solved.cell_size, grid:state_at(column, row)),
      }
    end
  end

  return rails
end

return M
```

- [ ] **Step 4: Run test to verify it passes**

Run: `lua vectric-celtic-weave-gadget/tests/run.lua`
Expected: PASS for `TestSizing`, `TestTopology`, and `TestRailGeometry`; FAIL for remaining scaffold tests

- [ ] **Step 5: Commit**

```bash
git add vectric-celtic-weave-gadget/src/preview_grid.lua vectric-celtic-weave-gadget/src/rail_geometry.lua vectric-celtic-weave-gadget/tests/test_rail_geometry.lua
git commit -m "feat: add initial weave rail geometry builder"
```

### Task 5: Implement preset cross-section geometry with width and height controls

**Files:**
- Create: `vectric-celtic-weave-gadget/src/cross_section.lua`
- Modify: `vectric-celtic-weave-gadget/tests/test_cross_section.lua`
- Test: `vectric-celtic-weave-gadget/tests/run.lua`

- [ ] **Step 1: Write the failing cross-section tests**

```lua
-- vectric-celtic-weave-gadget/tests/test_cross_section.lua
local luaunit = require("luaunit")
local cross_section = require("cross_section")

TestCrossSection = {}

function TestCrossSection:test_square_profile_uses_requested_width_and_height()
  local profile = cross_section.build({
    preset = "square",
    width = 8.0,
    height = 3.0,
  })

  luaunit.assertEquals(profile.kind, "polyline")
  luaunit.assertAlmostEquals(profile.bounds.width, 8.0, 0.001)
  luaunit.assertAlmostEquals(profile.bounds.height, 3.0, 0.001)
end

function TestCrossSection:test_none_returns_nil()
  local profile = cross_section.build({
    preset = "none",
    width = 8.0,
    height = 3.0,
  })

  luaunit.assertNil(profile)
end
```

- [ ] **Step 2: Run test to verify it fails**

Run: `lua vectric-celtic-weave-gadget/tests/run.lua`
Expected: FAIL with `module 'cross_section' not found`

- [ ] **Step 3: Implement the preset profile builder**

```lua
-- vectric-celtic-weave-gadget/src/cross_section.lua
local M = {}

local function bounds(width, height)
  return { width = width, height = height }
end

function M.build(input)
  if input.preset == "none" then
    return nil
  end

  if input.width <= 0 or input.height <= 0 then
    return nil, "profile width and height must be greater than zero"
  end

  if input.preset == "square" then
    return {
      kind = "polyline",
      points = {
        { x = 0.0, y = 0.0 },
        { x = input.width, y = 0.0 },
        { x = input.width, y = input.height },
        { x = 0.0, y = input.height },
      },
      bounds = bounds(input.width, input.height),
    }
  end

  return {
    kind = "preset",
    preset = input.preset,
    bounds = bounds(input.width, input.height),
  }
end

return M
```

- [ ] **Step 4: Run test to verify it passes**

Run: `lua vectric-celtic-weave-gadget/tests/run.lua`
Expected: PASS for `TestSizing`, `TestTopology`, `TestRailGeometry`, and `TestCrossSection`

- [ ] **Step 5: Commit**

```bash
git add vectric-celtic-weave-gadget/src/cross_section.lua vectric-celtic-weave-gadget/tests/test_cross_section.lua
git commit -m "feat: add preset extrude cross sections"
```

### Task 6: Wire the pure modules into an Aspire dialog and vector output path

**Files:**
- Create: `vectric-celtic-weave-gadget/src/dialog_state.lua`
- Create: `vectric-celtic-weave-gadget/src/dialog_controller.lua`
- Create: `vectric-celtic-weave-gadget/src/aspire_vectors.lua`
- Modify: `vectric-celtic-weave-gadget/CelticWeaveCreator.lua`
- Modify: `vectric-celtic-weave-gadget/CelticWeaveCreator.htm`
- Modify: `vectric-celtic-weave-gadget/README.md`
- Test: `vectric-celtic-weave-gadget/tests/run.lua`

- [ ] **Step 1: Write the failing Aspire integration smoke test at the module boundary**

```lua
-- add to vectric-celtic-weave-gadget/tests/test_rail_geometry.lua
local dialog_state = require("dialog_state")

function TestRailGeometry:test_dialog_state_builds_default_request()
  local state = dialog_state.default_state()
  luaunit.assertEquals(state.row_mode, "auto")
  luaunit.assertEquals(state.columns, 6)
  luaunit.assertEquals(state.cross_section_preset, "fancy")
end
```

- [ ] **Step 2: Run test to verify it fails**

Run: `lua vectric-celtic-weave-gadget/tests/run.lua`
Expected: FAIL with `module 'dialog_state' not found`

- [ ] **Step 3: Implement the Aspire-facing modules**

```lua
-- vectric-celtic-weave-gadget/src/dialog_state.lua
local M = {}

function M.default_state()
  return {
    face_width = 150.0,
    face_height = 1800.0,
    border = 20.0,
    columns = 6,
    row_mode = "auto",
    rows = 0,
    cross_section_preset = "fancy",
    profile_width = 8.0,
    profile_height = 3.0,
  }
end

return M
```

```lua
-- vectric-celtic-weave-gadget/src/aspire_vectors.lua
local M = {}

function M.create_rail_vectors(job, rails)
  return {
    created = #rails,
    group_name = "Celtic Weave Rails",
    job = job,
  }
end

function M.create_cross_section(job, profile, anchor)
  return {
    created = profile and 1 or 0,
    anchor = anchor,
    job = job,
  }
end

return M
```

```lua
-- vectric-celtic-weave-gadget/src/dialog_controller.lua
local sizing = require("sizing")
local topology = require("topology")
local rail_geometry = require("rail_geometry")
local cross_section = require("cross_section")
local aspire_vectors = require("aspire_vectors")

local M = {}

function M.build_preview(state)
  local solved, err = sizing.solve({
    face_width = state.face_width,
    face_height = state.face_height,
    border = state.border,
    columns = state.columns,
    row_mode = state.row_mode,
    rows = state.rows,
  })
  if not solved then
    return nil, err
  end

  local grid = topology.new(solved.columns, solved.rows)
  local rails = rail_geometry.build(solved, grid)
  return {
    solved = solved,
    grid = grid,
    rails = rails,
  }
end

function M.apply(job, state)
  local preview, err = M.build_preview(state)
  if not preview then
    return nil, err
  end

  local profile = cross_section.build({
    preset = state.cross_section_preset,
    width = state.profile_width,
    height = state.profile_height,
  })

  local rail_result = aspire_vectors.create_rail_vectors(job, preview.rails)
  local profile_result = aspire_vectors.create_cross_section(job, profile, {
    x = preview.solved.border + preview.solved.pattern_width + 20.0,
    y = preview.solved.border,
  })

  return {
    preview = preview,
    rails = rail_result,
    profile = profile_result,
  }
end

return M
```

```lua
-- vectric-celtic-weave-gadget/CelticWeaveCreator.lua
function main(script_path)
  local job = VectricJob()
  if not job.Exists then
    DisplayMessageBox("No job open.")
    return false
  end

  package.path = package.path .. ";" .. script_path .. "\\src\\?.lua"
  local config = require("config")
  local dialog_state = require("dialog_state")
  local controller = require("dialog_controller")

  local html_path = "file:" .. script_path .. "\\CelticWeaveCreator.htm"
  local dialog = HTML_Dialog(false, html_path, 900, 700, config.app_name)
  local state = dialog_state.default_state()
  dialog:AddLabelField("GadgetTitle", config.app_name)
  dialog:AddLabelField("GadgetVersion", config.version)

  if not dialog:ShowDialog() then
    return false
  end

  local result, err = controller.apply(job, state)
  if not result then
    DisplayMessageBox(config.app_name .. " error: " .. err)
    return false
  end

  return true
end
```

```md
## Aspire smoke test

1. Copy the `vectric-celtic-weave-gadget/` folder into the Aspire gadget directory so the folder contains `CelticWeaveCreator.lua`, `CelticWeaveCreator.htm`, and `src/`.
2. Launch Aspire V9.
3. Run `Celtic Weave Creator`.
4. Confirm the dialog opens and the gadget can generate rails and an optional cross section.
```

- [ ] **Step 4: Run the pure test suite to verify it passes**

Run: `lua vectric-celtic-weave-gadget/tests/run.lua`
Expected: PASS

- [ ] **Step 5: Run the Aspire smoke test manually**

Run: launch Aspire V9, install `vectric-celtic-weave-gadget/`, then run the gadget
Expected: dialog opens, generation succeeds, and vectors appear in the job without manual cleanup

- [ ] **Step 6: Commit**

```bash
git add vectric-celtic-weave-gadget/src/dialog_state.lua vectric-celtic-weave-gadget/src/dialog_controller.lua vectric-celtic-weave-gadget/src/aspire_vectors.lua vectric-celtic-weave-gadget/CelticWeaveCreator.lua vectric-celtic-weave-gadget/CelticWeaveCreator.htm vectric-celtic-weave-gadget/README.md
git commit -m "feat: wire Celtic weave gadget into Aspire workflow"
```

### Task 7: Replace the minimal geometry with real knot rails and validate Aspire handoff

**Files:**
- Modify: `vectric-celtic-weave-gadget/src/rail_geometry.lua`
- Modify: `vectric-celtic-weave-gadget/src/aspire_vectors.lua`
- Modify: `vectric-celtic-weave-gadget/tests/test_rail_geometry.lua`
- Modify: `vectric-celtic-weave-gadget/README.md`
- Test: `vectric-celtic-weave-gadget/tests/run.lua`

- [ ] **Step 1: Write the failing topology-sensitive rail tests**

```lua
-- add to vectric-celtic-weave-gadget/tests/test_rail_geometry.lua
function TestRailGeometry:test_grouped_rails_track_panel_bounds()
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

  for _, rail in ipairs(rails) do
    for _, point in ipairs(rail.points) do
      luaunit.assertTrue(point.x >= solved.border)
      luaunit.assertTrue(point.y >= solved.border)
      luaunit.assertTrue(point.x <= (solved.border + solved.pattern_width))
      luaunit.assertTrue(point.y <= (solved.border + solved.pattern_height))
    end
  end
end
```

- [ ] **Step 2: Run test to verify it fails**

Run: `lua vectric-celtic-weave-gadget/tests/run.lua`
Expected: FAIL because the minimal stub geometry does not yet model full knot rails correctly

- [ ] **Step 3: Implement real rail generation and Aspire vector creation**

```lua
-- target shape for vectric-celtic-weave-gadget/src/rail_geometry.lua
local preview_grid = require("preview_grid")

local M = {}

local deltas = {
  left = { dc = -1, dr = 0 },
  right = { dc = 1, dr = 0 },
  up = { dc = 0, dr = -1 },
  down = { dc = 0, dr = 1 },
}

local state_edges = {
  both = { "left", "right", "up", "down" },
  horizontal = { "left", "right" },
  vertical = { "up", "down" },
}

local function edge_key(column, row, edge)
  return string.format("%d:%d:%s", column, row, edge)
end

local function opposite(edge)
  if edge == "left" then return "right" end
  if edge == "right" then return "left" end
  if edge == "up" then return "down" end
  return "up"
end

local function edge_point(center, cell_size, edge)
  local half = cell_size * 0.5
  if edge == "left" then return { x = center.x - half, y = center.y } end
  if edge == "right" then return { x = center.x + half, y = center.y } end
  if edge == "up" then return { x = center.x, y = center.y - half } end
  return { x = center.x, y = center.y + half }
end

local function state_has_edge(state, edge)
  for _, candidate in ipairs(state_edges[state]) do
    if candidate == edge then
      return true
    end
  end
  return false
end

local function choose_exit(state, incoming)
  if state == "horizontal" then
    return incoming == "left" and "right" or "left"
  elseif state == "vertical" then
    return incoming == "up" and "down" or "up"
  elseif incoming == "left" then
    return "right"
  elseif incoming == "right" then
    return "left"
  elseif incoming == "up" then
    return "down"
  end
  return "up"
end

function M.build(solved, grid)
  local rails = {}
  local visited = {}

  for row = 1, grid.rows do
    for column = 1, grid.columns do
      local state = grid:state_at(column, row)
      for _, start_edge in ipairs(state_edges[state]) do
        local start_key = edge_key(column, row, start_edge)
        if not visited[start_key] then
          local path = {}
          local current_column = column
          local current_row = row
          local incoming = start_edge

          while current_column >= 1
            and current_column <= grid.columns
            and current_row >= 1
            and current_row <= grid.rows
          do
            local current_state = grid:state_at(current_column, current_row)
            if not state_has_edge(current_state, incoming) then
              break
            end

            local center = preview_grid.crossing_center(solved, current_column, current_row)
            path[#path + 1] = edge_point(center, solved.cell_size, incoming)
            path[#path + 1] = { x = center.x, y = center.y }

            local outgoing = choose_exit(current_state, incoming)
            visited[edge_key(current_column, current_row, incoming)] = true
            visited[edge_key(current_column, current_row, outgoing)] = true
            path[#path + 1] = edge_point(center, solved.cell_size, outgoing)

            local delta = deltas[outgoing]
            current_column = current_column + delta.dc
            current_row = current_row + delta.dr
            incoming = opposite(outgoing)
          end

          if #path >= 3 then
            rails[#rails + 1] = { points = path }
          end
        end
      end
    end
  end

  return rails
end

return M
```

```lua
-- target shape for vectric-celtic-weave-gadget/src/aspire_vectors.lua
local M = {}

function M.create_rail_vectors(job, rails)
  local layer = job.LayerManager:GetActiveLayer()
  local object_ids = {}

  for _, rail in ipairs(rails) do
    local contour = Contour(0.0)
    local first = rail.points[1]
    contour:AppendPoint(Point2D(first.x, first.y))

    for index = 2, #rail.points do
      local point = rail.points[index]
      contour:LineTo(Point2D(point.x, point.y))
    end

    local cad_object = CreateCadContour(contour)
    layer:AddObject(cad_object, true)
    object_ids[#object_ids + 1] = cad_object.Id
  end

  return {
    created = #object_ids,
    group_name = "Celtic Weave Rails",
    object_ids = object_ids,
  }
end

return M
```

- [ ] **Step 4: Run tests and Aspire validation**

Run: `lua vectric-celtic-weave-gadget/tests/run.lua`
Expected: PASS

Run: launch Aspire V9, generate a `150 x 1800 mm` panel with `20 mm` border and `6` columns, then feed the rails into `Extrude and Weave`
Expected: rails are selectable as a group, extrusion succeeds, and the pattern remains square and centered inside the bordered panel area

- [ ] **Step 5: Commit**

```bash
git add vectric-celtic-weave-gadget/src/rail_geometry.lua vectric-celtic-weave-gadget/src/aspire_vectors.lua vectric-celtic-weave-gadget/tests/test_rail_geometry.lua vectric-celtic-weave-gadget/README.md
git commit -m "feat: generate Aspire-ready Celtic weave rail vectors"
```

### Task 8: Decide re-edit support based on a real Aspire spike

**Files:**
- Modify: `vectric-celtic-weave-gadget/src/dialog_controller.lua`
- Modify: `vectric-celtic-weave-gadget/src/aspire_vectors.lua`
- Modify: `vectric-celtic-weave-gadget/README.md`
- Test: `vectric-celtic-weave-gadget/tests/run.lua`

- [ ] **Step 1: Write the decision test as documentation**

```md
## Re-edit spike

Validate whether Aspire V9 exposes enough information to:

1. detect a previously generated grouped weave
2. recover its sizing inputs
3. recover or reconstruct the crossing-state grid

If all three are reliable, implement reopen/re-edit support.
If any are unreliable, document re-edit as unsupported in v1.
```

- [ ] **Step 2: Run the spike manually**

Run: generate a weave, save the Aspire file, close Aspire, reopen the file, and rerun the gadget with the grouped rails selected
Expected: either reliable reconstruction of state or a clear technical reason it cannot be trusted

- [ ] **Step 3: Implement only one of the two outcomes**

```lua
-- outcome A in vectric-celtic-weave-gadget/src/dialog_controller.lua
local json = require("json")

function M.load_existing_selection(selection)
  local raw = selection and selection:GetString("celtic_weave_state")
  if not raw or raw == "" then
    return nil, "no saved Celtic weave state found on selection"
  end

  local ok, decoded = pcall(json.decode, raw)
  if not ok then
    return nil, "saved Celtic weave state is not valid JSON"
  end

  if not decoded.columns or not decoded.rows or not decoded.crossings then
    return nil, "saved Celtic weave state is incomplete"
  end

  return decoded
end
```

```md
## Re-edit support outcomes

### If Aspire selection metadata is reliable

- save a JSON blob named `celtic_weave_state`
- include `face_width`, `face_height`, `border`, `columns`, `rows`, `row_mode`, `cross_section_preset`, `profile_width`, `profile_height`, and the full crossing-state matrix
- reload that JSON when a generated weave group is selected before reopening the dialog

### If Aspire selection metadata is not reliable

- remove any `Edit Existing` affordance from the UI
- document re-edit as unsupported in v1
- tell the user to keep the original input values if they may need to regenerate the panel later
```

- [ ] **Step 4: Re-run tests and Aspire validation**

Run: `lua vectric-celtic-weave-gadget/tests/run.lua`
Expected: PASS

Run: repeat the save/reopen workflow in Aspire V9
Expected: either working re-edit support or clearly documented lack of support with no false promise in the UI

- [ ] **Step 5: Commit**

```bash
git add vectric-celtic-weave-gadget/src/dialog_controller.lua vectric-celtic-weave-gadget/src/aspire_vectors.lua vectric-celtic-weave-gadget/README.md
git commit -m "feat: finalize re-edit behavior for weave gadget"
```
