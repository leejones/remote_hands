on run argv
	tell application "System Events" to (name of processes) contains item 1 of argv
end run