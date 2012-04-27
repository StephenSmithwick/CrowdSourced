CrowdSourced
============

A location based crowd sourcing review server.

**Project details:**
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
$ `bundle install`

Cassandra Setup
---------------
Download from http://mirror.overthewire.com.au/pub/apache/cassandra/1.1.0/apache-cassandra-1.1.0-bin.tar.gz
tar -zxvf apache-cassandra-1.1.0-bin.tar.gz
cd apache-cassandra-1.1.0

sudo mkdir -p /var/log/cassandra
sudo chown -R `whoami` /var/log/cassandra
sudo mkdir -p /var/lib/cassandra
sudo chown -R `whoami` /var/lib/cassandra

Start Cassandra:
bin/cassandra -f

Create Cassandra keyspace:
bin/cassandra-cli -h localhost < CrowdSourced/store/store.rb
