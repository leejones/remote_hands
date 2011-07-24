module  Itunes
  module Helper
    def itunes_running?
      `osascript #{APPLESCRIPTS_PATH}/is_app_running.scpt iTunes`.chomp == 'true'
    end
    
    def get_itunes_volume
      if itunes_running?
        `osascript #{APPLESCRIPTS_PATH}/get_itunes_volume.scpt`.chomp.to_i
      else
        nil
      end
    end
    
    def set_itunes_volume(volume)
      if itunes_running?
        `osascript #{APPLESCRIPTS_PATH}/set_itunes_volume.scpt #{volume}`
      else
        false
      end
    end
  end
end