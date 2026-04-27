function main(script_path)
  local job = VectricJob()
  if not job.Exists then
    DisplayMessageBox("No job open.")
    return false
  end

  package.path = package.path .. ";" .. script_path .. "\\src\\?.lua"
  local config = require("config")
  local dialog_state = require("dialog_state")
  local controller = require("dialog_controller")

  local html_path = "file:" .. script_path .. "\\CelticWeaveCreator.htm"
  local state = dialog_state.default_state()
  local dialog = HTML_Dialog(false, html_path, 720, 560, config.app_name)

  dialog:AddLabelField("GadgetTitle", config.app_name)
  dialog:AddLabelField("GadgetVersion", config.version)
  dialog:AddDoubleField("FaceWidth", state.face_width)
  dialog:AddDoubleField("FaceHeight", state.face_height)
  dialog:AddDoubleField("Border", state.border)
  dialog:AddIntegerField("Columns", state.columns)
  dialog:AddRadioGroup("RowMode", 1)
  dialog:AddIntegerField("Rows", state.rows)
  dialog:AddRadioGroup("CrossSectionPreset", 3)
  dialog:AddDoubleField("ProfileWidth", state.profile_width)
  dialog:AddDoubleField("ProfileHeight", state.profile_height)

  if not dialog:ShowDialog() then
    return false
  end

  local result, err = controller.apply(job, dialog_state.from_dialog(dialog))
  if not result then
    DisplayMessageBox(config.app_name .. " error: " .. err)
    return false
  end

  DisplayMessageBox(
    "Created " .. result.rails.created .. " weave rail vectors."
  )

  return true
end
