# Agent Instructions

> **This file is for ANY AI coding agent working in this repo** (OpenCode, Claude
> Code, Codex, Copilot, Aider, Cursor, etc.). If you are an AI and you can read this,
> follow these rules. Humans can ignore this file.

## Project memory lives in the repo, NOT in chat

Chat/session history is stored **locally per machine** and does **not** sync between
devices. The user works on this project from **multiple devices**. The repo is the only
thing that syncs. So:

- **On every session start:** read `NOTES.md` (current state + goals) **and**
  `CHANGELOG.md` (ordered log of every change) **before** doing anything. Re-establish
  context from them silently — do not ask the user to re-explain the project.

## You MUST push updates automatically

After you finish a meaningful chunk of work (a change, a fix, a feature, even a partial
step if the user is going quiet):

1. **Log the change** — append an entry to `CHANGELOG.md` using the format at the top of
   that file. Also update the "Current state" / "TODO" sections in `NOTES.md` if they
   changed.
2. **Commit** with a short, clear message describing the change.
3. **Push to GitHub.** A `post-commit` hook is set up to auto-push, but **do not assume
   it worked — verify the push landed** (e.g. `git status -sb` should show the branch in
   sync with `origin/main`, or check `git ls-remote --heads origin`).

Do **not** wait to be asked to save. Leaving work unsaved at the end of a session is a
failure. If the user stops responding mid-task, update `NOTES.md` + `CHANGELOG.md` and
commit whatever exists, clearly noting what was in progress.

## Hard rules — DO NOT break these

- **Never rename or remove the URL `https://git.fable.bz/zyu/hydroxide/raw/branch/main/`**
  inside the `Tagged` script. The script fetches its UI library (Library/SaveManager/
  ThemeManager) from there at RUNTIME. Breaking the URL breaks the script entirely.
  "hydroxide" inside that URL must stay as-is even though the rest of the project is
  renamed to "Tagged".
- **Never re-add deleted files:** `hydroxide_original.lua` and `thumb.jpg` were deleted
  on purpose at the user's request. Do not restore them. If the original script is ever
  needed, re-download it from the URL above (path `ROGUE/rogue_ui.lua`) rather than
  committing it.
- **The repo is PRIVATE** and contains a Roblox exploit script. Keep it private. Do not
  publish, fork publicly, or expose it.

## Context for the project

See `NOTES.md` for what the project is, the current state, the TODO list, key line
numbers inside `Tagged`, and the reference UI colors. See `CHANGELOG.md` for the full
ordered history of what has already been done.
