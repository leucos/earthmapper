require 'rgeo'

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
end
