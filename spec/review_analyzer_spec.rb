# encoding: utf-8

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
        analyze("Cafe Sydney", "Thanks to Billicorp - lovely lunch at Cafe Sydney. Thank you to Kristen Marsh & Fallon Leek of Billicorp the property agents in Alexandria!").should be_liked
        analyze("Cafe Sydney", "Hot chocolate after a crazy speed boat ride! Perfect! (@ Café Sydney w/ 7 others) [pic]: http://t.co/URb2LYES").should be_liked
        analyze("Cafe Sydney", "My amazing entree at cafe Sydney. Taste way better than it looks. http://t.co/cV3D1kcY").should be_liked
        analyze("Guylian Belgian Chocolate Cafe", "Amber is in heaven @ Guylian Belgian Chocolate Café http://t.co/2TBscyVp").should be_liked
        analyze("Starbucks Coffee", "I love the Barnes & Noble atmosphere. Starbucks coffee & a good book. Yup, that's my Friday night... ").should be_liked
        analyze("Max Brenner", "Max brenner! Amazing!").should be_liked
        analyze("Max Brenner", "@lisalovesbacon @x_michelle mmmm Max Brenner. except having the exploding shot and a hot chocolate was too much chocolate for me ><").should be_liked
        analyze("Max Brenner", "Max brenner chocolate is best chocolate").should be_liked
        analyze("Max Brenner", "Max brenner's was POPPIN' #satisified @Patriz").should be_liked
        analyze("Max Brenner", "Max Brenner you have done it again #chocolate #fatty #yummmmm http://t.co/LUKcjtYv").should be_liked
        analyze("GG Espresso", "RT @TheLocalBar1: A bracing cup of coffee to recover from driving in the Sydney traffic @ GG espresso 56 Pitt Street. Goodness....").should be_liked
        analyze("GG Espresso", "Delicious lunch @ GG espresso Fairfax Media today. Thanks to the team.").should be_liked
        analyze("GG Espresso", "Coffee this morning at GG espresso @ 55 Hunter Street. Sourdough toast with jam, newspaper and some sunshine. Good start to Wednesday.").should be_liked
        analyze("GG Espresso", "Friday. Lunch in the sun @ GG espresso 40 Mount Street Nth Sydney. Ideal.").should be_liked
        analyze("MOS Cafe", "MOS Cafe's banana chocolate waffle and hot choco nom nom :9 http://t.co/yYgjW5GV").should be_liked
        analyze("MOS Cafe", "Hmm...finally my fave one, rice burger (@ MOS Cafe) http://t.co/GuiKiOtJ").should be_liked
        analyze("MOS Cafe", "Highly recommended, Green Tea Jelly by Mos Cafe PS").should be_liked
        analyze("JuJu", "JuJu is my favorite").should be_liked
        analyze("JuJu", "JuJu is my favourite").should be_liked
        analyze("JuJu", "JuJu is good").should be_liked
        analyze("JuJu", "nice food").should be_liked
        analyze("JuJu", "spectacular views,great food,love coming.").should be_liked
        analyze("JuJu", "Great food and atmosphere.").should be_liked
        analyze("JuJu", "Amazing views and tasty food.").should be_liked
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

