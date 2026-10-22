# Changelog — Tagged

**This is the ordered log of every change made to this project, oldest → newest.**
The AI MUST append an entry here every time it changes a file. This is how progress
survives across devices — a new session reads this to see what's already done.

## Format for new entries
```
## [YYYY-MM-DD] Short title of the change
- **File(s):** which files were touched
- **What changed:** plain-English description of the change and why
- **Status:** done / partial / reverted
- **Next:** what should happen immediately after this entry
```

---

## [2026-10-21] Project created and renamed to Tagged
- **File(s):** `Tagged` (created), `hydroxide_original.lua` (source, since deleted)
- **What changed:** Downloaded the original Rogue Lineage "hydroxide" script
  (`ROGUE/rogue_ui.lua`, 27,282 lines) from `https://git.fable.bz/zyu/hydroxide/raw/branch/main/`.
  Created `Tagged` as a renamed copy: all 47 "hydroxide/Hydroxide/HYDROXIDE" references
  → Tagged/tagged, EXCEPT the git.fable.bz URL (must stay so the script can load its
  runtime UI library) and the `tagged_raw` getgenv key (kept in sync across 2 lines).
- **Status:** done
- **Next:** UI work (accent color, compaction, search verification).

## [2026-10-21] GitHub repo set up with auto-save
- **File(s):** `.gitignore`, `NOTES.md`, `.git/hooks/post-commit`
- **What changed:** Installed `gh` CLI, authenticated as `jphcyv4rxx-cmd`, created
  private repo `https://github.com/jphcyv4rxx-cmd/Tagged`. Added a `post-commit` git
  hook that auto-pushes every commit so progress saves to GitHub without being asked.
  Set git identity to the GitHub username + noreply email.
- **Status:** done
- **Next:** remove unwanted files from the repo.

## [2026-10-21] Removed old hydroxide code and reference image
- **File(s):** `hydroxide_original.lua` (deleted), `thumb.jpg` (deleted locally)
- **What changed:** User asked to delete the reference image and the old hydroxide code
  from GitHub. `thumb.jpg` was git-ignored so it was never on GitHub — deleted from local
  disk only; its sampled colors are preserved in `NOTES.md`. `hydroxide_original.lua`
  HAD been pushed, so it was purged from git history via `git commit --amend` + force-push
  (the repo had a single commit, so rewriting it removed the file entirely).
- **Status:** done
- **Next:** set up the notes/changelog system for cross-device memory.

## [2026-10-21] Set up cross-device memory system
- **File(s):** `NOTES.md` (rewritten), `CHANGELOG.md` (created)
- **What changed:** Rewrote `NOTES.md` as the master "read this first" file: added
  explicit instructions for the AI to follow when resuming on a new device (read both
  files, re-establish context silently, update both on every change, commit+push, never
  re-add deleted files). Created this `CHANGELOG.md` as a separate ordered log of every
  change. Purpose: the user works on multiple devices; chat history does NOT sync but
  this repo does, so these two files carry the project memory between machines.
- **Status:** done
- **Next:** begin UI work — first change the default accent from red to teal `#00C7C0`.

## [2026-10-21] Added agent instructions (AGENTS.md + README.md)
- **File(s):** `AGENTS.md` (created), `README.md` (created)
- **What changed:** Created `AGENTS.md` — a file that ANY AI coding agent (OpenCode,
  Claude Code, Codex, Copilot, Aider, Cursor...) will auto-read, containing the rules:
  read NOTES.md + CHANGELOG.md on session start, auto-commit + push every chunk of work
  (verify the push landed, don't assume), and the hard constraints (never break the
  git.fable.bz runtime URL, never re-add deleted files, keep the repo private). Added
  `README.md` pointing to AGENTS.md, NOTES.md, and CHANGELOG.md so the system is
  discoverable. Purpose: the user wants updates pushed automatically from any AI on any
  device, not just a single chat session.
- **Status:** done
- **Next:** begin UI work — first change the default accent from red to teal `#00C7C0`.

## [2026-10-21] Self-host all runtime deps + add loadstring (no more git.fable.bz)
- **File(s):** `Tagged` (line 5), `backup/loader.lua` (rewritten), `backup/DEPENDENCIES/*`
  (added: Library, SaveManager, ThemeManager, Chatlogger), `README.md`, `NOTES.md`
- **What changed:** The script no longer depends on zyu's git.fable.bz server. Downloaded
  all 5 runtime deps (loader.lua + DEPENDENCIES/{Library,SaveManager,ThemeManager,
  Chatlogger}.lua) into `backup/`, mirroring the original path layout so every
  `DEFAULT_RAW .. "DEPENDENCIES/..."` fetch resolves. Repointed `Tagged` line 5
  `DEFAULT_RAW` from `https://git.fable.bz/zyu/hydroxide/raw/branch/main/` to
  `https://raw.githubusercontent.com/jphcyv4rxx-cmd/Tagged/main/backup/`. Rewrote
  `backup/loader.lua` to load `Tagged` from this repo on rejoin (it previously pulled
  zyu's original rogue_ui.lua, which would have reverted the rebrand after a rejoin).
  Flipped the repo PUBLIC (required for unauthenticated HttpGet — private repos 403);
  user accepted the code is readable, same as zyu. Added a one-line loadstring to
  `README.md`: `loadstring(game:HttpGet("https://raw.githubusercontent.com/jphcyv4rxx-cmd/Tagged/main/Tagged"))()`.
  Only remaining git.fable.bz mention in `Tagged` is a non-executed comment on line ~3872.
- **Status:** done
- **Next:** begin UI work — first change the default accent from red to teal `#00C7C0`.

## [2026-10-22] Big UI overhaul + accent picker + font changer + leaderboard stealth + Path Editor
- **File(s):** `Tagged`, `backup/DEPENDENCIES/Library.lua`,
  `backup/DEPENDENCIES/ThemeManager.lua`, `backup/DEPENDENCIES/Chatlogger.lua`
- **What changed:**
  - **Accent → teal.** `shared.theme.accent` is now `Color3.fromRGB(0,199,192)`
    (`#00C7C0`) instead of red. The library's own default scheme matches
    (Background `#1B1B1B`, Main `#222222`, Accent `#00C7C0`, Outline `#2E2E2E`) so
    the look is right even before the theme manager runs.
  - **Live accent picker.** Added `applyAccent(color)` in `Tagged` (wires to
    `utility:ChangeAccent`, `library.Scheme.AccentColor` and
    `library:UpdateColorsUsingRegistry()`). An `AccentColor` ColorPicker now sits at
    the top of Interface ▸ UI Settings. Persists via SaveManager.
  - **Font changer.** New `UIFont` dropdown in Interface ▸ UI Settings with ~38 Roblox
    fonts; drives `library:SetFont(Enum.Font[...])`. The library already applies
    `FontFace = "Font"` through the colour registry, so it restyles every element live.
  - **UI scale slider.** `UIScale` (70–110%, default 90) calls `library:SetDPIScale`.
  - **Accent top bar.** The window's top bar is now a slim (40px, was 48px)
    accent-coloured bar with rounded corners and a bold dark title. It is the drag
    handle (`Library:MakeDraggable(MainFrame, TopBar, ...)`), so the whole window moves
    by holding the accent bar — same feel as the rest of the UI. Named `TopBar`; a
    toggle `AccentTopBar` in Interface turns it on/off.
  - **Compact + neater.** Window default 640×520 (was 720×600), corner radius 6,
    list/padding spacing tightened (8→5, container padding 7→5, groupbox header
    trimmed), tabs/container start at y=41 with matching heights, search box restyled
    and labelled `Search (ctrl+f)`.
  - **Leaderboard stealth.** New toggle `neutral_leaderboard` ("Hide Leaderboard
    Colours") in Visuals ▸ Overlays. When on, every leaderboard name renders plain white
    instead of the class/observe/MaxEdict colours, so the colour tells give nothing
    away. Observe (right-click a name) and the hover class readout still work — only the
    giveaway colours are hidden. Wired into `updatePlayerLabel` and persisted in
    `cheat_client.config.neutral_leaderboard`.
  - **Path Editor tab.** New `Path Editor` tab (icon `route`) with four groupboxes:
    Path Points, Edit Point, Path Files, Run/Debug. List/select points, select-nearest,
    move a point to you, insert at end, reorder up/down, delete, clear; edit wait time /
    gate location / is-gate / wait-for-trinket and apply to the selected point; locally
    teleport to a point; save / load / duplicate / rename / delete / refresh paths. Run
    Path (test/real) and Stop Bot included, plus an optional 3s auto-refresh of the point
    list. It reuses the existing trinket-bot file format via a new `cheat_client.path_api`
    bridge instead of duplicating the loader.
  - **Rebrand leftovers fixed.** `ThemeManager.Folder` `HYDROXIDELib` → `TaggedLib`;
    added a built-in `Tagged` theme (teal) and set it as the default; `Chatlogger` paths
    `HYDROXIDE/...` → `Tagged/...`, highlight word `hydroxide` → `tagged`, and the
    "What's hydroxide.solutions?" response → "What's Tagged?".
- **Status:** done (syntax-validated with the Luau compiler; pending in-game test)
- **Next:** in-game test pass — verify accent-bar dragging, font changer, neutral
  leaderboard and the Path Editor save/load round-trip on the executor.

## [2026-10-22] Fix: library theme-colour registry crashed on property overrides
- **File(s):** `backup/DEPENDENCIES/Library.lua`
- **What changed:** The script errored on load with
  `Unable to assign property TextColor3. Color3 expected, got string` at
  `FillInstance`. Cause: `FillInstance` had a branch for "key already registered in
  `Library.Registry`" that only cleared the registry entry and let execution fall
  through to the raw assign, so any element that overrode a colour its *template*
  had already set (e.g. the new top-bar title overriding `TextLabel`'s default
  `TextColor3 = "FontColor"` with `"BackgroundColor"`) got the literal string
  assigned to a `Color3` property. Reordered the branches so theme-registry values
  (`Library.Scheme[v]` or a function) always resolve first, and the "literal
  overrides a registered theme key" case is the only one that prunes the registry.
- **Status:** done
- **Next:** re-run the in-game test pass (previous entry's checklist).

## [2026-10-22] Cache-bust Library.lua fetch (stale CDN copy caused the repeated error)
- **File(s):** `Tagged` (line ~3181)
- **What changed:** The previous `FillInstance` fix WAS live on GitHub, but the user still
  saw the same error — because `Tagged` fetched `Library.lua` with
  `game:HttpGet(DEFAULT_RAW .. "DEPENDENCIES/Library.lua", true)`, and that `true`
  (nocache) flag is ignored by some executors, so a stale cached copy was being loaded.
  `SaveManager`/`ThemeManager` right below already append `?nonce=<random>` for exactly
  this reason. Added the same `?nonce=` param to the `Library.lua` fetch (keeping the
  `true` flag) so an updated library always comes down.
- **Status:** done
- **Next:** reload the script in-game (fresh executor session) and re-test.

## [2026-10-22] Make the new UI colours version-proof (no registry strings over template props)
- **File(s):** `backup/DEPENDENCIES/Library.lua`
- **What changed:** Root cause of the repeated crash found by diffing against upstream
  `b4ee7b6`: the original library never hit the `FillInstance` string→`Color3` bug
  because the upstream SearchBox set `BackgroundColor3` (a property the `TextBox`
  *template* does not define) and the upstream title label set **no** `TextColor3`. My
  UI work added `TextColor3` on the title (`TextLabel` template already registers
  `TextColor3`) and `TextColor3` on the search box (`TextBox` template likewise) — the
  first collisions ever to hit that latent branch. Switched all four new colour props
  (title `TextColor3`, search box `TextColor3`, search icon `ImageColor3`, top-bar
  `BackgroundColor3`) to **function values** (`function() return Library.Scheme.X end`),
  which every version of `FillInstance` resolves correctly. The library is now safe on
  old *and* new builds, so a stale cached copy can no longer crash the script.
- **Status:** done
- **Next:** reload in-game; the title/search bar should render with correct colours.

## [2026-10-22] Fix ColorPicker API + path-dropdown selection (UI now builds past settings)
- **File(s):** `Tagged`
- **What changed:** Two real API bugs found by auditing against the library:
  - **`AddColorPicker` was called on the groupbox**, but in this library build colour
    pickers attach to **labels** — `AddColorPicker` lives in `BaseAddons` (alongside
    `AddKeyPicker`), not `BaseGroupbox`. Changed to the existing project pattern:
    `group_ui:AddLabel("Accent Color"):AddColorPicker("AccentColor", {...})` (that is how
    the skin/dye/RLFace pickers already work). Also added `Title` and dropped `Changed`
    (the library fires `Callback` and `Changed` at the same point, so both was redundant).
  - **Path Editor point dropdown was broken.** `Dropdown.Values` is an **array** and
    `SetValue` matches with `table.find`, so passing a numeric index never selected
    anything; worse, the callback did `tonumber(value)` on a label like
    `"1. (10, 20, 30)"`, which is `nil`, silently clearing the selection on every
    refresh. Now builds a `label -> index` map plus an `index -> label` map, selects by
    label string, and uses a `refreshing` guard so `SetValues`/`SetValue` firing the
    callback cannot wipe the user's selection.
  - **Option-ID collision removed.** The editor reused `PointWaitTime`, which the
    trinket bot already registers (line ~16468); creating it again would orphan the
    bot's widget. Renamed the editor's four options to `PathEditWaitTime`,
    `PathEditGateLocation`, `PathEditIsGate`, `PathEditWaitTrinket`.
- **Also audited:** every `:Add*`/`:Set*` method used in the new Path Editor + UI
  Settings blocks checked against the real `BaseGroupbox`/`BaseAddons` method lists (all
  valid); tab/groupbox icons verified to degrade gracefully on unknown names (`if Icon
  then` / `if BoxIcon then` guards), so the `route` icon is safe.
- **Status:** done (Luau-validated)
- **Next:** reload in-game and confirm the Interface tab renders, then exercise the
  Path Editor point selection.

## [2026-10-22] Merge Botting + Path Editor into "Bot Path" and add floating path editor
- **File(s):** `Tagged`
- **What changed:** Restructured the botting UI per the user's screenshot/reference.
  - **Tabs merged.** The old `Botting` and `Path Editor` tabs are now a single tab named
    **`Bot Path`** (icon `bot`). `Tabs.PathEditor` is gone entirely.
  - **Path Files relocated.** File management now lives in a `Path Files` groupbox at the
    **bottom of the Bot Path tab** (right column, below Trinket Bot Config and Looping
    Settings) — it reuses the existing `PathName` / `SavedPaths` options instead of
    creating duplicate inputs. It holds: Open Path Editor, Save Current Path, Duplicate
    Selected Path, Rename Selected Path.
  - **Floating path editor window** matching the reference shot: its own `ScreenGui`
    (`TaggedPathEditorGui`, `DisplayOrder = 2000`, `IgnoreGuiInset`, `ResetOnSpawn =
    false`, parented to `ui`/`gethui` with a PlayerGui fallback) so it always draws above
    the library UI — no ZIndex fighting. Accent header with the live point count
    `path editor (N)`, an `X` to close, and the header is the drag handle.
  - **Toolbar:** `+ Add @ Me`, `+ Action` (adds a 1s wait point), `Copy`, `Paste` on the
    left; `Test`, `Refresh`, `Save` on the right.
  - **Table:** `#`, `TYPE`, `POSITION`, `AREA`, `OPTIONS`, `ACTIONS`. Click the `#` cell
    to select a row (accent outline). `TYPE` shows `POINT` or `GATE` (gate points are
    yellow). `AREA` is an editable TextBox for the gate location (typing one marks the
    point as a gate). `OPTIONS` is an editable TextBox for the wait time in seconds.
    `ACTIONS` has `^` / `v` to move a point earlier/later and `X` to delete it, all of
    which re-render and refresh the 3D point markers.
  - **Visualise Points kept** in the Trinket Bot groupbox (now inside Bot Path).
  - Adding points inserts after the current selection (or appends), so building a route
    in order is straightforward.
- **Status:** done (Luau-validated)
- **Next:** in-game check — open the editor from `Path Files`, add/reorder/delete points,
  confirm the markers update and Save round-trips.

## [2026-10-22] Smooth editor drag, action points (LUA/TALK/etc), saved accent+font, Gorpig log
- **File(s):** `Tagged`
- **What changed:**
  - **Path editor drag is smooth now.** The window used to move from `InputObject.Changed`,
    which only fires when the OS reports a new cursor position and runs behind the
    renderer — that is what felt choppy. It now captures a start cursor position on
    `InputBegan` and moves the window on **`RunService.RenderStepped`** from the
    `UserInputService:GetMouseLocation()` delta (constant offsets cancel out, so no
    inset/DPI math is needed). `InputObject.Changed` is only used to detect
    `UserInputState == End` and disconnect the render connection.
  - **Action point types.** `+ Action` in the editor toolbar now opens a small popup
    list instead of dumping a plain wait point. New point types:
    `LUA` (run a file from `Tagged/trinket_paths/lua/`), `TALK` (walk to the point then
    click the nearest/`--name`-matched NPC's ClickDetector), `EQUIP` (tool by name),
    `WAIT` (seconds), `L-CLICK`, `R-CLICK`. The `TYPE` column shows them colour-coded;
    `OPTIONS` edits the action's argument (file / NPC / tool / seconds) and `AREA` goes
    read-only on action rows. Actions are stored per point as
    `action = { type, value }` — carried through the editor's Copy/Paste, both JSON
    serializers and the path loader, so old paths still load unchanged.
  - **LUA action runner** (`path_action_run_lua`) executes the file with the documented
    `env` table: `char`, `hum`, `hrp`, `point`, `findTool`, `leftClick`, `rightClick`,
    `mana` (`charge` / `decharge` / `chargeUntil` / `available` / `canUse` /
    `usingKeyPress`), `botLog`, `running`, `webhook`, `requestRemote`, `drop`. The
    `lua/` folder is created automatically. Errors are reported through the notify log
    instead of killing the run.
  - **Runner hook.** `RunPathPointAction` runs inside the main path loop right after the
    bot arrives at a point (inside `if not skip_current_point`, before the wait time),
    wrapped in `pcall` so a broken action cannot abort the route.
  - **Accent is persisted.** The library's `SaveManager` ignores theme settings, so
    accent / font / scale now live in `Tagged/ui_state.json` (`read_ui_state` /
    `write_ui_state`). The colour picker writes the hex on change, and the file is
    reapplied in a `task.defer` once every tab exists.
  - **Path editor honours the accent.** `applyAccent` calls `cheat_client.path_editor
    .refresh_theme()`, which rebuilds the floating window with the current scheme and
    keeps its visibility — previously it was built once with the old accent and never
    updated.
  - **Font now applies to every tab.** `applyUIFont` still calls `library:SetFont`, but
    then force-writes `FontFace` on every `TextLabel` / `TextButton` / `TextBox` under
    `library.ScreenGui`. Elements created outside the colour registry (dependency
    boxes, dropdown popups, key pickers, search box) were the ones that stayed on the
    old font. The `UI Font` dropdown default is now `Code` to match
    `Library.Scheme.Font` instead of claiming `Gotham`.
  - **Gorpig detector.** New `Gorpig Detector` groupbox in **Bot Path**: toggle, wrapped
    8-line log (newest first, `[HH:MM:SS]` stamped) and `Clear Gorpig Log`. A 1s
    background loop scans `workspace` for `Model`s whose name contains `gorpig` while a
    path is running, reports anything inside the range with a 20s per-model re-log
    throttle (weak-keyed table), and notifies. The range is the new
    **`Gorpig Proximity (studs)`** slider (default 150), placed with the other
    proximity sliders in the Trinket Bot groupbox.
  - **De-duplication.** There is now exactly one save implementation:
    `save_current_path_file()` in the bot block (it can snapshot the bot settings),
    exposed as `cheat_client.path_api.save_current_path`. The `Save Path` button and the
    editor's `Save` both call it, and the duplicate `Save Current Path` button was
    removed from `Path Files` (now Open / Duplicate / Rename only).
- **Status:** done (Luau-validated with `luau-compile`)
- **Next:** in-game pass — drag the editor, reload to confirm the accent/font stick,
  swap fonts and check every tab, add a LUA + TALK point to a throwaway path, and watch
  the Gorpig log while botting.

## [2026-10-22] Add a Roblox Studio UI preview harness (test the UI with no executor)
- **File(s):** `tests/ui_preview.client.lua` (new), `tests/studio_install.lua` (new),
  `tests/README.md` (new)
- **What changed:** Executors were down, so added a way to exercise the UI in plain
  Roblox Studio. It does **not** run `Tagged` (that returns early unless
  `game.PlaceId` is Rogue Lineage, and blocks on `WaitForChild("AreaMarkers")` /
  `ReplicatedStorage.Requests`, so it hangs in a baseplate). Instead:
  - `tests/studio_install.lua` — one command-bar paste. Fetches
    `backup/DEPENDENCIES/Library.lua` from this repo into a `ReplicatedStorage
    .TaggedLibrary` ModuleScript, and `tests/ui_preview.client.lua` into
    `StarterPlayerScripts.TaggedUIPreview`, then you just press Play. Re-running it
    refreshes both.
  - `tests/ui_preview.client.lua` — requires the real library, runs the same
    `SetDPIScale(90)` → `CreateWindow{640x520}` setup as `Tagged`, and rebuilds the
    changed UI: Bot Path (Trinket Bot subset incl. `Gorpig Proximity`, Gorpig Detector
    with a fake detection every 2s to test the wrapped log, Path Files), Interface (UI
    Settings: accent picker / font dropdown / scale slider / accent top bar, plus a
    widget reference sheet), and a floating path editor that reuses the **same
    `RenderStepped` + `GetMouseLocation()` delta drag**, the `+ Action` popup, the
    colour-coded TYPE column and the `refresh_theme` rebuild on accent/font change.
  - `tests/README.md` — setup steps, what is and isn't covered, and a manual fallback
    if Studio refuses `Source` assignment (paste Library.lua into the ModuleScript).
  - Known gap: bot logic, `Drawing` ESP, remotes and `writefile`/`readfile` still need
    an executor; the preview's Save is a no-op.
- **Status:** done (both files Luau-validated)
- **Next:** run the harness once in Studio to confirm the drag/accent/font behaviour,
  then repeat the in-game pass when an executor is back.
