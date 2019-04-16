local watch = require("awful.widget.watch")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

local cpu_widget = wibox.widget {
    max_value     = 1,
    forced_height = 12,
    forced_width  = 32,
    widget        = wibox.widget.progressbar,
}

local total_prev = 0
local idle_prev = 0

watch([[bash -c "cat /proc/stat | grep '^cpu '"]], 1,
    function(widget, stdout)
        local user, nice, system, idle, iowait, irq, softirq, steal, guest, guest_nice =
        stdout:match('(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s')

        local total = user + nice + system + idle + iowait + irq + softirq + steal

        local diff_idle = idle - idle_prev
        local diff_total = total - total_prev
        local diff_usage = (diff_total - diff_idle) / diff_total

        widget.value = diff_usage

        total_prev = total
        idle_prev = idle
    end,
    cpu_widget
)

return cpu_widget
