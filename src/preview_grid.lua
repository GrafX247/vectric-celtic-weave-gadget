local M = {}

function M.crossing_center(solved, column, row)
  return {
    x = solved.border + ((column - 0.5) * solved.cell_size),
    y = solved.border + ((row - 0.5) * solved.cell_size),
  }
end

return M
