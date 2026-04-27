local sizing = require("sizing")
local topology = require("topology")
local rail_geometry = require("rail_geometry")
local cross_section = require("cross_section")
local aspire_vectors = require("aspire_vectors")

local M = {}

function M.build_preview(state)
  local solved, err = sizing.solve({
    face_width = state.face_width,
    face_height = state.face_height,
    border = state.border,
    columns = state.columns,
    row_mode = state.row_mode,
    rows = state.rows,
  })
  if not solved then
    return nil, err
  end

  local grid = topology.new(solved.columns, solved.rows)

  return {
    solved = solved,
    grid = grid,
    rails = rail_geometry.build(solved, grid),
  }
end

function M.apply(job, state)
  local preview, err = M.build_preview(state)
  if not preview then
    return nil, err
  end

  local profile
  profile, err = cross_section.build({
    preset = state.cross_section_preset,
    width = state.profile_width,
    height = state.profile_height,
  })
  if err then
    return nil, err
  end

  local rails = aspire_vectors.create_rail_vectors(job, preview.rails)
  local section = aspire_vectors.create_cross_section(job, profile, {
    x = preview.solved.border + preview.solved.pattern_width + 20.0,
    y = preview.solved.border,
  })

  if job.Refresh2DView then
    job:Refresh2DView()
  end

  return {
    preview = preview,
    rails = rails,
    cross_section = section,
  }
end

return M
