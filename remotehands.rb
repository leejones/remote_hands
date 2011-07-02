class Remotehands < Sinatra::Base
  get '/' do
    erb :index
  end
end