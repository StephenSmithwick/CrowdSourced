require 'rubygems'
require 'cassandra'
require 'twitter'
require 'open-uri'
require 'json'
require 'rest-client'
require_relative 'crowdsourced/has_properties'

# fetch data from springsense
# curl http://api.springsense.com/disambiguate --data-ascii "ResMed Announces EasyCare Online Compliance Management Solution"
class Term
  include HasProperties
  has_properties :term, :pos, :offset, :meaning, :definition

  def initialize args
    super
  end

  def to_s
    "[term: #{@term}, pos: #{@pos}, offset:#{@offset}, meaning: #{@meaning}, definition: #{@definition}]"
  end
end

sentence = 'ResMed Announces EasyCare Online Compliance Management Solution'
springsense_url = 'http://api.springsense.com/disambiguate'

response = JSON.parse(RestClient.post springsense_url, sentence)
terms = response && response.first['terms'].map do |term|
  meanings = term[meanings]
  meaning = meanings && ! meanings.empy? && meanings.first
  Term.new(:term => term['term'], :pos => term['POS'], :offset => term['offset'],
           :meaning => meaning && meaning['meaning'], :definition => meaning && meaning['definition'])
end
puts terms


# Retrieves and persits Tweeter feeds
def parse_tweets(store, city, geocode, term)
  Twitter.search(term, :rpp => 3, :result_type => "recent", :geocode => geocode, :lang => "en").map do |tweet|
    puts "#{tweet.from_user}: #{tweet.text}"
    store.insert(:Tweets, city, {"#{tweet.id}" => "#{tweet.text}"});
  end
end

# Connect to Cassandra
store = Cassandra.new('CrowdSourced');

# Get the list of cafes is Sydney from Google Places
url = 'https://maps.googleapis.com/maps/api/place/search/json?location=-33.8670522,151.1957362&radius=3000&types=cafe&sensor=false&key=AIzaSyC2pDpNpBWnlNYnBUX363XV5Aog4UdOjeg'
result = open(url) do |file|
  result = JSON.parse(file.read)
  result["results"].each do |location|
    # Get the list of Tweets for this cafe in Sydney
    puts location["name"]
    parse_tweets store, 'Sydney', '33.8670522,151.1957362,3km', location["name"]
  end
end

# Display store content
user = store.get(:Tweets, 'Sydney')
user.each do |field|
  puts field.inspect
end

# Clear store
store.remove(:Tweets, 'Sydney')


