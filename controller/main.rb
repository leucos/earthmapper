# Default url mappings are:
# 
# * a controller called Main is mapped on the root of the site: /
# * a controller called Something is mapped on: /something
# 
# If you want to override this, add a line like this inside the class:
#
#  map '/otherurl'
#
# this will force the controller to be mounted on: /otherurl.
class MainController < Controller
  include Ramaze::Traited

  provide(:kml, :engine => :etanni, :type => 'application/vnd.google-earth.kml+xml') do |action, value|
    @content = value
  end

  # the index action is called automatically when no other action is specified
  def index
    @backends = EarthMapper.options.backends
  end
end
