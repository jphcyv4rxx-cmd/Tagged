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
