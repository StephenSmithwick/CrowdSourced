require 'json'
require 'rest-client'

require_relative 'review'
require_relative 'term'

class ReviewAnalyzer
  def self.good_terms
    ['good', 'favorite_n_01', 'nice_n_01', 'great_n_01', 'spectacular_n_01',
     'love_n_01', 'tasty', 'awesome', 'impressed', 'good_n_02',
     'delicious', 'ideal_n_01', 'recommended']
  end

  def self.good_slang
    [':)', ':-)', 'fave', 'nom', 'wow']
  end

  def self.bad_terms
    ['bad', 'hate', 'average_n_01', 'pricey']
  end

  def self.review_terms
    @review_terms = @review_terms || good_terms + bad_terms
  end

  SPRINGSENSE_URL = 'http://api.springsense.com/disambiguate'

  def analyze(keyword, message)
    Review.new keyword, message, fetchTerms(keyword.downcase, message.downcase)
  end

  private
  def fetchTerms(keyword, message)
    cleaned_message = clean keyword, message
    begin
      disambiguate(cleaned_message)['terms'].map do |term_json|
        Term.new term_json
      end
    rescue
      undisambiguate(cleaned_message).map do |word|
        FakeTerm.new word
      end
    end
  end

  private
  def clean keyword, message
    key_word = keyword.gsub(' ', '_')
    with_keyword_tokenised = message.gsub(keyword, key_word)
    tokens = with_keyword_tokenised.split(/[\s.?!]+/)
    tokens_without_slang = tokens.map do |token|
      if ReviewAnalyzer.good_slang.include? token
        "good"
      else
        token
      end
    end

    tokens_without_slang.join(" ").gsub(/[().@!:?,\n|%]/, ' ').gsub(/\s+/, " ")
  end

  def disambiguate text
    response = JSON.parse(RestClient.post SPRINGSENSE_URL, text)
    response && response.first
  end

  def undisambiguate text
    text.split(" ")
  end
end
