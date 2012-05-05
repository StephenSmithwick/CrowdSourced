require_relative 'review_analyzer'
require_relative '../dao/review_dao'
require_relative '../dao/place_dao'
require_relative '../dao/suburbs_dao'
require_relative '../twitter/twitter_feed'


class ReviewProcessor


  def processAllReviews()

    messages = Array.new
    @suburbsDao = SuburbsDAO.new() unless @suburbsDao
    @placeDao = PlaceDao.new() unless @placeDao
    @suburbsDao.findAll.each  do |suburb|
        messages = messages + processAllReviewsForSuburb(suburb)
    end
    messages
    end


  def processAllReviewsForSuburb(suburb)

    @placeDao = PlaceDao.new() unless @placeDao
    messages = Array.new
    @placeDao.findBySuburb(suburb["id"]).each do |place|
      messages = messages + processAllReviewsForPlace(place,suburb)
    end
    messages
  end


  def processAllReviewsForPlace(place,suburb)
    searchterm = place["name"]

    @twitterFeed = TwitterFeed.new() unless @twitterFeed
    @messages = @twitterFeed.findTweets searchterm, suburb, "3km"

    processTextForReviews @messages, searchterm ,place
  end




  def processTextForReviews(messages, term,place)
    @reviewAnalyzer = ReviewAnalyzer.new() unless @reviewAnalyzer
    
    reviews = messages.map do |message|
      puts "text to process #{message[:text]}"
      message[:review] = @reviewAnalyzer.analyze(term, message[:text])
    end
    
    
    @reviewDao = ReviewDAO.new() unless @reviewDao
    @reviewDao.saveAll term,messages ,place
    messages
  end
end