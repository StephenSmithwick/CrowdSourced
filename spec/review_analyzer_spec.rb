require_relative '../lib/crowdsourced/review/review_analyzer'
require 'rspec'

describe ReviewAnalyzer do
  before :all do
    @reviewAnalyzer = ReviewAnalyzer.new
  end

  describe '#analyze' do
    context 'with a non review' do
      it "should identify it as not a review" do
        analysis = @reviewAnalyzer.analyze "twitter", "Hello twitter"

        analysis.review?.should be_false
      end
    end

    context "with a review" do
      it "should identify it as a review" do
        [
            ["JuJu", "JuJu is my favorite"],
            ["JuJu", "JuJu is my favourite"],
            ["JuJu", "JuJu is good"],
            ["JuJu", "JuJu is bad"],
            ["JuJu", "I hate JuJu"]
        ].each do |item|
          result = @reviewAnalyzer.analyze item[0], item[1]
          result.review?.should be_true
        end
      end

      it "should identify it as a good review" do
        [
            ["JuJu", "JuJu is my favorite"],
            ["JuJu", "JuJu is my favourite"],
            ["JuJu", "JuJu is good"],
        ].each do |item|
          result = @reviewAnalyzer.analyze item[0], item[1]
          result.liked?.should be_true
        end
      end

      it "should identify it as a bad review" do
        [
            ["JuJu", "JuJu is bad"],
            ["JuJu", "I hate JuJu"]
        ].each do |item|
          result = @reviewAnalyzer.analyze item[0], item[1]
          result.liked?.should be_false
        end
      end
    end

  end
end
