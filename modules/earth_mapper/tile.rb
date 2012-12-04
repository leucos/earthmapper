#require 'rgeo'

module EarthMapper
  class Tile    
    def initialize(layer, row, col, zoom)
      @layer, @row, @col, @zoom = layer, row, col, zoom
    end

    def get_origin
      nil      
    end

    def url
      nil
    end

    def cached?
    end

    def cache
    end

  end

  Radius = 6378137.0

  def EarthMapper.distance(lat1, lon1, lat2, lon2)
    lat1 = lat1*Math::PI/180
    lon1 = lon1*Math::PI/180
    lat2 = lat2*Math::PI/180
    lon2 = lon2*Math::PI/180

    dLat = lat2-lat1
    dLon = lon2-lon1

    a = Math.sin(dLat/2) * Math.sin(dLat/2) + Math.sin(dLon/2) * Math.sin(dLon/2) * Math.cos(lat1) * Math.cos(lat2)
    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a)) 
    Radius * c
  end
end
