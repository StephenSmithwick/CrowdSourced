require_relative '../dao/suburbs_dao'
require_relative '../dao/cafes_dao'

class CafeProcessor
  def fetchCafesForSuburb(suburb)
    url = "https://maps.googleapis.com/maps/api/place/search/json?location=-" + suburb["lat"] + "," + suburb["lon"]  + "&radius=" + suburb["radius"]  + "&types=cafe&sensor=false&key=AIzaSyC2pDpNpBWnlNYnBUX363XV5Aog4UdOjeg"
    result = open(url) do |file|
      result = JSON.parse(file.read)
      result["results"].each do |location|
        @cafesDao.save(location["name"], location["rating"].to_s, location["geometry"]["location"]["lat"].to_s, location["geometry"]["location"]["lng"].to_s)
      end
    end
  end
  
  def initializeCafes
    @suburbsDao = SuburbsDAO.new() unless @suburbsDao
    @cafesDao = CafesDAO.new() unless @cafesDao
    
    suburbs = @suburbsDao.initializeSuburbs
    suburbs.each do |suburb|
      fetchCafesForSuburb suburb
    end
  end
end