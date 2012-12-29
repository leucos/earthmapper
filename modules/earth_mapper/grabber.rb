require 'json'
require 'redis'
require 'eventmachine'
require 'em-http'
require 'em-redis'

class Grabber
  def initialize
    @redis = Redis.new
    EventMachine.next_tick {    
      Ramaze::Log.info "Grabber ready"
      @redis_em = EM::Protocols::Redis.connect
      @redis_em.blpop('earthmapper.queue', 0) { |data| _grab(data[1]) }
    }
  end

  private 

  def _grab(data)
    data = JSON.parse(data)
    @redis.incr("earthmapper.requests")

    http = EventMachine::HttpRequest.new(data['url']).get(:head => {
      'User-Agent' => 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1312.14 Safari/537.17',
      'Referer' => 'http://127.0.0.1'
    })

    #http = EM::HttpRequest.new(data['url']).get

    http.callback {
      if http.response_header.status == 200
        @redis.lpush(data['key'], http.response)
        count = @redis.get('earthmapper.requests')
        puts "#{count} Wrote #{http.response.length} bytes for tile key #{data['key']}"
      else
        puts "Got status #{http.response_header.status} while retrieving tile #{data['url']}"
      end
      @redis.decr("earthmapper.requests")
    }

    http.errback {
      puts "Error getting tile #{data['url']} : %s" % http.inspect
      @redis.decr("earthmapper.requests")
    }

    while @redis.get("earthmapper.requests").to_i > 48
      sleep 0.1
    end

    @redis_em.blpop('earthmapper.queue', 0) { |d| _grab(d[1]) }
  end


end