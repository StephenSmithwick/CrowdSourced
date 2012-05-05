require 'mongo'

require_relative 'lib/crowdsourced/review/textual_analyzer'

task :default => [:server]

task :server do
  ruby "lib/crowdsourced.rb"
end

task :mongod do
  exec "mongod --config conf/mongod.conf"
end

task :clean do
  puts "Dropping Web database"
  db = Mongo::Connection.new("localhost").drop_database("mydb")
end

task :clean_db, [:db] do |t, args|
  puts "Dropping database: #{args.db}"
  db = Mongo::Connection.new("localhost").drop_database(args.db)
end

task :classify, [:db] do |t, args|
  text = ENV["text"]
  db = args.db

  analyzer = TextualAnalyzer.new db
  puts analyzer.classifications text
end

task :train , [:db,:tag] do |t, args|
  path = ENV['path']
  db = args.db
  tag = args.tag

  analyzer = TextualAnalyzer.new db
  if File::directory? path
    puts "Training for #{db}:#{tag} with dir: #{path}:"
    filenames = Dir.entries(path).select {|entry| !File::directory? entry }
    filenames.each do |filename|
      file = File.open("#{path}/#{filename}", "r")
      analyzer.train_all_file tag, file
      file.close
    end
  else
    puts "Training for #{db}:#{tag} with file: #{path}:"
    file = File.open(path, "r")
    analyzer.train_each_line tag, file
    file.close
  end
  puts
  puts "Done!"
end

task :test do
  exec "rspec spec -c --format nested"
end

task :help do
  puts "Usage: rake [server|mongod|clean|clean_db[]|classify[]|train[]|test]"
  puts "Command details:"
  puts "  server - default option, starts the synatra web application"
  puts "  mongod - start up mongod inline using the project configs"
  puts "  clean - cleans up the web app db"
  puts "Experimental Commands:"
  puts "  clean_db[:db_name] - drops a database of :db_name - useful when cleaning up after training"
  puts "  classify[:db_name] text=\":text\" - tries to classify a string of text given the training data setup in :db_name"
  puts "  train[:db_name,tag] path=\":path\" - trains the text analyzer pesristing to :db_name for the tag"
  puts "    :path = file      => treats all lines as a new dataset"
  puts "    :path = directory => treats all files as a new dataset"
end
