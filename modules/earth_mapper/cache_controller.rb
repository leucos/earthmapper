# coding: utf-8

module EarthMapper
  class CacheController < Ramaze::Controller
    def index(backend, layer, zoom, row, col)
      path = File.join(EarthMapper.options.cache_dir, backend, layer, zoom, row)
      file = File.join(path, col)

      # Ugly hack...
      # Suse elect ?
      100.times do |l|
        break if File.file?(file)
        sleep 0.1
      end

      send_file(file)
    end

    private

    def send_file(file)
      body = open(file , "rb") { |io| io.read }
      puts "sending #{file}"
      respond!(body, 200, 'Content-Type' => 'image/jpeg')
    end

  end
end