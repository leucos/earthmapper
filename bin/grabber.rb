#require 'net/http/persistent'
require 'json'
require 'redis'
require 'eventmachine'
require 'em-http'
require 'em-redis'


RS = Redis.new

def grab(redis,data)
  #puts "Got request: %s" % data  
  data = JSON.parse(data)
  #puts "Getting tile from #{data['url']}"

  RS.incr("earthmapper.requests")

  http = EventMachine::HttpRequest.new(data['url']).get(:head => {
    'User-Agent' => 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1312.14 Safari/537.17',
    'Referer' => 'http://127.0.0.1'
  })

  #http = EM::HttpRequest.new(data['url']).get

  http.callback {
    if http.response_header.status == 200
      RS.lpush(data['key'], http.response)
      count = RS.get('earthmapper.requests')
      puts "#{count} Wrote #{http.response.length} bytes for tile key #{data['key']}"
    else
      puts "Got status #{http.response_header.status} while retrieving tile #{data['url']}"
    end
    RS.decr("earthmapper.requests")
  }

  http.errback {
    puts "Error getting tile #{data['url']} : %s" % http.error
    RS.decr("earthmapper.requests")
  }

  while RS.get("earthmapper.requests").to_i > 48
    sleep 0.1
  end

  redis.blpop('earthmapper.queue', 0) { |d| grab(redis,d[1]) }
end


EventMachine.run {    
  redis = EM::Protocols::Redis.connect
  #while true do
    #puts "Waiting for request"    
    #data = 
    redis.blpop('earthmapper.queue', 0) do |data|
      data = data[1]
      grab(redis,data)
      
    end



    # http = EventMachine::HttpRequest.new(data['url'])
    # http.get

    # # http.errback do
    # #   puts "### ERRBACK ###"
    # #   puts http.inspect
    # # end

    # http.callback do
    #   puts "### CALLBACK ###"

    #   raw = http.response

    #   # key = "earthmapper.%s.%s.%s.%s.%s" % [ backend, layer, zoom, row, col ]

    #   puts "Response : %s " % http.response_header.status
    #   if http.response_header.status == '200'
    #     redis.lpush(data['key'], raw)
    #     puts "Wrote tile key #{data['key']}"
    #   else
    #     puts "Got status #{http.response_header.status} while retrieving tile"
    #   end
    #end
  #end
}