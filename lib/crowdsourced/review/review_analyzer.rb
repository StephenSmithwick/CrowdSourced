require_relative 'review'

class ReviewAnalyzer
  def analyze(term, message)
    Review.new term, message
  end
end
