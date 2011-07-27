class Remotehands < Sinatra::Base
  dir = File.dirname(File.expand_path(__FILE__))
  set :views,  "#{dir}/../views"
  set :public, "#{dir}/../public"
  set :static, true

  get '/' do
    erb :index
  end
  
  get '/itunes.json' do
    data = {
      :running => Itunes.running?,
      :volume => Itunes.volume
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
    Itunes.volume = params[:volume]
    if callback = params[:callback]
      content_type :js
      "#{callback}(#{{:volume => Itunes.volume}.to_json})"
    else
      content_type :json
      {:volume => Itunes.volume}.to_json
    end
  end

  post '/applications/launch' do
    `osascript -e 'tell application "#{params[:name]}" to launch'`
  end
  
  get '/javascripts/config.js' do
    websocket_url = "#{WEBSOCKETS_CONFIG[:host]}:#{WEBSOCKETS_CONFIG[:port]}"
    content_type :js
    "var websocket_url='#{websocket_url}';"
  end
  
  get '/ws' do
        html = <<-EOS
<html>
  <head>
    <script src='http://ajax.googleapis.com/ajax/libs/jquery/1.3.2/jquery.min.js'></script>
    <script>
      $(document).ready(function(){
        function debug(str){ $("#debug").append("<p>"+str+"</p>"); };
        function chat(str){ $("#msg").append("<p>"+str+"</p>"); }
        // # TODO: use hostname and/or make configurable
        ws = new WebSocket("ws://127.0.0.1:8080");
        ws.onmessage = function(event) {
          var data = eval("(" + event.data + ")");          
          switch(data.type) {
            case 'chat':
              chat(data.message)
              break;
            case 'log':
              debug(data.message);
              break;
          }
        };
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