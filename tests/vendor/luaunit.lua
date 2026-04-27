local luaunit = {}

function luaunit.assertEquals(actual, expected)
  if actual ~= expected then
    error(
      string.format(
        "assertEquals failed: expected %s, got %s",
        tostring(expected),
        tostring(actual)
      ),
      2
    )
  end
end

local function run_test_case(name, case)
  local failures = 0

  for method_name, method in pairs(case) do
    if type(method_name) == "string" and method_name:match("^test_") and type(method) == "function" then
      local ok, err = pcall(method)
      if not ok then
        failures = failures + 1
        io.stderr:write(string.format("%s.%s failed: %s\n", name, method_name, err))
      end
    end
  end

  return failures
end

luaunit.LuaUnit = {}

function luaunit.LuaUnit.run()
  local failures = 0

  for name, value in pairs(_G) do
    if type(name) == "string" and name:match("^Test") and type(value) == "table" then
      failures = failures + run_test_case(name, value)
    end
  end

  if failures > 0 then
    return failures
  end

  return 0
end

return luaunit
