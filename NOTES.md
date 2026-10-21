# Tagged — Progress Notes

This file is the cross-device memory for this project. OpenCode's chat history is
stored **locally per machine** and does NOT sync between devices. This file does.
On a new device: `git pull`, then tell the AI "read NOTES.md" to resume.

## What this project is
A renamed/rebranded copy of the Rogue Lineage "hydroxide" script, saved as `Tagged`.
Goal: rebrand to "Tagged", make the UI compact, add user-changeable accent colors,
and match the dark-grey + teal look from a reference video.

## Files
- `Tagged` — the deliverable script (full rogue_ui.lua, renamed).
- `hydroxide_original.lua` — unmodified original, for reference/diffing.
- `Library_original.lua` — the UI library the script loads at runtime (reference).
- `thumb.jpg` — reference video thumbnail.

## Key facts about the script (do not break these)
- It is ~27,000 lines and loads its UI library at RUNTIME via HttpGet from
  `https://git.fable.bz/zyu/hydroxide/raw/branch/main/`. That URL MUST stay intact
  or the script cannot fetch Library/SaveManager/ThemeManager and will not run.
- `getgenv().tagged_raw` (renamed from `hydroxide_raw`) is read on line 5 and set
  on line 9. Both are kept in sync. Safe to rename — the remote loader falls back
  to the same git.fable.bz URL if it doesn't recognize the var.
- Everything else "hydroxide/Hydroxide/HYDROXIDE" was renamed to Tagged/tagged.

## Status / DONE
- [x] Downloaded original rogue_ui.lua (27,282 lines) and Library.lua (7,238 lines).
- [x] Renamed all 47 hydroxide references to Tagged, EXCEPT the git.fable.bz URL
      and the `tagged_raw` getgenv key, which must survive for the script to load.

## Reference UI look (from video screenshots, sampled pixel-accurately)
- Panels: very dark grey (#222222 / #1B1B1B).
- Accent: bright teal/cyan, approx #00C7C0 / #00C8C0.
- Current accent in script is RED (Color3.fromRGB(255,0,0)) — needs changing to teal.

## TODO / pending
- [ ] Compact the UI (tighter groupbox/tab spacing). NOTE: layout lives in the
      EXTERNAL Library.lua fetched at runtime, not in `Tagged`. Compaction must
      happen either via `Library:SetDPIScale(<100)` called before CreateWindow,
      or by patching what `Tagged` passes to the library.
- [ ] Add a live accent color picker wired to `utility:ChangeAccent` (line ~2328),
      persisted via SaveManager.
- [ ] Change default accent from red to teal (#00C7C0) to match reference.
- [ ] The library ALREADY has a cross-tab search bar (enabled, DisableSearch=false)
      that hides non-matching elements and jumps to the matching tab. The requested
      "search that greys everything out until you type" behavior may already exist —
      verify against the reference before building anything new.

## Decisions
- 2026-10-21: GitHub repo is PRIVATE (script is an exploit menu — keep it private).
- 2026-10-21: User chose auto-commit + push to save progress across devices.
