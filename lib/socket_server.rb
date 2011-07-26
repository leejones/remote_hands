EventMachine.run do
  include OSX::Volume

  EM.add_periodic_timer(60) do
    CLIENTS.each do |s|
      s.send({ :type => 'osx', :volume => current_volume }.to_json)
    end    
  end

  Thread.new do
    redis = Redis.new(:host => '127.0.0.1', :post => 6379, :timeout => 0)
    # TODO: use hostname and/or make configurable
    EventMachine::WebSocket.start(:host => '0.0.0.0', :port => 8080) do |client|
      client.onopen do
        client.send({ :type => 'osx', :volume => current_volume }.to_json)
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
            
            set_volume(new_volume)        
        end
      end
    end
  end
end