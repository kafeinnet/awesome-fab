local watch = require("awful.widget.watch")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

local naughty = require("naughty")

local batt_widget = wibox.widget {
    max_value     = 1,
    forced_height = 12,
    forced_width  = 32,
    widget        = wibox.widget.progressbar,
}

watch("acpi -i", 10,
    function(widget, stdout)
        local batteryType

        local battery_info = {}
        local capacities = {}
        for s in stdout:gmatch("[^\r\n]+") do
            local status, charge_str, time = string.match(s, '.+: (%a+), (%d?%d?%d)%%,?.*')
            if string.match(s, 'rate information') then
                -- ignore such line
            elseif status ~= nil then
                table.insert(battery_info, {status = status, charge = tonumber(charge_str)})
            else
                local cap_str = string.match(s, '.+:.+last full capacity (%d+)')
                table.insert(capacities, tonumber(cap_str))
            end
        end

        local capacity = 0
        for i, cap in ipairs(capacities) do
            capacity = capacity + cap
        end

        local charge = 0
        local status
        for i, batt in ipairs(battery_info) do
            if batt.charge >= charge then
                -- use most charged battery status. This is arbitrary, and maybe another metric should be used
                status = batt.status
            end

            charge = charge + batt.charge * capacities[i]
        end

        local charge_percentage
        if capacity > 5 then
            charge = charge / capacity
            charge_percentage = charge / 100
        else
            -- when widget.value is < 0.04, the widget shows a full circle (as widget.value=1)
            charge_percentage = 0.05
        end

        widget.value = charge / 100

        if status == 'Charging' then
            widget.background_color = beautiful.widget_green
            widget.color = beautiful.widget_black
        else
            widget.background_color = beautiful.widget_transparent
            widget.color = beautiful.widget_main_color
        end

        if charge < 15 then
            wdiget.color = beautiful.widget_red
            if status ~= 'Charging' and os.difftime(os.time(), last_battery_check) > 300 then
                -- if 5 minutes have elapsed since the last warning
                last_battery_check = os.time()

                -- TODO
                show_battery_warning()
            end
        elseif charge >= 15 and charge < 40 then
            widget.color = beautiful.widget_yellow
        elseif charge >= 40 and charge < 80 then
            widget.color = beautiful.widget_green
        else
            widget.color = beautiful.widget_main_color
        end
    end,
    batt_widget
)

return batt_widget
