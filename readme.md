# Remote Hands

A Web Interface for Stuff on Your Mac

## Development

    bundle install
    
    # start Sinatra
    bundle exec shotgun
    
    # start the EventMachine loop
    bundle exec thin start -R socket-server-config.ru

    # app binds to your hostname (not localhost) by default

## Dependencies

* redis