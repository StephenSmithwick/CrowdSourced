require 'sinatra'
require 'mongo'
require 'twitter'
require 'open-uri'
require 'json'

require_relative 'crowdsourced/twitter/twitter_feed'
require_relative 'crowdsourced/review/review_processor'
require_relative 'crowdsourced/cafe/cafe_processor'
require_relative 'crowdsourced/dao/review_dao'
require_relative 'crowdsourced/dao/suburbs_dao'
require_relative 'crowdsourced/dao/cafes_dao'

class Crowdsourced


  get '/' do
    @title = 'root'
    "Hello, World!"
  end

  get '/about' do
    @title = 'about'
    "A little about me"
  end
  
  get '/init' do
      @title = 'Initialize CrowdSourced'
      "Initialize CrowdSourced"
      
      db = Mongo::Connection.new("localhost").db("mydb")
      db.collection("Suburbs").drop
      db.collection("Cafes").drop
      db.collection("Tweets").drop
      
      @cafeProcessor = CafeProcessor.new() unless @cafeProcessor
      @cafeProcessor.initializeCafes
  end

  get '/hello/:name' do
    @title = 'hello'
    "Hello there, #{params[:name]}."
  end

  get '/processTweetsSelectTerm' do
    @title = 'this is a form to select twitter'
    
    @suburbsDao = SuburbsDAO.new() unless @suburbsDao
    @suburbs = @suburbsDao.findAll
    
    @cafesDao = CafesDAO.new() unless @cafesDao
    @cafes = @cafesDao.findBySuburb(@suburbs.next()["id"])
    
    erb :form
  end


  post '/processTweets' do
    @title = 'list of tweets that have been processed'
    
    @suburbsDao = SuburbsDAO.new() unless @suburbsDao
    suburb = @suburbsDao.findById params[:suburbId]
    
    @twitterFeed = TwitterFeed.new() unless @twitterFeed
    @messages = @twitterFeed.findTweets params[:cafeName] + " " + params[:term], suburb["lat"], suburb["lon"], "3km"

    @reviewProcessor = ReviewProcessor.new() unless @reviewProcessor
    @reviewProcessor.processReviews @messages, params[:term]

    erb :resultsOfForm
  end

  get '/getReviews' do
    @title = 'list of reviews'

    @reviewsDAO = ReviewDAO.new() unless @reviewsDAO
    @reviews = @reviewsDAO.findAll
    erb :reviews
  end


  post '/form' do
    @messages = Array.new unless @messages
    @title = 'result of form'
    db = Mongo::Connection.new.db("mydb")
    coll = db.collection("testCollection")
    doc = { 'message' => params[:message]}
    coll.insert(doc)
    search_string = params[:start]

    coll.find( {:message => /^#{search_string}/}).each {|message|
       @messages << message}

    erb :resultsOfForm
  end
  
  get '/cafes/:suburbId' do
    @cafesDao = CafesDAO.new() unless @cafesDao
    cafes = @cafesDao.findBySuburb("#{params[:suburbId]}")
    cafesJson = Array.new
    cafes.each do |cafe|
      cafesJson << {"name" => cafe["name"]}
    end
    content_type 'application/json'
    cafesJson.to_json
  end

  not_found do
    halt 404, 'page not found'
  end

end