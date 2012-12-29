#require 'net/http/persistent'
require 'json'
require 'redis'
require 'eventmachine'
require 'em-http'
require 'em-redis'

RS = Redis.new

def grab(redis,data)
  data = JSON.parse(data)

  RS.incr("earthmapper.requests")
  
  user_agent  = data['user-agent'] 
  user_agent ||= 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1312.14 Safari/537.17'

  referer  = data['referer']
  referer ||= 'http://127.0.0.1'
  
  url = data['url']
  key = data['key']

  http = EventMachine::HttpRequest.new(url).get(
    :head => {
      'User-Agent' => user_agent,
      'Referer' => referer,
    }
  )

  http.callback {
    if http.response_header.status == 200
      RS.lpush(key, http.response)
    else
      puts "Got status #{http.response_header.status} while retrieving tile #{url}"
    end
    RS.decr("earthmapper.requests")
  }

  http.errback {
    puts "Error getting tile #{url} : %s" % http.error
    RS.decr("earthmapper.requests")
  }

  while RS.get("earthmapper.requests").to_i >= 50
    sleep 0.05
  end

  redis.blpop('earthmapper.queue', 0) { |d| grab(redis,d[1]) }
end

EventMachine.run {    
  redis = EM::Protocols::Redis.connect
  redis.blpop('earthmapper.queue', 0) { |data| grab(redis,data[1]) }
}