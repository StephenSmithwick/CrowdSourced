require_relative 'review_analyzer'

class Review
  attr_accessor :subject, :review

  def initialize(subject, review, terms)
    @subject = subject
    @review = review

    @terms = terms
    @meanings = terms.map {|term| (term.meaning || term.term).downcase }

    puts "#{self}"
  end

  def review?
    ReviewAnalyzer.review_terms.each do |term|
      return true if @meanings.include? term
    end
    return false
  end

  def liked?
    ReviewAnalyzer.good_terms.each do |keyword|
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
