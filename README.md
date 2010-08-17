# React

React is a simple application that allows for remote execution of commands, 
and it uses Redis as a queue.

## Inspiration

It's inspired by Simon Willison's example of "Queue-activated shell scripts"
in his [redis tutorial](http://simonwillison.net/static/2010/redis-tutorial/):

    while [ 1 ] do
      redis-cli blpop restart-httpd 0
      apache2ctl graceful
    done

## Installation

You can simply install React using rubygems:

    sudo gem install react

## Usage

Firs you have to prepare file with available commands. It can look like this: 

    # my_commands.yml
    restart_httpd: |
      apache2ctl graceful
    restart_mysql: |
      /etc/init.d/mysql restart
    reboot: |
      reboot
   
And now you can start a consumer. 

    react my_commands.yml

## Pushing commands

While your consumer is working, you can push any of specified command to  
queue (default queue name is `queue`), eg:

    redis-cli lpush queue restart_httpd
    redis-cli lpush queue reboot

After that consumer will pick up enqueued command names from and execute 
related commands. 

## Configuration
  
There are few more runtime options, which can be useful for you. 

* you can specify queue which will be consumed:

      react my_commands.yml --queue "my:queue:name"

* you can specify the database to which consumer should connect:

      react my_commands.yml --host "yourhost.com" --port 6379 --db 2 --password pass

* and finally, you can demonize the consumer:

      react my_commands.yml --daemon
      
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
