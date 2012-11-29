require 'gserver'
require 'open-uri'

POOL_SIZE = 20
PORT = 1234

class TileGrabber < GServer
  def initialize(port=PORT, host='127.0.0.1', connections=POOL_SIZE, *args)
    super(port, host, connections, *args)
  end

  def serve(io)
    url, filename = io.readpartial(4096).chomp.split('|')

    raw = nil
    open(url,
         "User-Agent" => 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1312.14 Safari/537.17',
         "Referer"=> 'localhost') do |f|
      raw = f.read
    end

    print "*"

    File.open(filename, 'w') do |f|
      f.write(raw)
    end
  end
end

puts "Starting tile grabber on port #{PORT}"

server = TileGrabber.new

trap("INT"){ server.shutdown }

server.audit = false
server.start
server.join