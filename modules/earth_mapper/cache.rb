#require 'sqlite3'

module EarthMapper
  class Cache
    def spool(tile, url)
      Ramaze::Log.info("Queue size is %s" % GQUEUE.size)
      data = "%s|%s" % [ url, path(tile) ]
      Ramaze::Log.info("Pushing #{data}")      
      GQUEUE.push data
    end

    def spool2(tile, url)
      begin
        t = TCPSocket.new('localhost', 1234)
      rescue
        puts "error: #{$!}"
      else
        t.print "%s|%s\n" % [ url, path(tile) ]
        t.close
      end
    end

    def fetch_url(tile)

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
