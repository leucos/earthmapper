require 'sqlite3'
#db = SQLite3::Database.new( "test.db" )
module EarthMapper
  class Cache
    def initialize
      raise ArgumentError unless File.directory?(EarthMapper.options.cachedir)
    end

    def store(tile)
      File.open(path(tile), 'w') { |f| f.write(tile.raw) }
    end

    def fetch(tile)
      return nil unless exist?(tile)
      open(path(tile), "rb") { |io| io.read }
    end

    def fetch_url(tile)
      "%s/%s/%s/%s/%s/%s/%s" %
        [ EarthMapper.options.myurl,
          EarthMapper::CacheController.r(:index),
          tile.tileset,
          tile.layer,
          tile.zoom.to_s,
          tile.row.to_s,
          tile.col.to_s ] if exist?(tile)
    end

    def exist?(tile)
      File.file?(path(tile))
    end
    alias_method :cached?, :exist?

    def reindex
    end

    def path(tile)
      p = File.join(EarthMapper.options.cachedir, tile.tileset, tile.layer, tile.zoom.to_s, tile.row.to_s)

      # Make directory
      FileUtils.mkdir_p p, :mode => 0755

      File.join(p, tile.col.to_s)
    end

  end
end
