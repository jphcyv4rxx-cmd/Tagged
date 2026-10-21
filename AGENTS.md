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

- **Never break the self-hosting URLs in the `Tagged` script.** `Tagged` loads its
  runtime deps from THIS repo via
  `https://raw.githubusercontent.com/jphcyv4rxx-cmd/Tagged/main/backup/` (line 5,
  `DEFAULT_RAW`), and `backup/loader.lua` reloads `Tagged` from this repo on rejoin.
  If these break, the script cannot fetch its dependencies and will not run. The repo
  MUST stay public, or raw fetches will 403 for the executor.
- **Never re-add deleted files:** `hydroxide_original.lua` and `thumb.jpg` were deleted
  on purpose at the user's request. Do not restore them.
- **The repo is PUBLIC** (required for the loadstring to work) and contains a Roblox
  exploit script. The user has accepted it is readable. Do not make it private again —
  that breaks the loadstring.

## Context for the project

See `NOTES.md` for what the project is, the current state, the TODO list, key line
numbers inside `Tagged`, and the reference UI colors. See `CHANGELOG.md` for the full
ordered history of what has already been done.
