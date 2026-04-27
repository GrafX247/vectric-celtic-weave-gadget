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

function luaunit.assertAlmostEquals(actual, expected, tolerance)
  if math.abs(actual - expected) > tolerance then
    error(
      string.format(
        "assertAlmostEquals failed: expected %s +/- %s, got %s",
        tostring(expected),
        tostring(tolerance),
        tostring(actual)
      ),
      2
    )
  end
end

function luaunit.assertNil(actual)
  if actual ~= nil then
    error(
      string.format("assertNil failed: expected nil, got %s", tostring(actual)),
      2
    )
  end
end

function luaunit.assertTrue(actual)
  if actual ~= true then
    error(
      string.format("assertTrue failed: expected true, got %s", tostring(actual)),
      2
    )
  end
end

function luaunit.assertNotEquals(actual, expected)
  if actual == expected then
    error(
      string.format(
        "assertNotEquals failed: expected value different from %s",
        tostring(expected)
      ),
      2
    )
  end
end

function luaunit.assertStrContains(actual, expected)
  if type(actual) ~= "string" or not actual:find(expected, 1, true) then
    error(
      string.format(
        "assertStrContains failed: expected %s to contain %s",
        tostring(actual),
        tostring(expected)
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
