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
- `Library_original.lua` — the UI library the script loads at RUNTIME via HttpGet.
  Kept here as reference because the UI/layout work lives in THIS file's code,
  even though at runtime the script fetches its own copy from the network.
- `NOTES.md` — this file (current state + goals + AI instructions).
- `CHANGELOG.md` — ordered log of every change made, oldest → newest.

## ⚠️ CRITICAL facts about the script (DO NOT BREAK THESE)
- `Tagged` loads its UI library at RUNTIME via HttpGet from
  `https://git.fable.bz/zyu/hydroxide/raw/branch/main/`. **That URL MUST stay intact**
  or the script cannot fetch Library/SaveManager/ThemeManager and will not run.
  Do NOT rename "hydroxide" inside that URL.
- `getgenv().tagged_raw` (renamed from `hydroxide_raw`) is read on line ~5 and set on
  line ~9. Both are kept in sync. The remote loader falls back to the same git.fable.bz
  URL if it doesn't recognize the var, so the rename is safe — but keep both lines
  consistent with each other.
- Everything else "hydroxide / Hydroxide / HYDROXIDE" was renamed to Tagged/tagged.
- The script uses Roblox exploit APIs (Drawing library, `getgenv`, `readfile`/`writefile`,
  `makefolder`). Config folders are now `Tagged/...` on the executor filesystem.

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
- Renaming COMPLETE and pushed to GitHub (private repo).
- UI work (compact + accent picker + teal) NOT yet started.

## TODO / next steps (in order)
- [ ] 1. Change default accent from red → teal `#00C7C0`.
- [ ] 2. Add a live accent color picker (wire to `utility:ChangeAccent`, persist w/ SaveManager).
- [ ] 3. Compact the UI. Layout lives in the EXTERNAL `Library.lua` fetched at runtime —
       so compaction must be done either by calling `Library:SetDPIScale(<100)` before
       `CreateWindow`, or by patching what `Tagged` passes to the library. Investigate first.
- [ ] 4. Verify the search bar already greys-out + jumps to matches; tune if needed.

## Deleted on purpose (DO NOT re-add)
- `hydroxide_original.lua` — the unmodified original. User asked to delete it from
  GitHub AND from disk. If it's ever needed again, re-download from the git.fable.bz
  URL above (path `ROGUE/rogue_ui.lua`) rather than committing it.
- `thumb.jpg` — reference video thumbnail. Was never pushed to GitHub (git-ignored);
  deleted from local disk at user's request. Colors are preserved in this file instead.

## Decisions log
- 2026-10-21: GitHub repo is **PRIVATE** (script is an exploit menu — keep private).
- 2026-10-21: User chose **auto-commit + push** to save progress across devices.
- 2026-10-21: Delete `hydroxide_original.lua` and `thumb.jpg` from the repo. Purged
  `hydroxide_original.lua` from git history via force-push.
- 2026-10-21: Progress is tracked via `NOTES.md` (state) + `CHANGELOG.md` (ordered log).
  AI must update both on every change.
