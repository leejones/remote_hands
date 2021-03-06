EventMachine.run do
  EM.add_periodic_timer(60) do
    client_messages = [
      { :type => 'osx', :volume => OSX::Volume.volume }.to_json
    ]
    CLIENTS.each do |s|
      client_messages.each {|message| s.send(message)}
    end    
  end

  Thread.new do
    redis = Redis.new(:host => '127.0.0.1', :post => 6379, :timeout => 0)
    # TODO: use hostname and/or make configurable
    EventMachine::WebSocket.start(:host => WEBSOCKETS_CONFIG[:host], :port => WEBSOCKETS_CONFIG[:port]) do |client|
      client.onopen do
        client.send({ :type => 'osx', :volume => OSX::Volume.volume }.to_json)
        CLIENTS << client
        client_message = { :type => 'status', :number_of_clients_connected => CLIENTS.length }.to_json
        CLIENTS.each do |s|
          s.send(client_message)
        end
      end
      client.onmessage do |message|
        data = JSON.parse(message)
        case data['type']
        when /osx/
          redis.publish 'remote_hands:osx', {:volume => data['volume']}.to_json
        end
      end
      client.onclose do
        CLIENTS.delete client
        client_message = { :type => 'status', :number_of_clients_connected => CLIENTS.length }.to_json
        CLIENTS.each do |s|
          s.send(client_message)
        end
      end
    end
  end

  Thread.new do
    redis = Redis.new(:host => '127.0.0.1', :post => 6379, :timeout => 0)
    redis.psubscribe('remote_hands:*') do |on|
       # When a message is published to 'remote_hands'
      on.pmessage do |pattern, channel, message|
        # Send out the message on each open socket
        data = JSON.parse(message)
        case channel
          when /remote_hands:osx/
            new_volume = data['volume']

            client_message = { :type => 'osx', :volume => new_volume }.to_json
            CLIENTS.each do |s|
              s.send(client_message)
            end
            
            OSX::Volume.volume = new_volume
        end
      end
    end
  end
end