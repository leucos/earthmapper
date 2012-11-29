require 'eventmachine'
require 'em-http-request'

VERBOSE=true

class TileGrabber < EM::Protocols::LineAndTextProtocol
  def receive_data(data)
    url,filename = data.chomp.split('|')

    print ">" if VERBOSE
    http = EventMachine::HttpRequest.new(url).get(:head => {
    "Accept-Encoding" => "gzip, compressed",
    "User-Agent" => 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1312.14 Safari/537.17',
    "Referer"=> 'localhost' })
    http.callback {
      File.open(filename, 'w') do |f|
        print "<" if VERBOSE
        f.write(http.response)
      end
    }
  end
end
 
EventMachine::run {
  EventMachine::start_server "127.0.0.1", 1234, TileGrabber
}
