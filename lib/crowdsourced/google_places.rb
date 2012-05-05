# Retrieve all suburubs from store
def retrieve_suburubs(db)
  collSuburbs = db.collection("Suburbs")
  return collSuburbs.find()
end

# Retrieves and persits Tweeter feeds
def parse_tweets(db, city, geocode, term)
  puts "Getting Tweets for " + city + " -> " + term
  collTweets = db.collection("Tweets")
  Twitter.search(term, :rpp => 3, :result_type => "recent", :geocode => geocode, :lang => "en").map do |tweet|
    collTweets.insert({"suburb" => city, "id" => "#{tweet.id}", "text" => "#{tweet.text}"});
  end
end

# Retrieves and persits the cafes in a Suburb from Google Places
def update_cafes(db)
  suburbs = retrieve_suburubs db
  suburbs.each do |suburb|
    url = "https://maps.googleapis.com/maps/api/place/search/json?location=-" + suburb["lat"] + "," + suburb["lon"]  + "&radius=" + suburb["radius"]  + "&types=place&sensor=false&key=AIzaSyC2pDpNpBWnlNYnBUX363XV5Aog4UdOjeg"
      result = open(url) do |file|
        result = JSON.parse(file.read)
        result["results"].each do |location|
          # Save cafes
          collCafes = db.collection("Cafes")
          collCafes.insert({
                    "name" => location["name"],
                    "rating" => location["rating"].to_s, 
                    "lat" => location["geometry"]["location"]["lat"].to_s, 
                    "lon" => location["geometry"]["location"]["lng"].to_s
          });
          # Get the list of Tweets for this place in this Suburb
          parse_tweets db, suburb["name"], suburb["lat"] + "," + suburb["lon"] + ",3km", location["name"]
        end
      end
  end
end

# Display and delete stored tweets
def display_and_delete_tweets(db)
  collTweets = db.collection("Tweets")
  
  suburbs = retrieve_suburubs db
  suburbs.each do |suburb|
    tweets = collTweets.find("suburb" => suburb["name"])
    tweets.each do |tweet|
      sentence = tweet["text"]
      springsense_url = 'http://api.springsense.com/disambiguate'
      response = JSON.parse(RestClient.post springsense_url, sentence)
      terms = response && response.first['terms'].map do |term_json|
        Term.new term_json
      end
      puts sentence
      puts terms
    end

  collTweets.remove("suburb" => suburb["name"])
  end
end
