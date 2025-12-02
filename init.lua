-- shell을 통해 .env 파일에서 환경 변수 읽기
local function getEnvValue(key)
    local envPath = os.getenv("HOME") .. "/.hammerspoon/.env"
    local handle = io.popen("source " .. envPath .. " 2>/dev/null && printf '%s' \"$" .. key .. "\"")
    local result = handle:read("*a")
    handle:close()
    -- 앞뒤 공백 및 줄바꿈 제거
    result = result:match("^%s*(.-)%s*$")
    return result ~= "" and result or nil
end

local secretValue = getEnvValue("SECRET_VALUE") or "hello"

-- Control + Option + Cmd + P를 눌러 SECRET_VALUE 타이핑
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "P", function()
    hs.eventtap.keyStrokes(secretValue)
end)

-- Hammerspoon 설정 리로드 알림
hs.alert.show("Config loaded")
