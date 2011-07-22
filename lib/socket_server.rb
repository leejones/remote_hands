EventMachine.run do
  Thread.new do
    redis = Redis.new(:host => '127.0.0.1', :post => 6379, :timeout => 0)
    # TODO: use hostname and/or make configurable
    EventMachine::WebSocket.start(:host => '0.0.0.0', :port => 8080) do |client|
      client.onopen do
        client.send "[server] You are connected."
        CLIENTS.each do |s|
          s.send "[server] 1 new client connected :).  #{CLIENTS.length} client(s) connected"
        end
        CLIENTS << client
      end
      client.onmessage do |msg|
        redis.publish 'remote_hands', msg
      end
      client.onclose do
        CLIENTS.delete client
        CLIENTS.each do |s|
          s.send "[server] 1 client disconnected :(.  #{CLIENTS.length} client(s) connected"
        end
      end
    end
  end

  Thread.new do
    redis = Redis.new(:host => '127.0.0.1', :post => 6379, :timeout => 0)
    redis.subscribe('remote_hands') do |on|
       # When a message is published to 'remote_hands'
       on.message do |chan, msg|
        # Send out the message on each open socket
        CLIENTS.each { |s| s.send "[client] #{msg}" }
       end
     end
   end
end