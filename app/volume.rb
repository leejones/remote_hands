class Volume < Sinatra::Base
  include OSX::Volume

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
    $redis.publish 'remote_hands_osx', {:volume => params[:volume]}.to_json
    # # TODO: move to background job
    # set_volume(params[:volume])
    if callback = params[:callback]
      content_type :js
      "#{params[:callback]}(#{{:volume => current_volume}.to_json})"
    else
      content_type :json
      {:volume => current_volume}.to_json
    end
  end
end