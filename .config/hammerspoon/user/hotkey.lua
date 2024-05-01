----------------------------------------------------------------------------------------------------
hs.hotkey.bind({ "cmd", "alt", "ctrl", "shift" }, "U", function()
    local state = hs.execute("brew services info xray", true)
    if string.find(state, "PID") then
        hs.notify.new({title="Hammerspoon", informativeText="Turn Off V2rayU"}):send()
        hs.execute("brew services stop xray", true)
        hs.execute("networksetup -setwebproxystate Wi-Fi off")
        hs.execute("networksetup -setwebproxystate 'USB 10/100 LAN' off")
        hs.execute("networksetup -setsecurewebproxystate Wi-Fi off")
        hs.execute("networksetup -setsecurewebproxystate 'USB 10/100 LAN' off")
        hs.execute("networksetup -setsocksfirewallproxystate Wi-Fi off")
        hs.execute("networksetup -setsocksfirewallproxystate 'USB 10/100 LAN' off")
    else
        hs.notify.new({title="Hammerspoon", informativeText="Turn On V2rayU"}):send()
        hs.execute("brew services start xray", true)
        hs.execute("networksetup -setwebproxy Wi-Fi 127.0.0.1 1087")
        hs.execute("networksetup -setwebproxy 'USB 10/100 LAN' 127.0.0.1 1087")
        hs.execute("networksetup -setsecurewebproxy Wi-Fi 127.0.0.1 1087")
        hs.execute("networksetup -setsecurewebproxy 'USB 10/100 LAN' 127.0.0.1 1087")
        hs.execute("networksetup -setsocksfirewallproxy Wi-Fi 127.0.0.1 1080")
        hs.execute("networksetup -setsocksfirewallproxy 'USB 10/100 LAN' 127.0.0.1 1080")
    end

end)


hs.hotkey.bind({ "cmd", "alt", "ctrl", "shift" }, "A", function()
    spoon.AClock:toggleShowPersistent()
end)
