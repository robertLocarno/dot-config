----------------------
---- BASIC CONFIG ----
----------------------

-- Noctalia Qt Application setup (make sure qt6ct is installed via paru)
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")

-- Nvidia specific setup, taken from the wiki
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")

-- Enable debug logs
--   NOTE: Disable when not actively debugging, this slows things down
-- debug.disable_logs = false
-- debug.gl_debugging = true

hl.on("hyprland.start", function()
	-- enable polkit authentication agent
	hl.exec_cmd("systemctl --user start hyprpolkitagent")
	-- enable clipse for copy / paste
	hl.exec_cmd("clipse -listen")
	-- Start the status bar
	hl.exec_cmd("noctalia")
end)

-- Notify config was reloaded
hl.on("config.reloaded", function()
	hl.notification.create({
		text = "Config Reloaded",
		timeout = 1000,
	})
end)

-- Use clipse for clipboard logic
hl.bind(
	"SUPER + V",
	hl.dsp.exec_cmd(
		"kitty --class clipse -e clipse",
		{ 
			float = true,
			size = { 600, 650 },
			stay_focused = true,
		}
	)
)

-- Hyprcursor
hl.env("HYPRCURSOR_THEME", "rose-pine-hyprcursor")
hl.env("HYPRCURSOR_SIZE", "24")

------------------
---- MONITORS ----
------------------

-- Old Book monitor
-- hl.monitor({
-- 	output   = "eDP-1",
-- 	mode     = "preferred",
-- 	position = "0x0",
-- 	scale    = "1.0",
-- })

hl.monitor({
	output   = "DP-1",
	mode     = "preferred",
	position = "0x0",
	scale    = "auto",
})

hl.monitor({
	output   = "HDMI-A-1",
	disabled = false,
	mode     = "preferred",
	position = "auto-center-left",
	transform = 1,
	scale    = "auto",
})

-----------------------------------
---- WORKSPACE & WINDOW CONFIG ----
-----------------------------------

hl.workspace_rule({ workspace = "1", monitor = "DP-1", persistent = true })
hl.workspace_rule({ workspace = "2", monitor = "HDMI-A-1", persistent = true })
hl.workspace_rule({ workspace = "3", monitor = "DP-1", persistent = true })
hl.workspace_rule({ workspace = "4", monitor = "DP-1", persistent = true })
hl.workspace_rule({ workspace = "5", monitor = "DP-1", persistent = true })

-- hl.window_rule({
-- 	name = "fullscreen-steam",
-- 	match = {
-- 		class = "^steam_app_.+$",
-- 	},
-- 	border_size = 0,
-- 	fullscreen = true,
-- 	monitor = "1",
-- 	workspace = "10",
-- })

---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER" -- "Windows" key
local terminal = "kitty"
local ipc = "noctalia msg "

-- Open terminal
hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(terminal))
-- Close window
hl.bind(mainMod .. " + C", hl.dsp.window.close())
-- Shutdown hyprland
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))

-- Toggle window float
hl.bind(mainMod .. " + F", hl.dsp.window.float({ action = "toggle" }))

-- Move focus
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))

-- Move window
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.move({ direction = "down" }))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.move({ direction = "right" }))

-- Workspace management
for i = 1, 10 do
	local key = i % 10 -- 10 maps to 0
	
	-- Switch to workspace
	hl.bind(mainMod .. " + " .. key, 		hl.dsp.focus({ workspace = i }))
	-- Move window to workspace
	hl.bind(mainMod .. " + SHIFT + " .. key, 	hl.dsp.window.move({ workspace = i }))
end

-- Move workspace to next monitor
hl.bind(mainMod .. " + TAB", hl.dsp.workspace.move({ monitor = "+1" }))

-- Submap escape
hl.bind("ESCAPE", function()
	local current_submap = hl.get_current_submap()

	if current_submap == "" then return { ok = false, message = "no-op" } end

	hl.dispatch(hl.dsp.submap("reset"))
	hl.config({ general = { col = { active_border = 0xffffffff } } })
end, { submap_universal = true, auto_consuming = true })

-- Resize submap
hl.bind(mainMod .. " + SHIFT + R", function()
	hl.dispatch(hl.dsp.submap("resize"))
	hl.config({ general = { col = { active_border = 0xffff0000 } } })
end)
hl.define_submap("resize", function()
	hl.bind(mainMod .. " + J", hl.dsp.window.resize({ x = 0, y = 10, relative = true}), { repeating = true })
	hl.bind(mainMod .. " + K", hl.dsp.window.resize({ x = 0, y = -10, relative = true}), { repeating = true })
	hl.bind(mainMod .. " + H", hl.dsp.window.resize({ x = -10, y = 0, relative = true}), { repeating = true })
	hl.bind(mainMod .. " + L", hl.dsp.window.resize({ x = 10, y = 0, relative = true}), { repeating = true })

	hl.bind("J", hl.dsp.window.move({ x = 0, y = 10, relative = true}), { repeating = true })
	hl.bind("K", hl.dsp.window.move({ x = 0, y = -10, relative = true}), { repeating = true })
	hl.bind("H", hl.dsp.window.move({ x = -10, y = 0, relative = true}), { repeating = true })
	hl.bind("L", hl.dsp.window.move({ x = 10, y = 0, relative = true}), { repeating = true })
end)

-- Fullscreen submap
hl.bind(mainMod .. " + SHIFT + F", function()
	hl.dispatch(hl.dsp.window.fullscreen({
		mode = "fullscreen",
		action = "toggle"
	}))

	hl.notification.create({
		text = "Fullscreen",
		timeout = 1000,
	})
end)

-- Hot reloads
hl.on("config.reloaded", function()
	hl.notification.create({
		text = "Config Reloaded",
		timeout = 1000,
	})
end)

-- Noctalia shortcuts
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd(ipc .. "panel-toggle launcher"))
-- hl.bind(mainMod .. " + SPACE", function()
-- 	hl.notification.create({ text = "debug", timeout = 1000 })
-- end)
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd(ipc .. "panel-toggle control-center"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd(ipc .. "settings-toggle"))

-- Media keys
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(ipc .. "volume-up"))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(ipc .. "volume-down"))
hl.bind("XF86AudioMute", hl.dsp.exec_cmd(ipc .. "volume-mute"))
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(ipc .. "brightness-up"))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(ipc .. "brightness-down"))

-- Hyprshutdown shortcut
hl.bind(mainMod .. " + CONTROL + ESCAPE", hl.dsp.exec_cmd("hyprshutdown"))

-- Special workspace stuff
local hiddenName = "hidden"

hl.bind(mainMod .. " + MINUS", hl.dsp.window.move({ workspace = "special:" .. hiddenName, follow = false }))
hl.bind(mainMod .. " + EQUAL", hl.dsp.workspace.toggle_special(hiddenName))

-----------------------
---- PROGRAM RULES ----
-----------------------

hl.window_rule({
    match = { class = "dev.noctalia.Noctalia" },
    float = true,
    size = { 1080, 920 },
})

hl.layer_rule({
  name = "noctalia",
  match = {
    namespace = "^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd|window-switcher)$",
  },
  no_anim = true,
  ignore_alpha = 0.5,
  blur = true,
  blur_popups = true,
})

-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
	general = {
		gaps_in = 5,
		gaps_out = 10,
		resize_on_border = true,
		allow_tearing = false,
		layout = "dwindle",
	},

	decoration = {
		rounding = 10,
		rounding_power = 2,

		active_opacity = 1.0,
		inactive_opacity = 0.95,

		shadow = {
			enabled = true,
			range = 4,
			render_power = 3,
			color = 0xee1a1a1a,
		},

		blur = {
			enabled = true,
			size = 3,
			passes = 2,
			vibrancy = 0.1696,
		},
	},
	animations = {
		enabled = true,
	},
	input = {
		sensitivity = -0.3,
	},
	misc = {
		disable_hyprland_logo = true,
		disable_splash_rendering = true,
	}
})


-- For Noctalia Color templates
require("noctalia").apply_theme()
