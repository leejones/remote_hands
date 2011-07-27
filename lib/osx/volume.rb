module OSX
  module Volume

    extend self

    def volume=(value)
      `osascript #{APPLESCRIPTS_PATH}/fade_system_volume_to.scpt '#{value}'`
    end

    def volume
      if muted?
        0
      else
        `osascript -e 'output volume of (get volume settings)'`.chomp.to_i
      end
    end

    def muted?
      `osascript -e 'output muted of (get volume settings)'`.chomp == 'true'
    end
  end
end