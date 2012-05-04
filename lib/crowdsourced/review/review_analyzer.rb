require 'json'
require 'rest-client'

require_relative 'review'
require_relative 'term'

class ReviewAnalyzer
  SPRINGSENSE_URL = 'http://api.springsense.com/disambiguate'

  def analyze(keyword, message)
    Review.new keyword, message, fetchTerms(keyword, message)
  end

  private
  def fetchTerms(keyword, message)
    key_word = keyword.sub(' ', '_')
    response = JSON.parse(RestClient.post SPRINGSENSE_URL, message.sub(keyword, key_word))

    response && response.first['terms'].map do |term_json|
      Term.new term_json
    end
  end
end
