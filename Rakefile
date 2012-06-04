require 'mongo'
require 'json'
require 'open-uri'

require_relative 'dao/review/textual_analyzer'
require_relative 'dao/review/review_analyzer'
require_relative 'dao/review/review_processor'
require_relative 'dao/place/place_processor'
require_relative 'dao/place_dao'
require_relative 'dao/suburbs_dao'
require_relative 'dao/twitter/twitter_feed'

def mongoDb
  Mongo::Connection.new("localhost")
end

def load_place(id, name)
  if id
    return PlaceDao.new.findById id
  elsif name
    return PlaceDao.new.findByName name
  end
end

def load_suburb(id, name, place)
  id = id || place && place["suburbId"]
  if id
    return SuburbsDAO.new.findById id
  elsif name
    return SuburbsDAO.new.findByName name
  end
end

task :default => [:server]

task :server do
  exec 'padrino start'
end

task :mongod do
  exec "mongod --config config/mongod.conf"
end

task :clean do
  puts "Dropping Web database"
  mongoDb.drop_database("mydb")
end

task :seed => :clean do
  puts "Initializing CrowdSourced"

  @reviewableProcessor = PlaceProcessor.new() unless @reviewableProcessor
  @reviewableProcessor.initializeReviewable
end

task :process_tweets do
  place = load_place ENV['place_id'], ENV['place']
  suburb = load_suburb ENV['suburb_id'], ENV['suburb'], place

  if place && suburb
    ReviewProcessor.new.processAllReviewsForPlace place, suburb
  elsif suburb
    ReviewProcessor.new.processAllReviewsForSuburb suburb
  else
    ReviewProcessor.new.processAllReviews
  end
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
  puts "Usage: rake [server|mongod|clean|clean_db[ ]|classify[ ]|train[ ]|test|process_tweets|seed]"
  puts "Command details:"
  puts "  server - default option, starts the synatra web application"
  puts "  mongod - start up mongod inline using the project configs"
  puts "  clean - cleans up the web app db"
  puts "  seed - cleans and populates database"
  puts "  process_tweets - look for tweets giving for a:"
  puts "         place - using place_id=? or place=?"
  puts "         all places in a suburb - using suburb_id=? or suburb=?"
  puts "         all known places - giving no options"
  puts "Experimental Commands:"
  puts "  clean_db[:db_name] - drops a database of :db_name - useful when cleaning up after training"
  puts "  classify[:db_name] text=\":text\" - tries to classify a string of text given the training data setup in :db_name"
  puts "  train[:db_name,:tag] path=\":path\" - trains the text analyzer pesristing to :db_name for the :tag"
  puts "    if :path is a file      => treats all lines as a new dataset"
  puts "    if :path is a directory => treats all files as a new dataset"
  puts ""
end
