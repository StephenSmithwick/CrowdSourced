class ReviewProcessor
  def processReviews messages
    @reviewDao = ReviewDAO.new() unless @reviewDao
    @reviewDao.saveAll messages
  end
end