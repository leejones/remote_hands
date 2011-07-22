EventMachine.run do
  Thread.new do
    redis = Redis.new(:host => '127.0.0.1', :post => 6379, :timeout => 0)
    EventMachine::WebSocket.start(:host => '0.0.0.0', :port => 8080) do |client|
      client.onopen do
        CLIENTS << client
        client.send "hello!"
      end
      client.onmessage do |msg|
        redis.publish 'remote_hands', msg
      end
      client.onclose { CLIENTS.each {|s| s.send "#{client} is closing :(" }; CLIENTS.delete client}
    end
  end

  Thread.new do
    redis = Redis.new(:host => '127.0.0.1', :post => 6379, :timeout => 0)
    redis.subscribe('remote_hands') do |on|
       # When a message is published to 'remote_hands'
       on.message do |chan, msg|
        # Send out the message on each open socket
        CLIENTS.each {|s| s.send "From Redis: #{msg}"} 
       end
     end
   end
end