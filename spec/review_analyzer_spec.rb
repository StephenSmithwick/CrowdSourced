require_relative '../lib/crowdsourced/review/review_analyzer'
require_relative '../lib/crowdsourced/has_properties'
require 'rspec'

describe ReviewAnalyzer do
  before :all do
    @analyzer = ReviewAnalyzer.new
  end

  describe '#analyze' do
    it "should identify non reviews" do
      analysis = @analyzer.analyze "twitter", "Hello twitter"

      analysis.review?.should be_false
    end

    context "with a review" do
      it "should identify reviews" do
        @analyzer.analyze("JuJu", "JuJu is my favorite").should be_a_review
        @analyzer.analyze("JuJu", "JuJu is my favourite").should be_a_review
        @analyzer.analyze("JuJu", "JuJu is bad").should be_a_review
        @analyzer.analyze("JuJu", "JuJu is bad").should be_a_review
        @analyzer.analyze("JuJu", "I hate JuJu").should be_a_review
      end

      it "should identify positive reviews" do
        @analyzer.analyze("JuJu", "JuJu is my favorite").should be_liked
        @analyzer.analyze("JuJu", "JuJu is my favourite").should be_liked
        @analyzer.analyze("JuJu", "JuJu is good").should be_liked
      end

      it "should identify negative reviews" do
        @analyzer.analyze("JuJu", "JuJu is bad").should_not be_liked
        @analyzer.analyze("JuJu", "I hate JuJu").should_not be_liked
      end
    end
  end
end
