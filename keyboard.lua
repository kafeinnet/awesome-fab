
local awful = require("awful")
local lain = require("lain")
local gears = require("gears")
local hotkeys_popup = require("awful.hotkeys_popup").widget

local pulseaudio = require("fab.pulseaudio")
local xrandr = require("fab.xrandr")

local config = require("config")

local modkey = config.modkey
local altkey = config.altkey

-- Globally available keys
local globalkeys = awful.util.table.join(
    -- Hotkeys
    awful.key({modkey,                   }, "s"             , hotkeys_popup.show_help, {description="show help", group="awesome"}),
    awful.key({modkey,                   }, "w"             , function () awful.util.mymainmenu:show() end, {description = "show main menu", group = "awesome"}),
    awful.key({modkey                    }, "r"             , function () awful.screen.focused().mypromptbox.launch() end, {description = "run prompt", group = "launcher"}),
    awful.key({modkey, "Control"         }, "r"             , awesome.restart, {description = "reload awesome", group = "awesome"}),
    awful.key({modkey,                   }, "q"             , awesome.quit, {description = "quit awesome", group = "awesome"}),
    awful.key({modkey,            "Shift"}, "d"             , xrandr.switch, {description = "screen selector", group="screen"}),
    awful.key({modkey                    }, "d"             , function () awful.util.spawn("autorandr -c") end, {description = "detect screen layout", group="screen"}),
    awful.key({modkey                    }, "l"             , function () awful.util.spawn("light-locker-command -l") end, {description = "lock screen", group="screen"}),

    -- Programs
    awful.key({modkey,                   }, "Return"        , function () awful.spawn(config.terminal) end, {description = "open a terminal", group = "launcher"}),
    awful.key({modkey                    }, "e"             , function () awful.spawn(config.filemanager, {intrusive=true}) end),
    awful.key({modkey                    }, "q"             , function () awful.spawn(config.browser) end),

    -- Screen browsing
    awful.key({modkey, "Control", "Shift"}, "Right"         , function () awful.screen.focus_relative( 1) end, {description = "focus the next screen", group = "screen"}),
    awful.key({modkey, "Control", "Shift"}, "Left"          , function () awful.screen.focus_relative(-1) end, {description = "focus the previous screen", group = "screen"}),

    -- Tag browsing
    awful.key({modkey, "Control"         }, "Left"          , awful.tag.viewprev, {description = "view previous", group = "tag"}),
    awful.key({modkey, "Control"         }, "Right"         , awful.tag.viewnext, {description = "view next", group = "tag"}),
    awful.key({modkey,                   }, "Tab"           , awful.tag.history.restore, {description = "go back", group = "tag"}),
    awful.key({altkey                    }, "Left"          , function () lain.util.tag_view_nonempty(-1) end, {description = "view previous nonempty", group = "tag"}),
    awful.key({altkey                    }, "Right"         , function () lain.util.tag_view_nonempty(1) end, {description = "view next nonempty", group = "tag"}),

    -- Client browsing
    awful.key({modkey                    }, "Down"          , function() awful.client.focus.bydirection("down") if client.focus then client.focus:raise() end end),
    awful.key({modkey                    }, "Up"            , function() awful.client.focus.bydirection("up") if client.focus then client.focus:raise() end end),
    awful.key({modkey                    }, "Left"          , function() awful.client.focus.bydirection("left") if client.focus then client.focus:raise() end end),
    awful.key({modkey                    }, "Right"         , function() awful.client.focus.bydirection("right") if client.focus then client.focus:raise() end end),
    awful.key({modkey,                   }, "u"             , awful.client.urgent.jumpto, {description = "jump to urgent client", group = "client"}),
    awful.key({altkey,                   }, "Tab"           , function () awful.client.focus.history.previous() if client.focus then client.focus:raise() end end, {description = "go back", group = "client"}),

    -- Layout manipulation
    awful.key({modkey,            "Shift"}, "j"             , function () awful.client.swap.byidx(  1) end, {description = "swap with next client by index", group = "client"}),
    awful.key({modkey,            "Shift"}, "k"             , function () awful.client.swap.byidx( -1) end, {description = "swap with previous client by index", group = "client"}),
    awful.key({modkey,                   }, "space"         , function () awful.layout.inc( 1) end, {description = "select next", group = "layout"}),
    awful.key({modkey,            "Shift"}, "space"         , function () awful.layout.inc(-1) end, {description = "select previous", group = "layout"}),

    -- Show/Hide Wibox
    awful.key({modkey                    }, "b"             , function () for s in screen do s.mywibox.visible = not s.mywibox.visible end end),

    -- Dynamic tagging
    awful.key({modkey,            "Shift"}, "n"             , function () lain.util.add_tag() end, {description = "create new tag", group="dynamic"}),
    awful.key({modkey,            "Shift"}, "r"             , function () lain.util.rename_tag() end, {description = "rename a tag", group="dynamic"}),
    awful.key({modkey,            "Shift"}, "Left"          , function () lain.util.move_tag(-1) end, {description = "move tag left", group="dynamic"}),
    awful.key({modkey,            "Shift"}, "Right"         , function () lain.util.move_tag(1) end, {description = "move tag right", group="dynamic"}),
    awful.key({modkey,            "Shift"}, "d"             , function () lain.util.delete_tag() end, {description = "delete a tag", group="dynamic"}),

    -- Multimedia
    awful.key({                          }, "XF86AudioPlay" , function() awful.util.spawn("dbus-send --print-reply --dest=" .. config.mpris_player .. " /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause") end, {description = "play", group="multimedia"}),
    awful.key({                          }, "XF86AudioNext" , function() awful.util.spawn("dbus-send --print-reply --dest=" .. config.mpris_player .. " /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next") end, {description = "next", group="multimedia"}),
    awful.key({                          }, "XF86AudioPrev" , function() awful.util.spawn("dbus-send --print-reply --dest=" .. config.mpris_player .. " /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous") end, {description = "prev", group="multimedia"}),
    awful.key({                          }, "XF86AudioStop" , function() awful.util.spawn("dbus-send --print-reply --dest=" .. config.mpris_player .. " /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Stop") end, {description = "stop", group="multimedia"}),
    awful.key({                          }, "XF86AudioRaiseVolume"  , pulseaudio.volumeUp, {description = "sound volume up", group="multimedia"}),
    awful.key({                          }, "XF86AudioLowerVolume"  , pulseaudio.volumeDown, {description = "sound volume down", group="multimedia"}),
    awful.key({                          }, "XF86AudioMute"         , pulseaudio.volumeMute, {description = "sound volume mute", group="multimedia"})
)

-- Tags keys
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({modkey                    }, "#" .. i + 9            , function() local tag = awful.screen.focused().tags[i]; if tag then tag:view_only(); end; end, {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({modkey, "Control"         }, "#" .. i + 9            , function() local tag = awful.screen.focused().tags[i]; if tag then tag:viewtoggle(); end; end, {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({modkey,            "Shift"}, "#" .. i + 9            , function() if client.focus then local tag = client.focus.screen.tags[i]; if tag then client.focus:move_to_tag(tag); end; end; end, {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({modkey, "Control", "Shift"}, "#" .. i + 9            , function() if client.focus then local tag = client.focus.screen.tags[i]; if tag then client.focus:toggle_tag(tag); end; end; end, {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

-- Keys available when a client is focused
clientkeys = awful.util.table.join(
    awful.key({modkey,            "Shift"}, "f"             , lain.util.magnify_client, {description = "toggle floating", group = "client"}),
    awful.key({modkey,                   }, "m"             , function (c) c.maximized = not c.maximized; c:raise() end , {description = "maximize", group = "client"}),
    awful.key({modkey,                   }, "f"             , function (c) c.fullscreen = not c.fullscreen; c:raise() end, {description = "toggle fullscreen", group = "client"}),
    awful.key({modkey,                   }, "x"             , function (c) c:kill() end, {description = "close", group = "client"})
)

return {
    globalkeys=globalkeys,
    clientkeys=clientkeys
}