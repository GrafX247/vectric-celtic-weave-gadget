local M = {}

function M.default_state()
  return {
    face_width = 150.0,
    face_height = 1800.0,
    border = 20.0,
    columns = 6,
    row_mode = "auto",
    rows = 0,
    cross_section_preset = "fancy",
    profile_width = 8.0,
    profile_height = 3.0,
  }
end

function M.from_dialog(dialog)
  local state = M.default_state()

  state.face_width = dialog:GetDoubleField("FaceWidth")
  state.face_height = dialog:GetDoubleField("FaceHeight")
  state.border = dialog:GetDoubleField("Border")
  state.columns = dialog:GetIntegerField("Columns")
  state.row_mode = dialog:GetRadioIndex("RowMode") == 2 and "fixed" or "auto"
  state.rows = dialog:GetIntegerField("Rows")

  local preset_index = dialog:GetRadioIndex("CrossSectionPreset")
  if preset_index == 1 then
    state.cross_section_preset = "none"
  elseif preset_index == 2 then
    state.cross_section_preset = "square"
  elseif preset_index == 3 then
    state.cross_section_preset = "round"
  elseif preset_index == 4 then
    state.cross_section_preset = "oval"
  else
    state.cross_section_preset = "fancy"
  end

  state.profile_width = dialog:GetDoubleField("ProfileWidth")
  state.profile_height = dialog:GetDoubleField("ProfileHeight")

  return state
end

return M
