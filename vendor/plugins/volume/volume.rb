class Volume < Sinatra::Base
  dir = File.dirname(File.expand_path(__FILE__))

  set :views,  "#{dir}/views"
  set :public, "#{dir}/public"
  set :static, true

  get '/' do
    @current_volume = current_volume.to_s
    erb :index
  end

  post '/volume' do
    set_volume params[:volume]
    redirect '/' unless request.xhr?
  end

  get '/volume.json' do
    if callback = params[:callback]
      content_type :js
      "#{params[:callback]}(#{{:volume => current_volume}.to_json})"
    else
      content_type :json
      {:volume => current_volume}.to_json
    end
  end
  
  post '/volume.json' do
    set_volume(params[:volume])
    if callback = params[:callback]
      content_type :js
      "#{params[:callback]}(#{{:volume => current_volume}.to_json})"
    else
      content_type :json
      {:volume => current_volume}.to_json
    end
  end
  
  def set_volume(value)
    `osascript -e 'set volume output volume #{value}'`
  end
  
  def current_volume
    if volume_muted?
      0
    else
      `osascript -e 'output volume of (get volume settings)'`.chomp.to_i
    end
  end
  
  def volume_muted?
    `osascript -e 'output muted of (get volume settings)'`.chomp == 'true'
  end
end