local watch = require("awful.widget.watch")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

local naughty = require("naughty")

local mem_widget = wibox.widget {
    max_value     = 1,
    forced_height = 12,
    forced_width  = 32,
    widget        = wibox.widget.progressbar,
}

watch('bash -c "free | grep -z Mem.*Swap.*"', 1,
    function(widget, stdout)
        total, used, free, shared, buff_cache, available, total_swap, used_swap, free_swap =
        stdout:match('(%d+)%s*(%d+)%s*(%d+)%s*(%d+)%s*(%d+)%s*(%d+)%s*Swap:%s*(%d+)%s*(%d+)%s*(%d+)')

        widget.value = (total - free) / total
    end,
    mem_widget
)

return mem_widget
