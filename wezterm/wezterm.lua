local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- pre-existing configuration...
config.color_scheme = "Tokyo Night"

-- hide tab bar on single terminal
config.hide_tab_bar_if_only_one_tab = true

-- disable close confirmation
wezterm.on("mux-is-process-stateful", function(proc)
	return false
end)

-- Terminator-style split shortcuts
config.keys = {
	{
		key = "e",
		mods = "CTRL|SHIFT",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "o",
		mods = "CTRL|SHIFT",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "w",
		mods = "CTRL|SHIFT",
		action = wezterm.action.CloseCurrentPane({ confirm = false }),
	},
}

return config
