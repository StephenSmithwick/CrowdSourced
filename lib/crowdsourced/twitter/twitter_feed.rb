
require 'twitter'
require_relative '../dao/review_dao'

class TwitterFeed

 def findTweets(term, suburb, radius)

   @reviewsDAO  || @reviewsDAO = ReviewDAO.new()

   searchterm = "\"#{term}\""
   tweets = Array.new unless tweets
   Twitter.search(searchterm, :rpp => 25, :result_type => "recent", :geocode => suburb["lat"] + "," + suburb["lon"] + "," + radius, :lang => "en").map do |tweet|

     tweets << {:id => "#{tweet.id}" , :text => "#{tweet.text}" , :suburb => suburb}  unless @reviewsDAO.saved? tweet.id,term
   end
   tweets
 end

end