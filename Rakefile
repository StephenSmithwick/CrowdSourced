require 'mongo'

require_relative 'lib/crowdsourced/review/textual_analyzer'

task :default => [:server]

task :play do
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
