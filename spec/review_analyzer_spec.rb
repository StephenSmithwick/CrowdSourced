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
      analyze("MOS Cafe", "Dinner. (@ MOS Cafe w/ @emilioolee.").should_not be_a_review
      analyze("MOS Cafe", "At mos cafe http://t.co/p8pdlj9B").should_not be_a_review
      analyze("MOS Cafe", "I'm at MOS CAFE w/ @kurosawatomoki http://t.co/hzkUa04N").should_not be_a_review
      analyze("GG Espresso", "It's still breakfast time, right? (@ GG Espresso) http://t.co/aAGOavK6").should_not be_a_review
      analyze("GG Espresso", "I'm at GG Espresso (North Ryde, NSW) http://t.co/LatewTdb").should_not be_a_review
      analyze("GG Espresso", "Afternoon coffee @ GG espresso 40 Mount St Nth Sydney. Plus a little iced coconut cake...just because.").should_not be_a_review
      analyze("GG Espresso", "Autumn weather in Sydney. Starting the week with breakfast at the cosy GG espresso @ Mallet St Camperdown.").should_not be_a_review
      analyze("twitter", "Hello twitter").should_not be_a_review
      analyze("Mirabelle", <<EOF
Offer of the Week | Babydoll Mirabelle
*25% Off
*Free Delivery

See our website for more info:-
http://t.co/RTPj5tCn http://t.co/1b6Z5749
EOF
      ).should_not be_a_review
    end

    context "with a review" do
      it "should identify positive reviews" do
        analyze("GG Espresso", "RT @TheLocalBar1: A bracing cup of coffee to recover from driving in the Sydney traffic @ GG espresso 56 Pitt Street. Goodness....").should be_liked
        analyze("GG Espresso", "Delicious lunch @ GG espresso Fairfax Media today. Thanks to the team.").should be_liked
        analyze("GG Espresso", "Coffee this morning at GG espresso @ 55 Hunter Street. Sourdough toast with jam, newspaper and some sunshine. Good start to Wednesday.").should be_liked
        analyze("GG Espresso", "Friday. Lunch in the sun @ GG espresso 40 Mount Street Nth Sydney. Ideal.").should be_liked
        analyze("MOS Cafe", "MOS Cafe's banana chocolate waffle and hot choco nom nom :9 http://t.co/yYgjW5GV").should be_liked
        analyze("MOS Cafe", "Hmm...finally my fave one, rice burger (@ MOS Cafe) http://t.co/GuiKiOtJ").should be_liked
        analyze("MOS Cafe", "Highly recommended, Green Tea Jelly by Mos Cafe PS").should be_liked
        analyze("MOS Cafe", "Breakfast :) (Checked in at Mo's Cafe) http://t.co/aYHYydg6").should be_liked
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
        analyze("JuJu", "JuJu is bad").should be_disliked
        analyze("JuJu", "I hate JuJu").should be_disliked
        analyze("JuJu", "food is under average").should be_disliked
        analyze("JuJu", "Food was in the pricey side").should be_disliked
        analyze("JuJu", "Found it pretentious and impersonal with very average service").should be_disliked
      end
    end
  end
end

RSpec::Matchers.define :be_liked do |review|
  match { |review| review.review? && review.liked? }
end

RSpec::Matchers.define :be_disliked do |review|
  match { |review| review.review? && !review.liked? }
end

