--[[
    Screen configuration file
]]

-- System libraries
local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local lain = require("lain")

-- Custom libraries
local utils = require("fab.utils")
local runshell = require("fab.run-shell")

-- Configuration loading
local config = require("config")
local mouse = require("mouse")

-- Widgets

-- Separator
local spr = wibox.widget.separator {
    forced_height = 8,
    thickness = 0,
}

-- Battery
local battery_widget = require("fab.widgets.batt")

-- Mem
local mem_widget = require("fab.widgets.mem")

-- CPU
local cpu_widget = require("fab.widgets.cpu")

-- Temp
local temp_widget = lain.widget.temp({
    settings = function()
        widget:set_markup(lain.util.markup.font(beautiful.font, " " .. coretemp_now .. "°C "))
        widget.align = "center"
    end
}).widget

-- Clock
local clock_widget = wibox.widget.textclock(lain.util.markup.font(beautiful.font, "%a %d\n%H:%M"), 1)
clock_widget.align = "center"

-- Callback called when a screen is connected
local function at_screen_connect(s)
    -- Wallpaper
    utils.set_wallpaper(s)

    -- Create a promptbox for each screen
    -- s.mypromptbox = awful.widget.prompt()
    s.mypromptbox = runshell

    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)
    ))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = mouse.taglist_buttons,
        widget_template = {
            {
                {
                    id            = 'text_role',
                    forced_height = 40,
                    forced_width  = 40,
                    align         = "center",
                    valign        = "center",
                    widget        = wibox.widget.textbox
                },
                margins = 4,
                widget  = wibox.container.margin,
            },
            id              = 'background_role',
            forced_width    = 40,
            forced_height   = 40,
            shape           = gears.shape.rounded_rect,
            widget          = wibox.container.background,
        },
        layout   = {
            layout  = wibox.layout.fixed.vertical
        }
    }

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = mouse.tasklist_buttons,
        widget_template = {
            {
                {
                    id            = 'icon_role',
                    forced_height = 40,
                    forced_width  = 40,
                    widget        = wibox.widget.imagebox
                },
                margins = 8,
                widget  = wibox.container.margin,
            },
            id              = 'background_role',
            forced_width    = 40,
            forced_height   = 40,
            shape           = gears.shape.rounded_rect,
            widget          = wibox.container.background,
        },
        layout   = {
            layout  = wibox.layout.fixed.vertical
        }
    }

    -- Create the systray
    s.mysystray = wibox.widget.systray()
    s.mysystray:set_horizontal(false)

    -- Create the wibox
    s.mywibox = awful.wibar({
        position = "left",
        screen = s,
        width = 40,
        bg = beautiful.bg_normal,
        fg = beautiful.fg_normal
    })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.vertical,
        { -- Top widgets
            layout = wibox.layout.fixed.vertical,
            spr,
            clock_widget,
            spr,
            cpu_widget,
            mem_widget,
            battery_widget,
            spr,
            s.mytaglist,
            spr,
        },
        s.mytasklist, -- Middle widget
        { -- Bottom widgets
            layout = wibox.layout.fixed.vertical,
            spr,
            s.mysystray,
            spr,
            s.mylayoutbox,
        },
    }
end

local init_tyrannical = function(tyrannical)
    -- Dynamic tags management
    tyrannical.tags = {
        {
            name        = "",
            init        = true, -- This tag wont be created at startup, but will be when one of the
                                -- client in the "class" section will start. It will be created on
                                -- the client startup screen
            -- exclusive   = false,
            fallback    = true,
            screen      = {1, 2, 3},
            layout      = awful.layout.suit.tile,
        },
        {
            name        = "",
            init        = true,
            exclusive   = true,
            force_screen = true,
            --icon        = "~net.png",                 -- Use this icon for the tag (uncomment with a real path)
            screen      = screen.count()>1 and 3 or 1,-- Setup on screen 2 if there is more than 1 screen, else on screen 1
                layout      = awful.layout.suit.max,      -- Use the max layout
                -- exec_once   = { "firefox" },
                class       = { "Navigator", "Firefox" }
        },
        {
            name        = "",
            init        = false,
            exclusive   = true,
            force_screen = true,
            volatile    = true,
            screen      = screen.count()>1 and 2 or 1,
            layout      = awful.layout.suit.max                          ,
            class       = { "code-oss" }
        },
        {
            name        = "",                 -- Call the tag "Term"
            init        = true,                   -- Load the tag on startup
            exclusive   = true,                   -- Refuse any other type of clients (by classes)
            screen      = screen.count()>1 and {2,3} or 1,                  -- Create this tag on screen 1 and screen 2
            layout      = awful.layout.suit.tile, -- Use the tile layout
            -- instance    = {"dev", "ops"},         -- Accept the following instances. This takes precedence over 'class'
            class       = { --Accept the following classes, refuse everything else (because of "exclusive=true")
                "Tilix","xterm","urxvt","aterm","URxvt","XTerm","konsole","terminator","gnome-terminal"
            }
        },
        {
            name        = "",
            init        = false,
            exclusive   = true,
            -- force_screen = true,
            volatile    = true,
            screen      = 1,
            layout      = awful.layout.suit.max,
            -- exec_once   = { "rocketchat-desktop" }, --When the tag is accessed for the first time, execute this command
            class       = { "Rocket.Chat" }
        },
        {
            name        = "",
            init        = false,
            exclusive   = true,
            -- force_screen = true,
            volatile    = true,
            screen      = 1,
            layout      = awful.layout.suit.max,
            -- exec_once   = { "spotify" }, --When the tag is accessed for the first time, execute this command
            class       = { "Spotify", "spotify" }
        },
    }

    -- Ignore the tag "exclusive" property for the following clients (matched by classes)
    tyrannical.properties.intrusive = {
        "ksnapshot"     , "pinentry"       , "gtksu"     , "kcalc"        , "xcalc"               ,
        "feh"           , "Gradient editor", "About KDE" , "Paste Special", "Background color"    ,
        "kcolorchooser" , "plasmoidviewer" , "Xephyr"    , "kruler"       , "plasmaengineexplorer",
    }

    -- Ignore the tiled layout for the matching clients
    tyrannical.properties.floating = {
        "MPlayer"      , "pinentry"        , "ksnapshot"  , "pinentry"     , "gtksu"          ,
        "xine"         , "feh"             , "kmix"       , "kcalc"        , "xcalc"          ,
        "yakuake"      , "Select Color$"   , "kruler"     , "kcolorchooser", "Paste Special"  ,
        "New Form"     , "Insert Picture"  , "kcharselect", "mythfrontend" , "plasmoidviewer"
    }

    -- Make the matching clients (by classes) on top of the default layout
    tyrannical.properties.ontop = {
        "Xephyr"       , "ksnapshot"       , "kruler"
    }

    -- Force the matching clients (by classes) to be centered on the screen on init
    tyrannical.properties.placement = {
        kcalc = awful.placement.centered
    }

    tyrannical.settings.block_children_focus_stealing = true --Block popups ()
    tyrannical.settings.group_children = true --Force popups/dialogs to have the same tags as the parent client
    tyrannical.settings.favor_focused = false

    return tyrannical
end

return {
    at_screen_connect = at_screen_connect,
    init_tyrannical = init_tyrannical
}