require 'socket'
require 'open-uri'

begin
  acceptor = TCPServer.open("127.0.0.1", 1234)
  fds = [acceptor]
  while true
    puts 'loop'
    if ios = select(fds, [], [], 10)
      reads = ios.first
      reads.each do |client|
        if client == acceptor
          print ">"
          client, sockaddr = acceptor.accept
          fds << client
        elsif client.eof?
          print "<"
          puts "Client disconnected"
          fds.delete(client)
          client.close
        else
          # Perform a blocking-read until new-line is encountered.
          # We know the client is writing, so as long as it adheres to the
          # new-line protocol, we shouldn't block for very long.
          url, filename = client.gets.chomp.split('|')
          print "+"

          raw = nil
          open(url,
            "User-Agent" => 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1312.14 Safari/537.17',
            "Referer"=> 'localhost') do |f|
            raw = f.read
          end

          print "*"

          File.open(filename, 'w') do |f|
            f.write(raw)

          print "#"
          end
        end
      end
    end
  end
ensure
  puts "Cleaning up"
  fds.each {|c| c.close}
end
