require 'mongo'

class CafesDAO
  def save(suburbId, name, rating, lat, lon)
    db = Mongo::Connection.new("localhost").db("mydb")
    collCafes = db.collection("Cafes")
    collCafes.insert({
              :suburbId => suburbId,
              :name => name,
              :rating => rating, 
              :lat => lat, 
              :lon => lon
    });
  end
  
  def findAll
    db = Mongo::Connection.new("localhost").db("mydb")
    collCafes = db.collection("Cafes")
    return collCafes.find
  end
  
  def findBySuburb(suburbId)
      db = Mongo::Connection.new("localhost").db("mydb")
      collCafes = db.collection("Cafes")
      return collCafes.find(:suburbId => suburbId)
    end
end
