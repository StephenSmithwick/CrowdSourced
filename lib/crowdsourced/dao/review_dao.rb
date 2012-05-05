require 'mongo'

class ReviewDAO
  def saveAll term,messages
    db = Mongo::Connection.new("localhost").db("mydb")
    collTweets = db.collection("Tweets")
    messages.each do |message|
      collTweets.insert({:text => message[:text],
                         :liked => message[:review].liked?,
                         :term => term,
                         :review => message[:review].review?
                        });
    end
  end

  def findAll
    db = Mongo::Connection.new("localhost").db("mydb")
    collTweets = db.collection("Tweets")
    return collTweets.find
  end
end