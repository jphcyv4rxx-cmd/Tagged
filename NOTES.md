# Tagged — Project Notes (READ THIS FIRST)

## ⚠️ INSTRUCTIONS FOR THE AI (read carefully)
This file is the **cross-device memory** of this project. OpenCode's chat history is
stored **locally per machine** and does NOT sync between devices. This repo DOES.
So when the user says "read the notes" / "read NOTES.md", do the following, in order:

1. **Read this file (`NOTES.md`) AND `CHANGELOG.md` in full before doing anything.**
   `CHANGELOG.md` is the ordered record of every change ever made. `NOTES.md` is the
   current state + goals. Together they tell you exactly where we left off.
2. **Re-establish context silently.** Do NOT ask the user to re-explain the project.
   You already know it from these files. Say briefly what you understand and what's
   next, then continue working.
3. **REPORT ALL CHANGES IN `CHANGELOG.md`.** Every time you make a change to any file,
   append an entry to `CHANGELOG.md` (format is at the bottom of that file). This is
   non-negotiable — it is how progress survives across devices. Also update the
   "Current state" / "TODO" sections in THIS file when they change.
4. **Commit and push** after finishing a chunk of work (a post-commit hook auto-pushes,
   but confirm the push landed). Never leave work unsaved at the end of a session —
   if the user stops responding, update `CHANGELOG.md` + `NOTES.md` and commit what
   exists, even if incomplete, and note what was in progress.
5. **Never re-introduce files that were deleted** (see "Deleted on purpose" below).

---

## What this project is
A renamed/rebranded copy of the Rogue Lineage "hydroxide" script, saved as `Tagged`.
The user is rebranding it to "Tagged" and improving the UI.

## Goals (what the user wants)
1. **Rename** everything hydroxide → Tagged. ✅ DONE (see CHANGELOG).
2. **Compact the UI** so it's less spread out. ✅ DONE (2026-10-22).
3. **User-changeable accent color** — a live color picker so the user can pick the
   accent themselves. ✅ DONE (2026-10-22).
4. **Match a reference look** (dark grey panels + bright teal accent, sampled from a
   video the user linked — colors recorded below). ✅ DONE (teal default).
5. **Search bar** that finds features by greying everything out and jumping/redirecting
   to the match. ✅ Already existed in the library; relabelled to `Search (ctrl+f)`.
6. **Font changer + UI scale + accent top bar** (2026-10-22). ✅ DONE.
7. **Leaderboard stealth** — hide the class/observe colours, show plain names, keep
   right-click observe. ✅ DONE (2026-10-22).
8. **Path Editor** — build your own bot paths. ✅ DONE (2026-10-22).

## Files in this repo
- `Tagged` — **the deliverable script** (full rogue_ui.lua, ~27,282 lines, renamed).
  This is what the loadstring fetches.
- `backup/` — **self-hosted runtime deps** that `Tagged` loads via HttpGet:
  `loader.lua`, `DEPENDENCIES/Library.lua`, `SaveManager.lua`, `ThemeManager.lua`,
  `Chatlogger.lua`. Mirrors the original git.fable.bz layout so all fetches resolve.
- `NOTES.md` — this file (current state + goals + AI instructions).
- `CHANGELOG.md` — ordered log of every change made, oldest → newest.
- `AGENTS.md` — rules for ANY AI agent (auto-read by coding tools). Tells every AI to
  read the memory files, auto-commit + push, and respect the hard constraints.
- `README.md` — shows the loadstring + hosting explanation + pointers to the memory files.

## Runtime files (executor side, NOT in this repo)
- `Tagged/ui_state.json` — persisted UI prefs: `accent` (hex), `font` (Enum.Font name),
  `scale` (%). Written by the Accent picker / UI Font / UI Scale controls and reapplied
  at startup (`read_ui_state` ~line 7453).
- `Tagged/trinket_paths/<name>.json` — saved paths: `{ points = {...}, settings = {...} }`.
  Each point may carry `action = { type, value }` for LUA/TALK/EQUIP/WAIT/L-CLICK/R-CLICK.
- `Tagged/trinket_paths/lua/<name>.lua` — scripts run by `LUA` action points. Created
  automatically; the runner only ever reads from this folder.

## ⚠️ CRITICAL facts about the script (DO NOT BREAK THESE)
- **SELF-HOSTED — no external server dependency.** `Tagged` loads its runtime deps from
  THIS repo via `https://raw.githubusercontent.com/jphcyv4rxx-cmd/Tagged/main/backup/`.
  That URL must stay intact or the script cannot fetch Library/SaveManager/ThemeManager/
  Chatlogger/loader and will not run. (Changed 2026-10-21 — used to point at zyu's
  git.fable.bz server; now fully self-hosted so it survives the original being taken down.)
- `getgenv().tagged_raw` is read on line ~5 and set on line ~9. Both kept in sync.
- The ONLY remaining "hydroxide"/git.fable.bz mention in `Tagged` is a COMMENT on line
  ~3872 (Stella feature, an alternative-host note). It is NOT executed. Leave it.
- `backup/loader.lua` was rewritten to load `Tagged` from THIS repo on rejoin (it used to
  pull zyu's original rogue_ui.lua — that would have silently reverted the rebrand).
- The script uses Roblox exploit APIs (Drawing library, `getgenv`, `readfile`/`writefile`,
  `makefolder`). Config folders are now `Tagged/...` on the executor filesystem.

## Loadstring (shown in README)
- `loadstring(game:HttpGet("https://raw.githubusercontent.com/jphcyv4rxx-cmd/Tagged/main/Tagged"))()`
- Repo is PUBLIC (required — private repos 403 on unauthenticated HttpGet). User accepted
  that the code is readable, same as zyu's setup.

## Reference UI look (sampled pixel-accurately from user's screenshots)
- Panels: very dark grey — `#222222` / `#1B1B1B`.
- Accent: bright teal/cyan — approx **`#00C7C0`** (`Color3.fromRGB(0, 199, 192)`).
- The script's accent default is now TEAL (`Color3.fromRGB(0,199,192)` / `#00C7C0`),
  changeable at runtime via the `AccentColor` picker in Interface ▸ UI Settings.
- Key locations in `Tagged`:
  - Theme table w/ accent: search `accent = Color3.fromRGB(0,199,192)` (~line 364).
  - `utility:ChangeAccent(accentColor)`: ~line 2328 — updates `shared.accents` drawings.
  - `applyAccent(color)` helper: ~line 7430; used by the picker (also rebuilds the
    floating path editor via `refresh_theme`).
  - `read_ui_state` / `write_ui_state` / `applyUIFont`: ~line 7453–7530. Persists
    accent/font/scale to `Tagged/ui_state.json` and force-applies the font to every text
    element in `library.ScreenGui`.
  - Window creation (`library:CreateWindow`): ~line 7536. `DisableSearch = false` there
    means the search bar is ENABLED.
  - Tabs: `Bot Path` (bot), `Macros`, `Interface`, `Config` — no separate Path Editor tab.
  - Path point actions (`path_action_*` helpers + `RunPathPointAction`): ~line 13900–
    14170, called from the main loop inside `if not skip_current_point then`.
  - `ExecutePath`: ~line 14216.
  - Gorpig detector (scan loop + `gorpig_log_push`): ~line 16941; its groupbox ~line
    19041. Proximity slider `GorpigProximity` sits with the other proximity sliders in
    the Trinket Bot groupbox (~line 17400).
  - Single path saver `save_current_path_file`: ~line 18405 (exposed as
    `cheat_client.path_api.save_current_path` at ~line 19073).
  - Bot Path block (floating path editor + Path Files groupbox):
    `--// Bot Path — path files + floating path editor \\--` (~line 20291).

## Current state
- Renaming COMPLETE and pushed to GitHub.
- **Self-hosting COMPLETE** — script + all runtime deps now live on THIS repo, no
  dependency on zyu's git.fable.bz. Repo is PUBLIC; loadstring is in README.
- **UI overhaul COMPLETE** (2026-10-22): accent is now teal `#00C7C0`, with a live
  accent ColorPicker, a `UIFont` dropdown (~38 fonts), a `UIScale` slider (70–110%),
  and a slim 40px accent top bar that also drags the window. Layout is more compact
  (640×520 default, tighter padding/spacing, restyled search box).
- **Leaderboard stealth COMPLETE** (2026-10-22): `neutral_leaderboard` toggle in
  Visuals ▸ Overlays — Hides the class/observe colours on the leaderboard and shows
  plain white names; right-click observe + hover class readout still work.
- **Path Editor COMPLETE** (2026-10-22): the botting tabs are merged into a single
  **`Bot Path`** tab (old `Botting` + `Path Editor` tabs are gone). A `Path Files`
  groupbox sits at the bottom of that tab and has the **Open Path Editor** button, which
  opens a floating, draggable path-editor window (own ScreenGui, DisplayOrder 2000).
  The window is a table: `#`, `TYPE`, `POSITION`, `AREA`, `OPTIONS`, `ACTIONS`, with
  `+ Add @ Me`, `+ Action`, `Copy`, `Paste`, `Test`, `Refresh`, `Save`, and per-row
  `^` / `v` / `X` to reorder and delete points. AREA = gate location (type one to make it
  a gate point), OPTIONS = wait seconds. Visualise Points toggle lives in Trinket Bot.
- **Editor polish + action points COMPLETE** (2026-10-22): drag runs on
  `RenderStepped` (smooth), `+ Action` opens a type picker (`LUA`, `TALK`, `EQUIP`,
  `WAIT`, `L-CLICK`, `R-CLICK`), actions persist in the path JSON as
  `action = { type, value }`, and the runner executes them after arriving at the point.
  Accent + font + scale persist in `Tagged/ui_state.json` and are reapplied at startup;
  the editor rebuilds itself (`editor.refresh_theme`) on accent/font change, and
  `applyUIFont` force-writes `FontFace` on every text element so all tabs change.
- **Gorpig detector COMPLETE** (2026-10-22): toggle + 8-line stamped log + clear button
  in a `Gorpig Detector` groupbox (Bot Path), scanning for `gorpig` models while a path
  runs; range set by the `Gorpig Proximity (studs)` slider (default 150) next to the
  other proximity sliders.
- **Save de-duplicated** (2026-10-22): one implementation
  (`save_current_path_file`), used by both `Save Path` and the editor's `Save`; the
  duplicate `Save Current Path` button was removed from `Path Files`.
- All changes syntax-validated with the Luau compiler; in-game test still pending.

## TODO / next steps (in order)
- [x] 1. Change default accent from red → teal `#00C7C0`.
- [x] 2. Add a live accent color picker (wire to `utility:ChangeAccent`, persist w/ SaveManager).
- [x] 3. Compact the UI (patched `backup/DEPENDENCIES/Library.lua` directly: window size,
       corner radius, paddings, top bar height, tab/container offsets).
- [x] 4. Verify the search bar already greys-out + jumps to matches (it does; relabelled
       to `Search  (ctrl+f)`).
- [ ] 5. In-game test pass on the executor: accent-bar drag, font changer, neutral
       leaderboard, Path Editor save/load round-trip, smooth editor drag, accent/font
       persistence across reload, LUA + TALK points, Gorpig log while botting.
- [x] 6. Add a `LUA` point type to the Path Editor, per the spec the user dropped in
       `lua-action.md` (runs a Lua file from `Tagged/trinket_paths/lua/`). ✅ DONE
       (2026-10-22) plus `TALK` / `EQUIP` / `WAIT` / `L-CLICK` / `R-CLICK`.
- [ ] 7. (Deferred) `env.kill` / `env.wipe` / `env.menu` / `env.setInn` / `env.expectDeath`
       are NOT implemented in the LUA env — they need death-window / gate integration.
       `menu` and `setInn` are not exposed as reusable functions in this build.

## Deleted on purpose (DO NOT re-add)
- `hydroxide_original.lua` — the unmodified original. User asked to delete it from
  GitHub AND from disk. If it's ever needed again, re-download from the git.fable.bz
  URL above (path `ROGUE/rogue_ui.lua`) rather than committing it.
- `thumb.jpg` — reference video thumbnail. Was never pushed to GitHub (git-ignored);
  deleted from local disk at user's request. Colors are preserved in this file instead.

## Decisions log
- 2026-10-21: Repo started PRIVATE, then flipped **PUBLIC** — a loadstring needs
  unauthenticated raw fetches, which 403 on private repos. User accepted the code is
  readable (same as zyu's setup).
- 2026-10-21: User chose **auto-commit + push** to save progress across devices.
- 2026-10-21: Delete `hydroxide_original.lua` and `thumb.jpg` from the repo. Purged
  `hydroxide_original.lua` from git history via force-push.
- 2026-10-21: Progress is tracked via `NOTES.md` (state) + `CHANGELOG.md` (ordered log).
  AI must update both on every change.
- 2026-10-21: **Self-host all runtime deps** in `backup/` and repoint `Tagged` at this
  repo instead of zyu's git.fable.bz, so the script survives the original being taken
  down and the user can add features. Rewrote `backup/loader.lua` to reload `Tagged`
  from this repo on rejoin.
