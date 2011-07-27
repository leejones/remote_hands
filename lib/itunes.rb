module  Itunes

  extend self

  def running?
    `osascript #{APPLESCRIPTS_PATH}/is_app_running.scpt iTunes`.chomp == 'true'
  end
  
  def volume
    if running?
      `osascript #{APPLESCRIPTS_PATH}/get_itunes_volume.scpt`.chomp.to_i
    else
      nil
    end
  end
  
  def volume=(value)
    if running?
      `osascript #{APPLESCRIPTS_PATH}/set_itunes_volume.scpt #{value}`
    else
      false
    end
  end
end