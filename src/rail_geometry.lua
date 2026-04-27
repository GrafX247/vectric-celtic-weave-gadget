local M = {}

local function point(x, y)
  return { x = x, y = y }
end

local shape_tables = {
  tl = {
    { "bltr", true }, { "blr", true }, { "blt", true },
    { "trl", false }, { "lr", false }, { "tl", false },
    { "trb", false }, { "br", false }, { "tb", false },
  },
  tr = {
    { "tlbr", true }, { "brl", false }, { "brt", false },
    { "tlr", true }, { "lr", false }, { "tr", false },
    { "tlb", true }, { "bl", false }, { "tb", false },
  },
  bl = {
    { "tlbr", false }, { "tlr", false }, { "tlb", false },
    { "brl", true }, { "lr", false }, { "bl", false },
    { "brt", true }, { "tr", false }, { "tb", false },
  },
  br = {
    { "bltr", true }, { "trl", true }, { "trb", true },
    { "blr", false }, { "lr", false }, { "br", false },
    { "blt", false }, { "tl", false }, { "tb", false },
  },
}

local prototypes = {
  tlbr = { point(0.0, 0.0), point(1.0, 1.0) },
  bltr = { point(0.0, 1.0), point(1.0, 0.0) },
  tb = { point(0.5, 0.0), point(0.5, 1.0) },
  lr = { point(0.0, 0.5), point(1.0, 0.5) },
  tlb = { point(0.0, 0.0), point(0.5, 0.5), point(0.5, 1.0) },
  tlr = { point(0.0, 0.0), point(0.5, 0.5), point(1.0, 0.5) },
  brt = { point(1.0, 1.0), point(0.5, 0.5), point(0.5, 0.0) },
  brl = { point(1.0, 1.0), point(0.5, 0.5), point(0.0, 0.5) },
  blt = { point(0.0, 1.0), point(0.5, 0.5), point(0.5, 0.0) },
  blr = { point(0.0, 1.0), point(0.5, 0.5), point(1.0, 0.5) },
  trb = { point(1.0, 0.0), point(0.5, 0.5), point(0.5, 1.0) },
  trl = { point(1.0, 0.0), point(0.5, 0.5), point(0.0, 0.5) },
  tl = { point(0.5, 0.0), point(0.5, 0.5), point(0.0, 0.5) },
  br = { point(0.5, 1.0), point(0.5, 0.5), point(1.0, 0.5) },
  bl = { point(0.5, 1.0), point(0.5, 0.5), point(0.0, 0.5) },
  tr = { point(0.5, 0.0), point(0.5, 0.5), point(1.0, 0.5) },
}

local function shape_family(tile_column, tile_row)
  if tile_row % 2 == 0 then
    return tile_column % 2 == 0 and "tl" or "tr"
  end

  return tile_column % 2 == 0 and "bl" or "br"
end

local function cut_at(cut_grid, row, column)
  local cut_row = cut_grid.cuts[row]
  if not cut_row then
    return 0
  end

  return cut_row[column] or 0
end

local function shape_for_tile(cut_grid, tile_column, tile_row)
  local even_cut = cut_at(
    cut_grid,
    math.floor((tile_row + 1) / 2) * 2,
    math.floor(tile_column / 2)
  )
  local odd_cut = cut_at(
    cut_grid,
    math.floor(tile_row / 2) * 2 + 1,
    math.floor((tile_column + 1) / 2)
  )
  local family = shape_family(tile_column, tile_row)

  return shape_tables[family][even_cut + odd_cut * 3 + 1]
end

local function tile_points(shape_name, tile_x, tile_y, tile_size, origin_x, origin_y)
  local prototype = prototypes[shape_name]
  local points = {}

  for _, pt in ipairs(prototype) do
    points[#points + 1] = point(
      origin_x + (tile_x + pt.x) * tile_size,
      origin_y + (tile_y + pt.y) * tile_size
    )
  end

  return points
end

function M.build(solved, grid)
  local rails = {}
  local cut_grid = grid:to_cut_grid()
  local tile_size = solved.cell_size * 0.5

  for tile_row = 0, cut_grid.tile_rows - 1 do
    for tile_column = 0, cut_grid.tile_columns - 1 do
      local shape = shape_for_tile(cut_grid, tile_column, tile_row)
      rails[#rails + 1] = {
        tile_column = tile_column + 1,
        tile_row = tile_row + 1,
        shape = shape[1],
        under = shape[2],
        points = tile_points(
          shape[1],
          tile_column,
          tile_row,
          tile_size,
          solved.border,
          solved.border
        ),
      }
    end
  end

  return rails
end

return M
