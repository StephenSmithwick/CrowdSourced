require 'sinatra'
require 'mongo'
require 'twitter'

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

  get '/currentTweetsSelectTerm' do
    @title = 'this is a form'
    erb :form
  end


  post '/currentTweets' do

    @title = 'list of tweets'

    puts "Getting Tweets for   #{params[:term]}"

    @messages = Array.new unless @messages
    Twitter.search(params[:term], :rpp => 3, :result_type => "recent", :geocode => "33.865866,151.206256,3km", :lang => "en").map do |tweet|
      @messages << {:id => "#{tweet.id}" , :text => "#{tweet.text}"}
    end
    erb :resultsOfForm
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