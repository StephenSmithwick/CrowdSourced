CrowdSourced
============

A location based crowd sourcing review server.

Project details
--------------------
Bringing the latest in computational linguistics to crowd source reviews from tweets in your area
(NoSql db, SpringSense, Ruby, possibly Sinatra)

Dev Environment
---------------
* Ruby 1.9.3
* Bundler
* Cassandra 1.1.0

Setup
-----
    $ bundle install
    $ rake setup_casandra

To Run
------
    $ rake run_casandra
    $ rake

Cassandra Setup
---------------

### In OSX 
    $ brew install cassandra

### In Linux
Download from http://mirror.overthewire.com.au/pub/apache/cassandra/1.1.0/apache-cassandra-1.1.0-bin.tar.gz
``` $ tar -zxvf apache-cassandra-1.1.0-bin.tar.gz
    $ cd apache-cassandra-1.1.0
    $ sudo mkdir -p /var/log/cassandra
    $ sudo chown -R $(whoami) /var/log/cassandra
    $ sudo mkdir -p /var/lib/cassandra
    $ sudo chown -R $(whoami) /var/lib/cassandra
    $ export PATH="${PATH}:$(pwd)/bin"
```
### Setup keyspace
    $ rake setup_cassandra

### Run Cassandra
    $ rake run_cassandra
