local gears = require("gears")
local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local gfs = require("gears.filesystem")
local assets_path = gfs.get_configuration_dir() .. "/assets"

local theme = {}

theme.wallpaper    = assets_path .. "/wallpaper.jpg"

-- Main colors
theme.fg_normal    = "#74AEAB"
theme.fg_focus     = "#EA6F81"
theme.fg_urgent    = "#CC9393"
theme.fg_normal    = "#74AEAB"
theme.bg_normal    = "#1A1A1A"
theme.bg_focus     = "#313131"
theme.bg_urgent    = "#1A1A1A"
theme.bg_systray   = theme.bg_normal

-- Text
theme.font         = "xos4 Terminus 9"
theme.taglist_font = "xos4 Terminus 16"

-- Border
theme.useless_gap   = dpi(0)
theme.border_width  = dpi(1)
theme.border_width                              = 1
theme.border_normal                             = "#3F3F3F"
theme.border_focus                              = "#7F7F7F"
theme.border_marked                             = "#CC9393"

-- Icons
theme.taglist_squares_sel                       = assets_path .. "/icons/square_sel.png"
theme.taglist_squares_unsel                     = assets_path .. "/icons/square_unsel.png"
theme.layout_tile                               = assets_path .. "/icons/tile.png"
theme.layout_tileleft                           = assets_path .. "/icons/tileleft.png"
theme.layout_tilebottom                         = assets_path .. "/icons/tilebottom.png"
theme.layout_tiletop                            = assets_path .. "/icons/tiletop.png"
theme.layout_fairv                              = assets_path .. "/icons/fairv.png"
theme.layout_fairh                              = assets_path .. "/icons/fairh.png"
theme.layout_spiral                             = assets_path .. "/icons/spiral.png"
theme.layout_dwindle                            = assets_path .. "/icons/dwindle.png"
theme.layout_max                                = assets_path .. "/icons/max.png"
theme.layout_fullscreen                         = assets_path .. "/icons/fullscreen.png"
theme.layout_magnifier                          = assets_path .. "/icons/magnifier.png"
theme.layout_floating                           = assets_path .. "/icons/floating.png"

-- Widgets
theme.widget_main_color = "#74aeab"
theme.widget_red = "#e53935"
theme.widget_yellow = "#c0ca33"
theme.widget_green = "#43a047"
theme.widget_black = "#000000"
theme.widget_transparent = "#00000000"
theme.progressbar_bg = theme.bg_focus
theme.progressbar_fg = theme.fg_normal
theme.progressbar_shape = gears.shape.rectangle
theme.progressbar_margins = {left=4, right=4, bottom=2, top=2}

return theme