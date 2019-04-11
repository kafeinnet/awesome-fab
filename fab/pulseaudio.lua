local io = io
local math = math
local tonumber = tonumber
local tostring = tostring
local string = string

local function getDefaultSink()
    local f = io.popen("pacmd stat | awk -F\": \" '/^Default sink name: /{print $2}'")
    local v = f:read()
    f:close()
    return v
end

local function getSinkVolume(s)
    local f = io.popen("pacmd list-sinks | awk '/^\\s+name: /{indefault = $2 == \"<'" .. s .. "'>\"} /^\\s+volume: / && indefault {print $5; exit}'")
    local v = f:read()
    f:close()

    return tonumber(string.sub(v, 0, string.find(v, '%%') - 1))
end

local function volumeUp()
    local d = getDefaultSink()
    local v = getSinkVolume(d)
    local step = 5 * 65536 / 100

    if v ~= nil then
      local volume = v * 65536 / 100
      local newVolume = math.floor(volume + step)
      if newVolume > 65536 then
          newVolume = 65536
      end
      io.popen("pacmd set-sink-volume " .. d .. " " .. newVolume)
    end
end

local function volumeDown()
    local d = getDefaultSink()
    local v = getSinkVolume(d)
    local step = 5 * 65536 / 100

    if v ~= nil then
      local volume = v * 65536 / 100
      local newVolume = math.floor(volume - step)
      if newVolume < 0 then
          newVolume = 0
      end
      io.popen("pacmd set-sink-volume " .. d .. " " .. newVolume)
    end
end

local function volumeMute()
    local d = getDefaultSink()
    local g = io.popen("pacmd dump | grep set-sink-mute | grep '" .. d .. "'")
    local mute = g:read()
    if string.find(mute, "no") then
        io.popen("pacmd set-sink-mute " .. d .. " yes")
    else
        io.popen("pacmd set-sink-mute " .. d .. " no")
    end
    g:close()
end

local function volumeInfo()
    volmin = 0
    volmax = 65536
    local f = io.popen("pacmd dump |grep set-sink-volume")
    local g = io.popen("pacmd dump |grep set-sink-mute")
    local v = f:read()
    local mute = g:read()
    if mute ~= nil and string.find(mute, "no") then
        volume = math.floor(tonumber(string.sub(v, string.find(v, 'x')-1)) * 100 / volmax).." %"
    else
        volume = "✕"
    end
    f:close()
    g:close()
    return "𝅘𝅥𝅮  "..volume
end

return {
    volumeUp = volumeUp,
    volumeDown = volumeDown,
    volumeMute = volumeMute,
    volumeInfo = volumeInfo
}
