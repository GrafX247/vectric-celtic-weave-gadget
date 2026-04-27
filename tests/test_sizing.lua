local luaunit = require("luaunit")

TestSizingScaffold = {}

function TestSizingScaffold:test_scaffold_failure()
  luaunit.assertEquals(false, true)
end
