require 'sinatra'
require 'mongo'
require 'twitter'

require_relative 'crowdsourced/twitter_feed'
require_relative 'crowdsourced/review/review_processor'
require_relative 'crowdsourced/dao/review_dao'

class Crowdsourced


  get '/' do
    @title = 'root'
    "Hello, World!"
  end

  get '/about' do
    @title = 'about'
    "A little about me"
  end

  get '/hello/:name' do

    @title = 'hello'
    "Hello there, #{params[:name]}."
  end

  get '/processTweetsSelectTerm' do
    @title = 'this is a form to select twitter'
    erb :form
  end


  post '/processTweets' do

    @twitterFeed = TwitterFeed.new() unless @twitterFeed

    @title = 'list of tweets that have been processed'

    @messages = @twitterFeed.find_tweets params[:term]

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

  not_found do
    halt 404, 'page not found'
  end

end