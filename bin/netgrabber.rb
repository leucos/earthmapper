require 'celluloid/io'
require 'open-uri'

POOL_SIZE = 50

class EchoServer
  include Celluloid::IO

  def initialize(host, port)
    puts "*** Starting echo server on #{host}:#{port}"

    # Since we included Celluloid::IO, we're actually making a
    # Celluloid::IO::TCPServer here
    @server = TCPServer.new(host, port)
    run!
  end

  def finalize
    @server.close if @server
  end

  def run
    loop { handle_connection! @server.accept }
  end

  def handle_connection(socket)
    _, port, host = socket.peeraddr
    print "^"
    loop do 
      data = socket.readpartial(4096).chomp!
      POOL.grab_tile!(*data.split('|'))
    end
  rescue EOFError
    print "v"
    socket.close
  end
end

class Grabber
  include Celluloid

  def grab_tile(url, filename)
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

POOL = Grabber.pool(size: POOL_SIZE)

supervisor = EchoServer.supervise("127.0.0.1", 1234)
trap("INT") { supervisor.terminate; exit }
sleep