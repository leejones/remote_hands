EventMachine.run do
  Thread.new do
    redis = Redis.new(:host => '127.0.0.1', :post => 6379, :timeout => 0)
    # TODO: use hostname and/or make configurable
    EventMachine::WebSocket.start(:host => '0.0.0.0', :port => 8080) do |client|
      client.onopen do
        CLIENTS << client
        CLIENTS.each do |s|
          s.send({ :type => 'log', :message => "#{CLIENTS.length} client(s) connected" }.to_json)
        end
      end
      client.onmessage do |msg|
        redis.publish 'remote_hands:chat', msg
      end
      client.onclose do
        CLIENTS.delete client
        CLIENTS.each do |s|
          s.send({ :type => 'log', :message => "#{CLIENTS.length} client(s) connected" }.to_json)
        end
      end
    end
  end

  Thread.new do
    redis = Redis.new(:host => '127.0.0.1', :post => 6379, :timeout => 0)
    redis.subscribe('remote_hands:chat') do |on|
       # When a message is published to 'remote_hands'
      on.message do |chan, msg|
        # Send out the message on each open socket
        CLIENTS.each do |client|
          client.send({ :type => 'chat', :message => msg }.to_json)
        end
      end
    end
  end
end