require 'mongo'

class CafesDAO
  def save(name, rating, lat, lon)
    db = Mongo::Connection.new("localhost").db("mydb")
    collCafes = db.collection("Cafes")
    collCafes.insert({
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
end
