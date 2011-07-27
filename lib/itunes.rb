module  Itunes

  extend self

  def running?
    `osascript #{APPLESCRIPTS_PATH}/osx/is_app_running.scpt iTunes`.chomp == 'true'
  end
  
  def volume
    if running?
      `osascript #{APPLESCRIPTS_PATH}/itunes/volume.scpt`.chomp.to_i
    else
      nil
    end
  end
  
  def volume=(value)
    if running?
      `osascript #{APPLESCRIPTS_PATH}/itunes/set_volume.scpt #{value}`
    else
      false
    end
  end
end