# Retrieve all suburubs from store
def retrieve_suburubs(store)
  all_suburbs = Array.new
  suburb_ids = store.get_range_keys(:Suburbs, :key_count => 4);
  suburb_ids.each do |suburb_id|
    suburb = store.get(:Suburbs, suburb_id)
    all_suburbs.push(suburb)
  end
  return all_suburbs
end

# Retrieves and persits Tweeter feeds
def parse_tweets(store, city, geocode, term)
  puts "Getting Tweets for " + city + " -> " + term
  Twitter.search(term, :rpp => 3, :result_type => "recent", :geocode => geocode, :lang => "en").map do |tweet|
    store.insert(:Tweets, city, {"#{tweet.id}" => "#{tweet.text}"});
  end
end

# Retrieves and persits the cafes in a Suburb from Google Places
def update_cafes(store)
  suburbs = retrieve_suburubs store
  suburbs.each do |suburb|
    url = "https://maps.googleapis.com/maps/api/place/search/json?location=-" + suburb["lat"] + "," + suburb["lon"]  + "&radius=" + suburb["radius"]  + "&types=cafe&sensor=false&key=AIzaSyC2pDpNpBWnlNYnBUX363XV5Aog4UdOjeg"
      result = open(url) do |file|
        result = JSON.parse(file.read)
        result["results"].each do |location|
          # Save cafes
          store.insert(:Cafes, location["name"],
                  { "rating" => location["rating"].to_s, 
                    "lat" => location["geometry"]["location"]["lat"].to_s, 
                    "lon" => location["geometry"]["location"]["lng"].to_s });
          # Get the list of Tweets for this cafe in this Suburb
          parse_tweets store, suburb["name"], suburb["lat"] + "," + suburb["lon"] + ",3km", location["name"]
        end
      end
  end
end

# Display and delete stored tweets
def display_and_delete_tweets(store)
  suburbs = retrieve_suburubs store
  suburbs.each do |suburb|
    tweets = store.get(:Tweets, suburb["name"])
    tweets.each do |tweet|
      sentence = tweet[1]
      springsense_url = 'http://api.springsense.com/disambiguate'
      response = JSON.parse(RestClient.post springsense_url, sentence)
      terms = response && response.first['terms'].map do |term_json|
        Term.new term_json
      end
      puts sentence
      puts terms
    end

    store.remove(:Tweets, suburb["name"])
  end
end
