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
    redis.subscribe('remote_hands_osx') do |on|
       # When a message is published to 'remote_hands'
      on.message do |channel, raw_message|
        # Send out the message on each open socket
        data = JSON.parse(raw_message)
        case channel
          when /remote_hands_osx/
            puts data.inspect
            new_volume = data['volume']
            EM.defer do
              set_volume(new_volume)
            end

            EM.defer do
              client_message = { :type => 'osx', :volume => new_volume }.to_json
              CLIENTS.each do |s|
                s.send(client_message)
              end
            end
        end
        puts 'done with case'
      end
    end
  end
end