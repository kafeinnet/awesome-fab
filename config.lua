--[[
    General configuration file
]]

local config_path = string.format("%s/.config/awesome", os.getenv("HOME"))
local config = {}

-- Keyboard
config.modkey       = "Mod4"
config.altkey       = "Mod1"

-- Programs
config.terminal     = "urxvt" or "xterm" or "tilix"
config.editor       = os.getenv("EDITOR") or "vim" or "nano"
config.filemanager  = "pcmanfm"
config.browser      = "firefox"

-- Multimedia
config.mpris_player = "org.mpris.MediaPlayer2.spotify"

-- Startup programs
config.startup      = {
    -- "unclutter -root",
    "nm-applet",
    -- "pasystray",
    "light-locker",
    "pcmanfm -d",
    "blueman-applet"
}

-- Theme
config.wallpaper    = config_path .. "/assets/wallpaper.jpg"
config.fg_normal    = "#74AEAB"
config.fg_focus     = "#EA6F81"
config.fg_urgent    = "#CC9393"
config.bg_normal    = "#1A1A1A"
config.bg_focus     = "#313131"
config.bg_urgent    = "#1A1A1A"

return config