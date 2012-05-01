require 'mongo'

class ReviewDAO
  def saveAll reviews
    db = Mongo::Connection.new("localhost").db("mydb")
    collTweets = db.collection("Tweets")
    reviews.each do |review|
      collTweets.insert({:text => review.review, :liked => review.liked?});
    end
  end

  def findAll
    db = Mongo::Connection.new("localhost").db("mydb")
    collTweets = db.collection("Tweets")
    return collTweets.find
  end
end