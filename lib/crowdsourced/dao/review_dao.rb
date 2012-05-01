class ReviewDAO
  def saveAll messages
    db = Mongo::Connection.new("localhost").db("mydb")
    collTweets = db.collection("Tweets")
    messages.each do |message|
      collTweets.insert({:id => message[:id], :text => message[:text]});
    end
  end

  def findAll
    db = Mongo::Connection.new("localhost").db("mydb")
    collTweets = db.collection("Tweets")
    return collTweets.find
  end
end