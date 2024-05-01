-- 自动重载配置文件
function reloadConfig(files)
    doReload = false
    for _, file in pairs(files) do
        if file:sub(-4) == ".lua" then
            doReload = true
        end
    end
    if doReload then
        hs.reload()
        hs.console.clearConsole()
    end
end

MyPathWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.config/hammerspoon/", reloadConfig):start()
hs.notify.new({title="Hammerspoon", informativeText="Reload Config"}):send()


require('user.plugins')

require('user.mouse')

require('user.hotkey')
