require 'rubygems'
require 'cassandra'
require 'twitter'
require 'open-uri'
require 'json'
require 'rest-client'
require 'extensions/all'

require_relative 'crowdsourced/term'
require_relative 'crowdsourced/google_places'

# fetch data from springsense
# curl http://api.springsense.com/disambiguate --data-ascii "ResMed Announces EasyCare Online Compliance Management Solution"

sentence = 'I love you Central Baking Depot'
springsense_url = 'http://api.springsense.com/disambiguate'

response = JSON.parse(RestClient.post springsense_url, sentence)
terms = response && response.first['terms'].map do |term_json|
  Term.new term_json
end
puts terms

# Connect to Cassandra
store = Cassandra.new('CrowdSourced');

# Insert Suburbs
store.insert(:Suburbs, '1', {"name" => "Circular Quay", "lat" => "33.861741", "lon" => "151.210579", "radius" => "300"});
store.insert(:Suburbs, '2', {"name" => "Wynyard", "lat" => "33.865866", "lon" => "151.206256", "radius" => "400"});
store.insert(:Suburbs, '3', {"name" => "The Rocks", "lat" => "33.859549", "lon" => "151.208605", "radius" => "300"});
store.insert(:Suburbs, '4', {"name" => "Kirribilli", "lat" => "33.847559", "lon" => "151.213664", "radius" => "300"});

# Update the list of Cafes
update_cafes store

# Display stored tweets
display_and_delete_tweets store
