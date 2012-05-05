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
  
  def findBySuburb(suburbId,type=nil)
    db = Mongo::Connection.new("localhost").db("mydb")
    collPlace = db.collection("Place")
    if type
    return collPlace.find(:suburbId => suburbId , :type => type)
    else
      return collPlace.find(:suburbId => suburbId)
    end

  end

  
  def findById(id)
      db = Mongo::Connection.new("localhost").db("mydb")
      collPlace = db.collection("Place")
      return collPlace.find_one(BSON::ObjectId.from_string(id))
  end

  def findByName(name)
    db = Mongo::Connection.new("localhost").db("mydb")
    collPlace = db.collection("Place")
    return collPlace.find_one(:name => name)
  end
end
