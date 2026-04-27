local M = {}

local cycle_order = {
  both = "horizontal",
  horizontal = "vertical",
  vertical = "both",
}

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
