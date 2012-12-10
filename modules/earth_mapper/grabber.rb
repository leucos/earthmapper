VERBOSE=true

require 'open-uri'

class GrabWorker
  def initialize(queue)
    @queue = queue
  end

  def perform
    grab while true
  end

  def grab
    data = @queue.pop

    url,filename = data.split('|')

    puts "> #{url}" if VERBOSE

    raw = nil
    open(url,
         'User-Agent' => EarthMapper.options.user_agent,
         'Referer'    => EarthMapper.options.referrer) do |f|
      raw = f.read
    end
    print "*"

    File.open(filename, 'w') do |f|
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


