#require 'rb-inotify'

module EarthMapper
  class CacheController < Ramaze::Controller
    def index(backend, layer, zoom, row, col)

      path = File.join(EarthMapper.options.cache_dir, backend, layer, zoom, row)
      file = File.join(path, col)

      loopit = 100

      
        # notifier = INotify::Notifier.new
        # notifier.watch(path, :create) {
        #   send_file(file)
        # }

        # if IO.select([notifier.to_io], [], [], 10)
        #   notifier.process
        # end

      while loopit > 0 do
        if File.file?(file)
          loopit = 0
        else
          sleep 0.1
          loopit -= 1
        end
      end

      #sleep 0.5
      send_file(file)
    end

      #notifier.close
      # 10.times do 
      #   sleep 1 if ! File.file?(file)
      # end

    private

    def send_file(file)
      body = open(file , "rb") { |io| io.read }
      puts "sending #{file}"
      respond!(body, 200, 'Content-Type' => 'image/jpeg')
    end

  end
end