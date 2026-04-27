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

function M.create_rail_vectors(job, rails)
  local group = ContourGroup(true)

  for _, rail in ipairs(rails) do
    group:AddTail(create_contour(rail.points, { x = 0.0, y = 0.0 }))
  end

  local cad_object = add_group_to_layer(job, group, "Celtic Weave Rails")

  return {
    created = #rails,
    group_name = "Celtic Weave Rails",
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
