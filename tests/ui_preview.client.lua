--[[
    Tagged — UI Preview (Roblox Studio, no executor needed)

    WHAT THIS IS
        Loads the real backup/DEPENDENCIES/Library.lua and rebuilds the parts of the
        Tagged UI that get changed, so you can test the look without an injector:
          - theme colours + live accent picker (and the editor rebuilding itself)
          - UI font changer (does every widget update?)
          - UI scale (DPI) slider
          - compact sliders / toggles / dropdowns / inputs / buttons / labels
          - the wrapped Gorpig log (fake detections every 2s)
          - the floating path editor, including the RenderStepped drag fix and the
            "+ Action" type popup

    WHAT THIS IS NOT
        It does not run bot logic, ESP (Drawing), remotes, the path runner, or file
        saving. Those still need an executor in a live server. This is a UI harness.

    SETUP (once per Studio place)
        1. Game Settings > Security > Allow HTTP Requests  = ON
        2. Run tests/studio_install.lua in the command bar (View > Command Bar)
        3. Press Play
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local libraryModule = ReplicatedStorage:WaitForChild("TaggedLibrary", 10)
if not libraryModule then
    error("[Tagged UI Preview] ReplicatedStorage.TaggedLibrary is missing - run tests/studio_install.lua in the command bar first.")
end

local library = require(libraryModule)

local FONT_VALUES = {
    "Code", "Gotham", "GothamBold", "GothamMedium", "Roboto", "RobotoMono", "SourceSans",
    "Ubuntu", "Arial", "Bodoni", "Cartoon", "Fantasy", "SciFi", "Antique", "Arcade",
    "Bangers", "Creepster", "DenkOne", "Fondamento", "FredokaOne", "Garamond",
    "GrenzeGotisch", "HighwayGothic", "IndieFlower", "JosefinSans", "Jura", "Kalam",
    "LuckiestGuy", "Merriweather", "Michroma", "Nunito", "Oswald", "PatrickHand",
    "PermanentMarker", "PressStart2P", "Sarpanch", "SpecialElite", "Zekton",
}

local function scheme(key, default)
    if library.Scheme and library.Scheme[key] ~= nil then
        return library.Scheme[key]
    end
    return default
end

local function create(class, props, parent)
    local object = Instance.new(class)
    for key, value in pairs(props or {}) do
        if key ~= "Parent" then
            object[key] = value
        end
    end
    if parent then
        object.Parent = parent
    end
    return object
end

local editor_api = {}

-- Same behaviour as Tagged's applyAccent / applyUIFont.
local function applyAccent(color)
    if typeof(color) ~= "Color3" then
        return
    end

    library.Scheme.AccentColor = color
    library:UpdateColorsUsingRegistry()

    if editor_api.refresh then
        editor_api.refresh()
    end
end

local function applyUIFont(font_name)
    local font_enum = Enum.Font[font_name] or Enum.Font.Gotham

    local ok = pcall(function()
        library:SetFont(font_enum)
    end)
    if not ok then
        return
    end

    pcall(function()
        local screen = library.ScreenGui
        if not screen then
            return
        end

        local font_face = (Font.fromEnum and Font.fromEnum(font_enum)) or font_enum
        for _, object in ipairs(screen:GetDescendants()) do
            if object:IsA("TextLabel") or object:IsA("TextButton") or object:IsA("TextBox") then
                object.FontFace = font_face
            end
        end
    end)

    if editor_api.refresh then
        editor_api.refresh()
    end
end

-- Same order as Tagged: scale first, then create the window.
library:SetDPIScale(90)

local window = library:CreateWindow({
    Title = "Tagged - UI Preview",
    NotifySide = "Left",
    Footer = "",
    Center = true,
    AutoShow = true,
    Resizable = true,
    Size = UDim2.fromOffset(640, 520),
    DisableSearch = false,
})

local Tabs = {
    BotPath = window:AddTab("Bot Path", "bot"),
    Interface = window:AddTab("Interface", "monitor"),
}

--// Bot Path — Trinket Bot (subset, same shapes as the real tab) \\--
local group_bot = Tabs.BotPath:AddLeftGroupbox("Trinket Bot")

group_bot:AddInput("PointWaitTime", {
    Default = "0",
    Numeric = true,
    Finished = false,
    Text = "Point Wait Time (seconds)",
    Tooltip = "Time to wait at each new point (0 = no wait)",
    Placeholder = "0",
})

group_bot:AddToggle("VisualizePoints", {
    Text = "Visualise Points",
    Default = false,
})

group_bot:AddDivider()

group_bot:AddSlider("ProximityCheck", {
    Text = "Player Proximity (studs)",
    Default = 150,
    Min = 0,
    Max = 1000,
    Rounding = 0,
    Compact = true,
})

group_bot:AddSlider("CriticalDistance", {
    Text = "Critical Distance (studs)",
    Default = 60,
    Min = 0,
    Max = 1000,
    Rounding = 0,
    Compact = true,
})

group_bot:AddSlider("GorpigProximity", {
    Text = "Gorpig Proximity (studs)",
    Default = 150,
    Min = 10,
    Max = 1000,
    Rounding = 0,
    Compact = true,
    Tooltip = "Range the gorpig detector watches while botting",
})

group_bot:AddDivider()

group_bot:AddDropdown("AutoDropItems", {
    Text = "Auto Drop Items",
    Values = { "Bread", "Amulet of the White King", "Phoenix Down", "Night Stone" },
    Multi = true,
})

group_bot:AddDropdown("SavedPaths", {
    Text = "Saved Paths",
    Values = { "test_path", "fountain_run", "gate_route" },
    Default = "test_path",
})

group_bot:AddButton({
    Text = "Create Point",
    Func = function()
        library:Notify("Preview: Create Point")
    end,
})

group_bot:AddButton({
    Text = "Undo Point",
    Func = function()
        library:Notify("Preview: Undo Point")
    end,
})

--// Bot Path — Gorpig Detector (live log wrap test) \\--
local group_gorpig = Tabs.BotPath:AddRightGroupbox("Gorpig Detector")

local gorpig_enabled = false
local gorpig_lines = {}
local gorpig_label

local function gorpig_push(text)
    table.insert(gorpig_lines, 1, string.format("[%s] %s", os.date("%H:%M:%S"), text))

    while #gorpig_lines > 8 do
        table.remove(gorpig_lines)
    end

    if gorpig_label then
        if #gorpig_lines > 0 then
            gorpig_label:SetText(table.concat(gorpig_lines, "\n"))
        else
            gorpig_label:SetText("No detections yet.")
        end
    end
end

group_gorpig:AddToggle("GorpigDetector", {
    Text = "Gorpig Detector",
    Default = false,
    Tooltip = "Preview: pushes a fake detection every 2s so you can check wrapping",
    Callback = function(value)
        gorpig_enabled = value
        gorpig_push(value and "Detector enabled" or "Detector disabled")
    end,
})

gorpig_label = group_gorpig:AddLabel("No detections yet.", true)

group_gorpig:AddButton({
    Text = "Clear Gorpig Log",
    Func = function()
        gorpig_lines = {}
        if gorpig_label then
            gorpig_label:SetText("No detections yet.")
        end
    end,
})

-- Fake detector loop (the real one scans workspace while a path runs).
task.spawn(function()
    local names = { "Gorpig", "Gorpig Elder", "Gorpig", "Gorpig Hatchling" }
    local index = 0

    while true do
        task.wait(2)

        if gorpig_enabled then
            index = index + 1
            gorpig_push(string.format(
                "%s  (%.0f studs)",
                names[(index - 1) % #names + 1],
                math.random(15, 145)
            ))
        end
    end
end)

--// Bot Path — Path Files \\--
local group_path_files = Tabs.BotPath:AddRightGroupbox("Path Files")

group_path_files:AddButton({
    Text = "Open Path Editor",
    Func = function()
        if editor_api.open then
            editor_api.open()
        end
    end,
})

group_path_files:AddButton({
    Text = "Duplicate Selected Path",
    Func = function()
        library:Notify("Preview: Duplicate Selected Path")
    end,
})

group_path_files:AddButton({
    Text = "Rename Selected Path",
    Func = function()
        library:Notify("Preview: Rename Selected Path")
    end,
})

--// Interface — UI Settings \\--
local group_ui = Tabs.Interface:AddLeftGroupbox("UI Settings")

group_ui:AddLabel("Accent Color"):AddColorPicker("AccentColor", {
    Default = scheme("AccentColor", Color3.fromRGB(0, 199, 192)),
    Title = "Accent Color",
    Transparency = 0,
    Callback = function(value)
        applyAccent(value)
    end,
})

group_ui:AddDropdown("UIFont", {
    Text = "UI Font",
    Values = FONT_VALUES,
    Default = "Code",
    Callback = function(value)
        applyUIFont(value)
    end,
})

group_ui:AddSlider("UIScale", {
    Text = "UI Scale (%)",
    Default = 90,
    Min = 70,
    Max = 110,
    Rounding = 0,
    Suffix = "%",
    Callback = function(value)
        pcall(function()
            library:SetDPIScale(value)
        end)
    end,
})

group_ui:AddToggle("AccentTopBar", {
    Text = "Accent Top Bar",
    Default = true,
    Callback = function(state)
        local frame = library.ScreenGui and library.ScreenGui:FindFirstChild("Main")
        local topBar = frame and frame:FindFirstChild("TopBar")
        if topBar then
            topBar.BackgroundTransparency = state and 0 or 1
        end
    end,
})

--// Interface — widget reference sheet \\--
local group_widgets = Tabs.Interface:AddRightGroupbox("Widget Check")

group_widgets:AddLabel("Plain label — check the font here after switching fonts.")
group_widgets:AddLabel("Wrapped label (DoesWrap = true). This text is long on purpose, so a broken wrap or a stale font is obvious while resizing the window.", true)
group_widgets:AddToggle("WidgetToggle", { Text = "Toggle", Default = true })
group_widgets:AddSlider("WidgetSlider", { Text = "Slider", Default = 50, Min = 0, Max = 100, Rounding = 0, Suffix = "%", Compact = true })
group_widgets:AddInput("WidgetInput", { Text = "Text Input", Default = "value", Placeholder = "type here" })
group_widgets:AddDropdown("WidgetDropdown", { Text = "Dropdown", Values = { "One", "Two", "Three" }, Default = "One" })
group_widgets:AddDropdown("WidgetMulti", { Text = "Multi Dropdown", Values = { "Red", "Green", "Blue" }, Multi = true })
group_widgets:AddButton({ Text = "Button", Func = function() library:Notify("Preview: button") end })
group_widgets:AddDivider()
group_widgets:AddLabel("Accent swatch: ██████", true)

--// Floating path editor (same drag technique + action popup as Tagged) \\--
local ACTION_DEFS = {
    { type = "lua",        label = "LUA",     color = Color3.fromRGB(116, 170, 255), value_label = "file name" },
    { type = "talk",       label = "TALK",    color = Color3.fromRGB(122, 220, 122), value_label = "npc name" },
    { type = "equip",      label = "EQUIP",   color = Color3.fromRGB(196, 156, 255), value_label = "tool name" },
    { type = "wait",       label = "WAIT",    color = Color3.fromRGB(255, 214, 81),  value_label = "seconds" },
    { type = "leftclick",  label = "L-CLICK", color = Color3.fromRGB(180, 180, 180), value_label = nil },
    { type = "rightclick", label = "R-CLICK", color = Color3.fromRGB(180, 180, 180), value_label = nil },
}

local ACTION_BY_TYPE = {}
for _, def in ipairs(ACTION_DEFS) do
    ACTION_BY_TYPE[def.type] = def
end

local COLUMNS = {
    { key = "#", x = 0, w = 26 },
    { key = "TYPE", x = 26, w = 82 },
    { key = "POSITION", x = 108, w = 148 },
    { key = "AREA", x = 256, w = 118 },
    { key = "OPTIONS", x = 374, w = 118 },
    { key = "ACTIONS", x = 492, w = 96 },
}

local editor_state = {
    gui = nil,
    window = nil,
    menu = nil,
    selected = 1,
    points = {
        { position = Vector3.new(0, 0, 0), wait_time = 0, is_gate_point = false },
        { position = Vector3.new(124, 0, 88), wait_time = 1.5, is_gate_point = false },
        { position = Vector3.new(310, 4, 210), wait_time = 0, is_gate_point = true, gate_location = "Flowerlight Town" },
        { position = Vector3.new(310, 4, 210), wait_time = 0, is_gate_point = false, action = { type = "lua", value = "eat" } },
        { position = Vector3.new(455, 4, 300), wait_time = 0, is_gate_point = false, action = { type = "talk", value = "Xenyari" } },
    },
}

local render_rows

local function build_editor()
    if not editor_state.gui or not editor_state.gui.Parent then
        editor_state.gui = create("ScreenGui", {
            Name = "TaggedPathEditorGui",
            DisplayOrder = 2000,
            IgnoreGuiInset = true,
            ResetOnSpawn = false,
        }, playerGui)
    end

    local accent = scheme("AccentColor", Color3.fromRGB(0, 199, 192))
    local background = scheme("BackgroundColor", Color3.fromRGB(27, 27, 27))
    local mainColor = scheme("MainColor", Color3.fromRGB(34, 34, 34))
    local outline = scheme("OutlineColor", Color3.fromRGB(46, 46, 46))
    local fontColor = scheme("FontColor", Color3.new(1, 1, 1))
    local fontFace = (library.Scheme and library.Scheme.Font) or Enum.Font.Code

    local frame = create("Frame", {
        Name = "TaggedPathEditor",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(640, 380),
        BackgroundColor3 = background,
        BorderSizePixel = 0,
        Active = true,
    }, editor_state.gui)

    create("UICorner", { CornerRadius = UDim.new(0, 6) }, frame)

    local header = create("TextButton", {
        Size = UDim2.new(1, 0, 0, 26),
        BackgroundColor3 = accent,
        BorderSizePixel = 0,
        Text = "",
        AutoButtonColor = false,
    }, frame)
    create("UICorner", { CornerRadius = UDim.new(0, 6) }, header)

    local title = create("TextLabel", {
        Position = UDim2.fromOffset(10, 0),
        Size = UDim2.new(1, -40, 1, 0),
        BackgroundTransparency = 1,
        Text = string.format("path editor (%d)", #editor_state.points),
        TextColor3 = background,
        TextSize = 13,
        FontFace = fontFace,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, header)

    local close = create("TextButton", {
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -6, 0, 4),
        Size = UDim2.fromOffset(18, 18),
        BackgroundTransparency = 1,
        Text = "X",
        TextColor3 = background,
        TextSize = 13,
        FontFace = fontFace,
        AutoButtonColor = false,
    }, header)

    close.MouseButton1Click:Connect(function()
        frame.Visible = false
    end)

    -- Smooth drag: stored cursor delta applied on RenderStepped.
    header.InputBegan:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseButton1
            and input.UserInputType ~= Enum.UserInputType.Touch then
            return
        end

        local start_mouse = UserInputService:GetMouseLocation()
        local start_position = frame.Position
        local drag_connection

        local function stop_dragging()
            if drag_connection then
                drag_connection:Disconnect()
                drag_connection = nil
            end
        end

        local end_connection
        end_connection = input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                stop_dragging()
                if end_connection then
                    end_connection:Disconnect()
                    end_connection = nil
                end
            end
        end)

        stop_dragging()
        drag_connection = RunService.RenderStepped:Connect(function()
            if not frame.Parent then
                stop_dragging()
                return
            end

            local delta = UserInputService:GetMouseLocation() - start_mouse
            frame.Position = UDim2.new(
                start_position.X.Scale,
                start_position.X.Offset + delta.X,
                start_position.Y.Scale,
                start_position.Y.Offset + delta.Y
            )
        end)
    end)

    -- Toolbar
    local leftBar = create("Frame", {
        Position = UDim2.fromOffset(8, 32),
        Size = UDim2.new(1, -16, 0, 22),
        BackgroundTransparency = 1,
    }, frame)

    local rightBar = create("Frame", {
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -8, 0, 32),
        Size = UDim2.new(1, -16, 0, 22),
        BackgroundTransparency = 1,
    }, frame)

    local function toolbar_button(parent, label, width, order, callback)
        local button = create("TextButton", {
            Position = UDim2.fromOffset(order == 1 and 0 or (74 + 4), 0),
            Size = UDim2.fromOffset(width, 22),
            BackgroundColor3 = mainColor,
            BorderSizePixel = 0,
            Text = label,
            TextColor3 = fontColor,
            TextSize = 11,
            FontFace = fontFace,
            AutoButtonColor = false,
            LayoutOrder = order,
        }, parent)
        button.AnchorPoint = Vector2.new(0, 0)
        create("UICorner", { CornerRadius = UDim.new(0, 3) }, button)
        create("UIStroke", { Color = outline, Thickness = 1 }, button)
        button.MouseButton1Click:Connect(callback)
        return button
    end

    local function close_action_menu()
        if editor_state.menu then
            editor_state.menu:Destroy()
            editor_state.menu = nil
        end
    end

    local add_point
    add_point = function(template)
        local at = math.min((editor_state.selected or #editor_state.points) + 1, #editor_state.points + 1)
        at = math.max(1, at)
        table.insert(editor_state.points, at, template)
        editor_state.selected = at
        render_rows()
    end

    toolbar_button(leftBar, "+ Add @ Me", 74, 1, function()
        local character = player.Character
        local hrp = character and character:FindFirstChild("HumanoidRootPart")
        add_point({
            position = hrp and hrp.Position or Vector3.new(0, 0, 0),
            wait_time = 0,
            is_gate_point = false,
        })
    end)

    local action_button = toolbar_button(leftBar, "+ Action", 62, 2, function()
        if editor_state.menu and editor_state.menu.Parent then
            close_action_menu()
            return
        end

        local menu = create("Frame", {
            Position = UDim2.fromOffset(82, 56),
            Size = UDim2.fromOffset(150, #ACTION_DEFS * 20 + 6),
            BackgroundColor3 = mainColor,
            BorderSizePixel = 0,
            ZIndex = 20,
        }, frame)
        create("UICorner", { CornerRadius = UDim.new(0, 4) }, menu)
        create("UIStroke", { Color = outline, Thickness = 1 }, menu)

        for menu_index, def in ipairs(ACTION_DEFS) do
            local entry = create("TextButton", {
                Position = UDim2.fromOffset(3, 3 + (menu_index - 1) * 20),
                Size = UDim2.new(1, -6, 0, 18),
                BackgroundTransparency = 1,
                BackgroundColor3 = background,
                Text = def.label,
                TextColor3 = def.color,
                TextSize = 11,
                FontFace = fontFace,
                TextXAlignment = Enum.TextXAlignment.Left,
                AutoButtonColor = false,
                ZIndex = 21,
            }, menu)
            create("UIPadding", { PaddingLeft = UDim.new(0, 4) }, entry)

            entry.MouseEnter:Connect(function()
                entry.BackgroundTransparency = 0.85
            end)
            entry.MouseLeave:Connect(function()
                entry.BackgroundTransparency = 1
            end)

            entry.MouseButton1Click:Connect(function()
                close_action_menu()
                add_point({
                    position = Vector3.new(0, 0, 0),
                    wait_time = 0,
                    is_gate_point = false,
                    action = { type = def.type, value = "" },
                })
                library:Notify(string.format("Preview: added %s point", def.label))
            end)
        end

        editor_state.menu = menu
    end)

    action_button.Position = UDim2.fromOffset(78, 0)

    toolbar_button(leftBar, "Copy", 44, 3, function()
        library:Notify("Preview: copy")
    end).Position = UDim2.fromOffset(144, 0)

    toolbar_button(leftBar, "Paste", 44, 4, function()
        library:Notify("Preview: paste")
    end).Position = UDim2.fromOffset(192, 0)

    local save_button = toolbar_button(rightBar, "Save", 52, 1, function()
        library:Notify("Preview: save (no file written)")
    end)
    save_button.AnchorPoint = Vector2.new(1, 0)
    save_button.Position = UDim2.new(1, 0, 0, 0)

    local refresh_button = toolbar_button(rightBar, "Refresh", 60, 2, function()
        render_rows()
    end)
    refresh_button.AnchorPoint = Vector2.new(1, 0)
    refresh_button.Position = UDim2.new(1, -56, 0, 0)

    -- Table
    local tableFrame = create("Frame", {
        Position = UDim2.fromOffset(8, 62),
        Size = UDim2.new(1, -16, 1, -70),
        BackgroundColor3 = mainColor,
        BorderSizePixel = 0,
    }, frame)
    create("UICorner", { CornerRadius = UDim.new(0, 4) }, tableFrame)
    create("UIStroke", { Color = outline, Thickness = 1 }, tableFrame)

    local headerRow = create("Frame", {
        Size = UDim2.new(1, 0, 0, 22),
        BackgroundColor3 = mainColor,
        BorderSizePixel = 0,
    }, tableFrame)

    for _, column in ipairs(COLUMNS) do
        create("TextLabel", {
            Position = UDim2.fromOffset(column.x + 4, 0),
            Size = UDim2.fromOffset(column.w, 22),
            BackgroundTransparency = 1,
            Text = column.key,
            TextColor3 = accent,
            TextSize = 10,
            FontFace = fontFace,
            TextXAlignment = Enum.TextXAlignment.Left,
        }, headerRow)
    end

    local body = create("ScrollingFrame", {
        Position = UDim2.fromOffset(0, 22),
        Size = UDim2.new(1, 0, 1, -22),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        CanvasSize = UDim2.new(),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollBarThickness = 4,
    }, tableFrame)

    render_rows = function()
        for _, child in ipairs(body:GetChildren()) do
            if child:IsA("Frame") then
                child:Destroy()
            end
        end

        title.Text = string.format("path editor (%d)", #editor_state.points)

        for index, point in ipairs(editor_state.points) do
            local point_action = point.action
            local action_def = point_action and point_action.type and ACTION_BY_TYPE[point_action.type] or nil

            local type_text, type_color = "POINT", fontColor
            if action_def then
                type_text, type_color = action_def.label, action_def.color
            elseif point.is_gate_point then
                type_text, type_color = "GATE", Color3.fromRGB(255, 214, 81)
            elseif point.wait_for_trinket then
                type_text, type_color = "TRINKET", Color3.fromRGB(100, 170, 255)
            end

            local selected = editor_state.selected == index
            local row = create("Frame", {
                Position = UDim2.fromOffset(0, (index - 1) * 22),
                Size = UDim2.new(1, -4, 0, 22),
                BackgroundColor3 = (selected or index % 2 == 0) and mainColor or background,
                BorderSizePixel = 0,
                ZIndex = 1,
            }, body)

            if selected then
                create("UIStroke", { Color = accent, Thickness = 1 }, row)
            end

            create("TextButton", {
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(0, 0),
                Size = UDim2.fromOffset(26, 22),
                Text = tostring(index),
                TextColor3 = selected and accent or fontColor,
                TextSize = 11,
                FontFace = fontFace,
                AutoButtonColor = false,
                ZIndex = 2,
            }, row).MouseButton1Click:Connect(function()
                editor_state.selected = index
                render_rows()
            end)

            create("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(30, 0),
                Size = UDim2.fromOffset(78, 22),
                Text = type_text,
                TextColor3 = type_color,
                TextSize = 11,
                FontFace = fontFace,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 2,
            }, row)

            create("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(112, 0),
                Size = UDim2.fromOffset(144, 22),
                Text = string.format("(%.0f, %.0f, %.0f)", point.position.X, point.position.Y, point.position.Z),
                TextColor3 = fontColor,
                TextSize = 11,
                FontFace = fontFace,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 2,
            }, row)

            local area_editable = action_def == nil
            local areaBox = create("TextBox", {
                Position = UDim2.fromOffset(260, 2),
                Size = UDim2.fromOffset(110, 18),
                BackgroundColor3 = background,
                BorderSizePixel = 0,
                Text = point.gate_location or "-",
                PlaceholderText = "gate area",
                TextColor3 = point.gate_location and Color3.fromRGB(122, 220, 122) or Color3.fromRGB(120, 120, 120),
                TextSize = 11,
                FontFace = fontFace,
                TextXAlignment = Enum.TextXAlignment.Left,
                ClearTextOnFocus = false,
                TextEditable = area_editable,
                ZIndex = 3,
            }, row)
            create("UICorner", { CornerRadius = UDim.new(0, 3) }, areaBox)
            create("UIPadding", {
                PaddingLeft = UDim.new(0, 4),
                PaddingRight = UDim.new(0, 4),
            }, areaBox)

            local options_text
            local options_editable
            if action_def then
                if action_def.value_label then
                    options_text = tostring(point_action.value or "")
                    options_editable = true
                else
                    options_text = "-"
                    options_editable = false
                end
            else
                options_text = tostring(point.wait_time or 0)
                options_editable = true
            end

            local optionBox = create("TextBox", {
                Position = UDim2.fromOffset(374, 2),
                Size = UDim2.fromOffset(110, 18),
                BackgroundColor3 = background,
                BorderSizePixel = 0,
                Text = options_text,
                PlaceholderText = action_def and action_def.value_label or "seconds",
                TextColor3 = action_def and action_def.color or fontColor,
                TextSize = 11,
                FontFace = fontFace,
                TextXAlignment = Enum.TextXAlignment.Left,
                ClearTextOnFocus = false,
                TextEditable = options_editable,
                ZIndex = 3,
            }, row)
            create("UICorner", { CornerRadius = UDim.new(0, 3) }, optionBox)
            create("UIPadding", {
                PaddingLeft = UDim.new(0, 4),
                PaddingRight = UDim.new(0, 4),
            }, optionBox)

            areaBox.FocusLost:Connect(function()
                if not area_editable then
                    return
                end

                local text = areaBox.Text
                if text == "-" then
                    text = ""
                end

                if text and text ~= "" then
                    point.gate_location = text
                    point.is_gate_point = true
                else
                    point.gate_location = nil
                    point.is_gate_point = false
                end

                render_rows()
            end)

            optionBox.FocusLost:Connect(function()
                if not options_editable then
                    return
                end

                if action_def then
                    point_action.value = optionBox.Text
                else
                    point.wait_time = tonumber(optionBox.Text) or 0
                end

                render_rows()
            end)

            local function row_button(label, x, width, callback)
                local button = create("TextButton", {
                    Position = UDim2.fromOffset(x, 2),
                    Size = UDim2.fromOffset(width, 18),
                    BackgroundColor3 = background,
                    BorderSizePixel = 0,
                    Text = label,
                    TextColor3 = fontColor,
                    TextSize = 10,
                    FontFace = fontFace,
                    AutoButtonColor = false,
                    ZIndex = 3,
                }, row)
                create("UICorner", { CornerRadius = UDim.new(0, 3) }, button)
                button.MouseButton1Click:Connect(callback)
            end

            row_button("^", 496, 20, function()
                if index > 1 then
                    editor_state.points[index], editor_state.points[index - 1] =
                        editor_state.points[index - 1], editor_state.points[index]
                    render_rows()
                end
            end)

            row_button("v", 518, 20, function()
                if index < #editor_state.points then
                    editor_state.points[index], editor_state.points[index + 1] =
                        editor_state.points[index + 1], editor_state.points[index]
                    render_rows()
                end
            end)

            row_button("X", 540, 20, function()
                table.remove(editor_state.points, index)
                editor_state.selected = math.max(1, math.min(editor_state.selected, #editor_state.points))
                render_rows()
            end)
        end
    end

    render_rows()
    editor_state.window = frame
    return frame
end

function editor_api.open()
    local frame = editor_state.window
    if not (frame and frame.Parent) then
        frame = build_editor()
    end
    frame.Visible = true
end

-- Mirrors Tagged's editor.refresh_theme: rebuild, keep visibility.
function editor_api.refresh()
    local existing = editor_state.window
    if not (existing and existing.Parent) then
        return
    end

    local was_visible = existing.Visible

    if editor_state.menu then
        editor_state.menu:Destroy()
        editor_state.menu = nil
    end

    existing:Destroy()
    editor_state.window = nil

    local rebuilt = build_editor()
    if rebuilt then
        rebuilt.Visible = was_visible
    end
end

library:Notify("UI Preview ready - open Path Files > Open Path Editor", 5)
