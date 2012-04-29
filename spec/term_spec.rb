require_relative '../lib/crowdsourced/term'

describe Term do

  before :each do
    @json = {
        "term"=>"ResMed",
        "lemma"=>"ResMed",
        "word"=>"ResMed",
        "POS"=>"NNP",
        "offset"=>0,
        "meanings"=>[
            {"definition"=>"a human being", "meaning"=>"person_n_01"},
            {"definition"=>"a point or extent in space", "meaning"=>"location_n_01"},
            {"definition"=>"a human being", "meaning"=>"person_n_01"}]}
    @term = Term.new @json
  end

  describe '#new' do
    it "builds a new Term from a parsed json object" do
      @term.should be_an_instance_of Term
      @term.term.should match "ResMed"
      @term.pos.should match "NNP"
      @term.offset.should == 0
      @term.meaning.should match "person_n_01"
      @term.definition.should match "a human being"
    end
  end
end
