require 'mongo'

class SuburbsDAO
  def initializeSuburbs
    db = Mongo::Connection.new("localhost").db("mydb")
    collSuburbs = db.collection("Suburbs")

    collSuburbs.insert({:id => "1", :name => "Circular Quay", :lat => "33.861741", :lon => "151.210579", :radius => "300"});
    collSuburbs.insert({:id => "2", :name => "Wynyard", :lat => "33.865866", :lon => "151.206256", :radius => "400"});
    collSuburbs.insert({:id => "3", :name => "The Rocks", :lat => "33.859549", :lon => "151.208605", :radius => "300"});
    collSuburbs.insert({:id => "4", :name => "Kirribilli", :lat => "33.847559", :lon => "151.213664", :radius => "300"});

    return collSuburbs.find
  end

  def findAll
    db = Mongo::Connection.new("localhost").db("mydb")
    collSuburbs = db.collection("Suburbs")
    return collSuburbs.find
  end
    
  def findById(id)
    db = Mongo::Connection.new("localhost").db("mydb")
    collSuburbs = db.collection("Suburbs")
    return collSuburbs.find_one(:id => id)
  end
end
