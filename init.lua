-- init.lua

-- LOAD VARIABLES
monitorWatcher = nil

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

-- objects will be garbage collected if they aren't in explicit vars
-- Starts the screen watcher, making it so fn is called each time the screen arrangement changes
monitorWatcher = hs.screen.watcher.new(monitorChangedCallback):start()
