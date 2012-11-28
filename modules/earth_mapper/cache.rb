require 'sqlite3'

module EarthMapper
  class Cache
    def initialize
      [EarthMapper.options.cache_dir, EarthMapper.options.data_dir].each do |dir|
        begin
          Ramaze::Log.info "Creating directory %s" % dir
          FileUtils.mkdir_p dir, :mode => 0755
        rescue
          Ramaze::Log.error "Unable to create directory %s" % dir
          exit
        end
      end

#       @database = SQLite3::Database.new( "#{EarthMapper.options.data_dir}/earthmapper.db" )
#       @database.busy_timeout 100000

#       if @database.get_first_value( "SELECT COUNT(*) FROM sqlite_master WHERE name='tiles'" ) == 0
#         sql =<<SQL
# CREATE TABLE tiles (backend VARCHAR(255),
#                     layer VARCHAR(255),
#                     row INTEGER, col INTEGER, zoom INTEGER,
#                     north REAL, west REAL, south REAL, east REAL,
#                     hits INTEGER);
# CREATE INDEX tiles_backend_idx ON tiles(backend);
# CREATE INDEX tiles_layer_idx ON tiles(layer);
# CREATE INDEX tiles_row_idx ON tiles(row);
# CREATE INDEX tiles_col_idx ON tiles(col);
# CREATE INDEX tiles_zoom_idx ON tiles(zoom);
# CREATE INDEX tiles_north_idx ON tiles(north);
# CREATE INDEX tiles_west_idx ON tiles(west);
# CREATE INDEX tiles_south_idx ON tiles(south);
# CREATE INDEX tiles_east_idx ON tiles(east);

# SQL
#         @database.execute_batch(sql)
#      end
    end

    def spool(tile, url)
      #@database.execute("INSERT INTO jobs VALUES (null, \"%s\", \"%s\");" % [ url, path(tile) ])
      begin
        t = TCPSocket.new('localhost', 1234)
      rescue
        puts "error: #{$!}"
      else
        t.print "%s|%s\n" % [ url, path(tile) ]
        t.close
        # @database.execute("INSERT OR IGNORE INTO tiles VALUES (\"%s\", \"%s\", %s, %s, %s, %s, %s, %s, %s, 0 );" % 
        # [tile.backend, tile.layer, tile.row, tile.col, tile.zoom, tile.north, tile.west, tile.south, tile.east ])
      end
    end

    # def store(tile)
    #   Ramaze::Log.info "IN STORE => EXITING"
    #   exit
    #   File.open(path(tile), 'w') { |f| f.write(tile.raw) }
    #   @database.execute("INSERT OR IGNORE INTO tiles VALUES (\"%s\", \"%s\", %s, %s, %s, %s, %s, %s, %s, 0 );" % 
    #     [tile.backend, tile.layer, tile.row, tile.col, tile.zoom, tile.north, tile.west, tile.south, tile.east ])
    #   @database.execute("UPDATE tiles SET hits = hist + 1 WHERE backend = \"%s\" AND 
    #     layer = \"%s\" AND row = %s AND col = %s AND zoom = %s AND
    #     north = %s AND west = %s AND south = %s AND east = %s" % 
    #     [tile.backend, tile.layer, tile.row, tile.col, tile.zoom, tile.north, tile.west, tile.south, tile.east ])
    # end

    # def fetch(tile)
    #   Ramaze::Log.info "IN FETCH => EXITING"
    #   exit
    #   return nil unless exist?(tile)
    #   open(path(tile), "rb") { |io| io.read }
    # end

    def fetch_url(tile)
      # @database.execute("UPDATE tiles SET hits = hits + 1 WHERE backend = \"%s\" AND 
      #   layer = \"%s\" AND row = %s AND col = %s AND zoom = %s AND
      #   north = %s AND west = %s AND south = %s AND east = %s" % 
      #   [tile.backend, tile.layer, tile.row, tile.col, tile.zoom, tile.north, tile.west, tile.south, tile.east ])


      "%s/%s/%s/%s/%s/%s/%s" %
        [ EarthMapper.options.myurl,
          EarthMapper::CacheController.r(:index),
          tile.backend,
          tile.layer,
          tile.zoom.to_s,
          tile.row.to_s,
          tile.col.to_s ]
    end

    def exist?(tile)
      File.file?(path(tile))
    end
    alias_method :cached?, :exist?

    def reindex
    end

    def path(tile)
      p = File.join(EarthMapper.options.cache_dir, tile.backend, tile.layer, tile.zoom.to_s, tile.row.to_s)

      # Make directory
      FileUtils.mkdir_p p, :mode => 0755

      File.join(p, tile.col.to_s)
    end

  end
end
