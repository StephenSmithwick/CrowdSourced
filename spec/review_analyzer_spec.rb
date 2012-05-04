require_relative '../lib/crowdsourced/review/review_analyzer'
require_relative '../lib/crowdsourced/has_properties'
require 'rspec'

describe ReviewAnalyzer do
  before :all do
    @do = ReviewAnalyzer.new
  end

  def analyze(keyword, message)
    @do.analyze keyword, message
  end

  describe '#analyze' do
    it "should identify non reviews" do
      analysis = analyze "twitter", "Hello twitter"

      analysis.review?.should be_false
    end

    context "with a review" do
      it "should identify reviews" do
        analyze("JuJu", "JuJu is my favorite").should be_a_review
        analyze("JuJu", "JuJu is my favourite").should be_a_review
        analyze("JuJu", "JuJu is good").should be_a_review
        analyze("JuJu", "nice food").should be_a_review
        analyze("JuJu", "spectacular views,great food,love coming.").should be_a_review
        analyze("JuJu", "Great food and atmosphere.").should be_a_review
        analyze("JuJu", "Amazing views and tasty food.").should be_a_review
        analyze("JuJu", "WOW!").should be_a_review
        analyze("JuJu", "fantastic coffee great service ill deffinetely be back").should be_a_review
        analyze("JuJu", "Awesome food & having very fast service").should be_a_review
        analyze("JuJu", "Great views, well presented, tasty food").should be_a_review
        analyze("JuJu", "Really impressed with the coffee, jugs of water, pastries and general concept of this place, especially given that it's right in the middle of touristville").should be_a_review
        analyze("JuJu", "JuJu is bad").should be_a_review
        analyze("JuJu", "I hate JuJu").should be_a_review
        analyze("JuJu", "food is under average").should be_a_review
        analyze("JuJu", "Food was in the pricey side").should be_a_review
        analyze("JuJu", "Found it pretentious and impersonal with very average service").should be_a_review
      end

      it "should identify positive reviews" do
        analyze("JuJu", "JuJu is my favorite").should be_liked
        analyze("JuJu", "JuJu is my favourite").should be_liked
        analyze("JuJu", "JuJu is good").should be_liked
        analyze("JuJu", "nice food").should be_liked
        analyze("JuJu", "spectacular views,great food,love coming.").should be_liked
        analyze("JuJu", "Great food and atmosphere.").should be_liked
        analyze("JuJu", "Amazing views and tasty food.").should be_liked
        analyze("JuJu", "WOW!").should be_liked
        analyze("JuJu", "fantastic coffee great service ill deffinetely be back").should be_liked
        analyze("JuJu", "Awesome food & having very fast service").should be_liked
        analyze("JuJu", "Great views, well presented, tasty food").should be_liked
        analyze("JuJu", "Really impressed with the coffee, jugs of water, pastries and general concept of this place, especially given that it's right in the middle of touristville").should be_liked
      end

      it "should identify negative reviews" do
        analyze("JuJu", "JuJu is bad").should_not be_liked
        analyze("JuJu", "I hate JuJu").should_not be_liked
        analyze("JuJu", "food is under average").should_not be_liked
        analyze("JuJu", "Food was in the pricey side").should_not be_liked
        analyze("JuJu", "Found it pretentious and impersonal with very average service").should_not be_liked
      end
    end
  end
end
