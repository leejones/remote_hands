on run argv
  set original_volume to (get output volume of (get volume settings))
  if (count argv) is 0 then
    log "You must specify a volume."
    exit
  else
    set requested_volume to item 1 of argv
  end if

   set adjustment_interval to 5
   set delay_between_adjustments_in_seconds to 0.20

   log "Requested Volume: " & requested_volume

   set current_volume to (get output volume of (get volume settings))

   repeat
     log "Current Volume: " & current_volume
     if current_volume is equal to requested_volume then
       log "Volumes are the same"
       exit repeat
     else if absolute_value_of(current_volume - requested_volume) is less than adjustment_interval
       set volume output volume requested_volume
       -- The system will change some values so once we get here that's good enough
       log "Volumes are close enough"
       exit repeat
     else if current_volume is less than requested_volume then
       set volume output volume (current_volume + adjustment_interval)
       set current_volume to (current_volume + adjustment_interval)
     else if current_volume is greater than requested_volume then
       set volume output volume (current_volume - adjustment_interval)
       set current_volume to (current_volume - adjustment_interval)
     else
       exit repeat
     end if
     delay delay_between_adjustments_in_seconds
   end repeat
end run

on absolute_value_of(n)
  if n < 0 then set n to -n
  return n
end absolute_value_of