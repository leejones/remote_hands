# Remote Hands

A Web Interface for Stuff on Your Mac

## Development

    bundle install
    
    # start Sinatra
    bundle exec shotgun
    
    # start the EventMachine loop
    bundle exec thin start -R socket-server-config.ru

## Dependencies

* redis