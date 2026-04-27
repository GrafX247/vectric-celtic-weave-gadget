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
