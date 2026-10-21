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
2. **Compact the UI** so it's less spread out.
3. **User-changeable accent color** — a live color picker so the user can pick the
   accent themselves.
4. **Match a reference look** (dark grey panels + bright teal accent, sampled from a
   video the user linked — colors recorded below).
5. **Search bar** that finds features by greying everything out and jumping/redirecting
   to the match. (NOTE: the UI library ALREADY has this — `Library:UpdateSearch`.
   Verify it does what's wanted before building anything new.)

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
- The script's accent is currently RED (`Color3.fromRGB(255,0,0)`) — **needs to become teal.**
- Key locations in `Tagged`:
  - Theme table w/ accent: search `accent = Color3.fromRGB(255,0,0)` (~line 364).
  - `utility:ChangeAccent(accentColor)`: ~line 2328 — updates `shared.accents` drawings.
  - Window creation (`library:CreateWindow`): ~line 7421. `DisableSearch = false` there
    means the search bar is ENABLED.

## Current state
- Renaming COMPLETE and pushed to GitHub.
- **Self-hosting COMPLETE** — script + all runtime deps now live on THIS repo, no
  dependency on zyu's git.fable.bz. Repo is PUBLIC; loadstring is in README.
- UI work (compact + accent picker + teal) NOT yet started.

## TODO / next steps (in order)
- [ ] 1. Change default accent from red → teal `#00C7C0`.
- [ ] 2. Add a live accent color picker (wire to `utility:ChangeAccent`, persist w/ SaveManager).
- [ ] 3. Compact the UI. Layout lives in `backup/DEPENDENCIES/Library.lua` — compaction
       can be done via `Library:SetDPIScale(<100)` before `CreateWindow`, or by patching
       the library directly (now that we self-host it, patching IS an option).
- [ ] 4. Verify the search bar already greys-out + jumps to matches; tune if needed.

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
