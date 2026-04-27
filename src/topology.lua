local M = {}

M.CUT_NONE = 0
M.CUT_HORIZONTAL = 1
M.CUT_VERTICAL = 2

local cycle_order = {
  both = "horizontal",
  horizontal = "vertical",
  vertical = "both",
}

local cut_for_state = {
  both = M.CUT_NONE,
  horizontal = M.CUT_HORIZONTAL,
  vertical = M.CUT_VERTICAL,
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

function Grid:to_cut_grid()
  local tile_columns = self.columns * 2
  local tile_rows = self.rows * 2
  local cut_columns = self.columns + 1
  local cuts = {}

  for row = 0, tile_rows do
    cuts[row] = {}
    for column = 0, cut_columns - 1 do
      cuts[row][column] = M.CUT_NONE
    end
  end

  for row = 0, tile_rows do
    if row % 2 == 1 then
      cuts[row][0] = M.CUT_VERTICAL
      cuts[row][cut_columns - 1] = M.CUT_VERTICAL
    end
  end

  for column = 0, cut_columns - 1 do
    cuts[0][column] = M.CUT_HORIZONTAL
    cuts[tile_rows][column] = M.CUT_HORIZONTAL
  end

  for row = 1, self.rows do
    for column = 1, self.columns do
      local cut_row = row * 2
      local cut_column = column - 1
      cuts[cut_row][cut_column] = cut_for_state[self.cells[row][column]]
    end
  end

  return {
    tile_columns = tile_columns,
    tile_rows = tile_rows,
    cut_columns = cut_columns,
    cuts = cuts,
  }
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
