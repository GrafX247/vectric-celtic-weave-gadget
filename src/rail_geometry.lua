local preview_grid = require("preview_grid")

local M = {}

local function point(x, y)
  return { x = x, y = y }
end

local function add_horizontal(points, center, half)
  points[#points + 1] = point(center.x - half, center.y)
  points[#points + 1] = point(center.x, center.y)
  points[#points + 1] = point(center.x + half, center.y)
end

local function add_vertical(points, center, half)
  points[#points + 1] = point(center.x, center.y - half)
  points[#points + 1] = point(center.x, center.y)
  points[#points + 1] = point(center.x, center.y + half)
end

local function points_for_state(center, cell_size, state)
  local half = cell_size * 0.5
  local points = {}

  if state == "horizontal" then
    add_horizontal(points, center, half)
  elseif state == "vertical" then
    add_vertical(points, center, half)
  else
    add_horizontal(points, center, half)
    add_vertical(points, center, half)
  end

  return points
end

function M.build(solved, grid)
  local rails = {}

  for row = 1, grid.rows do
    for column = 1, grid.columns do
      local state = grid:state_at(column, row)
      local center = preview_grid.crossing_center(solved, column, row)
      rails[#rails + 1] = {
        column = column,
        row = row,
        state = state,
        points = points_for_state(center, solved.cell_size, state),
      }
    end
  end

  return rails
end

return M
