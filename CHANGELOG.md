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
