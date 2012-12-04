#require 'rgeo'
#require 'open-uri'

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
        # if not retrieve
        # puts "fetching #{remote_url}"
        # open(remote_url,
        #   "User-Agent" => 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1312.14 Safari/537.17',
        #   "Referer"=> 'localhost') do |f|
        #   @raw = f.read
        # end
        # CACHE.store(self)
        Ramaze::Log.info "+++ CACHE MISS"
        CACHE.spool(self, remote_url)
      else
        Ramaze::Log.info "+++ CACHE HIT"
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
      CACHE.fetch_url(self)
    end

    private 

    def remote_url
      "http://gpp3-wxs.ign.fr/#{self.key}/geoportail/wmts?LAYER=#{self.layer}&EXCEPTIONS=text/xml&FORMAT=image/jpeg&SERVICE=WMTS&VERSION=1.0.0&REQUEST=GetTile&STYLE=normal&TILEMATRIXSET=PM&TILEMATRIX=#{self.zoom}&TILEROW=#{self.row}&TILECOL=#{self.col}"
    end
  end
end