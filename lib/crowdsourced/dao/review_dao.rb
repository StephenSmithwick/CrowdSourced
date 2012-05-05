require 'mongo'

class ReviewDAO
  def saveAll term,messages
    db = Mongo::Connection.new("localhost").db("mydb")
    collTweets = db.collection("Tweets")

    messages.each do |message|
      puts  "saved id #{message[:id]}"
      collTweets.insert({:text => message[:text],
                         :liked => message[:review].liked?,
                         :term => term,
                         :review => message[:review].review? ,
                         :suburb => message[:suburb]["id"]   ,
                         :_id => message[:id]
                        })
    end
  end

  def findAll
    db = Mongo::Connection.new("localhost").db("mydb")
    collTweets = db.collection("Tweets")
    return collTweets.find
  end

  def saved? id
    db = Mongo::Connection.new("localhost").db("mydb")
    collTweets = db.collection("Tweets")
    collTweets.find_one(_id:"#{id}")
  end
end