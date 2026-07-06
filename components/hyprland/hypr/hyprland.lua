----------------------
---- BASIC CONFIG ----
----------------------

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

------------------
---- MONITORS ----
------------------

hl.monitor({
	output   = "dp-2",
	mode     = "preferred",
	position = "auto",
	scale    = "auto",
})

hl.monitor({
	output   = "hdmi-a-1",
	mode     = "preferred",
	position = "auto",
	scale    = "auto",
})

---------------------
---- MY PROGRAMS ----
---------------------

local terminal = "kitty"

---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER" -- "Windows" key

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
	hl.bind(mainMod .. " + J", hl.dsp.window.resize({ x = 0, y = -10, relative = true}, { repeating = true }))
	hl.bind(mainMod .. " + K", hl.dsp.window.resize({ x = 0, y = 10, relative = true}, { repeating = true }))
	hl.bind(mainMod .. " + H", hl.dsp.window.resize({ x = -10, y = 0, relative = true}, { repeating = true }))
	hl.bind(mainMod .. " + L", hl.dsp.window.resize({ x = 10, y = 0, relative = true}, { repeating = true }))
end)

-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
	general = {
		resize_on_border = true,
		allow_tearing = false,
		layout = "dwindle",
	},

	decoration = {
		rounding = 10,
		rounding_power = 2,

		active_opacity = 1.0,
		inactive_opacity = 0.9,

		shadow = {
			enabled = true,
			range = 4,
			render_power = 3,
			color = 0xee1a1a1a,
		},

		blur = {
			enabled = true,
			size = 3,
			passes = 1,
			vibrancy = 0.1696,
		},
	},
	animations = {
		enabled = true,
	},
})

