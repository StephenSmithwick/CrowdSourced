require 'rubygems'
require 'twitter'
require 'open-uri'
require 'json'
require 'rest-client'
require 'mongo'

require_relative 'crowdsourced/term'
require_relative 'crowdsourced/google_places'

sentence = "G'Morning Friday, have a G'Day ja  @ Amazon Cafe' PTT"
springsense_url = 'http://api.springsense.com/disambiguate'
response = JSON.parse(RestClient.post springsense_url, sentence)
terms = response && response.first['terms'].map do |term_json|
  Term.new term_json
end
puts terms

# Connect to MongoDB
db = Mongo::Connection.new("localhost").db("mydb")

# Insert Suburbs
collSuburbs = db.collection("Suburbs")
collSuburbs.insert({"name" => "Circular Quay", "lat" => "33.861741", "lon" => "151.210579", "radius" => "300"});
#store.insert(:Suburbs, '2', {"name" => "Wynyard", "lat" => "33.865866", "lon" => "151.206256", "radius" => "400"});
#store.insert(:Suburbs, '3', {"name" => "The Rocks", "lat" => "33.859549", "lon" => "151.208605", "radius" => "300"});
#store.insert(:Suburbs, '4', {"name" => "Kirribilli", "lat" => "33.847559", "lon" => "151.213664", "radius" => "300"});

# Update the list of Cafes
update_cafes db

# Display stored tweets
display_and_delete_tweets db

# Remove Suburbs
collSuburbs.remove("name" => "Circular Quay")
#store.remove(:Suburbs, '2')
#store.remove(:Suburbs, '3')
#store.remove(:Suburbs, '4')
