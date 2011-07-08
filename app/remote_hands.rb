class Remotehands < Sinatra::Base
  include Itunes::Helper
  dir = File.dirname(File.expand_path(__FILE__))
  set :views,  "#{dir}/../views"
  set :public, "#{dir}/../public"
  set :static, true

  get '/' do
    erb :index
  end
  
  get '/itunes.json' do
    data = {
      :running => itunes_running?,
      :volume => get_itunes_volume
    }
    if callback = params[:callback]
      content_type :js
      "#{callback}(#{data.to_json})"
    else
      content_type :json
      data.to_json
    end
  end

  post '/itunes.json' do
    set_itunes_volume(params[:volume])
    if callback = params[:callback]
      content_type :js
      "#{callback}(#{{:volume => get_itunes_volume}.to_json})"
    else
      content_type :json
      {:volume => get_itunes_volume}.to_json
    end
  end

  post '/applications/launch' do
    `osascript -e 'tell application "#{params[:name]}" to launch'`
  end
end