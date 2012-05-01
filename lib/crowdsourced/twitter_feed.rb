
require 'twitter'

class TwitterFeed

 def find_tweets term
   tweets = Array.new unless tweets
   Twitter.search(term, :rpp => 10, :result_type => "recent", :geocode => "33.865866,151.206256,1km", :lang => "en").map do |tweet|
     tweets << {:id => "#{tweet.id}" , :text => "#{tweet.text}"}
   end
   tweets
 end

end