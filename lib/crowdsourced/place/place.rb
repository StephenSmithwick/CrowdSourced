require_relative '../dao/review_dao'
require 'json'

class Place
  attr_accessor :id, :suburbId, :type, :name, :lat, :lon, :google_rating

  def self.init_all places_hash
    review_dao = ReviewDAO.new
    places = places_hash.map { |hash| Place.new hash, review_dao }

    best = places.reduce(nil) do |best, contender|
      worse = best && best.reviews.positive_count > contender.reviews.positive_count
      worse ? best : contender
    end
    best.best!

    places
  end

  def initialize hash, review_dao = nil
    @id = hash['_id'].to_s
    @suburbId = hash['suburbId'].to_s
    @type = hash['type']
    @name = hash['name']
    @lat = hash['lat']
    @lon = hash['lon']
    @google_rating = hash['google_rating']
    @review_dao = review_dao
    @best = false
  end

  def to_json opts
    <<-EOF
    {
      "id" : "#{@id}",
      "suburbId" : "#{@suburbId}",
      "name" : "#{@name}",
      "lat" : "#{@lat}",
      "lon" : "#{@lon}",
      "rating" : "#{@google_rating}",
      "best" : "#{@best}",
      "reviews" : {
        "count" : #{reviews.count},
        "positive_count" : #{reviews.positive_count}
      }
    }
    EOF
  end

  def best
    @best
  end

  def reviews
    return @reviews if @reviews
    @review_dao = ReviewDAO.new unless @review_dao

    @reviews = Reviews.new @review_dao.findReviewsForPlace('_id' => @id)
  end

  def best!
    @best = true
  end

end

class Reviews
  attr_accessor :reviews

  def initialize reviews
    @reviews = reviews.map {|review| review}
  end

  def count
    @reviews.count
  end

  def positive_count
    @reviews.select { |review| review["liked"] }.count
  end
end
