class Say < Sinatra::Base
  post '/say' do
    OSX::Say.say params[:phrase]
  end
end