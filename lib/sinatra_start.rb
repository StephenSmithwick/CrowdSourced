require 'sinatra'
require 'mongo'

class SinatraStart


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

  get '/form' do

    @title = 'input of form'
    erb :form
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