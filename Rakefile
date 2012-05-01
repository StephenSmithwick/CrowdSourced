require 'mongo'

task :default => [:server]

task :play  do
  ruby "lib/crowdsourced_playground.rb"
end

task :server do
  ruby "lib/crowdsourced.rb"
end

task :mongod do
  exec "mongod --config conf/mongod.conf"
end

task :clean do
  db = Mongo::Connection.new("localhost").db("mydb")
  db.collection("Suburbs").drop
  db.collection("Cafes").drop
  db.collection("Tweets").drop
end

task :test do
  exec "rspec spec -c --format nested"
end
