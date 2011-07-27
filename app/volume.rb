class Volume < Sinatra::Base

  get '/volume.json' do
    if callback = params[:callback]
      content_type :js
      "#{params[:callback]}(#{{:volume => OSX::Volume.volume}.to_json})"
    else
      content_type :json
      {:volume => OSX::Volume.volume}.to_json
    end
  end
  
  post '/volume.json' do
    # # TODO: move to background job
    OSX::Volume.volume = params[:volume]
    if callback = params[:callback]
      content_type :js
      "#{params[:callback]}(#{{:volume => OSX::Volume.volume}.to_json})"
    else
      content_type :json
      {:volume => OSX::Volume.volume}.to_json
    end
  end
end