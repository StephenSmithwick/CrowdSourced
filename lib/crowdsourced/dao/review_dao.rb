require 'mongo'

class ReviewDAO
  def saveAll term, messages, place
    db = Mongo::Connection.new("localhost").db("mydb")
    collTweets = db.collection("Tweets")

    messages.each do |message|
      puts  "saved id #{message[:id]} - " + place["_id"].to_s
      collTweets.insert({:text => message[:text],
                         :liked => message[:review].liked?,
                         :term => term,
                         :review => message[:review].review? ,
                         :suburb => message[:suburb]["_id"].to_s   ,
                         :_id => message[:id]   ,
                         :place => place["_id"].to_s,
                         :time_saved => time1 = Time.new
                        })
    end
  end

  def findAll
    db = Mongo::Connection.new("localhost").db("mydb")
    collTweets = db.collection("Tweets")
    return collTweets.find
  end

  def findReviewsForPlace place
    db = Mongo::Connection.new("localhost").db("mydb")
    collTweets = db.collection("Tweets")
    return collTweets.find(:place => place["_id"].to_s , :review => true)
  end

  def findReviewsForSuburb suburb
    db = Mongo::Connection.new("localhost").db("mydb")
    collTweets = db.collection("Tweets")
    return collTweets.find(:suburb => suburb["_id"].to_s , :review => true)
  end

  def saved? (id, term)
    db = Mongo::Connection.new("localhost").db("mydb")
    collTweets = db.collection("Tweets")
    collTweets.find_one(:_id => id, :term => term)
  end
end
