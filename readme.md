# Remote Hands

A Web Interface for Stuff on Your Mac

## Development

    bundle install
    
    # start Sinatra
    bundle exec shotgun --host [your hostname]
    
    # start the EventMachine loop
    bundle exec thin start -R socket-server-config.ru

    # websocket binds to your hostname (not localhost) by default

## Dependencies

* redis