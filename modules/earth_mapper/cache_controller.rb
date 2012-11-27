module EarthMapper
  class CacheController < Ramaze::Controller
    def index(backend, layer, zoom, row, col)
    
      filepath = File.join(EarthMapper.options.cachedir, backend, layer, zoom, row, col)

      10.times do 
        sleep 1 if ! File.file?(filepath)
      end

      body = open(filepath , "rb") { |io| io.read }

      respond!(body, 200, 'Content-Type' => 'image/jpeg')
    end
  end
end