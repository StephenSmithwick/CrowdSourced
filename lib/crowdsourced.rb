require 'sinatra'
require 'mongo'
require 'twitter'
require 'open-uri'
require 'json'

require_relative 'crowdsourced/twitter/twitter_feed'
require_relative 'crowdsourced/review/review_processor'
require_relative 'crowdsourced/place/place_processor'
require_relative 'crowdsourced/dao/review_dao'
require_relative 'crowdsourced/dao/suburbs_dao'
require_relative 'crowdsourced/dao/place_dao'
require_relative 'crowdsourced/place/place'

class Crowdsourced
  # Initialize the list of Suburbs and Cafes
  get '/init' do
    @title = 'Initialize CrowdSourced'
    "Initialize CrowdSourced"

    db = Mongo::Connection.new("localhost").db("mydb")
    db.collection("Suburbs").drop
    db.collection("Place").drop
    db.collection("Tweets").drop

    @reviewableProcessor = PlaceProcessor.new() unless @reviewableProcessor
    @reviewableProcessor.initializeReviewable
  end

  # Home page: Displays GMap and the list of cafes
  get '/' do
    @title = 'Reviews made by youse'

    @suburbsDao = SuburbsDAO.new() unless @suburbsDao
    @suburbs = @suburbsDao.findAll

    @placeDao = PlaceDao.new() unless @placeDao
    @cafes = @placeDao.findBySuburb(@suburbs.next()["id"], "cafe")

    erb :form
  end

  get '/processTweets/:placeId' do
    @title = 'list of tweets that have been processed'

    @placeDao = PlaceDao.new() unless @placeDao
    place = @placeDao.findById params[:placeId]
    searchterm = place["name"]

    @suburbsDao = SuburbsDAO.new() unless @suburbsDao
    suburb = @suburbsDao.findById place["suburbId"]

    @twitterFeed = TwitterFeed.new() unless @twitterFeed
    @messages = @twitterFeed.findTweets searchterm, suburb, "3km"

    @reviewProcessor = ReviewProcessor.new() unless @reviewProcessor
    @reviewProcessor.processReviews @messages, searchterm, place

    erb :resultsOfForm
  end


  get '/processAllTweetsInSuburb/:suburbName/forPlace/:placeName' do
    @title = 'process tweets by suburb and name'


    @placeDao = PlaceDao.new() unless @placeDao
    place = @placeDao.findByName params[:placeName]

    @suburbsDao = SuburbsDAO.new() unless @suburbsDao
    suburb = @suburbsDao.findByName(params[:suburbName])

    @reviewProcessor = ReviewProcessor.new() unless @reviewProcessor
    @messages = @reviewProcessor.processAllReviewsForPlace place, suburb

    erb :resultsOfForm
  end

  get '/processAllTweetsInSuburb/:suburbName' do
    @title = 'process tweets by suburb'

    @reviewProcessor = ReviewProcessor.new() unless @reviewProcessor
    @suburbsDao = SuburbsDAO.new() unless @suburbsDao
    @messages = @reviewProcessor.processAllReviewsForSuburb @suburbsDao.findByName(params[:suburbName])

    erb :resultsOfForm
  end

  get '/processAllTweets' do
    @title = 'list of tweets that have been processed'

    @reviewProcessor = ReviewProcessor.new() unless @reviewProcessor
    @messages = @reviewProcessor.processAllReviews()

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
    doc = {'message' => params[:message]}
    coll.insert(doc)
    search_string = params[:start]

    coll.find({:message => /^#{search_string}/}).each { |message|
      @messages << message }

    erb :resultsOfForm
  end

  # Returns a JSON list of Cafes for specified Suburb
  get '/places/:suburbId/:type' do
    @placeDao = PlaceDao.new() unless @placeDao
    places_hash = @placeDao.findBySuburb(params[:suburbId], params[:type])

    places = Place.init_all places_hash

    content_type 'application/json'

    places.to_json
  end

  # Returns Suburb in JSON form
  get '/suburb/:suburbId' do
    @suburbsDao = SuburbsDAO.new() unless @suburbsDao
    suburb = @suburbsDao.findById params[:suburbId]

    content_type 'application/json'
    suburb.to_json
  end

  # Returns a JSON list of reviews for a specified Cafe
  get '/place/reviews/:placeId' do
    @reviewDao = ReviewDAO.new() unless @reviewDao
    reviews = @reviewDao.findReviewsForPlace('_id' => params[:placeId])

    reviewsJson = Array.new
    reviews.each do |review|
      reviewsJson << {"text" => review["text"], "liked" => review["liked"]}
    end

    content_type 'application/json'
    reviewsJson.to_json
  end

  not_found do
    halt 404, 'page not found'
  end

end
