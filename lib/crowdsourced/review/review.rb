class Review
  attr_accessor :term, :review

  def initialize(term, review)
    @term = term
    @review = review
    @review_words = @review.split(" ")
  end

  def review?
    ['good', 'bad', 'favourite', 'favorite', 'hate'].each do |keyword|
      return true if @review_words.include? keyword
    end
    return false
  end

  def liked?
    ['good', 'favourite', 'favorite'].each do |keyword|
      return true if @review_words.include? keyword
    end
    return false
  end

  def to_s
    "[term=#{@term},review=#{@review}]"
  end
end
