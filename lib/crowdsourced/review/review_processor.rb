require_relative 'review_analyzer'
require_relative '../dao/review_dao'

class ReviewProcessor
  def processReviews(messages, term, place)
    @reviewAnalyzer = ReviewAnalyzer.new() unless @reviewAnalyzer
    
    reviews = messages.map do |message|
      puts "text to process #{message[:text]}"
      message[:review] = @reviewAnalyzer.analyze(term, message[:text])
    end
    
    
    @reviewDao = ReviewDAO.new() unless @reviewDao
    @reviewDao.saveAll term, messages, place
  end
end