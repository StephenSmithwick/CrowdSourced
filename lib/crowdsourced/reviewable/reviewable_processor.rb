require_relative '../dao/suburbs_dao'
require_relative '../dao/reviewable_dao'

class ReviewableProcessor
  def fetchCafesForSuburb(suburb)
    url = "https://maps.googleapis.com/maps/api/place/search/json?location=-" + suburb["lat"] + "," + suburb["lon"]  + "&radius=" + suburb["radius"]  + "&types=cafe&sensor=false&key=AIzaSyC2pDpNpBWnlNYnBUX363XV5Aog4UdOjeg"
    result = open(url) do |file|
      result = JSON.parse(file.read)
      result["results"].each do |location|
        @reviewableDao.save(suburb["id"], "cafe" ,location["name"], location["rating"].to_s, location["geometry"]["location"]["lat"].to_s, location["geometry"]["location"]["lng"].to_s)
      end
    end
  end
  
  def initializeReviewable
    @suburbsDao = SuburbsDAO.new() unless @suburbsDao
    @reviewableDao = ReviewableDao.new() unless @reviewableDao
    
    suburbs = @suburbsDao.initializeSuburbs
    suburbs.each do |suburb|
      fetchCafesForSuburb suburb
    end
  end
end