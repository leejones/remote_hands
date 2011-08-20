module OSX
  module Say
    extend self
    
    def say(phrase)
      `say "#{sanitize(phrase)}"`
    end


    def sanitize(string)
      string.gsub(/[^0-9A-Za-z.?!,\s\-']/, '')
    end
  end
end