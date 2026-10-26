local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- -- APPEARANCE --
config.window_decorations = "RESIZE"
config.font = wezterm.font_with_fallback({
  "Aporetic Serif Mono",
  "Zhuque Fangsong A1050",
  "Symbols Nerd Font Mono",
})
-- TODO: Move to a standlone project, maybe named to `vercel-wezterm`?
-- Vercel palette from
-- https://github.com/lumirelle/vercel.nvim/blob/main/lua/vercel/colors.lua.
-- Every comment below is a `palette.<scale>[<step>]` lookup.
config.color_schemes = {
  ["Vercel Dark"] = {
    foreground = "#EDEDED", -- gray[1000]
    background = "#000000", -- background[200]
    cursor_bg = "#EDEDED", -- gray[1000]
    cursor_fg = "#000000", -- background[200]
    cursor_border = "#EDEDED", -- gray[1000]
    selection_fg = "none",
    selection_bg = "#1A1A1A", -- gray[100], the repo's background_hover
    scrollbar_thumb = "#878787", -- gray[600]
    split = "#2E2E2E", -- gray[400], the repo's border
    ansi = {
      "#A1A1A1", -- gray[900]
      "#FF6166", -- red[900]
      "#62C073", -- green[900]
      "#F2A20D", -- amber[900]
      "#52A8FF", -- blue[900]
      "#BF7AF0", -- purple[900]
      "#0AC7B4", -- teal[900]
      "#EDEDED", -- gray[1000]
    },
    brights = {
      "#A1A1A1", -- gray[900]
      "#FF6166", -- red[900]
      "#62C073", -- green[900]
      "#F2A20D", -- amber[900]
      "#52A8FF", -- blue[900]
      "#BF7AF0", -- purple[900]
      "#0AC7B4", -- teal[900]
      "#EDEDED", -- gray[1000]
    },
    tab_bar = {
      background = "#000000", -- background[200]
      inactive_tab_edge = "#2E2E2E", -- gray[400]
      active_tab = { bg_color = "#1F1F1F", fg_color = "#EDEDED", intensity = "Bold" }, -- gray[200] / gray[1000]
      inactive_tab = { bg_color = "#000000", fg_color = "#878787" }, -- gray[600] label
      inactive_tab_hover = { bg_color = "#1A1A1A", fg_color = "#EDEDED", italic = true }, -- gray[100]
      new_tab = { bg_color = "#000000", fg_color = "#878787" }, -- gray[600] label
      new_tab_hover = { bg_color = "#1A1A1A", fg_color = "#EDEDED", italic = true }, -- gray[100]
    },
  },
  ["Vercel Light"] = {
    foreground = "#171717", -- gray[1000]
    background = "#FAFAFA", -- background[200]
    cursor_bg = "#171717", -- gray[1000]
    cursor_fg = "#FAFAFA", -- background[200]
    cursor_border = "#171717", -- gray[1000]
    selection_fg = "none",
    selection_bg = "#F2F2F2", -- gray[100], the repo's background_hover
    scrollbar_thumb = "#A8A8A8", -- gray[600]
    split = "#E6E6E6", -- gray[300], the repo's border
    ansi = {
      "#171717", -- gray[1000]
      "#CB2A2F", -- red[900]
      "#297A3A", -- green[900]
      "#A35200", -- amber[900]
      "#0068D6", -- blue[900]
      "#7820BC", -- purple[900]
      "#067A6E", -- teal[900]
      "#4D4D4D", -- gray[900]
    },
    brights = {
      "#171717", -- gray[1000]
      "#CB2A2F", -- red[900]
      "#297A3A", -- green[900]
      "#A35200", -- amber[900]
      "#0068D6", -- blue[900]
      "#7820BC", -- purple[900]
      "#067A6E", -- teal[900]
      "#4D4D4D", -- gray[900]
    },
    tab_bar = {
      background = "#FAFAFA", -- background[200]
      inactive_tab_edge = "#E6E6E6", -- gray[300]
      active_tab = { bg_color = "#EBEBEB", fg_color = "#171717", intensity = "Bold" }, -- gray[200] / gray[1000]
      inactive_tab = { bg_color = "#FAFAFA", fg_color = "#7D7D7D" }, -- gray[800] label
      inactive_tab_hover = { bg_color = "#F2F2F2", fg_color = "#171717", italic = true }, -- gray[100]
      new_tab = { bg_color = "#FAFAFA", fg_color = "#7D7D7D" }, -- gray[800] label
      new_tab_hover = { bg_color = "#F2F2F2", fg_color = "#171717", italic = true }, -- gray[100]
    },
  },
}
-- Follow the system appearance. `wezterm.gui` is missing in a headless mux
-- server and `get_appearance` returns nil on Wayland, so anything that is not
-- `Light` gets the dark scheme.
local ok, appearance = pcall(function()
  return wezterm.gui.get_appearance()
end)
if ok and appearance == "Light" then
  config.color_scheme = "Vercel Light"
  config.window_frame = { active_titlebar_bg = "#FAFAFA", inactive_titlebar_bg = "#FAFAFA" } -- background[200]
else
  config.color_scheme = "Vercel Dark"
  config.window_frame = { active_titlebar_bg = "#000000", inactive_titlebar_bg = "#000000" } -- background[200]
end

-- -- LAUNCHING PROGRAMS --
config.default_prog = { "nu", "-l" }
config.launch_menu = {
  { label = "Nushell", args = { "nu", "-l" } },
  { label = "Windows Subsystem for Linux", args = { "wsl", "--cd", "~" } },
  { label = "Commad Prompt", args = { "cmd" } },
  { label = "Windows PowerShell", args = { "powershell", "-NoLogo" } },
}
config.enable_kitty_keyboard = true

return config
