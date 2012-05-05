require 'mongo'
require 'bson'

class ReviewableDao
  def save(suburbId, type , name, rating, lat, lon)
    db = Mongo::Connection.new("localhost").db("mydb")
    collReviewable = db.collection("Reviewable")
    collReviewable.insert({
              :suburbId => suburbId,
              :type => type,
              :name => name,
              :rating => rating,
              :lat => lat,
              :lon => lon
    });
  end
  
  def findAll
    db = Mongo::Connection.new("localhost").db("mydb")
    collReviewable = db.collection("Reviewable")
    return collReviewable.find
  end
  
  def findBySuburb(suburbId)
      db = Mongo::Connection.new("localhost").db("mydb")
      collReviewable = db.collection("Reviewable")
      return collReviewable.find(:suburbId => suburbId)
  end
  
  def findById(id)
      db = Mongo::Connection.new("localhost").db("mydb")
      collReviewable = db.collection("Reviewable")
      return collReviewable.find_one(BSON::ObjectId.from_string(id))
  end
end
