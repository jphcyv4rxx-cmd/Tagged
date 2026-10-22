--[[
    Tagged - Studio preview installer

    RUN THIS IN THE STUDIO COMMAND BAR (View > Command Bar), in EDIT mode, once per
    place. Requires: Game Settings > Security > Allow HTTP Requests = ON.

    It does two things, both fetched from this repo (so the preview is always the
    version you pushed, no copy-paste of 5k lines):
      1. ReplicatedStorage.TaggedLibrary   <- backup/DEPENDENCIES/Library.lua
      2. StarterPlayer.StarterPlayerScripts.TaggedUIPreview <- tests/ui_preview.client.lua

    Then press Play. Re-run this command after pushing changes to refresh both.

    If `Source` is locked in your Studio version, fall back to creating a ModuleScript
    named `TaggedLibrary` in ReplicatedStorage and pasting
    backup/DEPENDENCIES/Library.lua into it, then doing the same for the LocalScript
    with tests/ui_preview.client.lua.
]]

local BASE = "https://raw.githubusercontent.com/jphcyv4rxx-cmd/Tagged/main/"
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")

local function fetch(path)
    return HttpService:GetAsync(BASE .. path .. "?nocache=" .. tostring(os.time()))
end

-- 1. Library module
local existingModule = ReplicatedStorage:FindFirstChild("TaggedLibrary")
if existingModule then
    existingModule:Destroy()
end

local librarySource = fetch("backup/DEPENDENCIES/Library.lua")

local libraryModule = Instance.new("ModuleScript")
libraryModule.Name = "TaggedLibrary"
libraryModule.Source = librarySource
libraryModule.Parent = ReplicatedStorage

-- 2. Preview LocalScript
local scripts = StarterPlayer:FindFirstChild("StarterPlayerScripts")
if not scripts then
    error("[Tagged] StarterPlayerScripts not found")
end

local existingScript = scripts:FindFirstChild("TaggedUIPreview")
if existingScript then
    existingScript:Destroy()
end

local previewSource = fetch("tests/ui_preview.client.lua")

local preview = Instance.new("LocalScript")
preview.Name = "TaggedUIPreview"
preview.Source = previewSource
preview.Parent = scripts

print(string.format(
    "[Tagged] Installed TaggedLibrary (%.1f KB) + TaggedUIPreview (%.1f KB). Press Play.",
    #librarySource / 1024,
    #previewSource / 1024
))
