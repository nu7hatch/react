# React

React is a simple application that allows for remote execution of commands.
It uses Redis as a queue - it is blocking specified list and waits for new 
entries - when an entry appears, then it is executing recognized command.

## Inspiration

It's inspired by Simon Willson's example of "Queue-activated shell scripts"
in his redis-tutorial:

    while [ 1 ] do
      redis-cli blpop restart-httpd 0
      apache2ctl graceful
    done

## Examples

Firs you have to prepare file with available commands. It can look like this: 

    # my_commands.yml
    restart_httpd: |
      apache2ctl graceful
    restart_mysql: |
      /etc/init.d/mysql restart
    reboot: |
      reboot
   
And now you can start consumer. 

    react my_commands.yml

## Commands

While your consumer is working, you can push any of specified command to it's 
queue (default queue name is `queue`), eg:

    redis-cli lpush queue restart_httpd
    redis-cli lpush queue reboot

## Configuration
  
There are few more runtime options, which can be useful for you. 

* you can specify queue wihch will be consumed:

    react my_commands.yml --queue "my:queue:name"

* you can specify the database to which consumer should connect:

    react my_commands.yml --host "yourhost.com" --port 6379 --db 2

* and finally, you can demonize the consumer:

    react my_commands.yml --daemonize

## Links

* [My website](http://nu7hatch.com/)
* [Simon Wilson's Redis tutorial](http://simonwillison.net/static/2010/redis-tutorial/)

## Note on Patches/Pull Requests
 
* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

## Copyright

Copyright (c) 2010 Kriss Kowalik. See LICENSE for details.    
