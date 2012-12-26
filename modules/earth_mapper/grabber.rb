require 'net/http/persistent'
require 'json'
require 'redis'
require 'celluloid'

class Grabber
  include Celluloid

  def initialize
    @http = Net::HTTP::Persistent.new "grabber_#{Thread.current}"
    @redis = Redis.new
  end

  def perform
    Ramaze::Log.debug "Perform called"    
    grab while true
  end

  def grab
    Ramaze::Log.debug "Waiting for request"    
    data = @redis.blpop('earthmapper.queue', :timeout => 0)[1]
    Ramaze::Log.debug "Got request: %s" % data  
    data = JSON.parse(data)

    Ramaze::Log.debug "Here"    

    Ramaze::Log.debug "Getting tile from #{data['url']}"

    uri = URI data['url']
    
    req = Net::HTTP::Get.new(data['url'])
    req.add_field('User-Agent', EarthMapper.options.user_agent)
    req.add_field('Referer', EarthMapper.options.referrer)

    response = @http.request(uri, req)

    raw = response.read_body

    # key = "earthmapper.%s.%s.%s.%s.%s" % [ backend, layer, zoom, row, col ]

    Ramaze::Log.debug "Response : %s " % response.code

    if response.code == '200'
      @redis.lpush(data['key'], raw)
      Ramaze::Log.debug "Wrote tile key #{data['key']}"
    else
      Ramaze::Log.error "Got status #{response.code} while retrieving tile"
    end
  end
end


class GrabPool
  def GrabPool.start(count)
    # Ensure count is an int
    count = count.to_i
    Ramaze::Log.info "Starting #{count} workers"
    count.times do
      Thread.new do
        GrabWorker.new.perform
      end 
    end
  end
end


