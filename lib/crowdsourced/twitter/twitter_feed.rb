
require 'twitter'

class TwitterFeed

 def findTweets(term, lat, lon, radius)
   tweets = Array.new unless tweets
   Twitter.search(term, :rpp => 100, :result_type => "recent", :geocode => lat + "," + lon + "," + radius, :lang => "en").map do |tweet|
     tweets << {:id => "#{tweet.id}" , :text => "#{tweet.text}"}
   end
   tweets
 end

end