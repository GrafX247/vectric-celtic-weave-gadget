local M = {}

local function create_contour(points, offset)
  local contour = Contour(0.0)
  local first = points[1]
  contour:AppendPoint(Point2D(first.x + offset.x, first.y + offset.y))

  for index = 2, #points do
    local pt = points[index]
    contour:LineTo(Point2D(pt.x + offset.x, pt.y + offset.y))
  end

  return contour
end

local function add_group_to_layer(job, group, layer_name)
  local cad_object = CreateCadGroup(group)
  local layer = job.LayerManager:GetLayerWithName(layer_name)
  layer:AddObject(cad_object, true)
  return cad_object
end

local function select_only(job, cad_object)
  if not job.Selection then
    return
  end

  local ok = pcall(function()
    job.Selection:Clear()
    job.Selection:Add(cad_object, false, true)
  end)

  return ok
end

local function rectangle_points(x0, y0, width, height)
  return {
    { x = x0, y = y0 },
    { x = x0 + width, y = y0 },
    { x = x0 + width, y = y0 + height },
    { x = x0, y = y0 + height },
    { x = x0, y = y0 },
  }
end

function M.create_rail_vectors(job, rails)
  local group = ContourGroup(true)

  for _, rail in ipairs(rails) do
    group:AddTail(create_contour(rail.points, { x = 0.0, y = 0.0 }))
  end

  local ok, rejoined = pcall(function()
    return group:RejoinContours(0.001, true, true)
  end)
  if ok and rejoined and not rejoined.IsEmpty then
    group = rejoined
  end

  local cad_object = add_group_to_layer(job, group, "Celtic Weave Rails")
  select_only(job, cad_object)

  return {
    created = #rails,
    group_name = "Celtic Weave Rails",
    object_id = cad_object.Id,
  }
end

function M.create_border_guide(job, solved)
  local group = ContourGroup(true)
  group:AddTail(create_contour(rectangle_points(
    solved.border,
    solved.border,
    solved.pattern_width,
    solved.pattern_height
  ), { x = 0.0, y = 0.0 }))

  local cad_object = add_group_to_layer(job, group, "Celtic Weave Border Guide")

  return {
    created = 1,
    group_name = "Celtic Weave Border Guide",
    object_id = cad_object.Id,
  }
end

function M.create_cross_section(job, profile, anchor)
  if not profile then
    return { created = 0 }
  end

  local group = ContourGroup(true)
  group:AddTail(create_contour(profile.points, anchor))

  local cad_object = add_group_to_layer(job, group, "Celtic Weave Cross Sections")

  return {
    created = 1,
    group_name = "Celtic Weave Cross Sections",
    object_id = cad_object.Id,
  }
end

return M
