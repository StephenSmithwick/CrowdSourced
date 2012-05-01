require_relative 'review_analyzer'
require_relative '../dao/review_dao'

class ReviewProcessor
  def processReviews(messages, term)
    @reviewAnalyzer = ReviewAnalyzer.new() unless @reviewAnalyzer
    
    reviews = messages.map do |message|
      @reviewAnalyzer.analyze term, message[:text]
    end
    
    
    @reviewDao = ReviewDAO.new() unless @reviewDao
    @reviewDao.saveAll reviews.select {|review| review.review? }
  end
end