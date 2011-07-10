module SystemVolumeControl
  def set_volume(value)
    `osascript -e 'set volume output volume #{value}'`
  end

  def current_volume
    if volume_muted?
      0
    else
      `osascript -e 'output volume of (get volume settings)'`.chomp.to_i
    end
  end

  def volume_muted?
    `osascript -e 'output muted of (get volume settings)'`.chomp == 'true'
  end
end