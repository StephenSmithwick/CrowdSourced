require_relative '../dao/review_dao'

class ReviewProcessor
  def processReviews messages
    @reviewDao = ReviewDAO.new() unless @reviewDao
    @reviewDao.saveAll messages
  end
end