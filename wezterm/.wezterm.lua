local wezterm = require("wezterm")
local act = wezterm.action
local mux = wezterm.mux

local config = {}

-- Use config bild object if possible
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- config.default_domain = ""
-- config.default_prog = { "pwsh.exe", "-NoLogo"
config.default_domain = "WSL:Ubuntu"
-- config.color_scheme = "Catppuccin Macchiato"
config.font = wezterm.font_with_fallback({
	{ family = "CaskaydiaCove Nerd Font", weight = "Regular" },
})
config.window_decorations = "RESIZE"
config.scrollback_lines = 50000
config.default_workspace = "main"
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

config.audible_bell = "Disabled"

config.default_domain = "WSL:Ubuntu"
config.front_end = "WebGpu"
config.max_fps = 120
for _, gpu in ipairs(wezterm.gui.enumerate_gpus()) do
	if gpu.backend == "Vulkan" then
		config.webgpu_preferred_adapter = gpu
		break
	end
end

config.hide_tab_bar_if_only_one_tab = true

config.colors = {
	background = "black",
}

-- tab bar
config.use_fancy_tab_bar = false
config.status_update_interval = 1000
config.tab_bar_at_bottom = true
-- wezterm.on("update-status", function(window, pane)
-- 	-- Workspace name
-- 	local stat = window:active_workspace()
-- 	local stat_color = "#f7768e"
-- 	-- It's a little silly to have workspace name all the time
-- 	-- Utilize this to display LDR or current key table name
-- 	if window:active_key_table() then
-- 		stat = window:active_key_table()
-- 		stat_color = "#7dcfff"
-- 	end
-- 	if window:leader_is_active() then
-- 		stat = "LDR"
-- 		stat_color = "#bb9af7"
-- 	end
--
-- 	-- Current working directory
-- 	local basename = function(s)
-- 		-- Nothing a little regex can't fix
-- 		return string.gsub(s, "(.*[/\\])(.*)", "%2")
-- 	end
-- 	-- CWD and CMD could be nil (e.g. viewing log using Ctrl-Alt-l). Not a big deal, but check in case
-- 	local cwd = pane:get_current_working_dir()
-- 	-- cwd = cwd and basename(cwd) or ""
-- 	-- Current command
-- 	local cmd = pane:get_foreground_process_name()
-- 	cmd = cmd and basename(cmd) or ""
--
-- 	local bat = ""
-- 	for _, b in ipairs(wezterm.battery_info()) do
-- 		bat = "🔋" .. string.format("%.0f%% %s", b.state_of_charge * 100, b.state)
-- 	end
--
-- 	-- Left status (left of the tab line)
-- 	window:set_left_status(wezterm.format({
-- 		{ Foreground = { Color = stat_color } },
-- 		{ Text = "  " },
-- 		{ Text = stat },
-- 		{ Text = " |" },
-- 	}))
--
-- 	-- Right status
-- 	window:set_right_status(wezterm.format({
-- 		-- Wezterm has a built-in nerd fonts
-- 		-- https://wezfurlong.org/wezterm/config/lua/wezterm/nerdfonts.html
-- 		{ Text = bat },
-- 		{ Text = " | " },
-- 		{ Text = cwd },
-- 		{ Text = " | " },
-- 		{ Text = cmd },
-- 		"ResetAttributes",
-- 	}))
-- end)

wezterm.on("gui-startup", function()
	local tab, pane, window = mux.spawn_window({})
	window:gui_window():maximize()
end)

return config
