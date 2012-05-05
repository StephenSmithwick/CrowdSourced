require 'mongo'
require 'bson'

class PlaceDao
  def save(suburbId, type , name, rating, lat, lon)
    db = Mongo::Connection.new("localhost").db("mydb")
    collPlace = db.collection("Place")
    collPlace.insert({
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
    collReviewable = db.collection("Place")
    return collReviewable.find
  end
  
  def findBySuburb(suburbId,type)
      db = Mongo::Connection.new("localhost").db("mydb")
      collPlace = db.collection("Place")
      return collPlace.find(:suburbId => suburbId , :type => type)
  end
  
  def findById(id)
      db = Mongo::Connection.new("localhost").db("mydb")
      collPlace = db.collection("Place")
      return collPlace.find_one(BSON::ObjectId.from_string(id))
  end
end
