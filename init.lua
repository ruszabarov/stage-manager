-- init.lua

-- LOAD VARIABLES
monitorWatcher = nil

-- MY FUNCTIONS
-- function to reload init.lua when it changes
function reloadConfig(files)
    doReload = false
    for _, file in pairs(files) do
        if file:sub(-4) == ".lua" then
            doReload = true
        end
    end
    if doReload then
        hs.reload()
    end
end

-- function that calls an applescript
function monitorChangedCallback()
    local script = [[
        tell application "System Events"
			      set countDisplays to count of desktops
	
			      if countDisplays is greater than 1 then
				        do shell script "defaults write com.apple.WindowManager GloballyEnabled -bool true"
			      else
				        do shell script "defaults write com.apple.WindowManager GloballyEnabled -bool false"
			      end if
		    end tell
    ]]
    hs.osascript.applescript(script)
end

-- starts the pathwatcher to see if the init.lua changes in ~/.hammerspoon/
initWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()
hs.alert.show("Config loaded")

-- objects will be garbage collected if they aren't in explicit vars
-- Starts the screen watcher, making it so fn is called each time the screen arrangement changes
monitorWatcher = hs.screen.watcher.new(monitorChangedCallback):start()
