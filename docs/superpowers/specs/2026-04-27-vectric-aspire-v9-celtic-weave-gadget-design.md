# Vectric Aspire V9 Celtic Weave Gadget Design

**Project:** Aspire V9 Celtic weave gadget plugin

**Goal:** Build a usable Aspire V9 gadget that generates Celtic weave rail vectors and optional preset cross-section vectors for rectangular post faces, preserving square weave geometry and fitting within adjustable borders.

## Summary

The gadget is a modernized replacement for the legacy-style Celtic Weave Creator workflow shown in the reference screenshots and transcript. It should produce the same practical output: editable 2D weave rails that can be passed into Aspire's native `Extrude and Weave` tool, plus an optional cross-section vector for extrusion.

This is not a pixel-perfect clone of the old dialog and it should not attempt to recreate Aspire's modeling toolchain. The gadget owns the 2D weave topology, panel sizing, and optional cross-section generation. Aspire continues to own the 3D `Extrude and Weave` behavior.

## User Problem

The target use case is decorative weave panels for square or rectangular posts, for example:

- face width: `100 mm` or `150 mm`
- face height: up to `1800 mm`
- adjustable border: e.g. `20 mm`
- fixed weave density across the width, such as `6` columns

The pattern must not distort to fit the height. The weave cells stay square. If more height is available, the layout should add more rows rather than stretch vertically.

## Non-Goals

The first version does not include:

- a clone of Aspire's `Extrude and Weave` left-hand modeling panel
- direct 3D component generation
- freeform custom cross-section editing inside the gadget
- non-square weave cells
- advanced symmetry/preset libraries
- guaranteed reopen/re-edit of saved designs unless the Aspire gadget API proves it can be done robustly

## Functional Requirements

### 1. Panel Sizing

The gadget must accept:

- `Face Width`
- `Face Height`
- adjustable border values
- `Columns Across`
- row mode:
  - `Auto-fill height`
  - `Fixed rows`

The geometry rules are:

- cells are square in v1
- usable width = face width minus left and right borders
- usable height = face height minus top and bottom borders
- cell size is derived from usable width and columns across
- in auto-fill mode, rows are computed from available height
- in fixed-row mode, the requested row count must fit inside the available height or fail validation

The gadget must show derived values live:

- usable width
- usable height
- cell size
- computed rows
- pattern height

### 2. Border Handling

Borders affect real geometry and are not decorative metadata.

V1 supports one linked border value applied equally on all four sides. The sizing engine should be written so per-side borders can be added in a future version without replacing the core geometry math.

Generated rails must fit inside the bordered panel area.

### 3. Topology Editing

The weave is defined by a grid of crossing points.

Each crossing cycles through three states when clicked:

- both directions connected
- horizontal-only
- vertical-only

The gadget must provide:

- a live preview/editor
- a reset action for crossing content
- topology rebuild when columns or rows change

The interaction should follow the old tool's behavior closely enough that a user familiar with it can use it immediately, but the UI does not need to mimic the old layout.

### 4. Vertical Fit Modes

The gadget must support both modes because both are required by the target workflow.

#### Auto-fill height

- derive square cell size from width
- compute how many full rows fit inside usable height
- stop before violating the border constraints

#### Fixed rows

- use the exact requested row count
- preserve square cells
- validate if the pattern height exceeds the usable height

### 5. Rail Vector Output

On apply, the gadget must generate:

- clean 2D rail vectors representing the weave layout
- vector grouping suitable for easy selection in Aspire
- stable placement inside the bordered panel area

The output must be usable with Aspire's native `Extrude and Weave` tool without manual cleanup.

This is a core success criterion. Clean vector generation matters more than visual polish in the preview.

### 6. Cross-Section For Extrude

This is a v1 feature because it removes repetitive manual setup.

The gadget must support:

- `None`
- `Square`
- `Ellipse`
- `Round`
- `Fancy`

The cross-section must also support:

- `Profile Width`
- `Profile Height`

These are independent values. The weave layout remains square and non-distorted; only the profile dimensions are independently adjustable.

The gadget should prefill sensible default profile dimensions, but they must stay editable.

### 7. Cross-Section Placement

The generated cross-section vector should be placed automatically in a predictable offset position beside the weave, following the easiest workflow for selection in Aspire.

V1 should not expose a custom anchor-placement control for the profile.

### 8. Aspire Workflow Boundary

The gadget is responsible for:

- panel sizing
- topology editing
- rail vector generation
- optional cross-section generation

Aspire remains responsible for:

- assigning rails in `Extrude and Weave`
- attaching the profile to the rails
- over/under weave behavior
- square corner options in the modeling tool
- `Scale Shape` vs `Add Base`
- `Z Under` and `Z Over`
- final component combination behavior

This boundary avoids duplicating native Aspire functionality poorly.

## UI Design

The UI should be modernized and task-focused rather than copied from the legacy dialog.

Recommended structure:

- left panel:
  - face width
  - face height
  - border
  - columns across
  - row mode
  - rows down when fixed mode is selected
  - derived values
- main panel:
  - live weave preview/editor
- secondary panel:
  - cross-section preset
  - profile width
  - profile height
  - action buttons

Recommended actions:

- `Rebuild Preview`
- `Reset Crossings`
- `Create Cross Section`
- `Apply`
- `Close`

## Internal Architecture

The implementation should be split into clear units.

### Sizing Engine

Responsible for:

- border-aware panel math
- square-cell calculation
- auto-fill row calculation
- fixed-row validation

This part should be pure logic and independently testable.

### Topology Model

Responsible for:

- storing crossing states
- resetting state
- resizing the grid
- exposing enough information to build preview and output geometry

### Geometry Builder

Responsible for:

- converting topology and sizing into centerline rail vectors
- generating preset cross-section vectors
- placing generated geometry into the Aspire job

This is the highest-risk part and should be validated early.

### UI Layer

Responsible for:

- binding inputs to the sizing/topology model
- rendering the preview
- handling click-to-cycle interactions
- invoking output creation

## Re-Edit Strategy

Re-edit support is desirable because the legacy tool can reconstruct an existing weave when the generated vectors remain grouped and unmodified.

However, this should not be promised until proven.

Recommended v1 approach:

- treat re-edit as a technical spike early in development
- if robust metadata tagging or geometry reconstruction is possible, include it
- if not, defer reopen/re-edit explicitly rather than ship something unreliable

The product is still useful without that feature. Clean output and correct sizing matter more.

## Validation Rules

The gadget must validate at least:

- positive face width and height
- positive border values
- positive columns count
- positive rows count when fixed mode is active
- usable width greater than zero
- usable height greater than zero
- auto-fill mode producing at least one row
- fixed-row mode fitting inside usable height
- profile width and height greater than zero when a preset profile is selected
- profile width remaining within a safe bound relative to cell size

Validation should fail clearly before generating invalid geometry.

## Success Criteria

The gadget is successful when a user can:

1. Enter a post face size such as `150 mm x 1800 mm`
2. Set a border such as `20 mm`
3. Set `6` columns across
4. Choose auto-fill or fixed rows
5. Edit crossing states interactively
6. Generate rail vectors that fit the panel without distortion
7. Generate an optional preset cross-section beside the weave
8. Use those vectors directly with Aspire's native `Extrude and Weave` workflow

## Risks

Primary risks:

- Aspire gadget API limitations around vector creation/grouping
- reliable generation of clean rails for the full weave topology
- possible difficulty reconstructing a previously generated weave from saved geometry

Secondary risks:

- preview/editor interaction quirks
- profile preset geometry looking poor at extreme dimensions

## Recommended Delivery Order

1. Prove the sizing engine with post-face constraints
2. Build the crossing-state grid model
3. Generate preview geometry from the model
4. Generate real rail vectors in Aspire
5. Generate preset cross-section vectors with width/height controls
6. Validate the workflow against Aspire `Extrude and Weave`
7. Spike reopen/re-edit support only after the above is stable

## Open Decisions Closed In This Spec

The following decisions are now fixed for v1:

- modernized UI, not pixel-perfect V9 cloning
- same practical output as the old workflow
- no geometry distortion
- square cells only
- width-driven sizing
- height handled by auto-fill or fixed rows
- adjustable borders
- preset cross-section generation included
- profile width and height both adjustable
- cross-section placed automatically beside the weave
- Aspire keeps ownership of 3D modeling parameters
