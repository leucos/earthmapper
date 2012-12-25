#require 'sqlite3'
require 'redis'

module EarthMapper

  class Cache
    @@redis = Redis.new
    def spool(tile, url)
      Ramaze::Log.info("Queue size is %s" % @@redis.llen("earthmapper.queue"))
      data = { 'url' => url, 'key' => key(tile) }
      Ramaze::Log.info("Pushing #{data}")      
      @@redis.rpush('earthmapper.queue', data.to_json)
    end

    def exist?(tile)
      # We always retrieve
      false
    end
    alias_method :cached?, :exist?

    def key(tile)
      "earthmapper.%s.%s.%s.%s.%s" %
        [ 
          tile.backend,
          tile.layer,
          tile.zoom.to_s,
          tile.row.to_s,
          tile.col.to_s ]
    end

    def path(tile)
      "%s/%s/%s/%s/%s/%s/%s" %
        [ EarthMapper.options.myurl,
          EarthMapper::CacheController.r(:index),
          tile.backend,
          tile.layer,
          tile.zoom.to_s,
          tile.row.to_s,
          tile.col.to_s ]
    end

  end
end
