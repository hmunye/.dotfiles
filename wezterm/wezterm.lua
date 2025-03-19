local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.max_fps = 120
config.enable_kitty_graphics = true
config.window_close_confirmation = "NeverPrompt"

config.initial_rows = 1800
config.initial_cols = 1169

config.font_size = 15
config.harfbuzz_features = { "calt=0", "clig=0", "liga=0" }

config.enable_tab_bar = false
config.window_decorations = "RESIZE"

config.colors = {
    foreground = "#fbf7f4",
    background = "#101010",
    cursor_bg = "#d6cbc1",
    cursor_fg = "#151515",
    cursor_border = "#d6cbc1",
    selection_fg = "#151515",
    selection_bg = "#f3e4a5",
    scrollbar_thumb = "#646464",
    split = "#2e2e2e",
    ansi = {
        "#2e2e2e",
        "#ff6c6c",
        "#9ecca0",
        "#f3e4a5",
        "#9e9eec",
        "#ff9e9e",
        "#80caff",
        "#d0d0d0",
    },
    brights = {
        "#646464",
        "#ff6c6c",
        "#a0e3b0",
        "#f7f3b0",
        "#c0aaff",
        "#d0a6a6",
        "#a0d9ff",
        "#ffffff",
    },
    indexed = { [136] = "#af8700" },
    compose_cursor = "#ff9e9e",
    copy_mode_active_highlight_bg = { Color = "#151515" },
    copy_mode_active_highlight_fg = { AnsiColor = "Black" },
    copy_mode_inactive_highlight_bg = { Color = "#9ecca0" },
    copy_mode_inactive_highlight_fg = { AnsiColor = "White" },
    quick_select_label_bg = { Color = "#d0a6a6" },
    quick_select_label_fg = { Color = "#ffffff" },
    quick_select_match_bg = { AnsiColor = "Navy" },
    quick_select_match_fg = { Color = "#ffffff" },
}

config.window_padding = {
    left = 30,
    right = 30,
    top = "1cell",
    bottom = "1cell",
}

config.keys = {
    {
        key = "f",
        mods = "CTRL",
        action = wezterm.action({
            SendString = 'zsh -c "~/.local/bin/tmux-session.sh"\n',
        }),
    },
}

config.window_background_opacity = 0.9
config.macos_window_background_blur = 15

return config
