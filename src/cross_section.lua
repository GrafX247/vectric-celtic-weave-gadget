local M = {}

local function build_bounds(width, height)
  return { width = width, height = height }
end

function M.build(input)
  if input.preset == "none" then
    return nil
  end

  if input.width == nil or input.width <= 0 or input.height == nil or input.height <= 0 then
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
        { x = 0.0, y = 0.0 },
      },
      bounds = build_bounds(input.width, input.height),
    }
  end

  return {
    kind = "polyline",
    preset = input.preset,
    points = {
      { x = 0.0, y = 0.0 },
      { x = input.width * 0.25, y = input.height * 0.75 },
      { x = input.width * 0.5, y = input.height },
      { x = input.width * 0.75, y = input.height * 0.75 },
      { x = input.width, y = 0.0 },
    },
    bounds = build_bounds(input.width, input.height),
  }
end

return M
