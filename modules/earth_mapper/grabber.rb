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

    Ramaze::Log.debug "Getting tile from #{url}"

    uri = URI url
    
    req = Net::HTTP::Get.new(url)
    req.add_field('User-Agent', EarthMapper.options.user_agent)
    req.add_field('Referer', EarthMapper.options.referrer)

    response = @http.request(uri, req)

    raw = response.read_body

    if response.code == '200'
      File.open(filename, 'wb') do |f|
        f.write(raw)
      end
      Ramaze::Log.debug "Writing tile to #{filename}"
    else
      Ramaze::Log.error "Got status #{response.status} while retrieving tile"
    end
  end
end


class GrabPool
  @@queue = nil
  def GrabPool.start(count)
    Ramaze::Log.info "Starting #{count} workers"
    @@queue = Queue.new
    count.times do
      Thread.new do
        GrabWorker.new(@@queue).perform
      end 
    end
    @@queue
  end
end


