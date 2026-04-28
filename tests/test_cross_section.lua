local luaunit = require("luaunit")
local cross_section = require("cross_section")

TestCrossSection = {}

function TestCrossSection:test_square_profile_uses_requested_width_and_height()
  local profile = cross_section.build({
    preset = "square",
    width = 8.0,
    height = 3.0,
  })

  luaunit.assertEquals(profile.kind, "polyline")
  luaunit.assertAlmostEquals(profile.bounds.width, 8.0, 0.001)
  luaunit.assertAlmostEquals(profile.bounds.height, 3.0, 0.001)
end

function TestCrossSection:test_none_returns_nil()
  local profile = cross_section.build({
    preset = "none",
    width = 8.0,
    height = 3.0,
  })

  luaunit.assertNil(profile)
end

function TestCrossSection:test_round_profile_is_sampled_arc()
  local profile = cross_section.build({
    preset = "round",
    width = 8.0,
    height = 3.0,
  })

  luaunit.assertEquals(profile.kind, "polyline")
  luaunit.assertEquals(profile.preset, "round")
  luaunit.assertTrue(#profile.points > 4)
  luaunit.assertAlmostEquals(profile.bounds.width, 8.0, 0.001)
  luaunit.assertAlmostEquals(profile.bounds.height, 3.0, 0.001)
end

function TestCrossSection:test_oval_profile_is_lower_than_round_height()
  local profile = cross_section.build({
    preset = "oval",
    width = 8.0,
    height = 4.0,
  })

  luaunit.assertEquals(profile.kind, "polyline")
  luaunit.assertAlmostEquals(profile.bounds.height, 3.0, 0.001)
end
