require_relative '../lib/crowdsourced/review/review_analyzer'
require_relative '../lib/crowdsourced/has_properties'
require 'rspec'

describe ReviewAnalyzer do
  before :all do
    @reviewAnalyzer = ReviewAnalyzer.new
  end

  describe '#analyze' do
    it "should identify non reviews" do
      analysis = @reviewAnalyzer.analyze "twitter", "Hello twitter"

      analysis.review?.should be_false
    end

    context "with a review" do
      it "should identify a positive review" do
        [
            q(:term => "JuJu", :msg => "JuJu is my favorite"),
            q(:term => "JuJu", :msg => "JuJu is my favourite"),
            q(:term => "JuJu", :msg => "JuJu is good")
        ].each do |q|
          result = @reviewAnalyzer.analyze q.term, q.msg

          result.review?.should be_true, "not identified as a review"
          result.liked?.should be_true, "is not liked"
        end
      end

      it "should identify a bad review" do
        [
            q(:term => "JuJu", :msg => "JuJu is bad"),
            q(:term => "JuJu", :msg => "I hate JuJu")
        ].each do |q|
          result = @reviewAnalyzer.analyze q.term, q.msg

          result.review?.should be_true, "not identified as a review"
          result.liked?.should be_false, "liked"
        end
      end
    end


    def q props
      Q.new props
    end
  end
end

class Q
  include HasProperties
  has_properties :term, :msg
end
