require_relative 'has_properties'

class Term
  include HasProperties

  has_properties :term, :pos, :offset, :meaning, :definition

  def initialize(term_json)
    meanings = term_json["meanings"]
    meaning = meanings && ! meanings.empty? && meanings.first
    super(
        :term => term_json['term'],
        :pos => term_json['POS'],
        :offset => term_json['offset'],
        :meaning => meaning && meaning['meaning'],
        :definition => meaning && meaning['definition'])
  end

  def to_s
    "[term: #{@term}, pos: #{@pos}, offset:#{@offset}, meaning: #{@meaning}, definition: #{@definition}]"
  end
end
