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
local cellPhone = getEnvValue("CELL_PHONE") or "01000000000"

-- Control + Option + Cmd + P를 눌러 SECRET_VALUE 타이핑
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "P", function()
    hs.eventtap.keyStrokes(secretValue)
end)

-- Control + Option + Cmd + H를 눌러 전화번호 입력
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "H", function()
    hs.eventtap.keyStrokes(cellPhone)
end)

hs.hotkey.bind({"cmd", "alt"}, "V", function()
    hs.eventtap.keyStrokes(hs.pasteboard.getContents())
end)

-- 오른쪽 Command 키 상태 추적
rightCmdPressed = false
rightCmdFlagsTap = hs.eventtap.new({hs.eventtap.event.types.flagsChanged}, function(event)
    if event:getKeyCode() == 54 then
        rightCmdPressed = event:getFlags().cmd
    end
    return false
end)
rightCmdFlagsTap:start()

-- 오른쪽 Command + Space 차단
rightCmdSpaceTap = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(event)
    if event:getKeyCode() == 49 and rightCmdPressed then
        return true
    end
    return false
end)
rightCmdSpaceTap:start()


-- Hammerspoon 설정 리로드 알림
hs.alert.show("Config loaded")
