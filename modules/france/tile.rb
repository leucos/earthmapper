module France
  class Tile < EarthMapper::Tile

    attr_reader :row, :col, :layer, :zoom, :key, :raw
    @@backend = :france

    def backend
      @@backend.to_s
    end

    def initialize(key, layer, row, col, zoom)
      @key, @layer, @row, @col, @zoom = key, layer, row, col, zoom
      @northwest = @southeast = nil

      @raw = nil

      # check if cached
      case CACHE.cached?(self)
      when false
        Ramaze::Log.info "--- CACHE MISS ---"
        CACHE.spool(self, { 'url' => remote_url, 
                            'referer' => EarthMapper.options.france['referer'], 
                            'user_agent' => EarthMapper.options.france['user_agent'] })
      else
        Ramaze::Log.info "+++ CACHE HIT +++"
        open(CACHE.path(self)) do |f|
          @raw = f.read
        end
      end
    end

    def north
      north_west[1]
    end

    def south
      south_east[1]
    end

    def west
      north_west[0]
    end

    def east
      south_east[0]
    end

    def north_west
      return @northwest if @northwest
      @northwest = France::tile2coords(@row,@col,@zoom)
    end

    def south_east
      return @southeast if @southeast
      @southeast = France::tile2coords(@row+1,@col+1,@zoom)
    end

    def url
      CACHE.path(self)
    end

    private 

    def remote_url
      "http://gpp3-wxs.ign.fr/#{self.key}/geoportail/wmts?LAYER=#{self.layer}&EXCEPTIONS=text/xml&FORMAT=image/jpeg&SERVICE=WMTS&VERSION=1.0.0&REQUEST=GetTile&STYLE=normal&TILEMATRIXSET=PM&TILEMATRIX=#{self.zoom}&TILEROW=#{self.row}&TILECOL=#{self.col}"
    end
  end
end