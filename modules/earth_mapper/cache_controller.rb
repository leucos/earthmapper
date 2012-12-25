# coding: utf-8

require 'redis'

module EarthMapper
  class CacheController < Ramaze::Controller
    def index(backend, layer, zoom, row, col)
      redis = Redis.new

      data  = nil
      key   = "earthmapper.%s.%s.%s.%s.%s" % [ backend, layer, zoom, row, col ]

      data = redis.blpop(key, :timeout => 5)

      if data
        respond!(data[1], 200, 'Content-Type' => 'image/jpeg')
      else
        respond!("Can't be fetched", 404)
      end
    end
  end
end