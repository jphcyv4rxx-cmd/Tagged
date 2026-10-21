# Tagged

A Rogue Lineage script. This is the **only URL you need** — it always runs the latest version.

## Loadstring

Paste this into your executor:

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/jphcyv4rxx-cmd/Tagged/main/Tagged"))()
```

That's it. Because the script is fetched live from this repo, you never have to paste
the full script again — update the code here once and the loadstring picks it up
automatically next time you run it.

## How it's hosted

The loadstring above fetches `Tagged` (the main script). `Tagged` then loads its own
runtime dependencies from **this same repo** (`backup/` folder):

- `backup/loader.lua` — rejoin/queue loader (loads `Tagged` again on rejoin)
- `backup/DEPENDENCIES/Library.lua` — the UI library
- `backup/DEPENDENCIES/SaveManager.lua` — config saving
- `backup/DEPENDENCIES/ThemeManager.lua` — themes
- `backup/DEPENDENCIES/Chatlogger.lua` — chat logging

Nothing depends on any external server. If this repo is up, the script works.

## Working on this repo?

- **AI agents:** read `AGENTS.md` first — it has the rules (auto-commit + push, memory
  files, hard constraints).
- **Memory / progress:** lives in `NOTES.md` (current state) and `CHANGELOG.md`
  (ordered log of every change). Chat history does NOT sync between devices; these files do.
- The script is fetched live by the loadstring, so **pushing an update here changes what
  the loadstring runs.** Test before pushing.
