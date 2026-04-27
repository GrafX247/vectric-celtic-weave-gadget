local luaunit = require("luaunit")

TestTopologyScaffold = {}

function TestTopologyScaffold:test_scaffold_failure()
  luaunit.assertEquals(false, true)
end
