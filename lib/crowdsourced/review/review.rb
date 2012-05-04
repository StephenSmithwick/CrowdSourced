class Review
  attr_accessor :subject, :review

  $good_terms = ['good','favorite_n_01','nice_n_01','great_n_01','spectacular_n_01',
                 'love_n_01', 'tasty','wow','awesome','great_n_01','impressed']
  $bad_terms = ['bad', 'hate','average_n_01','pricey']
  $review_terms = $good_terms + $bad_terms

  def initialize(subject, review, terms)
    @subject = subject
    @review = review

    @terms = terms
    @meanings = terms.map {|term| (term.meaning || term.term).downcase }

    puts "#{self}"
  end

  def review?
    $review_terms.each do |term|
      return true if @meanings.include? term
    end
    return false
  end

  def liked?
    $good_terms.each do |keyword|
      return true if @meanings.include? keyword
    end
    return false
  end

  def to_s
    if review?
      outcome = liked? ? ":-)" : ":-("
    else
      outcome = ":-|"
    end

    "(#{@review}) => #{@meanings} => #{outcome}"
  end
end
