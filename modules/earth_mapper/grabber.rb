VERBOSE=true

require 'net/http/persistent'

class GrabWorker
  def initialize(queue)
    @queue = queue
    @http = Net::HTTP::Persistent.new "grabber_#{Thread.current}"
  end

  def perform
    grab while true
  end

  def grab
    data = @queue.pop

    url,filename = data.split('|')

    puts "> #{url}" if VERBOSE

    uri = URI url
    
    req = Net::HTTP::Get.new(url)
    req.add_field('User-Agent', EarthMapper.options.user_agent)
    req.add_field('Referer', EarthMapper.options.referrer)

    response = @http.request(uri, req)

    raw = response.read_body
    print "*"

    File.open(filename, 'wb') do |f|
      f.write(raw)
    end

    print "< #{filename}" if VERBOSE
  end
end


class GrabPool
  @@queue = nil
  def GrabPool.start(count)
    print "Starting #{count} workers"
    @@queue = Queue.new
    count.times do
      print "." 
      Thread.new do
        GrabWorker.new(@@queue).perform
      end 
    end
    puts
    @@queue
  end
end


