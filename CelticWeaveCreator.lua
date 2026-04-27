function main(script_path)
  package.path = package.path .. ";" .. script_path .. "\\src\\?.lua"
  local config = require("config")

  local job = VectricJob()
  if not job.Exists then
    DisplayMessageBox("No job open.")
    return false
  end

  local html_path = "file:" .. script_path .. "\\CelticWeaveCreator.htm"
  local dialog = HTML_Dialog(false, html_path, 640, 480, config.app_name)
  dialog:AddLabelField("GadgetTitle", config.app_name)
  dialog:AddLabelField("GadgetVersion", config.version)

  if not dialog:ShowDialog() then
    return false
  end

  return true
end
