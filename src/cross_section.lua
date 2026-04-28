local M = {}

local function build_bounds(width, height)
  return { width = width, height = height }
end

local function point(x, y)
  return { x = x, y = y }
end

local function arc_points(width, height, samples)
  local points = {}

  points[#points + 1] = point(0.0, 0.0)
  for index = 1, samples do
    local t = (index / samples) * math.pi
    local x = (width * 0.5) - math.cos(t) * (width * 0.5)
    local y = math.sin(t) * height
    points[#points + 1] = point(x, y)
  end
  points[#points + 1] = point(width, 0.0)

  return points
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
      preset = input.preset,
      points = {
        point(0.0, 0.0),
        point(input.width, 0.0),
        point(input.width, input.height),
        point(0.0, input.height),
        point(0.0, 0.0),
      },
      bounds = build_bounds(input.width, input.height),
    }
  end

  if input.preset == "round" then
    return {
      kind = "polyline",
      preset = input.preset,
      points = arc_points(input.width, input.height, 8),
      bounds = build_bounds(input.width, input.height),
    }
  end

  if input.preset == "oval" then
    return {
      kind = "polyline",
      preset = input.preset,
      points = arc_points(input.width, input.height * 0.75, 10),
      bounds = build_bounds(input.width, input.height * 0.75),
    }
  end

  return {
    kind = "polyline",
    preset = input.preset,
    points = {
      point(0.0, 0.0),
      point(input.width * 0.18, input.height * 0.45),
      point(input.width * 0.35, input.height * 0.85),
      point(input.width * 0.5, input.height),
      point(input.width * 0.65, input.height * 0.85),
      point(input.width * 0.82, input.height * 0.45),
      point(input.width, 0.0),
    },
    bounds = build_bounds(input.width, input.height),
  }
end

return M
