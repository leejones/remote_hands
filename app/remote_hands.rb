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
  
  get '/ws' do
        html = <<-EOS
<html>
  <head>
    <script src='http://ajax.googleapis.com/ajax/libs/jquery/1.3.2/jquery.min.js'></script>
    <script>
      $(document).ready(function(){
        function debug(str){ $("#debug").append("<p>"+str+"</p>"); };

        ws = new WebSocket("ws://127.0.0.1:8080");
        ws.onmessage = function(evt) { $("#msg").append("<p>"+evt.data+"</p>"); };
        ws.onclose = function() { debug("socket closed"); };
        ws.onopen = function() {
          debug("connected...");
        };
        $('#message-box').submit(function(value){
          var $input = $('input', this);
          var message = $input.val();
          ws.send(message);
          $input.val('');
          return false;
        })
      });
    </script>
  </head>
  <body>
    <h1>Websockets Spike</h1>
    <form id="message-box">
      <label for="message-text">Message: </label>
      <input type="text" name="message-text" id="message-text" />
    </form>
    <h2>Messages</h2>
    <div id="msg"></div>
    <h2>Debugger</h2>
    <div id="debug"></div>
  </body>
</html>
EOS
  end
end