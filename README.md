# Celtic Weave Rail Generator

Standalone Aspire V9 gadget project for a modernized Celtic weave rail generator.

Current contents:

- `CelticWeaveCreator.lua` and `CelticWeaveCreator.htm` for the Vectric gadget entrypoint and HTML dialog
- `src/` for Lua modules
- `tests/` for pure-logic test scaffolding
- `docs/superpowers/specs/` for the agreed design spec
- `docs/superpowers/plans/` for the implementation plan

Important:

- This project targets Aspire V9 behavior.
- Vectric V10 SDK samples are being used as the closest reference, but Aspire V9 remains the source of truth for runtime validation.
- Aspire V9.5 already includes a stock `Celtic_Weave_Creator` gadget under `C:\ProgramData\Vectric\Aspire\V9.5\Gadgets\Celtic_Weave_Creator`.
- The stock gadget is based on Andrew Birrell's Knotwork Designer at `http://birrell.org/andrew/knotwork/`; its cut/tile topology is the geometry behavior to preserve when replacing the current placeholder rail builder.
- Keep this gadget separately named so users can compare it with the stock gadget and so the stock install is never overwritten.
