class Say < Sinatra::Base
  post '/say' do
    say params[:phrase]
  end

  def say(phrase)
    `say '#{phrase}'`
  end
end