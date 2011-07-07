module  Itunes
  module Helper
    def itunes_running?
      `osascript applescripts/is_app_running.scpt iTunes`.chomp == 'true'
    end
    
    def get_itunes_volume
      if itunes_running?
        `osascript applescripts/get_itunes_volume.scpt`.chomp.to_i
      else
        nil
      end
    end
    
    def set_itunes_volume(volume)
      if itunes_running?
        `osascript applescripts/set_itunes_volume.scpt #{volume}`
      else
        false
      end
    end
  end
end