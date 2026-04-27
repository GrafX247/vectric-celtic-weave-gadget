local luaunit = require("luaunit")

TestRailGeometryScaffold = {}

function TestRailGeometryScaffold:test_scaffold_failure()
  luaunit.assertEquals(false, true)
end
