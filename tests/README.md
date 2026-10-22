# Testing the UI without an executor

Executors are only needed to **inject into a live server**. The UI itself is plain
`Instance.new` + `ScreenGui`, so **Roblox Studio** renders it identically. This folder
is a harness for that.

## Why you can't just run `Tagged` in Studio

Two hard blockers (not bugs, by design of the game script):

1. Line 134: the whole script body only runs when `game.PlaceId` is one of the Rogue
   Lineage place IDs. In a baseplate it returns immediately.
2. Lines 273–290: it blocks on `workspace:WaitForChild("AreaMarkers")`,
   `ReplicatedStorage:WaitForChild("Requests")…`, `require(…AreaData)` — none of which
   exist outside the real game, so it would hang *before* the window is created.

So the harness loads the **real** `Library.lua` and rebuilds the changed parts of the
UI instead of executing the bot.

## Setup (once per Studio place)

1. Open your place in Studio → **Game Settings ▸ Security ▸ Allow HTTP Requests = ON**.
2. **View ▸ Command Bar**, paste the whole of `tests/studio_install.lua`, press Enter.
   It downloads from this repo and creates:
   - `ReplicatedStorage.TaggedLibrary` (ModuleScript) ← `backup/DEPENDENCIES/Library.lua`
   - `StarterPlayer ▸ StarterPlayerScripts ▸ TaggedUIPreview` (LocalScript) ← `tests/ui_preview.client.lua`
3. Press **Play**.

Re-run step 2 after pushing UI changes and both files are replaced with the new versions.

If your Studio build refuses `Source` assignment, do it manually: create a ModuleScript
named `TaggedLibrary` in `ReplicatedStorage` and paste `backup/DEPENDENCIES/Library.lua`
into it; then create a LocalScript named `TaggedUIPreview` in `StarterPlayerScripts` and
paste `tests/ui_preview.client.lua`.

## What the preview covers

Matches the real script's setup order (`SetDPIScale(90)` → `CreateWindow` with the same
options), so spacing/sizing is representative.

- **Bot Path** tab
  - Trinket Bot groupbox: input, toggle, compact sliders (`Gorpig Proximity` sits with
    the other proximity sliders), multi-dropdown, dropdown, buttons.
  - Gorpig Detector: toggle + wrapped 8-line log + clear. Turn the toggle on and a fake
    detection is pushed every 2s so you can check the wrap/resize behaviour.
  - Path Files: **Open Path Editor**.
- **Interface** tab
  - UI Settings: accent colour picker, UI font dropdown, UI scale slider, accent top bar.
  - Widget Check: one of each widget for font/colour regressions.
- **Floating path editor** (Open Path Editor)
  - Same `ScreenGui` (`DisplayOrder 2000`, `IgnoreGuiInset`) and the same
    **`RenderStepped` + `GetMouseLocation()` delta** drag as `Tagged`.
  - Table `# / TYPE / POSITION / AREA / OPTIONS / ACTIONS` with colour-coded
    `POINT` / `GATE` / `TRINKET` / `LUA` / `TALK` / `EQUIP` / `WAIT` / `L-CLICK` /
    `R-CLICK` rows, editable gate area + options, `^` / `v` / `X`.
  - `+ Action` popup with the same six action types.
  - Changing the accent or font rebuilds the editor (`refresh_theme`) exactly like the
    real one, and keeps it open.

## What it cannot test

- Bot logic, `Drawing` ESP, remotes, `fireclickdetector`, the path runner, and
  `writefile`/`readfile` (no filesystem in Studio). The editor's **Save** is a no-op.
- Anything that depends on the real game tree (NPCs, gates, trinkets).

For those you still need an executor in a live server. In the meantime, every commit is
validated with `luau-compile`, which catches syntax errors but not runtime wiring.

## Quick checklist

- [ ] Drag the editor header fast in a circle — should track the cursor with no stutter.
- [ ] Change accent → editor header/outline/row selection update immediately.
- [ ] Change UI font → every tab (including dropdown popups and the editor) changes.
- [ ] UI scale 70 → 110 → back to 90, check nothing overlaps.
- [ ] Gorpig Detector on → log lines wrap and the groupbox grows; Clear empties it.
- [ ] `+ Action` → add each type, confirm TYPE colour + OPTIONS placeholder.
