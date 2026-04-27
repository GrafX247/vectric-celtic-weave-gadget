local luaunit = require("luaunit")

TestCrossSectionScaffold = {}

function TestCrossSectionScaffold:test_scaffold_failure()
  luaunit.assertEquals(false, true)
end
